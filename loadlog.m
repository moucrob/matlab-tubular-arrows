fileID = fopen('datas2019-01-06_16_42.log','r');
tline = fgetl(fileID);
toSplit = cell(0,1);
while ischar(tline)
    toSplit{end+1,1} = tline;
    tline = fgetl(fileID);
end
fclose(fileID);

succeedingRuns = cell(0,1);
i=1;
while 1
    
    i += 1;
    if i == size(toSplit)
        break
    end
end

%deletete var toSplit