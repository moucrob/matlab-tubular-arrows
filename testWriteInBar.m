% https://fr.mathworks.com/matlabcentral/answers/175955-how-to-assign-a-label-to-each-bar-in-stacked-bar-graph
D = randi(10, 5, 3);
figure
hBar = bar(D);%, 'stacked');matl
yd = get(hBar, 'YData');
yjob = {'Job A' 'Job B' 'Job C'};
barbase = cumsum([zeros(size(D,1),1) D(:,1:end-1)],2);
joblblpos = D/2 + barbase;
for k1 = 1:size(D,1)
    text(xt(k1)*ones(1,size(D,2)), joblblpos(k1,:), yjob, 'HorizontalAlignment','center')
end

figure
b2 = bar(countdowns,ones(1,numel(countdowns)));
hold on
xt = get(gca, 'XTick');
for i=1:numel(countdowns)
    t = text(countdowns(i),0.5,'test','HorizontalAlignment','center');
    set(t,'Rotation',90);
    hold on
end
    