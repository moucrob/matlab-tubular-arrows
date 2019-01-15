% function mainWrapPlotLog(fileName)
clc
% fileName = 'datas2019-01-08_21_52.log'; %RRTconnect 1param, 2runs, 50random queries, 0:2:2s of countdown
% fileName = 'datas2019-01-09_21_58.log'; %TRRT 9params, 2runs, 50random queries, 2:2:4s of countdown
% fileName = 'datas2019-01-09_23_15.log'; %TRRT 9params, 2runs, 50random queries, 0:2:2s of countdown
% fileName = 'goodmins.log';
fileName = 'goodminsRRT.log';
c = loadlog(fileName);
for i=1:numel(c)
% for i=12:12
    plotOptimizer(c{i});
end
% end