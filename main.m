function main(dirpath)
    files    = dir(dirpath);

    for f = 3:length(files) %skip . and ..
        dtry = files(f).name;
	search=[dtry '/*mat'];
	mat = dir(search);
	e=[];
	if(size(mat)==0)
	    search=[dtry '/*csv'];
	    csv = dir(search);
	    e=importEmotiveData(csv(1).name);
	    save([files(f).name,'.mat'],e) 
	else
	    load [files(f).name,'.mat'];
	end
	search=[dtry '/*pls'];
	labfile=dir(search);
	labels=cell(1,1);
	labels{1}=importdata(labfile(1).name);

	e=csCompile(e,labels,0)
	csOSTest(e)
    end

end
