figure
plot(0,0,’*’)
axis([-1 1 -1 1])
axis equal square
set(gca,’xTick’,[-1 0 1],’yTick’,[-1 0 1])
grid on
text(0,0,’  (0,0)  ’,HA,’center’,’color’,’r’,’Fontweight’,’bold’)
title(’Center of text aligned.’)