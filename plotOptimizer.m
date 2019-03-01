function [fig,h1] = plotOptimizer(cellComp)
%designed to work on a component of the cell outputed from loadlog().
%% load
%fictionalDataset;
planner = cellComp.planner;
metric = cellComp.metric;
scene = cellComp.scene;
query = cellComp.query;
countdown = cellComp.countdown;
acceptance = cellComp.acceptance;
run = cellComp.run;
seqParam = cellComp.seqParam;
seqM = cellComp.seqM;
step = cellComp.step; %vector
jointNamesVec = cellComp.jointNamesVec;
lims = [cellComp.jointAnglesMin ; cellComp.jointAnglesMax];

%% main:
nbRestarts = max(size(seqParam(1).seq));
nbParams = max(size(seqParam));
if nbParams > 2
    middleAxis = true;
    thetas = 90/(nbParams-2+1);
    %PUT ACTUALLY ALL THE FOLLOWING WITHIN THAT IF, AND ELSE ERROR USE
    %ANOTHER SCRIPT
end
indexesToPick = randperm(nbParams);

[~, idxMaxQuality] = max(seqM.seq);
for i=1:nbParams
    tmpvec = [];
    for j=1:nbRestarts
        tmpvec(end+1) = strlength(num2str(seqParam(i).seq(j)));
    end
    seqParam(i).howManyCharMaximum = max(tmpvec);
    seqParam(i).min = min(seqParam(i).seq);
    seqParam(i).max = max(seqParam(i).seq);
    seqParam(i).step = step(i);
    
    seqParam(i).maxHighlightable = true;
    if seqParam(i).seq(idxMaxQuality) == seqParam(i).min
        seqParam(i).maxHighlightable = false;
    end
    
    seqParam(i).lastHighlightable = true;
    if seqParam(i).seq(end) == seqParam(i).min
        seqParam(i).lastHighlightable = false;
    end
end

%% %%%%%%%%%%%%%%%%% TWEAKABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorAxis = 'k' ; colorEvolution = autumn(nbParams); colorMoves = cool(nbRestarts);
colorEmphasizeBest = 'g' ; colorEmphasizeLast = 'r';

contour = colorAxis;%'none'; %or colorAxis
tickFontSize = 20;
boxHeight = 0.1; %boxes wrapping the ticks
perc = 0.5; %if perc = 1 (100%), then the labels are all sticked together with no space inbetween

axisStemRatio = 0.9;
axisRadius = 0.01;

evolutionStemRatio = axisStemRatio;
evolutionRadius = axisRadius;

smooth = 40; %number of point on the circumference of the streamtubes

dontCropArrow = [-(1.2*(2*axisRadius)) 1]; %120percent to get some margin with the arrowHead radius := 2*arrowBody radius

howManyCharMaximum = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define the scaling factors for each axis,
%two first ones are 1unit long, whereas all the following are more or less
%greater than 1m long because they are chords within a square whith one
%extremity anchored onto a vertex:
mapAxisIntoZeroMag = @(x,xmin,xmax,magnitude) ((x-xmin)./(xmax-xmin)).*magnitude;

%% beginning of the bifurcation of the axes in two "parallel worlds" from matlab internal graphics storage point of view
firstfig = figure ; ax1 = axes;
%plot the ticks
ticks = {};
% disp(['idxMaxQuality = ',num2str(idxMaxQuality)])
% disp(['colorable = ',num2str(colorable)])
tmpTheta = NaN; %debug
for i=1:nbParams
    %debug
%     disp(['i = ',num2str(i)])
%     disp(strcat('param =  ',seqParam(indexesToPick(i)).name))
    
    mini = seqParam(indexesToPick(i)).min;
    step = seqParam(indexesToPick(i)).step;
    maxi = seqParam(indexesToPick(i)).max;
%     disp(['mini = ',num2str(mini)])
%     disp(['step = ',num2str(step)])
%     disp(['maxi = ',num2str(maxi)])
    lastValue = seqParam(indexesToPick(i)).seq(end);
    ticksAlong = [mini+step:step:maxi]; %don't want several ticks onto the 0 point
    nbTicksAlong = numel(ticksAlong);
%     disp(['lastValue = ',num2str(lastValue)])
%     disp(['ticksAlong = ',num2str(ticksAlong)])
%     disp(['nbTicksAlong = ',num2str(nbTicksAlong)])
    [~,idxLastInAlong] = find(lastValue == ticksAlong);
    [~,idxBestInAlong] = find(seqParam(indexesToPick(i)).seq(idxMaxQuality) == ticksAlong);
