% function mainWrapPlotLog(fileName)
clc
% fileName = 'datas2019-01-08_21_52.log'; %RRTconnect 1param, 2runs, 50random queries, 0:2:2s of countdown
% fileName = 'datas2019-01-09_21_58.log'; %TRRT 9params, 2runs, 50random queries, 2:2:4s of countdown

% fileName = 'datas2019-01-09_23_15.log'; %TRRT 9params, 2runs, 50random queries, 0:2:2s of countdown

% fileName = 'goodmins.log';
% fileName = 'TRRTwrapped.log'; %not so much in that one...
% fileName = 'ESTwrapped.log'; %skipped to see the plot from 70 to 171
% fileName = 'RRTwrapped.log'; %i=570 to end gives good plots
fileName = 'RRTCwrapped.log';

c = loadlog(fileName);
fig = cell(0,1) ; rules = cell(0,1);
% for i=1:numel(c)
for i=640:numel(c) 
    
% for i=24:24

    [fig{end+1,1},rules{end+1,1}] = plotOptimizer(c{i});
    disp(['i = ',num2str(i)]) ; pause(4);
end
% end