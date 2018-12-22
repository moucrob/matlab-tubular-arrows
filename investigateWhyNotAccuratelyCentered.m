color = 'k';
txt = '1';
howManyCharMaximum = 7;
boxWidth = 250;
boxHeight = 100;

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
hText = text(x, y, ...
            txt, ...
            'Units', 'points', ...
            'FontSize', fontSize, ...
            'HorizontalAlignment', 'left', ...
            'VerticalAlignment', 'middle', ...
            'Color', color);