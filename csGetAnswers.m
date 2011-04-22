function [ answers ] = csGetAnswers( test, indexMap )
%CSGETANSWERS Gets the columns in a score matrix that should be the highest

nwords = length(test.condition.words);
answers = zeros(nwords,1);

for w = 1:nwords
    wi = strIndexOf(test.condition.words{w},test.condition.wordIndex);
    answers(w,1) = indexMap(wi);
end
    
end

