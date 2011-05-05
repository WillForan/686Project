function [ filterF filterFC ] = csFilterData( f, indexMap, isTrain, fc, params )
%CSMEANFILTER Filters input by taking the mean of each channel over the
%allotted time
%
% f - the data to filter
% isTrain - true if f is training data, false if it is test data
% fc - the classes for the rows of f (only provided if isTrain is true)
% indexMap - a map from input wordIndex to output wordIndex
%   indexMap(i) = -1 if word i should be ignored (rest period)
%   indexMap(i) = j if word i should appear in column j in the scores

nw = length(unique(f.condition.label)); 		%2
nt = length(f.condition.label);				%21
np = length(f.periods);					%19
nc = f.channels;					%14
nx = params.useMean + params.useVar + params.useMedian;	%1
nd = f.condition.TbinSec * f.sampling;			%1920
ns = params.segments;					%4
incr = nd/ns;						%480


%
%filter the training data
%
if params.useHorizNorm
    f.data = zscore(f.data,0,2);
end

r = zeros(nt,params.segments*nc*nx);
sp = 1;
for p = 1:np
    wi = indexMap(f.periods{p}(1));
    if wi == -1
        continue;
    end
    data = f.data(f.periods{p}(2):f.periods{p}(3),:);
    
    filtered = zeros(ns,nx,nc);
    
    for k = 1:ns
        datapart = data( 1+(k-1)*incr : k*incr ,:);
        
        x = 1;
        if params.useMean == 1
            filtered(k,x,:) = mean(datapart);
            x = x + 1;
        end
        if params.useMedian == 1
            filtered(k,x,:) = median(datapart);
            x = x + 1;
        end
        if params.useVar == 1
            filtered(k,x,:) = var(datapart);
            x = x + 1;
        end
        %if params.useMode == 1
        %    filtered(k,x,:) =var(datapart);
        %    x = x + 1;
        %end
        %if params.useFFT == 1
        %    filtered(k,x,:) = twoSidedFFT(datapart,128);
        %    x = x + 1;
        %end
    end
    r(sp,:) = reshape(filtered,1,ns*nx*nc);
    sp = sp + 1;
end

filterF = r;
filterFC = fc;

if( isTrain )
    [nt nc] = size(r);
    wr = cell(nw);
    wrc = cell(nw);
    for wi = 1:nw
        %get the rows of the data with word i
        rows = wi == fc;
        wr{wi} = r(rows,:);
        wrc{wi} = fc(rows);
    end
    
    for wi = 1:nw
        %get the distance to the centroid for each point
        [unused,unused,unused,d] = kmeans(wr{wi},1);
        [rows cols] = size(wr{wi});
        
        %save the original variance in the distances
        origVar = var(d);
        origTrials = rows;
        
        %remove data that is farthest from the new centroid until x percent
        % of the variance in distance from the centroid is removed.
        while 1
            [rows cols] = size(wr{wi});
            if( rows <= params.minTrialsPerClass )
                break;
            end
            
            %get the distance to the centroid for each point
            [unused,unused,unused,d] = kmeans(wr{wi},1);

            %have we removed enough outliers?
            v = var(d);
            if( 1 - v/origVar > params.varianceReductionRatio )
                break;
            end
            
            %remove the entry with maximum distance
            [vmax,imax] = max(d);
            
            wr{wi}(imax,:) = [];
            wrc{wi}(imax,:) = [];
        end
    end
    
    %reshape back into row=trail, col=feature
    filterF = wr{1};
    filterFC = wrc{1};
    for wi = 2:nw
        filterF = vertcat(filterF,wr{wi});
        filterFC = vertcat(filterFC,wrc{wi});
    end
end

end

