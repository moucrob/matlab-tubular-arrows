clc
clear all
logNamesVec = {'datas2019-01-08_21_52.log','datas2019-01-09_21_58.log'};

format longG %otherwise tmpMat(end+1,:) = tmpRow transforms "1.00001" into numerical value 1 !!

allCells = cell(0,1);
for k=1:numel(logNamesVec)
    fileName = string(logNamesVec(k));
    
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
    noResults = 10; %number of lines when there is no results, otherwise there are 10 or more
    while 1
        if numel(toSplit{i}) == 0
           %move the preceding subcell array to a temporary array:
           %disp(['begin = ', num2str(begin)])
           %disp(['endofsub-1 = ', num2str(endofsub-1)])
           arrayToPotentiallyKeep = toSplit(begin:endofsub-1);

           begin = endofsub + 1;
    %        %check whether there are datas in the run
    %        if numel(arrayToPotentiallyKeep) > noResults
               runs{end+1,1} = arrayToPotentiallyKeep;
    %        end
        end
        if i == size(toSplit,1)
            break
        end
        i = i + 1;
        endofsub = endofsub + 1;
    end
    clear toSplit

    %%
    runsStructCell = cell(0,1);
    for i=1:numel(runs)
        stru = struct();
        %the legends
        for j=1:7
            beforeafter = strsplit(runs{i}(j), ' = ');
            stru.(beforeafter(1)) = beforeafter(2);
        end
        %their associated parameter name:
        paramNamesVec = string(strsplit(runs{i}(8),{', ', ':'}));
        paramNamesVec(end-1:end) = []; %remove 'quality', and the '' char returned after the ':' due to the split!

        %and the datas
        tmpMat = [];
        if numel(runs{i}) >= 11
            for k=9:numel(runs{i})-2
                tmpRow = strsplit(runs{i}(k),{', ', ';'});
                tmpRow(end) = []; %remove the '' char returned after the ';' due to the split!
                tmpMat(end+1,:) = tmpRow;
            end
        end
        tmpMat = tmpMat';
        seqParam = [];
        if numel(runs{i}) >= 11
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

for i=1:numel(allCells)
    countdowns = [];
    nbRuns = 0;
    for j=1:numel(allCells{i,1})
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
    stru.acceptance = allCells{i,1}{1,1}.acceptance;
    stru.scene = allCells{i,1}{1,1}.scene;
    stru.metric = allCells{i,1}{1,1}.metric
    stru.countdowns = countdowns;
    stru.nbQueries = nbQueries;
    stru.nbRuns = nbRuns;
    
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
        qualitiesAvg(end+1) = mean(qualityStorage); %careful, mean([]) = NaN
        if isnan(qualitiesAvg(end)) ; qualitiesAvg(end) = 0 ; end %instead
    end
    
    stru.successRatesAvg = successRatesAvg;
    stru.qualitiesAvg = qualitiesAvg;
    allPlanners{end+1,1} = stru;
end

%% and plot
figure
toBar = []; %MY CURRENT WAY USING toBar MATRIX CONSTRAINS TO HAVE THE SAME COUNTDOWNS SET FOR EACH PLANNER LOG !!!!
%ALSO EACH SIMULATION SHOULD BE RUN INTO THE SAME SCENE AND FOR THE SAME
%METRIC !!!!
for i=1:numel(allPlanners)
%     subplot(2,1,1)
%     plot(countdowns, allPlanners{i}.successRatesAvg) ; hold on
    subplot(2,1,2)
    title('test')
    plot(countdowns, allPlanners{i}.qualitiesAvg) ; hold on
    toBar(end+1,:) = allPlanners{i}.successRatesAvg;
end
subplot(2,1,1)
b = bar(toBar');
set(gca,'XTick',countdowns)