%To see if plotting a tick after setting camlight headlight will leads to
%its background becoming gray or not
%clear all
figure
arrow = arrow3D([0 0 0], [1 1 1], 'r', 0.8, 0.2, 1.5);
set(arrow, 'EdgeColor', 'interp', 'FaceColor', 'interp');
%camlight headlight %might be interesting to uncomment this line
pause(5)
surfaceHandle = rotateAxisTicks('lol','r',10,-0.3,0.5,0.5,1,1,1,0);
pause(5)
camlight headlight
%material(surfaceHandle,'default') %doesn't work
%surfaceHandle1.FaceLighting = 'none' %doesn't work