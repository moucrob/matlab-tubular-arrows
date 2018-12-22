%https://stackoverflow.com/questions/9843048/matlab-how-to-plot-a-text-in-3d
clc
figure ; plot3(1,1,1,'*')
xlabel('x') ; ylabel('y') ; zlabel('z') ; grid on ; grid minor
xlim([0 1]) ; ylim([0 1]) ; zlim([-1.5 0]) 
%% that future function will take as arguments :
text.str = 'blabla' ; text.color = 'k' ;
zmax = -0.2;
mag = 1; %length of the axis
graduSpace = 0.5; %space between each graduation, within the local (not yet projected on x,y) axis !!
labelNumber = 1; %(the first label to be displayed is actually associated to the second graduation (0 can't get several labels)
axnumber = 3; %out of nbParams, 1 for x, 2 for y, then, from closest to x, to closest to y : 3 to nbParams.
%THETA (ANGLE AROUND Z FROM X TO THE AXIS) HAS TO BE AN OPTIONAL ARGUMENT
perc = 0.9; %if perc = 1 (100%), then the labels are all sticked together with no space inbetween
boxHeight = 1; %width of the boxes depend on how much the axis graduations are refined so height shouldn't depend on graduSpace
thetaInput = 45; %has to be in degree

%rotate(t,[0 0 1],pi/2) %doesn't work.

%% Seems like there is no way to get rid of the black contouring...
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

%% MAKE THE X,Y,Z (text) REVERSE DEPENDING ON AZIMUT VALUE (launch a fig and see on the bottom in real time the azimut value)
% X or Y or Z(1,1) =  _______
%                    *       |
%                    |       |
%                    |_______|
% X or Y or Z(1,2) =  _______
%                    |       *
%                    |       |
%                    |_______|
% X or Y or Z(2,1) =  _______
%                    |       |
%                    |       |
%                    x_______|
% X or Y or Z(2,2) =  _______
%                    |       |
%                    |       |
%                    |_______x
if axnumber == 2 %axis = y
    X = [0 0; 0 0];
    Y = [0 perc*graduSpace; 0 perc*graduSpace]+labelNumber*((graduSpace/2)+((1-perc)/2)*graduSpace);
    %(graduSpace/2)/2 to center under the graduation, (1-perc)/2) to
    %additionally shift a bit so that the perc% of graduSpace stay centered
    %under the graduation
else %I assume axis = x, that I might later rotate if it's not actually x
    X = [0 perc*graduSpace; 0 perc*graduSpace]+labelNumber*((graduSpace/2)+((1-perc)/2)*graduSpace);
    Y = [0 0; 0 0];
end
Z = [zmax zmax; zmax-boxHeight zmax-boxHeight];
s = surf(X, Y, Z, 'FaceColor', 'texturemap', 'CData', textImage);
if axnumber > 2
    rotate(s, [0 0 1], thetaInput,[0 0 0]);
end