clear all
clc
%% fictional dataset

%given a scene + query + a run + a countdown
scene = 'blabla';
query = 'backflip';
run = 'run number10';
countdown = '15sec';
acceptance = '1-t/T';

seqParam(1).seq = [0 1 0 1 2 1 2 3 4 3 2];
seqParam(1).min = 0 ; seqParam(1).max = 5 ; seqParam(1).step = 1;

seqParam(2).seq = [0.0 0.1 0.2 0.1 0.2 0.3 0.4 0.3 0.2 0.3 0.4];
seqParam(2).min = 0. ; seqParam(2).max = 0.5 ; seqParam(2).step = 0.1;

seqParam(3).seq = [10 11 10 11 10 12 11 12 13 14 15];
seqParam(3).min = 10 ; seqParam(3).max = 17 ; seqParam(3).step = 1;

seqParam(4).seq = [3.5 4. 4.5 4. 4.5 5. 5.5 6. 5.5 6. 5.5];
seqParam(4).min = 3.5 ; seqParam(4).max = 7 ; seqParam(4).step = 0.5;

seqM.seq = [0.2 0.3 0.6 0.8 0.74 0.35 0.24 0.15 0.48 0.69 0.47];
seqM.min = 0. ; seqM.max = 1.;

%% what should last:
nbRestarts = max(size(seqParam(1).seq));
nbParams = max(size(seqParam));
if nbParams > 2
    middleAxis = true;
    thetas = 90/(nbParams-2+1);
    %PUT ACTUALLY ALL THE FOLLOWING WITHIN THAT IF, AND ELSE ERROR USE
    %ANOTHER SCRIPT
end
indexesToPick = randperm(nbParams);

%%%%%%%%%%%%%%%%%%%% TWEAKABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorAxis = 'k' ; colorEvolution = autumn(nbParams);
colorIsoMetric = 'g' ; colorEmphasize = 'g';

axisStemRatio = 0.9;
axisRadius = 0.01;
axisHeadRatio = 1.5; headRadius = axisHeadRatio*axisRadius;

evolutionStemRatio = axisStemRatio;
evolutionRadius = axisRadius;
evolutionHeadRatio = axisHeadRatio;

smooth = 40; %number of point on the circumference of the streamtubes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Define the scaling factors for each axis,
%two first ones are 1unit long, whereas all the following are more or less
%greater than 1m long because they are chords within a square whith one
%extremity anchored onto a vertex
mapAxisIntoZeroMag = @(x,xmin,xmax,magnitude) ((x-xmin)./(xmax-xmin)).*magnitude;
axis = [1;0;0];
figure
colormap(cool)
for i=1:nbParams %plot the associated axis
    seqParam(indexesToPick(i)).mapseq = mapAxisIntoZeroMag(seqParam(indexesToPick(i)).seq, seqParam(indexesToPick(i)).min, seqParam(indexesToPick(i)).max,1); %mapped between 0 and 1
    if i <= 2
        ax{i} = arrow3D([0 0 0], axis, colorAxis, axisStemRatio, axisRadius, axisHeadRatio); %i=1 : x
        axis = cross([0;0;1],axis); %i=2 : y
        hold on
    else
        tmpTheta = (i-2)*thetas;
        scalefactor = lengthChordFromVertexInSquare(tmpTheta,1); %to map between 0 and smthg<sqrt(2)
        seqParam(indexesToPick(i)).mapseq = seqParam(indexesToPick(i)).mapseq * scalefactor;
        ax{i} = arrow3D([0 0 0], scalefactor*[cos(deg2rad(tmpTheta)) sin(deg2rad(tmpTheta)) 0], colorAxis, axisStemRatio, axisRadius, axisHeadRatio);
        hold on
    end
