function [ tacc tracc ] = csTest( train, test, indexMap, params, classifierName )
%CSTEST Summary of this function goes here
%   Detailed explanation goes here

%We only want the EEG channels
test.data = test.data(:,3:16);
train.data = train.data(:,3:16);
test.channels = 14;
train.channels = 14;

testAnswers = csGetAnswers(test,indexMap);
trainAnswers = csGetAnswers(train,indexMap);

[filterTrain filterTest trainAnswers] = ...
    csFilter(train,trainAnswers,test,indexMap,params);    

classifier = trainClassifier(filterTrain,trainAnswers,classifierName);
scores = applyClassifier(filterTest,classifier);
[results eY trace] = summarizePredictions(scores,classifier,'accuracy',testAnswers);
tacc = mean(results{1});
[results eY trace] = summarizePredictions(scores,classifier,'averageRank',testAnswers);
tracc = mean(1 - results{1});

end

