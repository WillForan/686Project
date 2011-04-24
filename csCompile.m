function [ e ] = csCompile( e, trialLabels, offsetSamples )
%CSCOMPILEDATA Associates emotive experiment data with condition info
%   ----ci - codition index (i.e. experement number)
%   trialLabels - cell of labels for trial (eg { 'sense' 'nonsense' 'nonsense' 'sense' } )
%   e - the data read in from csv file
%   offsetSamples - the number of samples to offset start of the data by
%   wordsText - a list of words used in the experiment
%   cWordsText - the order the words were presented in this condition

%Normalize the data
e.data = zscore(e.data);

%trialLabels = {
%
%    {... condition 1
%        'sense','sense','nonsense','sense', ...
%        'nonsense','sense','sense','nonsense', ...
%        'sense','nonsense','sense','nonsense' ...
%    },...
%}; %end of cwords

%Compile some info about the condition
e.condition.sense = {'Sense','Antisense'};
%e.condition.label = trialLabels{ci};
e.condition.label = trialLabels;
e.condition.TbinSec = 15;

%Calculate the expected and actual time data was collected
nlabels = length(e.condition.label ); 						%2
e.condition.expectedTimeSec = e.condition.TbinSec*nlabels;			
e.condition.expectedSamples = e.condition.expectedTimeSec * e.sampling;

%Shift the data by the offset
tmp = e.data;
e.data = zeros(e.condition.expectedSamples,e.channels);
%tstart = max([1 offsetSamples]);
%tend = min([(tstart + e.condition.expectedSamples - 1) (length(tmp))]);

%trail ends exactly when data stops
tend = length(tmp);
%so the start is relative to this
tstart = max([1 length(tmp) - e.condition.expectedSamples]);

%where to copy data from
dstart = max([1,-offsetSamples]); %always 1 ?
dend = dstart+tend-tstart;

e.data(dstart:dend,:) = tmp(tstart:tend,:);
e.samples = e.condition.expectedSamples;

%free tmp memory
tmp=[]; 

%make interval storage
e.periods = cell( 1,length(e.condition.label)  );


%add period information to 
es=0;
for p = 1:nlabels
    ss = es+1;
    es = ss-1 + e.condition.TbinSec*e.sampling;
    disp(e.condition.label{p});
    e.periods{p} = [ strIndexOf(e.condition.label{p},e.condition.sense), ss, es ];
end

end

