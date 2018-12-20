%To see if plotting a tick after setting camlight headlight will leads to
%its background becoming gray or not
%clear all

mainfig = figure ; ax1 = axes;
surfaceHandle = rotateAxisTicks('lol','r',10,-0.3,0.5,0.5,1,1,1,0,0,NaN);

tempfig = figure; ax2 = axes;
arrow = arrow3D([0 0 0], [1 1 1], 'r', 0.8, 0.2);
set(arrow, 'EdgeColor', 'interp', 'FaceColor', 'interp');
camlight headlight %might be interesting to uncomment this line

%% Prepare and set matching limits
x1 = [ax1.XLim ; ax2.XLim];
x1 = [min(x1(:,1)), max(x1(:,2))];
y1 = [ax1.YLim ; ax2.YLim];
y1 = [min(y1(:,1)), max(y1(:,2))];
z1 = [ax1.ZLim ; ax2.ZLim];
z1 = [min(z1(:,1)), max(z1(:,2))];
hax = [ax1;ax2] ; set(hax,'XLim',x1,'YLim',y1,'ZLim',z1)

% Adjust the view to be sure
ax2.View = ax1.View;

%% Remove secondary axes background, then move it to main figure
ax2.Visible = 'off';
ax2.Parent = mainfig; delete(tempfig)

%% Link the view between axes
h1 = linkprop(hax, 'View');
%or link even more properties at once
%h1 = linkprop(hax, 'View', 'XLim', 'YLim', 'ZLim');