clc
clear all
path = "logs/unrestricted/";
logNamesVec = {'RRT.log','RRTwrapped.log','EST.log','ESTwrapped.log','PRMstar.log','RRTCstar.log','RRTC.log','RRTCwrapped.log','TRRTwrapped.log','TRRT.log'};
% logNamesVec = {'TRRTwrapped.log','TRRT.log'}; %debug
format longG %otherwise tmpMat(end+1,:) = tmpRow transforms "1.00001" into numerical value 1 !!

allCells = cell(0,1);
for k=1:numel(logNamesVec) %all planners
    fileName = strcat(path,string(logNamesVec(k)))
    
    %% read each line
    fileID = fopen(fileName,'r');
    tline = fgetl(fileID);
    toSplit = cell(0,1);
    while ischar(tline)
        toSplit{end+1,1} = tline;
        tline = fgetl(fileID);
    end
    fclose(fileID);
    toSplit = string(toSplit);

    %% split the file into several runs
    runs = cell(0,1);
    i = 1;
    begin = 1;
    endofsub = 1;
    noResults = 13; %number of lines when there is no results, otherwise there are 14 or more
    while 1
        if numel(toSplit{i}) == 0
           %move the preceding subcell array to a temporary array:
           %disp(['begin = ', num2str(begin)])
           %disp(['endofsub-1 = ', num2str(endofsub-1)])
           arrayToKeep = toSplit(begin:endofsub-1);
           begin = endofsub + 1;
           runs{end+1,1} = arrayToKeep;
        end
        if i == size(toSplit,1)
            break
        end
        i = i + 1;
        endofsub = endofsub + 1;
    end
    %clear toSplit %debug

    %% Parse each runs:
    runsStructCell = cell(0,1);
    for i=1:numel(runs)
        stru = struct();
        %the legends:
        for j=1:7
            beforeafter = strsplit(runs{i}(j), ' = ');
            stru.(beforeafter(1)) = beforeafter(2);
        end
        % %the joint limits:
        for n=8:10
            beforeafter = strsplit(runs{i}(n), ' = [ ');
            %re-split to get the vector of the joint names + the char ']':
            cell2strVar = string(beforeafter(2));
            cell2strVec = strsplit(cell2strVar, ' ');
            cell2strVec(end) = []; %remove the char "]" at the end
            if n~=8
                stru.(beforeafter(1)) = str2double(strcat(cell2strVec));
            else
                stru.(beforeafter(1)) = strcat(cell2strVec);
            end
        end
        % %the planner's parameter names:
        paramNamesVec = string(strsplit(runs{i}(11),{', ', ':'}));
        paramNamesVec(end-1:end) = []; %remove 'quality', and the '' char returned after the ':' due to the split!
        % %the datas:
        tmpMat = [];
        if numel(runs{i}) >= noResults+1
            for k=noResults-1:numel(runs{i})-2
                tmpRow = strsplit(runs{i}(k),{', ', ';'});
                tmpRow(end) = []; %remove the '' char returned after the ';' due to the split!
                tmpMat(end+1,:) = tmpRow;
            end
        end
        tmpMat = tmpMat';
        seqParam = [];
        if numel(runs{i}) >= noResults+1
            for m=1:numel(paramNamesVec)
                seqParam(m,1).seq = tmpMat(m,:);
                seqParam(m,1).name = paramNamesVec(m);
            end
            stru.seqM.seq = tmpMat(end,:);
            stru.success = 1;
            stru.quality = stru.seqM.seq(end);
        else
            for m=1:numel(paramNamesVec)
                seqParam(m,1).seq = [];
                seqParam(m,1).name = paramNamesVec(m);
            end
            stru.seqM.seq = [];
            stru.success = 0;
            stru.quality = 0;
        end
        stru.seqParam = seqParam;
        % %the steps:
        beforeafter = strsplit(runs{i}(numel(runs{i})), ' = [ ');
        %re-split to get the vector of the steps associated to the vector of
        %paramNames:
        cell2strVar = string(beforeafter(2));
        cell2strVec = strsplit(cell2strVar, ' ');
        cell2strVec(end) = []; %remove the char "]" at the end
        stru.(beforeafter(1)) = str2double(strcat(cell2strVec));
        
        runsStructCell{i,1} = stru;
    end
    allCells{end+1,1} = runsStructCell;
end

%% get the necessary to plot successRate & quality of the succeedings sol vs allocated countdown
allPlanners = cell(0,1);

for i=1:numel(allCells) %all planners
    countdowns = [];
    nbRuns = 0;
    for j=1:numel(allCells{i,1}) %every run
        countdown = str2num(allCells{i,1}{j,1}.countdown);
        if ~ismember(countdown,countdowns)
            countdowns(end+1) = countdown;
        end
        
        run = str2num(allCells{i,1}{j,1}.run);
        if run > nbRuns
            nbRuns = run;
        end
    end
