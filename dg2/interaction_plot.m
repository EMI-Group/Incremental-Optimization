function [] = interaction_plot(mat,fun_id)

% [r, c] = size(mat);                          % Get the matrix size
% imagesc((1:c)+0.5, (1:r)+0.5, mat);          % Plot the image
% imagesc(mat);
% colormap(gray);                              % Use a gray colormap
% % axis equal                                   % Make axes grid sizes equal
% % set(gca, 'XTick', 1:(c+1), 'YTick', 1:(r+1), ...  % Change some axes properties
% %          'XLim', [1 c+1], 'YLim', [1 r+1], ...
% %          'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');

% HeatMap(mat + 0);
% colormap(gray);                              % Use a gray colormap

spy(mat);
xlabel('$i$','Interpreter','LaTex', 'FontSize', 20);
ylabel('$j$','Interpreter','LaTex', 'FontSize', 20);
h = legend('$x_i$ interacts with $x_j$'); set(h,'Interpreter','LaTex'); h.FontSize = 20; 
set(gca, 'FontSize',14);

hold on;

% plot dash lines
if(fun_id == 3)
    idx = [35,50,60];
elseif(fun_id == 4)
    idx = [5,20,60];
else
    idx = [20,40,60];
end

for i = 1:2
    xy1 = [[0,idx(i)]; [60,idx(i)];];
    xy2 = [[idx(i),0]; [idx(i),60];];
    plot(xy1(:,1),xy1(:,2),'k--','LineWidth',2);
    plot(xy2(:,1),xy2(:,2),'k--','LineWidth',2);
end

hold off;

%set (gcf,'Position',[0,0,512,512]);
%set(gcf,'position',[0 0 1 1],'units','normalized');

end