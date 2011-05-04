function [ e ] = csCompile( e, trialLabels, offsetSamples, iter )
%CSCOMPILEDATA Associates emotive experiment data with condition info
%   ----ci - codition index (i.e. experement number)
%   trialLabels - cell of labels for trial (eg { 'sense' 'nonsense' 'nonsense' 'sense' } )
%   e - the data read in from csv file
%   offsetSamples - the number of samples to offset start of the data by
%   wordsText - a list of words used in the experiment
%   cWordsText - the order the words were presented in this condition

%Normalize the data
rawData = e.data;
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
    e.periods{p} = [ strIndexOf(e.condition.label{p},e.condition.sense), ss, es ];
end

%this part does fft for the first data set (ie person). We do it for one
%person in order to not plot a bunch of graphs
if(iter == 2)
    rawE = e;
    rawE.data = rawData;
    %plot the raw data
    csPlot(e);
    %pause;
    figure;
    %plot the raw data as a mesh
    EGG_data = rawData(:,3:16);
    mesh(EGG_data);title('RAW EEG plot');
    %pause;
    %plot the normalized data
    figure;
    x = e.data(:,3:16);
    mesh(x);title('normalized EEG plot');
    %pause;
    %plot the fft 
    y=fft2(x);
    z=real(sqrt(y.^2));
    mesh(z);
    %pause;
    %fftshit plots the dc component in the center and the others around it
    %in a circular fashion.
    figure;
    w = fftshift(z);
    surf(w);title('FFT plot of EEG data');
    %pause;
    %contour(log(w+1))
    %prism;
    %pause;

end

end

