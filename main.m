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
	   matpath=strcat(dirpath,dtry,'/',mat.name)
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
	csOSTest(e,'logisticRegression')
	%csOSTest(e,'nbayes')
    end

end
