% function mainWrapPlotLog(fileName)
fileName = 'datas2019-01-06_16_42.log';
c = loadlog(fileName);
for i=1:numel(c)
    plotOptimizer(c{i});
end
% end