%     disp(['idxLastInAlong = ',num2str(idxLastInAlong)])
%     disp(['idxBestInAlong = ',num2str(idxBestInAlong)])
    if i <= 2
        ticksAlongMapped = mapAxisIntoZeroMag(ticksAlong,mini,maxi,1);
    else
        tmpTheta = (i-2)*thetas;
        scalefactor = lengthChordFromVertexInSquare(tmpTheta,1); %to map between 0 and smthg<sqrt(2)
        ticksAlongMapped = mapAxisIntoZeroMag(ticksAlong,mini,maxi,scalefactor);
    end
%     disp(['ticksAlongMapped = ',num2str(ticksAlongMapped)])
    %handle an exception where one param progressed overall from only 1 unit far
    %from its origin:
    if nbTicksAlong == 1
        graduSpace = ticksAlongMapped;
    elseif nbTicksAlong == 0 %e.g:mini=0, step=0.5, maxi=0, because there was only 1 sumonning and no restart constrainted to progress forward!
        graduSpace = step;
    else
        graduSpace = diff(ticksAlongMapped(1:2));
    end
%     disp(['graduSpace = ',num2str(graduSpace)])
    for j=1:nbTicksAlong
        colorSent = colorAxis; %bring back
        if j == idxLastInAlong & seqParam(indexesToPick(i)).lastHighlightable == 1
%             disp('j == idxLastInAlong')
            colorSent = colorEmphasizeLast;
        end
        if j==idxBestInAlong & seqParam(indexesToPick(i)).maxHighlightable == 1
%             disp('j==idxBestInAlong & colorable==true')
            colorSent = colorEmphasizeBest;
        end
        ticks{end+1} = rotateAxisTicks2(num2str(ticksAlong(j)), ...
                                       seqParam(indexesToPick(i)).howManyCharMaximum, ...
                                       colorSent, ...
                                       dontCropArrow(1), ...
                                       graduSpace, ...
                                       boxHeight, ...
                                       perc, ...
                                       j, ...
                                       i, ...
                                       tmpTheta, ...
                                       0, ...
                                       NaN, ...
                                       contour);
        hold on
    end
    %plot the axis name
    ticks{end+1} = rotateAxisTicks2(seqParam(indexesToPick(i)).name, ...
                                   strlength(seqParam(indexesToPick(i)).name), ...
                                   colorAxis, ...
                                   0, ...
                                   graduSpace, ...
                                   boxHeight, ...
                                   1, ...
                                   nbTicksAlong, ...
                                   i, ...
                                   tmpTheta, ...
                                   1, ...
                                   0.3, ...
                                   colorAxis);
    hold on
end

%% second parallel world, enlightened this time!
tempfig = figure; ax2 = axes;

%plot the parameter axis
axis = [1;0;0];
for i=1:nbParams
    seqParam(indexesToPick(i)).mapseq = mapAxisIntoZeroMag(seqParam(indexesToPick(i)).seq, seqParam(indexesToPick(i)).min, seqParam(indexesToPick(i)).max,1); %mapped between 0 and 1
    if i <= 2
        ax{i} = arrow3D([0 0 0], axis, colorAxis, axisStemRatio, axisRadius); %i=1 : x
        axis = cross([0;0;1],axis); %i=2 : y
        hold on
    else
        tmpTheta = (i-2)*thetas;
        scalefactor = lengthChordFromVertexInSquare(tmpTheta,1); %to map between 0 and smthg<sqrt(2)
        seqParam(indexesToPick(i)).mapseq = seqParam(indexesToPick(i)).mapseq * scalefactor;
        ax{i} = arrow3D([0 0 0], scalefactor*[cos(deg2rad(tmpTheta)) sin(deg2rad(tmpTheta)) 0], colorAxis, axisStemRatio, axisRadius);
        hold on
    end
end
%axis z:
seqM.min = 0 ; seqM.max = 1; % ASSUMPTION
seqM.mapseq = mapAxisIntoZeroMag(seqM.seq, seqM.min, seqM.max,1); %mapped between 0 and 1
seqM.magz = diff(seqM.mapseq);
ax{end+1} = arrow3D([0 0 0], [0 0 1], colorAxis, axisStemRatio, axisRadius);
hold on

