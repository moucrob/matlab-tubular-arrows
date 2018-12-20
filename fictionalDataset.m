%given a scene + query + a run + a countdown
planner = 'PLANNER';
scene = 'SCENE';
query = 'backflip';
%run = 'run number10';
countdown = '15sec';
acceptance = '1-t/T';
metric = 'relevancy';

seqParam(1).seq = [0 1 0 1 2 1 2 1 2 1 2];
seqParam(1).min = 0 ; seqParam(1).max = 2 ; seqParam(1).step = 1;
seqParam(1).name = 'param1';

seqParam(2).seq = [0.0 0.1 0.2 0.1 0.2 0.3 0.4 0.3 0.2 0.3 0.4];
seqParam(2).min = 0. ; seqParam(2).max = 0.5 ; seqParam(2).step = 0.1;
seqParam(2).name = 'param2';

seqParam(3).seq = [10 11 10 11 10 12 11 12 13 14 15];
seqParam(3).min = 10 ; seqParam(3).max = 17 ; seqParam(3).step = 1;
seqParam(3).name = 'param3';

seqParam(4).seq = [3.5 4. 4.5 4. 4.5 5. 5.5 6. 5.5 6. 5.5];
seqParam(4).min = 3.5 ; seqParam(4).max = 7 ; seqParam(4).step = 0.5;
seqParam(4).name = 'param4';

seqM.seq = [0.2 0.3 0.6 0.8 0.74 0.35 0.24 0.15 0.48 0.69 0.47];
seqM.min = 0. ; seqM.max = 1.;