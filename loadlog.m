function succeedingRunsStructCell = loadlog(fileName)
%read a whole log generated by the planner's parameter c++ optimizer in
%order to show the progress. This is a prelude to any plot, that keeps only
%the runs where results have been found before the allocated countdown.
%Each necessary variable for a run are stored as attributes of a cell array
%component: eg: cell{successive run <= total nb of runs}.seqParam(2) = [...]

format short g %otherwise (e.g:) str2num('0.5') (appears later in the code) returns 0.5000 uselessly..
%https://stackoverflow.com/questions/24068990/how-to-remove-decimal-trailing-zeros-in-matlab

%% read each line
fileID = fopen(fileName,'r');
tline = fgetl(fileID);
toSplit = cell(0,1);
while ischar(tline)
    toSplit{end+1,1} = tline;
    tline = fgetl(fileID);
end
fclose(fileID);
%tic
toSplit = string(toSplit);
%t = toc ; disp(['rewriting of toSplit from cell to array took ',num2str(t)])

%% split the file into several runs and keep only the concluding ones
succeedingRuns = cell(0,1);
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
       %check whether there are datas in the run
       if numel(arrayToPotentiallyKeep) > noResults
           succeedingRuns{end+1,1} = arrayToPotentiallyKeep;
       end
    end
    if i == size(toSplit,1)
        break
    end
    i = i + 1;
    endofsub = endofsub + 1;
end
clear toSplit

%%
succeedingRunsStructCell = cell(0,1);
for i=1:numel(succeedingRuns)
    stru = struct();
    %the legends
    for j=1:7
        beforeafter = strsplit(succeedingRuns{i}(j), ' = ');
        stru.(beforeafter(1)) = beforeafter(2);
    end
    %their associated parameter name:
    paramNamesVec = string(strsplit(succeedingRuns{i}(8),{', ', ':'}));
    paramNamesVec(end-1:end) = []; %remove 'quality', and the '' char returned after the ':' due to the split!
    %and the datas
    tmpMat = [];
    for k=9:numel(succeedingRuns{i})-2
        tmpRow = strsplit(succeedingRuns{i}(k),{', ', ';'});
        tmpRow(end) = []; %remove the '' char returned after the ';' due to the split!
        tmpMat(end+1,:) = tmpRow;
    end
    tmpMat = tmpMat';
    seqParam = [];
    for m=1:numel(paramNamesVec)
        seqParam(m,1).seq = tmpMat(m,:);
        seqParam(m,1).name = paramNamesVec(m);
    end
    stru.seqParam = seqParam;
    stru.seqM.seq = tmpMat(end,:);
    beforeafter = strsplit(succeedingRuns{i}(numel(succeedingRuns{i})), ' = [ ');
    %re-split to get the vector of the steps associated to the vector of
    %paramNames:
    cell2strVar = string(beforeafter(2));
    cell2strVec = strsplit(cell2strVar, ' ');
    cell2strVec(end) = []; %remove the char "]" at the end
    stru.(beforeafter(1)) = str2num(cell2strVec);
    succeedingRunsStructCell{i,1} = stru;
end
% assignin('base','succeedingRunsStructCell',succeedingRunsStructCell) %debug
end