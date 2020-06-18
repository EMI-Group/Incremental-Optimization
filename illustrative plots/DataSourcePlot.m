%plot the manifold data source
function SF = DataSourcePlot(X,ColorV)

[m,n] = size(X);
figure;
% subplot(331);

if n == 2    
    scatter(X(:,1),X(:,2),12,ColorV,'filled');    
    axis tight;
elseif n == 3
    scatter3(X(:,1),X(:,2),X(:,3),12,ColorV,'filled');
    xlabel('x_1'); ylabel('x_2'); zlabel('x_3');  
    axis tight;
    xlim([-25,25]); ylim([-25,25]); zlim([-25,25]);
    %set(gca,'position',[0 0 1 1],'units','normalized');
    %axis off;
    %axis equal;
elseif n == 1
scatter(X(:,1),ones(m,1),12,'filled');   
axis tight;
else
    cla;
    axis([-1 1 -1 1]);
    text(-0.7,0,'Only plots 2D or 3D data');
    axis off;
end;
%  set(gcf,'Color',[0.95,0.95,0.95]);
%  set(gca,'XColor',[0,0,0]);
%   set(gca,'YColor',[0,0,0]);
%    set(gca,'ZColor',[0,0,0]);
   set(gca, 'FontSize', 18);
 