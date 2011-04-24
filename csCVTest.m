function [ tacc, tracc ] = csCVTest( es, classifierName )
%CSCVTEST Does a cross validation test and outputs accuracies

%Filter parameters
%
% segments:
%   the number of temporal bins per column

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
n = length(es);
nw = max(indexMap);
tacc = zeros(1,n);
tracc = zeros(1,n);

T = zeros(1,n);
for t = 1:n
    T(t) = t;
end

estrain = cell(1,n-1);
for t = 1:n
    i = 1;
    for j = 1:n
        if j ~= t
            estrain{i} = es{j};
            i = i+1;
        end
    end

    test = es{t};
    train = csCombine( estrain );

    [a ra] = csTest(train,test,indexMap,params,classifierName);
    tacc(t) = a;
    tracc(t) = ra;
end

%mean(tacc)
%mean(tracc)
