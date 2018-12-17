clear all
x=[0,1]; %extremities of the vector pointing from the origin towards the center of the largest slice of the cone
y=[0,0.0001]; %cannot be 0
z=[0,0.0001];
u=[NaN,1]; %1st component of u,v,w can be whatever
v=[NaN,1];
w=[NaN,1];
[X,Y,Z] = meshgrid(x,y,z);
[U,V,W] = meshgrid(u,v,w);

xmin = min(x(:));
xmax = max(x(:));
ymin = min(y(:));
ymax = max(y(:));
zmin = min(z(:));
zmax = max(z(:));
n = 1; %n = how many cones along each direction..
xrange = linspace(xmin,xmax,n);
yrange = linspace(ymin,ymax,n);
zrange = linspace(zmin,zmax,n);
[CX,CY,CZ] = meshgrid(xrange,yrange,zrange);

figure
d = arrow3D([0,0,0], [1,1,1], [0,1,0],0.8,0.5);

c = coneplot(X,Y,Z,U,V,W,CX,CY,CZ,0);
c.FaceColor = 'red';
c.EdgeColor = 'none';
camlight right
lighting gouraud
c.DiffuseStrength = 0.8;
grid on ; grid minor
xlabel('x') ; ylabel('y') ; zlabel('z')