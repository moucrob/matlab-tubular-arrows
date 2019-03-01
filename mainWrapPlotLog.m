% function mainWrapPlotLog(fileName)
clc
clear all
% fileName = 'logs/unrestricted/datas2019-01-08_21_52.log'; %RRTconnect 1param, 2runs, 50random queries, 0:2:2s of countdown
% fileName = 'logs/unrestricted/datas2019-01-09_21_58.log'; %TRRT 9params, 2runs, 50random queries, 2:2:4s of countdown

%fileName = 'logs/unrestricted/datas2019-01-09_23_15.log'; %TRRT 9params, 2runs, 50random queries, 0:2:2s of countdown

%fileName = 'logs/restricted/TRRTwrapped.log'; %very low improvements, defo
%need to properlier estabish the search space for TRRT

% fileName = 'logs/unrestricted/goodmins.log';
% fileName = 'logs/unrestricted/TRRTwrapped.log'; %not so much in that one...
% fileName = 'logs/unrestricted/ESTwrapped.log'; %skipped to see the plot from 70 to 171
% fileName = 'logs/unrestricted/RRTwrapped.log'; %i=570 to end gives good plots

fileName = 'logs/unrestricted/RRTCwrapped.log';
%idx = 640 +figNumber (if initially no fig)-1
%good figs are thus :
%662 : shows that final parameter set is red, while optimalest one since
%call is green
%648 : in the end the arrows (quality) are forced to go to the side where
%it make them rise up
%650 : be aware though, that the end of the process doesn't take part
%necessarily on the right side of the fig as shown here, the end of the
%process is where is the last arrowhead. Other note is that as viewable
%here, for a same parameter (set), plan found can be of several qualities,
%due to the randomness of the trees' growth itself. For this reason we keep
%in memory during the process not only the winning parameter set but also
%its assmatlab bar pociated plan found!

c = loadlog(fileName);
fig = cell(0,1) ; rules = cell(0,1);

%for i=1:numel(c)
%for i=570:numel(c)
%for i=24:26
% for i=1728:numel(c)
for i=[648,650,662] %for RRTC 1D
%for i=24:24 %for TRRT 9D datas2019-01-09_23_15.log
    [fig{end+1,1},rules{end+1,1}] = plotOptimizer(c{i});
    disp(['i = ',num2str(i)]) ; pause(4);
end
% end