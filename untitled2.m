clear all
%% fictional dataset
param1min = 0 ; param1max = 5 ; param1step = 1;
param2min = 0 ; param1max = 0.5 ; param1step = 0.1;
param3min = 10 ; param1max = 17 ; param1step = 1;
param2min = 3.5 ; param1max = 7 ; param1step = 0.5;

metricmin = 0. ; metricmax = 1.;

%given a scene + query + a run + a countdown
scene = 'blabla';
query = 'backflip';
run = 'run number10';
countdown = '15sec';

seqParam{1} = [0 1 0 1 2 1 2 3 4 3 2]; %length = how many restarts
seqParam{2} = [0.0 0.1 0.2 0.1 0.2 0.3 0.4 0.3 0.2 0.3 0.4];
seqParam{3} = [10 11 10 11 10 12 11 12 13 14 15];
seqParam{4} = [3.5 4. 4.5 4. 4.5 5. 5.5 6. 5.5 6. 5.5];
seqM = [0.2 0.3 0.6 0.8 0.74 0.35 0.24 0.15 0.48 0.69 0.47];

%% what should last:
colorAxis = 'k'; colorEvolution = 'b'; colorIsoMetric = 'g'; colorEmphasize = 'r';
axisStemRatio = 0.9 ; axisRad = 0.1 ; axisHeadRatio = 1.5;

nbParams = max(size(seqParam));
indexesToPick = randperm(nbParams);
figure
%axis z
z = arrow3D([0 0 metricmin], [0 0 metricmax], colorAxis, axisStemRatio, axisRad, axisHeadRatio);
hold on
x = arrow3D([0 0 metricmin], [0 0 metricmax], colorAxis, axisStemRatio, axisRad, axisHeadRatio);



grid on ; grid minor
xlabel('x') ; ylabel('y') ; zlabel('z')

xx{1} = 0:xmax:xmax;
yy{1} = 0:ymax:ymax;
zz{1} = 0:1:1; %quality (or 100...)

for i=1:2
    zz{i} = i-1:1:2;
    yy{i} = zz{i}.*i.*sin(zz{i});
    xx{i} = zz{i}.*i.*cos(zz{i});
    XYZ{i} = [xx{i}',yy{i}',zz{i}'];
end
daspect([1,1,1])
figure
diam = 3;
smooth = 40; %number of points per circumference
tubes = streamtube(XYZ,[diam, smooth]);
set(tubes,'EdgeColor','none','AmbientStrength',0.5,'FaceColor','r')
set(gca,'Projection','perspective')
camlight right