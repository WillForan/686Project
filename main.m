function main(dirpath)
    files    = dir(dirpath);

    for f = 3:length(files) %skip . and ..
        dtry = files(f).name;
	mat = dir([dtry,'/*mat']);
	e=[];
	if(size(mat)==0)
	    csv = dir([dtry,'/*csv']);
	    e=importEmotiveData(csv(1).name);
	    save([files(f).name,'.mat'],e) 
	else
	    load [files(f).name,'.mat'];
	end
	labfile=dir([dtry,'/*pls']);
	labels=importdata(labfile(1).name);

	e=csCompile(e,labels,0)
	csOSTest(e)
    end

end
