function [ filterTrain filterTest filterTrainAnswers ] ...
  = csFilter( train, trainAnswers, test, indexMap, params )
%CSMEANFILTER Filters input by taking the mean of each channel over the
%allotted time
%
% train - the training data
% trainAnswers - the classes for the training data
% test - the testing data
% indexMap - a map from input wordIndex to output wordIndex
%   indexMap(i) = -1 if word i should be ignored (rest period)
%   indexMap(i) = j if word i should appear in column j in the scores

[filterTrain filterTrainAnswers] = csFilterData(train,indexMap,1,trainAnswers,params);
[filterTest unused] = csFilterData(test,indexMap,0,[],params);

end

