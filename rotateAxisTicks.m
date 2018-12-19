function surfaceHandle = rotateAxisTicks(str,color,fontsize,zmax,graduSpace,boxHeight,perc,labelNumber,axnumber,thetaInput)
%https://stackoverflow.com/questions/9843048/matlab-how-to-plot-a-text-in-3d
    %zmax : give it a negative value to not overlap the axis
    %graduSpace : space between each graduation, within the projected on [0,1] axis if axis = x||y, OR local (not yet projected on x,y) axis !!
    %boxHeight : width of the boxes depend on how much the axis graduations are refined, so height shouldn't depend on graduSpace
    %perc : if perc = 1 (100%), then the labels are all sticked together with no space inbetween
    %labelNumber : the first tick to be displayed is actually associated to the second graduation (0 can't get several labels)
    %axnumber : out of nbParams, 1 for x, 2 for y, then, from closest to x, to closest to y : 3 to nbParams.
    %thetaInput : (angle around z, from x to the axis) has to be in degree

    %% Seems like there is no way to get rid of the black contouring...
    hFigure = figure(1000);
    set(hFigure,'Color', 'w', ...        % Create a figure window
                     'MenuBar', 'none', ...
                     'ToolBar', 'none');
    hText = uicontrol('Parent', hFigure, ...  % Create a text object
                      'Style', 'text', ...
                      'String', str, ...
                      'BackgroundColor', 'w', ...
                      'ForegroundColor', color, ...
                      'FontSize', fontsize, ...
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
        Y = [0 perc*graduSpace; 0 perc*graduSpace] + labelNumber*graduSpace - perc*graduSpace/2;
        %(graduSpace/2)/2 to center under the graduation, (1-perc)/2) to
        %additionally shift a bit so that the perc% of graduSpace stay centered
        %under the graduation
    else %I assume axis = x, that I might later rotate if it's not actually x
        X = [0 perc*graduSpace; 0 perc*graduSpace] + labelNumber*graduSpace - perc*graduSpace/2; %+labelNumber*((graduSpace/2)+((1-perc)/2)*graduSpace)
        Y = [0 0; 0 0];
    end
    Z = [zmax zmax; zmax-boxHeight zmax-boxHeight];
    surfaceHandle = surf(X, Y, Z, 'FaceColor', 'texturemap', 'CData', textImage);
    if axnumber > 2
        rotate(surfaceHandle, [0 0 1], thetaInput,[0 0 0]);
    end
end