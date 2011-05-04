function [ tacc, tracc ] = csOSTest_params( e, classifierName,params )
%CSCVTEST Does a cross validation test and outputs accuracies


%csFilter.m has more explination
indexMap = [1,2];  %which indexes get scores, -1 means ignore
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

%mean(tacc)
%mean(tracc)
