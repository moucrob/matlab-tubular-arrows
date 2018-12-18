clear all
load wind

xmax=1; ymax=1; %maximums of 2 in n params
zmax = 1; %quality = 1 (or 100...)

diamaxis = 0.2;
diamtubes = 0.4;
smooth = 40; %number of points per circumference
percentagetube = 0.8;
percentagecone = 1-percentagetube;

xmax = percentagetube*xmax;
ymax = percentagetube*ymax;
zmax = percentagetube*zmax;

%axis x
xx{1} = [0,xmax];
yy{1} = zeros(1,2);
zz{1} = zeros(1,2);
xxcone{1} = 0;

%axis y
xx{2} = zeros(1,2);
yy{2} = 0:ymax:ymax;
zz{2} = zeros(1,2); 

%axis z
xx{3} = zeros(1,2);
yy{3} = zeros(1,2);
zz{3} = 0:zmax:zmax; 

for i=1:max(size(xx))
    XYZ{i} = [xx{i}',yy{i}',zz{i}'];
end
daspect([1,1,1])
figure
tubes = streamtube(XYZ,[diamaxis, smooth]);
% cones = coneplot(XYZ);
% set(tubes,'EdgeColor','none','AmbientStrength',0.5,'FaceColor','k')
set(gca,'Projection','perspective')
camlight right