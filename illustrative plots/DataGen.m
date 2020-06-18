function [X,ColorV] = DataGen(manifoldType,pointsNum,SecParam)

% GENERATE SAMPLED DATA
exampleValue = manifoldType;
N = pointsNum;   % Number of points to use.
N = max(1,N);
ExParam = SecParam;  % Second parameter for example
ExParam = max(0.0,ExParam);

%choose the manifold type
switch exampleValue
    case 1  % Swiss Roll
        tt = (3*pi/2)*(1+2*rand(1,N));  
        height = 21*rand(1,N);
        X = [tt.*cos(tt); height; ExParam*tt.*sin(tt)]';
        ColorV = tt';
        fprintf(1,'Swiss Roll manifold with %d points',N);
    case 2  % Swiss Hole
        % Swiss Roll w/ hole example taken from Donoho & Grimes
        tt = (3*pi/2)*(1+2*rand(1,2*N));  
        height = 21*rand(1,2*N);
        kl = repmat(0,1,2*N);
        for ii = 1:2*N
            if ( (tt(ii) > 9)&(tt(ii) < 12))
                if ((height(ii) > 9) & (height(ii) <14))
                    kl(ii) = 1;
                end;
            end;
        end;
        kkz = find(kl==0);
        tt = tt(kkz(1:N));
        height = height(kkz(1:N));
        X = [tt.*cos(tt); height; ExParam*tt.*sin(tt)]';     
        ColorV = tt';
        fprintf(1,'Swiss Holl manifold with %d points',N);
        case 3  % Corner Planes
        k = 1;
        xMax = floor(sqrt(N));
        yMax = ceil(N/xMax);
        cornerPoint = floor(yMax/2);
        for x = 0:xMax
            for y = 0:yMax
                if y <= cornerPoint
                    Xn(k,:) = [x,y,0];
                    ColorVector(k) = y;
                else
                    Xn(k,:) = [x,cornerPoint+(y-cornerPoint)*cos(pi*ExParam/180),(y-cornerPoint)*sin(pi*ExParam/180)];
                    ColorVector(k) = y;
                end;
                k = k+1;
            end;
        end;
        X = Xn;
        ColorV = ColorVector';
        fprintf(1,'Corner Planes manifold with %d points',N); 
    case 4  % Punctured Sphere by Saul & Roweis
        inc = 9/sqrt(N);   %inc = 1/4;
        [xx,yy] = meshgrid(-5:inc:5);
        rr2 = xx(:).^2 + yy(:).^2;
        [tmp ii] = sort(rr2);
        Y = [xx(ii(1:N))'; yy(ii(1:N))'];
        a = 4./(4+sum(Y.^2));
        X = [a.*Y(1,:); a.*Y(2,:); ExParam*2*(1-a)]';
        ColorV = X(:,3);
        fprintf(1,'Punctured Sphere manifold with %d points',N); 
    case 5  % Twin Peaks by Saul & Roweis
        inc = 1.5 / sqrt(N);  % inc = 0.1;
        [xx2,yy2] = meshgrid(-1:inc:1);
        zz2 = sin(pi*xx2).*tanh(3*yy2);
        xy = 1-2*rand(2,N);
        X = [xy; sin(pi*xy(1,:)).*tanh(3*xy(2,:))]';
        X(:,3) = ExParam * X(:,3);
        ColorV = X(:,3);
        fprintf(1,'Twin Peaks manifold with %d points',N);
    case 6  % 3D Clusters
        ExParam=3;
        numClusters = ExParam;
        numClusters = max(1,numClusters);
        Centers = 10*rand(numClusters,3);
        D = L2_distance(Centers',Centers',1);
        minDistance = min(D(find(D>0)));
        k = 1;
        N2 = N - (numClusters-1)*9;
        for i = 1:numClusters
            for j = 1:ceil(N2/numClusters)
               Xn(k,1:3) = Centers(i,1:3)+(rand(1,3)-0.5)*minDistance/sqrt(12);
               ColorVector(k) = i;
               k = k + 1;
           end;
           % Connect clusters with straight line.
           if i < numClusters
               for t = 0.1:0.1:0.9
                    Xn(k,1:3) = Centers(i,1:3) + (Centers(i+1,1:3)-Centers(i,1:3))*t;
                    ColorVector(k) = 0;
                    k = k+1;
                end;
           end;
        end;
        X = Xn;
        ColorV = ColorVector;
        fprintf(1,'3D Clusters manifold with %d points',N);
    case 7  % Toroidal Helix by Coifman & Lafon
        noiseSigma=0.05;   %noise parameter
        t = (1:N)'/N;
        t = t.^(ExParam)*2*pi;
        X = [(2+cos(8*t)).*cos(t) (2+cos(8*t)).*sin(t) sin(8*t)]+noiseSigma*randn(N,3);
        ColorV = t;
        fprintf(1,'Toroidal Helix manifold with %d points',N);
    case 8  % Gaussian randomly sampled
        Xn = ExParam * randn(N,3);
        Xn(:,3) = 1 / (ExParam^2 * 2 * pi) * exp ( (-Xn(:,1).^2 - Xn(:,2).^2) / (2*ExParam^2) );
        X = Xn;
        ColorV = Xn(:,3);
        fprintf(1,'Gaussian manifold with %d points',N);
    case 9  % Occluded disks
        m = 20;   % Image size m x m.
        Rd = 3;   % Disk radius.
        Center = (m+1)/2;
        u0 = zeros(m,m);
        for i = 1:m
            for j = 1:m
                if (Center - i)^2 + (Center - j)^2 < ExParam^2
                    u0(i,j) = 1;
                end;
            end;
        end;
        for diskNum = 1:N
            DiskX(diskNum) = (m-1)*rand+1;
            DiskY(diskNum) = (m-1)*rand+1;
            u = u0;
            for i = 1:m
                for j = 1:m
                    if (DiskY(diskNum) - i)^2 + (DiskX(diskNum) - j)^2 < Rd^2
                        u(i,j) = 1;
                    end;
                end;
            end;
            Xn(diskNum,:) = reshape(u,1,m*m);
        end;
                % Since this is a special manifold, plot separately.
        figure;
        t = 0:0.1:2*pi+0.1;
        plot(ExParam*cos(t)+Center,ExParam*sin(t)+Center);
        axis([0.5 m+0.5 0.5 m+0.5]);
        hold on;
        ColorV = (sqrt((DiskX-Center).^2+(DiskY-Center).^2))';
        scatter(DiskX,DiskY,12,ColorV');
        hold off;
        X = Xn;
        fprintf(1,'Occluded Disks manifold with %d points',N); 
%         tt = (3*pi/2)*(1+2*rand(1,N));  height = 21*rand(1,N);
%         X = [tt.*cos(tt); height; tt.*sin(tt)];
    case 10
        % % ellip
        
        [xc, yc, zc] = deal(1, 1, 1);
        [xr, yr, zr] = deal(6, 2, 3);
        [x, y, z] = ellipsoid(xc, yc, zc, xr, yr, zr, round(sqrt(N)));
        
%         surf(x, y, z) % ÏÔÊ¾±ê×¼ÍÖÇò×´Ì¬
%         axis equal
        
        X = [x(:)';y(:)';z(:)']';
        ColorV = X(:,3);
    case 11
        % cube
        inc = 1/N^0.33;
        [x,y,z]=meshgrid([0:inc:1],[0:inc:1],[0:inc:1]);
        
        X = [x(:)';y(:)';z(:)']';
        ColorV = X(:,3);

end;

% --- L2_distance function
% Written by Roland Bunschoten, University of Amsterdam, 1999
function d = L2_distance(a,b,df)
if (size(a,1) == 1)
  a = [a; zeros(1,size(a,2))]; 
  b = [b; zeros(1,size(b,2))]; 
end
aa=sum(a.*a); bb=sum(b.*b); ab=a'*b; 
d = sqrt(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab);
d = real(d); 
if (df==1)
  d = d.*(1-eye(size(d)));
end
