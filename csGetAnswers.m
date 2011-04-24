function [ answers ] = csGetAnswers( test, indexMap )
%CSGETANSWERS Gets the columns in a score matrix that should be the highest

nwords = length(test.condition.label);
answers = zeros(nwords,1);

for w = 1:nwords
    wi = strIndexOf(test.condition.label{w},test.condition.sense);
    answers(w,1) = indexMap(wi);
end
    
end