%plot the graduations:
[xs,ys,zs] = sphere(smooth);
%scale the sphere pattern:
[xs,ys,zs] = feval(@(x) x{:}, {xs*(2*axisRadius),ys*(2*axisRadius),zs*(2*axisRadius)}); %feval x{:} = multi initialization
ax{end+1} = surf(xs,ys,zs,'FaceColor', colorAxis, 'EdgeColor', 'none');
for i=1:nbParams
    mini = seqParam(indexesToPick(i)).min;
    step = seqParam(indexesToPick(i)).step;
    maxi = seqParam(indexesToPick(i)).max;
    spheresAlong = [mini:step:maxi-step]; %don't want a sphere to overlap the axis arrow bits
    nbSpheresAlong = numel(spheresAlong); %(equals btw nbTicksAlong)
    if i == 1
        spheresAlong = mapAxisIntoZeroMag(spheresAlong,mini,maxi,1);
        seqParam(indexesToPick(i)).xgradu = spheresAlong;
        seqParam(indexesToPick(i)).ygradu = zeros(1,nbSpheresAlong);
    elseif i == 2
        spheresAlong = mapAxisIntoZeroMag(spheresAlong,mini,maxi,1);
        seqParam(indexesToPick(i)).ygradu = spheresAlong;
        seqParam(indexesToPick(i)).xgradu = zeros(1,nbSpheresAlong);
    else
        tmpTheta = (i-2)*thetas;
        scalefactor = lengthChordFromVertexInSquare(tmpTheta,1); %to map between 0 and smthg<sqrt(2)
        spheresAlong = mapAxisIntoZeroMag(spheresAlong,mini,maxi,scalefactor);
        seqParam(indexesToPick(i)).xgradu = spheresAlong*cos(deg2rad(tmpTheta));
        seqParam(indexesToPick(i)).ygradu = spheresAlong*sin(deg2rad(tmpTheta));
    end
    for j=1:nbSpheresAlong
        ax{end+1} = surf(xs+seqParam(indexesToPick(i)).xgradu(j), ...
                         ys+seqParam(indexesToPick(i)).ygradu(j), ...
                         zs+0, ...
                         'FaceColor', colorAxis, ...
                         'EdgeColor', 'none');
        hold on
    end
end

%plot the sequence of recalls:
count = 0;
for i=1:nbParams
    if i == 1 %x
        seqParam(indexesToPick(i)).x = seqParam(indexesToPick(i)).mapseq;
        seqParam(indexesToPick(i)).y = zeros(1,nbRestarts);
    elseif i == 2 %y
        seqParam(indexesToPick(i)).x = zeros(1,nbRestarts);
        seqParam(indexesToPick(i)).y = seqParam(indexesToPick(i)).mapseq;
    else %chord axis
        tmpTheta = (i-2)*thetas;
        seqParam(indexesToPick(i)).x = cos(deg2rad(tmpTheta))*seqParam(indexesToPick(i)).mapseq;
        seqParam(indexesToPick(i)).y = sin(deg2rad(tmpTheta))*seqParam(indexesToPick(i)).mapseq;
    end
    seqParam(indexesToPick(i)).magx = diff(seqParam(indexesToPick(i)).x);
    seqParam(indexesToPick(i)).magy = diff(seqParam(indexesToPick(i)).y);
    for j=1:nbRestarts-1 %2 arrows for 3 points
        count = count+1;
        dataArrows{count} = arrow3D([seqParam(indexesToPick(i)).x(j) seqParam(indexesToPick(i)).y(j) seqM.mapseq(j)], [seqParam(indexesToPick(i)).magx(j) seqParam(indexesToPick(i)).magy(j) seqM.magz(j)], colorEvolution(i,:), evolutionStemRatio, evolutionRadius);
        hold on
    end
end

%plot the sequence of sets of parameters as tubes of iso quality:
if numel(indexesToPick) > 1
    count = 0;
    if numel(indexesToPick) > 2
        indexesToPickForIso = [indexesToPick(1),indexesToPick(3:end),indexesToPick(2)]; %in order for the streamtubes to use the shortest path, I must pushback axis y (index 2 out of n) to the end of the list!
    else %numel(indexesToPick) = 2
        indexesToPickForIso = indexesToPick;
    end
    for i=1:nbRestarts
       x = [] ; y = [] ; z = [];
       for j=1:nbParams
           x(end+1,1) = seqParam(indexesToPickForIso(j)).x(i);
           y(end+1,1) = seqParam(indexesToPickForIso(j)).y(i);
           z(end+1,1) = seqM.mapseq(i);
       end
       x(isnan(x)) = 0 ; y(isnan(y)) = 0;
       xx{i} = x ; yy{i} = y ; zz{i} = z;
       XYZ{1} = [xx{i},yy{i},zz{i}]; %streamtubes wants only cells idk why...
       count = count+1;
       isoQualityTubes{count} = streamtube(XYZ,[30*evolutionRadius, smooth]);
       set(isoQualityTubes{count},'EdgeColor','none','AmbientStrength',1,'FaceColor',colorMoves(i,:)) %'EdgeColor',colorMoves(i,:) to get rid of the lighting (if visually not clear enough)
       hold on
    end
