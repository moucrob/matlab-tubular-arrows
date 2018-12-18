clear all
%% fictional dataset

%given a scene + query + a run + a countdown
scene = 'blabla';
query = 'backflip';
run = 'run number10';
countdown = '15sec';

seqParam(1).seq = [0 1 0 1 2 1 2 3 4 3 2];
seqParam(1).min = 0 ; seqParam(1).max = 5 ; seqParam(1).step = 1;

seqParam(2).seq = [0.0 0.1 0.2 0.1 0.2 0.3 0.4 0.3 0.2 0.3 0.4];
seqParam(2).min = 0. ; seqParam(2).max = 0.5 ; seqParam(2).step = 0.1;

seqParam(3).seq = [10 11 10 11 10 12 11 12 13 14 15];
seqParam(3).min = 10 ; seqParam(3).max = 17 ; seqParam(3).step = 1;

seqParam(4).seq = [3.5 4. 4.5 4. 4.5 5. 5.5 6. 5.5 6. 5.5];
seqParam(4).min = 3.5 ; seqParam(4).max = 7 ; seqParam(4).step = 0.1;

seqM.seq = [0.2 0.3 0.6 0.8 0.74 0.35 0.24 0.15 0.48 0.69 0.47];
seqM.min = 0. ; seqM.max = 1.;

%% what should last:
colorAxis = 'k'; colorEvolution = 'b'; colorIsoMetric = 'g'; colorEmphasize = 'r';

axisStemRatio = 0.9;
axisRadius = 0.01;
axisHeadRatio = 1.5;

evolutionStemRatio = axisStemRatio;
evolutionRadius = axisRadius;
evolutionHeadRatio = axisHeadRatio;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbRestarts = max(size(seqParam(1).seq));
nbParams = max(size(seqParam));
if nbParams > 2
    middleAxis = true;
    thetas = 90/(nbParams-2+1);
    %PUT ACTUALLY ALL THE FOLLOWING WITHIN THAT IF, AND ELSE ERROR USE
    %ANOTHER SCRIPT
end
indexesToPick = randperm(nbParams);

%Define the scaling factors for each axis,
%two first ones are 1unit long, whereas all the following are more or less
%greater than 1m long because they are chords within a square whith one
%extremity anchored onto a vertex
axis = [1;0;0];
figure
for i=1:nbParams
    %plot the associated axis
    for j=1:nbRestarts 
        seqParam(indexesToPick(i)).mapseq(j) = (seqParam(indexesToPick(i)).seq(j)-seqParam(indexesToPick(i)).min)/seqParam(indexesToPick(i)).max;
    end %mapped between 0 and 1
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
for j=1:nbRestarts 
        seqM.mapseq(j) = (seqM.seq(j)-seqM.min)/seqM.max;
end %mapped between 0 and 1
seqM.magz = diff(seqM.mapseq);
z = arrow3D([0 0 0], [0 0 1], colorAxis, axisStemRatio, axisRadius, axisHeadRatio);
hold on

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
        dataArrows{count} = arrow3D([seqParam(indexesToPick(i)).x(j) seqParam(indexesToPick(i)).y(j) seqM.mapseq(j)], [seqParam(indexesToPick(i)).magx(j) seqParam(indexesToPick(i)).magy(j) seqM.magz(j)], colorEvolution, evolutionStemRatio, evolutionRadius, evolutionHeadRatio);
    end
end

grid on ; grid minor
xlabel('x') ; ylabel('y') ; zlabel('z')

% xx{1} = 0:xmax:xmax;
% yy{1} = 0:ymax:ymax;
% zz{1} = 0:1:1; %quality (or 100...)
% 
% for i=1:2
%     zz{i} = i-1:1:2;
%     yy{i} = zz{i}.*i.*sin(zz{i});
%     xx{i} = zz{i}.*i.*cos(zz{i});
%     XYZ{i} = [xx{i}',yy{i}',zz{i}'];
% end
% daspect([1,1,1])
% figure
% diam = 3;
% smooth = 40; %number of points per circumference
% tubes = streamtube(XYZ,[diam, smooth]);
% set(tubes,'EdgeColor','none','AmbientStrength',0.5,'FaceColor','r')
set(gca,'Projection','perspective')
camlight headlight
lighting gouraud