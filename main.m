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
    files    = dir(dirpath);

    for f = 3:length(files) %skip . and ..
        dtry = files(f).name;
	search=strcat(dirpath, dtry, '/*mat');
	mat = dir(search);
	e=[];
	if(size(mat,1)==0)
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
	search=strcat(dirpath, dtry, '/*pls');
	labfile=dir(search);
	if(size(labfile,1)==0)
	  fprintf('error: no pls for %s\n', dtry);
	  continue
	end
        labpath=strcat(dirpath,dtry,'/',labfile(1).name);
	labels=importdata(labpath);
	e=csCompile(e,labels,0);
	%for i={'logisticRegression','nbayes','neuralnetwork','SMLR'}
	fprintf('%s--\n',dtry);
	for i={ ...
	    'logisticRegression', ...  'nnets' ...
	     'nbayes', ... 'SMLR', 'nueral', 'knn' ...
	}
	    %supress output of classifiers
	    evalc('[tacc,tracc]=csOSTest(e,i{1})');
	    %[tacc,tracc]=csOSTest(e,i{1});
	    fprintf('\t%f %f\t(%s)\n',mean(tacc),mean(tracc),i{1});
	end
	
    end

end
