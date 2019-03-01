function surfaceHandle = rotateAxisTicks2(txt,howManyCharMaximum,color,zmax,graduSpace,boxHeight,perc,labelNumber,axnumber,thetaInput,axisNameCall,labelWidth,contour)
%https://stackoverflow.com/questions/9843048/matlab-how-to-plot-a-text-in-3d
    %zmax : give it a negative value to not overlap the axis
    %graduSpace : space between each graduation, within the projected on [0,1] axis if axis = x||y, OR local (not yet projected on x,y) axis !!
    %boxHeight : width of the boxes depend on how much the axis graduations are refined, so height shouldn't depend on graduSpace
    %perc : if perc = 1 (100%), then the labels are all sticked together with no space inbetween
    %labelNumber : the first tick to be displayed is actually associated to the second graduation (0 can't get several labels)
    %axnumber : out of nbParams, 1 for x, 2 for y, then, from closest to x, to closest to y : 3 to nbParams.
    %thetaInput : (angle around z, from x to the axis) has to be in degree
    
    %axisNameCall: boolean that activates a special behavior
    %labelWidth: in the axis dim (before projection), for axis name only.
    
    %contour : ifticks surfaces have to be highlighted, eg: 'k', 'none'.

%% TWEAKABLE
factor = 5000; %boxes dimensions are in the units of the plot, which is a unitary cube so dim <1 and standard fontsizes are o(10) points
%%
boxHeightUnscaled = boxHeight;
boxHeight = factor*boxHeight;
if ~axisNameCall
    boxWidth = perc*graduSpace;
else
    boxWidth = labelWidth;
end
boxWidth = factor*boxWidth;

%% comput: Now I assume one char is as wide as tall
howManyChar = strlength(txt);
marginHoriz = mod(boxWidth,howManyCharMaximum); %in points
subRectangle.width = (boxWidth-marginHoriz)/howManyCharMaximum;
subRectangle.height = boxHeight;
[fontSize,idx] = min([subRectangle.width, subRectangle.height]); %the largest square that fits in a rectangle

%%
hFigure = figure('MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Units', 'points', ...
                 'Position', [0 0 boxWidth boxHeight], ... % x y from bottom left of screen to botleft of the fig
                 'Color', 'w'); 
hAxes = axes; hAxes.Visible = 'off';

%pos:=botleft vertex of the string
switch(idx)
    case 1
        x = floor((boxWidth-howManyChar*fontSize)/2);
        y = floor((boxHeight-fontSize)/2);
    case 2
        addMarginHoriz = (subRectangle.width-subRectangle.height)*howManyCharMaximum;
        x = floor((boxWidth-howManyChar*fontSize)/2);
        y = 0;
end
hText = text(0.5, 0.5, ...
            txt, ...
            'Units', 'normalized', ...
            'FontSize', fontSize, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'Color', color, ...
            'Interpreter', 'none');
set(hText,'Rotation',-90)
            
imageData = getframe(hFigure);  %# Save the figure as an image frame
% assignin('base','imageData',imageData);

delete(hFigure);
textImage = imageData.cdata;  %# Get the RGB image of the text

%% TODO : MAKE THE X,Y,Z (text) REVERSE DEPENDING ON AZIMUT VALUE (launch a fig and see on the bottom in real time the azimut value)
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
if ~axisNameCall
    if axnumber == 2 %axis = y
        X = [0 0; 0 0];
        Y = [0 perc*graduSpace; 0 perc*graduSpace] + labelNumber*graduSpace - perc*graduSpace/2;
        %(graduSpace/2)/2 to center under the graduation, (1-perc)/2) to
        %additionally shift a bit so that the perc% of graduSpace stay centered
        %under the graduation
    else %I assume axis = x, that I might later rotate if it's not actually x
        X = [0 perc*graduSpace; 0 perc*graduSpace] + labelNumber*graduSpace - perc*graduSpace/2; %+labelNumber*((graduSpace/2)+((1-perc)/2)*graduSpace)
        Y = [0 0; 0 0];
    end
    Z = [zmax zmax; zmax-boxHeightUnscaled zmax-boxHeightUnscaled];
    surfaceHandle = surf(X, Y, Z, 'FaceColor', 'texturemap', 'CData', textImage, 'EdgeColor', contour);
    if axnumber > 2
        rotate(surfaceHandle, [0 0 1], thetaInput,[0 0 0]);
    end
else %function called for plotting an axis name
    if axnumber == 2 %axis = y
        X = [0 0; 0 0];
        Y = [0 perc*labelWidth; 0 perc*labelWidth] + labelNumber*graduSpace;
        %(graduSpace/2)/2 to center under the graduation, (1-perc)/2) to
        %additionally shift a bit so that the perc% of graduSpace stay centered
        %under the graduation
    else %I assume axis = x, that I might later rotate if it's not actually x
        X = [0 perc*labelWidth; 0 perc*labelWidth] + labelNumber*graduSpace; %+labelNumber*((graduSpace/2)+((1-perc)/2)*graduSpace)
        Y = [0 0; 0 0];
    end
    Z = [zmax+boxHeightUnscaled zmax+boxHeightUnscaled; zmax zmax]; %here zmax is actually zmin to nor overlap the last tick
    surfaceHandle = surf(X, Y, Z, 'FaceColor', 'texturemap', 'CData', textImage, 'EdgeColor', contour);
    if axnumber > 2
        rotate(surfaceHandle, [0 0 1], thetaInput,[0 0 0]);
    end
end
% pause(1)
end