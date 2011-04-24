function main()
    files = dir('./*CSV');
    for f = 1:length(files),
	str = files(f).name;
	[subj str] = strtok(str, '-');
	[cond str] = strtok(str, '-'); cond = find(strcmp(classes, cond));
	[t str] = strtok(str, '-');    t = str2num(t);

	e=csCompile(e,labels,0)
	csOSTest(e)
    end

end
