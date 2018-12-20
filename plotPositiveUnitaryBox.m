function wrap = plotPositiveUnitaryBox(spec,mag)
%spec = 'k-';
%mag = 1;
%                                                /|\
%                                               / | \
%                                              |\/ \/|
%                                              | \z/ |x
%                                             y \ | /
%visualize a cube which bottom face is like this \|/
xStartEnd = [0,1; %x
             0,0; %y
             0,0; %z, then rotate the cube from 180° around z by anchoring the camera
             1,0; %new x
             1,1; %new y
             1,1; %new z then bring back the inital cube
             0,1; %upper x
             0,0; %upper y
             1,0; %anti lower x (point symetry
             1,1; %anti lower y
             1,1; %"right z"
             0,0;]'*mag;%"left z"

yStartEnd = [0,0;
             0,1;
             0,0;
             1,1;
             1,0;
             1,1;
             0,0;
             0,1;
             1,1;
             1,0;
             0,0;
             1,1]'*mag;
         
zStartEnd = [0,0;
             0,0;
             0,1;
             0,0;
             0,0;
             0,1;
             1,1;
             1,1;
             1,1;
             1,1;
             0,1;
             0,1]'*mag;

wrap = plot3(xStartEnd,yStartEnd,zStartEnd,spec);