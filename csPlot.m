function [ f ] = csPlot( f )
%CSPLOT Displays pictures of averaged cognitive states to try and help
%decide on an initial offset time for the experimental data.
%
% f - the experimental data 

clf;

nw = length(f.condition.wordIndex);
wsums = cell(1,nw);
wfreqs = cell(1,nw);
wmeans = cell(1,nw);
for w = 1:nw
    wsums{w} = 0;
    wfreqs{w} = 0;
end

for p = 1:length(f.periods)
    wi = f.periods{p}(1);
    ss = f.periods{p}(2);
    es = f.periods{p}(3);

    wsums{wi} = wsums{wi} + f.data(ss:es,:);
    wfreqs{wi} = wfreqs{wi} + 1;
end

vmin = +inf;
vmax = -inf;

for w = 2:nw
    m = wsums{w} ./ wfreqs {w};
    wmeans{w} = m(:,3:16);
    vmin = min([vmin min(min(m))]);
    vmax = max([vmax max(max(m))]);
end
for w = 2:nw
    subplot(3,2,w);
    imagesc(wmeans{w},[vmin vmax]);
    title(sprintf('emotion: %s',f.condition.wordIndex{w}));
    colorbar;
end