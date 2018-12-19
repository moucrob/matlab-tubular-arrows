%https://stackoverflow.com/questions/9843048/matlab-how-to-plot-a-text-in-3d
clc
figure ; plot3(1,1,1,'*')
xlabel('x') ; ylabel('y') ; zlabel('z')
text.str = 'blabla' ; text.color = 'k' ; text.pos = [1 1 1] ; text.size = 0.5;
%rotate(t,[0 0 1],pi/2) %doesn't work.

hFigure = figure('Color', 'w', ...        %# Create a figure window
                 'MenuBar', 'none', ...
                 'ToolBar', 'none');
hText = uicontrol('Parent', hFigure, ...  %# Create a text object
                  'Style', 'text', ...
                  'String', text.str, ...
                  'BackgroundColor', 'w', ...
                  'ForegroundColor', text.color, ...
                  'FontSize', 100, ...
                  'FontWeight', 'normal');
set([hText hFigure], 'Pos', get(hText, 'Extent'));  %# Adjust the sizes of the
                                                    %#   text and figure
imageData = getframe(hFigure);  %# Save the figure as an image frame
delete(hFigure);
textImage = imageData.cdata;  %# Get the RGB image of the text

hold on
[X,Y,Z] = feval(@(x) x{:}, {[0 1; 0 1]*text.size,[0 0; 0 0]*text.size,[1 1; 0 0]*text.size}); %feval x{:} = multi initialization
s = surf(X, Y, Z, 'FaceColor', 'texturemap', 'CData', textImage);