%
% glue everything together, look at cor_graph.dot for a directional graph
% main('trials/')
% expects dir struct like 
% trails/
%    person_trail1/
%           *.pls       --- file containint labels of bin 1/line
%           *.(csv|mat) --- emotive data in csv 
%                       or already in mat file 
%                       (saved output of importEmotiveData as either var 'e' 
%                          or as a var named after the file name)
function main(dirpath)
%

%Filter parameters
%
% segments:
%   the number of temporal bins per column
%
% removeVarianceRatio:
%   
%
% minTrialsPerClass:
%   the minimum number of trails per class to keep for the training set
% 
% useMean
%   1 if a feature should be the per bin mean, 0 otherwise
%
% useMedian
%   1 if a feature should be the per bin median, 0 otherwise
%
% useVar
%   1 if a feature should be the per bin variance, 0 otherwise
%
% useHorizNorm
%   1 if horizontal normalization should be performed, 0 otherwise
%

%set default parameters, later change mean,median and var
params.segments = 4;

params.varianceReductionRatio = -1;
params.minTrialsPerClass = 1;

params.useHorizNorm = 1;

params.useMean = 0;
params.useMedian = 0;
params.useVar = 0;
params.useMode = 0;


%disp('Results reported as accuracy and rank accuracy');
    files    = dir(dirpath);
    all =cell(size(files)-2);
    for f = 3:length(files) %skip . and ..
        %fprintf('file no. %d\n', (f-2));
        dtry = files(f).name;
        search=strcat(dirpath, dtry, '/*mat');
	%fprintf('dir is %s\n',search);
        mat = dir(search);
        e=[];
        if(size(mat,1)==0)
            disp('matrix too small');
            disp(dtry);
            return
            
            search=strcat(dirpath, dtry, '/*csv');
            
            csv = dir(search);
            e=importEmotiveData(csv(1).name);
            save([files(f).name,'.mat'],e) 
        else
            matpath=strcat(dirpath,dtry,'/',mat.name);
            %load file
            load(matpath)
            %and loading does not bring in e
            if(~exist('e(1)','var'))
                %set it (via eval) to be e
                e=eval(mat.name(1:length(mat.name)-4));
            end
        end

	%now we have a loaded e

        search=strcat(dirpath, dtry, '/*pls');
        labfile=dir(search);
        if(size(labfile,1)==0)
            fprintf('error: no pls for %s\n', dtry);
            continue
        end
        labpath=strcat(dirpath,dtry,'/',labfile(1).name);
        labels=importdata(labpath);
        e=csCompile(e,labels,0,f);
	all{f-2}=e;
        %for i={'logisticRegression','nbayes','neuralnetwork','SMLR'}
        %fprintf('%s--\n',dtry);

	%for each classifier
        for i={ ...
            'logisticRegression', ...  'nnets' ...
            'nbayes', ... 'SMLR', 'nueral', 'knn' ...
        }
	    %for each mean median var mode
	    for stat_it=1:3
	        %reset
		params.useMean   = 0;
		params.useMedian = 0;
		params.useVar    = 0;
		params.useMode   = 0;
		stats= 'err';
		if (stat_it==1) 
			params.useMean = 1; stats='mean'; 
		elseif (stat_it==2)
			params.useMedian = 1; stats='median';
		elseif(stat_it==3) 
			params.useVar = 1; stats='var'; 
		elseif(stat_it==4)
			params.useMedian = 1;params.useMean=1; 
			stats='mean_median'; 
		elseif(stat_it==5) 
			params.useVar = 1;params.useMedian=1; 
			stats='var_median'; 
		elseif(stat_it==6) 
			params.useVar = 1;params.useMedian=1; 
			params.useMean = 1;
			stats='all'; 
		else 
			continue;
		end
		%supress output of classifiers
		evalc('[tacc,tracc]=csOSTest_params(e,i{1},params)');
		%[tacc,tracc]=csOSTest_params(e,i{1},params);
		fprintf('%s\t%f\t%s\t%s\n', ...
		dtry,mean(tacc),i{1},stats);
	   end
        end
	
    end
    %csCombine(all(1:6))

end
