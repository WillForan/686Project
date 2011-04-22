function [ x ] = csCombine( es )
%CSCOMBINE Combines a list of emotive cognitive data into a long dataset.
%Assumes that various things about the different data sets are the same
%such as the wordIndex the number of periods per session, etc.

n = length(es);
nperiods = length(es{1}.periods);
nwords = length(es{1}.condition.words);
nsamples = es{1}.samples;

x = es{1};

x.file = '<combined>';
x.title = '<combined>';

x.samples = n * nsamples;
x.periods = cell(1,n*nperiods);
x.condition.words = cell(1,n*nwords);
x.data = zeros(x.samples,x.channels);

poff = 0;
for ei = 1:n
    for p = 1:nperiods
        x.periods{(ei-1)*nperiods + p} = es{ei}.periods{p} + [0,poff,poff];
    end
    poff = poff + es{ei}.periods{nperiods}(3);
end

for ei = 1:n
    for w = 1:nwords
        x.condition.words{(ei-1)*nwords + w} = es{ei}.condition.words{w};
    end
end

for ei = 1:n
    x.data(1+(ei-1)*nsamples:ei*nsamples,:) = es{ei}.data;
end

end

