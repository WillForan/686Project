function [ e ] = csCompile( e, ci, offsetSamples )
%CSCOMPILEDATA Associates emotive experiment data with condition info
%   ci - codition index (i.e. experement number)
%   e - the data read in from csv file
%   offsetSamples - the number of samples to offset start of the data by
%   wordsText - a list of words used in the experiment
%   cWordsText - the order the words were presented in this condition

%Normalize the data
e.data = zscore(e.data);

cWordsText = {
    {... condition 1
        'funny','angry','happy','sad', ...
        'funny','angry','funny','sad', ...
        'happy','angry','angry','happy', ...
        'sad','funny','sad','happy', ...
        'angry','happy','happy','sad', ...
        'angry','funny','sad','funny' ...
    },...
    {... condition 2
        'sad','angry','funny','sad', ...
        'angry','funny','happy','angry', ...
        'happy','funny','sad','happy', ...
        'angry','sad','happy','sad', ...
        'happy','funny','funny','angry', ...
        'funny','happy','angry','sad', ...
    },...
    {... condition 3
        'angry','sad','happy','funny', ...
        'happy','angry','sad','funny', ...
        'angry','sad','happy','funny', ...
        'funny','angry','sad','sad', ...
        'happy','angry','funny','funny', ...
        'sad','happy','happy','angry', ...
    }...
}; %end of cwords

%Compile some info about the condition
e.condition.wordIndex = {'longRest','shortRest','funny','angry','happy','sad'};
e.condition.words = cWordsText{ci};
e.condition.TshortRestSec = 5;
e.condition.TlongRestSec = 30;
e.condition.TwordSec = 10;

%Calculate the expected and actual time data was collected
nwords = length(e.condition.words);
e.condition.expectedTimeSec = 0 + ...
    2*e.condition.TlongRestSec + ...
    (e.condition.TwordSec + e.condition.TshortRestSec)*(nwords-1) + ...
    e.condition.TwordSec;

e.condition.expectedSamples = e.condition.expectedTimeSec * e.sampling;

%Shift the data by the offset
tmp = e.data;
e.data = zeros(e.condition.expectedSamples,e.channels);
tstart = max([1 offsetSamples]);
tend = min([(tstart + e.condition.expectedSamples - 1) (length(tmp))]);
dstart = max([1,-offsetSamples]);
dend = dstart+tend-tstart;

e.data(dstart:dend,:) = tmp(tstart:tend,:);
e.samples = e.condition.expectedSamples;

%Compute some statistics we will need
nwords = length(e.condition.words);
nperiods = 3 + (nwords-1)*2;
e.periods = cell( 1,nperiods );

%The opening resting period
ss = 1;
es = ss-1 + e.condition.TlongRestSec*e.sampling;
e.periods{1} = [ strIndexOf('longRest',e.condition.wordIndex), ss, es ];

%All the word/break periods
for p = 1:nwords-1
    %A word
    ss = es+1;
    es = ss-1 + e.condition.TwordSec*e.sampling;
    e.periods{2*p} = [ strIndexOf(e.condition.words{p},e.condition.wordIndex), ss, es ];
    
    %The resting period after a word
    ss = es+1;
    es = ss-1 + e.condition.TshortRestSec*e.sampling;
    e.periods{2*p+1} = [ strIndexOf('shortRest',e.condition.wordIndex), ss, es ];
end

%The last word
ss = es+1;
es = ss-1 + e.condition.TwordSec*e.sampling;
e.periods{nperiods-1} = [ strIndexOf(e.condition.words{nwords},e.condition.wordIndex), ss, es ];

%The final resting period
ss = es+1;
es = ss-1 + e.condition.TlongRestSec*e.sampling;
e.periods{nperiods} = [ strIndexOf('longRest',e.condition.wordIndex), ss, es ];

end