%     countdowns = sort(countdowns);
    nbQueries = numel(allCells{i,1})/(nbRuns*numel(countdowns));
    
    stru = struct();
    stru.plannerName = allCells{i,1}{1,1}.planner;
    stru.metric = allCells{i,1}{1,1}.metric;
    stru.scene = allCells{i,1}{1,1}.scene;
    stru.countdowns = countdowns;
    stru.acceptance = allCells{i,1}{1,1}.acceptance;
    stru.nbRuns = nbRuns;
    stru.nbQueries = nbQueries;
    stru.jointNamesVec = allCells{i,1}{1,1}.jointNamesVec;
    stru.jointAnglesMin = allCells{i,1}{1,1}.jointAnglesMin;
    stru.jointAnglesMax = allCells{i,1}{1,1}.jointAnglesMax;
    
    %Datas:
    successRatesAvg = []; %(for each allocated countdown)
    qualitiesAvg = [];
    for k=1:numel(countdowns)
        successRateStorage = 0;
        succeedingIndexes = [];
        qualityStorage = [];
        for m=1:nbQueries
            for n=1:nbRuns
                spareAtIdx = (k-1)*(nbQueries*nbRuns) + (m-1)*nbRuns + n;
                successRate = allCells{i,1}{spareAtIdx,1}.success;
                successRateStorage = successRateStorage + successRate;
                if successRate ~= 0 %get the j<->query+run combination for which a solution exists
                    succeedingIndexes(end+1) = spareAtIdx; %not mandatory
                    qualityStorage(end+1) = allCells{i,1}{spareAtIdx,1}.seqM.seq(end);
                end
            end
        end
        successRatesAvg(end+1) = successRateStorage/(nbQueries*nbRuns);
        qualitiesAvg(end+1) = sum(qualityStorage)/(nbQueries*nbRuns); %careful, mean([]) = NaN
        if isnan(qualitiesAvg(end)) ; qualitiesAvg(end) = 0 ; end %instead
    end
    
    stru.successRatesAvg = successRatesAvg;
    stru.qualitiesAvg = qualitiesAvg;
    allPlanners{end+1,1} = stru;
end

%% and plot
figure

co = distinguishable_colors(numel(allPlanners), {'w','k'});

toBar = []; %MY CURRENT WAY USING toBar MATRIX CONSTRAINS TO HAVE THE SAME COUNTDOWNS SET FOR EACH PLANNER LOG !!!!
%ALSO EACH SIMULATION SHOULD BE RUN INTO THE SAME SCENE AND FOR THE SAME
%METRIC !!!!
names = cell(0,1);
qualitiesAvgMat = [];
for i=1:numel(allPlanners)
%     subplot(2,1,1)
%     plot(countdowns, allPlanners{i}.successRatesAvg) ; hold on
    subplot(3,1,2)
    set(gca,'XTick', allPlanners{i}.countdowns)
    plot(countdowns, 100*allPlanners{i}.qualitiesAvg, ...
         '-o','MarkerSize',5,'MarkerFaceColor',co(i,:),'color',co(i,:))
    hold on
    qualitiesAvgMat(end+1,:) = allPlanners{i}.qualitiesAvg;
    names{end+1,1} = char(allPlanners{i}.plannerName);
    
    toBar(end+1,:) = allPlanners{i}.successRatesAvg;
end
[~,idxBestQualityPlanners] = max(qualitiesAvgMat);

subplot(3,1,2)
l = legend(names);
ylabel({strcat( ['average ',num2str(allPlanners{1}.metric)] ); ...
        'quality metric'})
ytickformat('percentage');
xtickangle(90)
grid on ; grid minor

subplot(3,1,1)
b1 = bar(100*toBar');
% set(gca,'XTick', allPlanners{1}.countdowns)
set(gca,'XTickLabels', string(allPlanners{1}.countdowns))
ylabel({'average success rate'; ...
        strcat(['overall ',num2str(allPlanners{1}.nbRuns),' runs on']); ...
        strcat(['each of the ',num2str(allPlanners{1}.nbQueries)]); ...
        'random feasible queries'})
xlabel('allocated countdown (sec)')
ytickformat('percentage');
grid on ; grid minor

lims = [allPlanners{1}.jointAnglesMin ; allPlanners{1}.jointAnglesMax];
tbl_str = tableTitle(allPlanners{1}.jointNamesVec,lims,"Joint angle limits (rad)");
title(tbl_str,'Interpreter','latex');


subplot(3,1,3)
b2 = bar(countdowns,ones(1,numel(countdowns)));
set(gca,'TickLength', [0 0])
set(gca,'XTick', allPlanners{1}.countdowns)
set(gca,'XTickLabels', string(allPlanners{1}.countdowns))
xtickangle(90)
title({'Lookup table : planner that had the best quality overall,';'w.r.t to each allocated countdown T (in sec)'})
set(gca,'YTick',[])
set(gca,'YTickLabel',[])
ylabel({'input scene:'; ...
        strcat([num2str(allPlanners{1}.scene),',']); ...
        strcat(['acceptance(t):=',num2str(allPlanners{2}.acceptance)]); ...
        'for wrapped planners'},'Interpreter','none')

%to modify individually the bars' color
b2.FaceColor = 'flat';
for i=1:numel(allPlanners)
    b1(1,i).FaceColor = 'flat';
    b1(1,i).CData(1:numel(countdowns),:) = repmat(co(i,:),numel(countdowns),1);
end
for j=1:numel(countdowns)
    b2.CData(j,:) = co(idxBestQualityPlanners(j),:);
end

%to precise the names of the winners: in subplot313
for i=1:numel(countdowns)
    t = text(countdowns(i),0.5,names{idxBestQualityPlanners(i)},'HorizontalAlignment','center');
    set(t,'Rotation',90);
    hold on
end

set(gcf,'color','w');