end
bar = colorbar('Ticks',linspace(0, 1, nbRestarts),'TickLabels',num2cell(1:nbRestarts));
str = {'Last parameter set tweak';'(and call to';strcat(planner,')')};
set(get(bar,'title'),'string',str);

% tbl_str = tableTitle(jointNamesVec,lims,"Joint angle limits (rad)");
% set(get(bar,'YLabel'),'string',tbl_str,'Interpreter','latex');
    
camlight headlight
lighting gouraud

wrap = plotPositiveUnitaryBox([colorAxis,'-'],1);
hold on
%% Merge the two parallel figs
x11 = [ax1.XLim ; ax2.XLim];
x12 = [min(x11(:,1)), max(x11(:,2))];
y11 = [ax1.YLim ; ax2.YLim];
y12 = [min(y11(:,1)), max(y11(:,2))];
z11 = [ax1.ZLim ; ax2.ZLim];
z12 = [min(z11(:,1)), max(z11(:,2))];
hax = [ax1;ax2];
set(hax,'XLim',x12,'YLim',y12,'ZLim',z12)

%Adjust the view to be sure
ax2.View = ax1.View;
ax2.CameraPosition = ax1.CameraPosition;
ax2.CameraTarget = ax1.CameraTarget;
ax2.DataAspectRatio = ax1.DataAspectRatio;
ax2.PlotBoxAspectRatio = ax1.PlotBoxAspectRatio;
ax2.CameraViewAngle = ax1.CameraViewAngle;
ax2.Projection = ax1.Projection;
ax2.Position = ax1.Position;
ax2.OuterPosition = ax1.OuterPosition;
ax1.CLim = ax2.CLim; %it's figmain who should adapt its color range to tempfig since it's tempfig that contains the colorbar

%Remove secondary axes background, then move it to main figure
ax2.Visible = 'off';

ax2.Parent = firstfig; delete(tempfig)

%Link the view between axes
%h1 = linkprop(hax, 'View');
%or link even more properties at once
h1 = linkprop(hax, {'View', 'XLim', 'YLim', 'ZLim', ...
    'CameraPosition','CameraTarget', ...
    'DataAspectRatio','PlotBoxAspectRatio', ...
    'CameraViewAngle', 'Projection', ...
    'Position', 'OuterPosition', ...
    'CLim'}); %linkprop keeps the equality through time, but previous assignations have to be made!!!
%%
colormap(cool(nbRestarts))

%to potentially remove :
%disp(['xylim should stop at ',num2str(-(1.2*(2*axisRadius)))])
%xlim(dontCropArrow) ; ylim(dontCropArrow) ; zlim([-(1.2*(2*axisRadius)+boxHeight), 1]) 

set(gca,'Projection','perspective')

grid off
set(gca,'XColor','none') ; set(gca,'YColor','none') ; set(gca,'ZColor','none')

line1 = strcat("Iterative tweaks of ",planner, " parameter set");
line2 = 'associated to the quality of the resulting plan, ';
line22 = strcat(line2,'with respect to our ',metric,' metric.');
line3 = strcat('Context: scene "',scene,'"');
longStr = {line1;line2;line3; ...
            strcat('query "',query, ...
               '",'); strcat('countdown T = ',countdown, ...
               's, acceptance(t):=',acceptance)};
t1 = title(longStr, 'Interpreter', 'none'); % https://fr.mathworks.com/matlabcentral/answers/9260-disabling-printing-underscore-as-subscript-in-figures
set(gcf,'color','w');

tbl_str = tableTitle(jointNamesVec,lims,"Joint angle limits (rad)");
t2 = text('string',tbl_str,'Position', [0.5, -0.055, 0],'Units', 'normalized','HorizontalAlignment','center','Interpreter','latex');

fig = get(firstfig);