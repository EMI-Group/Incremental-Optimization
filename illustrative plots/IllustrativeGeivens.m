


% % Plot an apple
% [x,y,z]=meshgrid(linspace(-3,3));
% zz=sqrt(x.^2+y.^2)-1;
% p=z.^2+zz.^2;
% [faces,verts,colors] =isosurface(x,y,z,p,1,x);
% pp=patch('Faces',faces,'Vertices',verts);
% set(pp,'FaceColor','r','EdgeColor','none');
% axis off
% camlight
% lighting gouraud
% hold on
% y1=0.05:0.05:0.8; 
% x1=zeros(length(y1))+0.1; 
% z1=0.3+sqrt(y1); 
% 
% plot3(x1,y1,z1,'k','LineWidth',5);


%Generate datasets
pointsNum=10000;
SecParam=1.0;
manifoldType=1;

[X,ColorV] = DataGen(manifoldType,pointsNum,SecParam);



% % ellip
% 
% [xc, yc, zc] = deal(1, 1, 1);
% [xr, yr, zr] = deal(6, 2, 3);
% [x, y, z] = ellipsoid(xc, yc, zc, xr, yr, zr, 1000);
% 
% surf(x, y, z) % ÏÔÊ¾±ê×¼ÍÖÇò×´Ì¬
% axis equal
% 
% X = [x(:)';y(:)';z(:)']';

%Rotations 
N = 3; 
% Rotation 12
i = 1; j = 2;
I_mat = [N*(i - 1) + i, N*(j - 1) + i, N*(i - 1) + j, N*(j - 1) + j];
R_mat = planerot([1 1]')'; R_mat = R_mat(:); % rotation values of each element
RM_12 = eye(3); RM_12(I_mat) = R_mat;

% Rotation 23
i = 2; j = 3;
I_mat = [N*(i - 1) + i, N*(j - 1) + i, N*(i - 1) + j, N*(j - 1) + j];
R_mat = planerot([1 1]')'; R_mat = R_mat(:); % rotation values of each element
RM_23 = eye(3); RM_23(I_mat) = R_mat;

% Rotation 123
RM_123 = RM_12*RM_23;

%Plot sample dataset
%original 
DataSourcePlot(X,ColorV); 
%R12
DataSourcePlot(X*RM_12,ColorV); 
%R23
DataSourcePlot(X*RM_23,ColorV); 
%R123
DataSourcePlot(X*RM_123,ColorV);