end
%axis z:
seqM.mapseq = mapAxisIntoZeroMag(seqM.seq, seqM.min, seqM.max,1); %mapped between 0 and 1
seqM.magz = diff(seqM.mapseq);
zax = arrow3D([0 0 0], [0 0 1], colorAxis, axisStemRatio, axisRadius, axisHeadRatio);
set(zax, 'EdgeColor', 'interp', 'FaceColor', 'interp');
hold on

%plot the graduations
[xs,ys,zs] = sphere(smooth);
%scale the sphere pattern 
[xs,ys,zs] = feval(@(x) x{:}, {xs*headRadius,ys*headRadius,zs*headRadius}); %feval x{:} = multi initialization
ax{end+1} = surf(xs,ys,zs);
hold on
for i=1:nbParams
    min = seqParam(indexesToPick(i)).min;
    step = seqParam(indexesToPick(i)).step;
    max = seqParam(indexesToPick(i)).max;
    spheresAlong = [min:step:max-step]; %don't want a sphere to overlap the axis arrow bits
    nbSpheresAlong = numel(spheresAlong);
    if i == 1
        spheresAlong = mapAxisIntoZeroMag(spheresAlong,min,max,1);
        seqParam(indexesToPick(i)).xgradu = spheresAlong;
        seqParam(indexesToPick(i)).ygradu = zeros(1,nbSpheresAlong);
    elseif i == 2
        spheresAlong = mapAxisIntoZeroMag(spheresAlong,min,max,1);
        seqParam(indexesToPick(i)).ygradu = spheresAlong;
        seqParam(indexesToPick(i)).xgradu = zeros(1,nbSpheresAlong);
    else
        tmpTheta = (i-2)*thetas;
        scalefactor = lengthChordFromVertexInSquare(tmpTheta,1); %to map between 0 and smthg<sqrt(2)
        spheresAlong = mapAxisIntoZeroMag(spheresAlong,min,max,scalefactor);
        seqParam(indexesToPick(i)).xgradu = spheresAlong*cos(deg2rad(tmpTheta));
        seqParam(indexesToPick(i)).ygradu = spheresAlong*sin(deg2rad(tmpTheta));
    end
    for j=1:nbSpheresAlong
        ax{end+1} = surf(xs+seqParam(indexesToPick(i)).xgradu(j),ys+seqParam(indexesToPick(i)).ygradu(j),zs+0);
        hold on
    end
end

%plot the sequence of recalls
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
        dataArrows{count} = arrow3D([seqParam(indexesToPick(i)).x(j) seqParam(indexesToPick(i)).y(j) seqM.mapseq(j)], [seqParam(indexesToPick(i)).magx(j) seqParam(indexesToPick(i)).magy(j) seqM.magz(j)], colorEvolution(i,:), evolutionStemRatio, evolutionRadius, evolutionHeadRatio);
        hold on
    end
end

%plot the sequence of sets of parameters as tubes of iso quality
count = 0;
for i=1:nbRestarts
   x = [] ; y = [] ; z = [];
   for j=1:nbParams
       x(end+1,1) = seqParam(j).x(i);
       y(end+1,1) = seqParam(j).y(i);
       z(end+1,1) = seqM.mapseq(i);
   end
   
   xx{i} = x ; yy{i} = y ; zz{i} = z;
   XYZ{1} = [xx{i},yy{i},zz{i}]; %streamtubes wants only cells idk why...
   count = count+1;
   isoQualityTubes{count} = streamtube(XYZ,[30*evolutionRadius, smooth]);
   %set(isoQualityTubes{count},'EdgeColor','none','AmbientStrength',1,'FaceColor',colorIsoMetric)
   set(isoQualityTubes{count},'EdgeColor','interp','AmbientStrength',1,'FaceColor','interp')
   hold on
end

grid on ; %grid minor
xlabel('x') ; ylabel('y') ; zlabel('z')
dontCropArrow = [-(1.2*headRadius) 1]; %120percent to get some margin
xlim(dontCropArrow) ; ylim(dontCropArrow) ; zlim(dontCropArrow) 

set(gca,'Projection','perspective')
camlight headlight
lighting gouraud