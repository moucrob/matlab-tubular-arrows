hFigure = figure('MenuBar', 'none', ...
    'ToolBar', 'none', ...
    'Units', 'points', ...
    'Position', [0 0 15 80], ...
    'Color', 'w');

hAxes = axes;
hAxes.Visible = 'off';

hText = text(-2.6, 1., ...
    "0.0000001", ...
    'Units', 'normalized', ...
    'FontSize', 18, ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom', ...
    'Color', 'k', ...
    'Interpreter', 'none');
set(hText,'Rotation',-90)

imageData = getframe(hFigure);
textImage = imageData.cdata;

X = [0 15; 0 15];
Y = [0 0; 0 0];
Z = [0 0; -80 -80];

figure;
surfaceHandle = surf(X, Y, Z, ...
    'FaceColor', 'texturemap', ...
    'CData', textImage, ...
    'EdgeColor', 'k');
set(gca,'DataAspectRatio',[1,1,1])