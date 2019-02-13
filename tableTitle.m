function t = tableTitle(jnames, lims, intitule)
%% https://www.mathworks.com/matlabcentral/answers/300523-plot-title-formatting-with-table
%clear all;
%clc

%% Inputs:
% jnames = ["base","elb","wrist"];
% lims = [-6.28 -3.14 -6.28 ; 6.28 3.14 6.28];
% intitule = "Joint angle limits (rad)";

%% Latex code:
% \begin{tabular}{|c|c|c|}
% \multicolumn{3}{c}{Country List} \\
% \hline
% jn1 & jn1 & jn1 \\
% \hline
% -3 \leq q_1 \leq 3 &
% -3 \leq q_1 \leq 3 &
% -3 \leq q_1 \leq 3 \\
% \hline
% \end{tabular}

%% Parse the number of joints
nbj = size(lims,2);

%% Construct the 1st latex line:
begt = "\begin{tabular}{";
for i=1:nbj
    begt = strcat(begt, "|c");
end
begt = strcat(begt, "|}");

%% Construct the title of the table:
titlet = sprintf("\\multicolumn{%d}{c}{%s} \\\\ ", nbj, intitule);

%% Construct the joint names:
jnamest = jnames(1);
for i=2:nbj
    jnamest = strcat(jnamest," & ");
    jnamest = strcat(jnamest,jnames(i));
end
jnamest = strcat(jnamest," \\ "); %\\ = \ in sprintf(), but not in strcat()

%% Construct the lims:
% BE CAREFUL TO DO USE THE $, even though it works without it within
% overleaf!
for i=1:nbj
    currLims = lims(:,i);
    limst(i) = sprintf("$%.2f \\leq q_%d \\leq %.2f$",currLims(1),i,currLims(2));
end
limst = strjoin(limst, ' & ');
limst = strcat(limst," \\ ");

%% Some latex regexs:
trait = "\hline";
endt = "\end{tabular}";

tbl_str = sprintf("%s %s %s %s %s %s %s %s", ...
                  begt, ...
                  titlet, ...
                  trait, ...
                  jnamest, ...
                  trait, ...
                  limst, ...
                  trait, ...
                  endt)

figure
t = title(tbl_str,'Interpreter','latex');
return t
