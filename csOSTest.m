function [ tacc, tracc ] = csOSTest( e, classifierName )
%CSCVTEST Does a cross validation test and outputs accuracies

%Filter parameters
%
% segments:
%   the number of temporal bins per column
%
% removeVarianceRatio:
%   
%
% minTrialsPerClass:
%   the minimum number of trails per class to keep for the training set
% 
% useMean
%   1 if a feature should be the per bin mean, 0 otherwise
%
% useMedian
%   1 if a feature should be the per bin median, 0 otherwise
%
% useVar
%   1 if a feature should be the per bin variance, 0 otherwise
%
% useHorizNorm
%   1 if horizontal normalization should be performed, 0 otherwise
%
params.segments = 4;

params.varianceReductionRatio = -1;
params.minTrialsPerClass = 1;

params.useHorizNorm = 1;

params.useMean = 1;
params.useMedian = 0;
params.useVar = 0;

indexMap = [-1,-1,1,2,3,4];
n = length(indexMap);
tacc = zeros(1,n);
tracc = zeros(1,n);

%Need to go through and collect the Tth occurance of each word.
%The below is obviously not the most efficient way to do this.
for t = 1:n
    trainPeriods = cell(0);
    testPeriods = cell(0);
    trainIdx = 1;
    testIdx = 1;
    counts = zeros(1,n);
    for j = 1:length(e.periods)
        p = e.periods{j};
        counts(p(1)) = counts(p(1)) + 1;
        if( counts(p(1)) == t )
            testPeriods{testIdx} = p;
            testIdx = testIdx + 1;
        else
            trainPeriods{trainIdx} = p;
            trainIdx = trainIdx + 1;
        end
    end
    
    test = e;
    train = e;
    test.periods = testPeriods;
    train.periods = trainPeriods;

    [a ra] = csTest(train,test,indexMap,params,classifierName);
    tacc(t) = a;
    tracc(t) = ra;
end

mean(tacc)
mean(tracc)