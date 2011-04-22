function [ out ] = importEmotiveData( file )
%IMPORTEMOTIVEDATA Imports CSV data exported from emotive
%   file - the csv file to import the data from
%

header = readline(file);
rest = header;
while ~strcmp(rest,'')
    [field,rest] = strtok(rest,',');
    m = regexp(field,'\s*(?<label>[^:]+):(?<value>[^:]+)\s*','names');
    
    if [0 0] == size(m)
        continue;
    else
        m.label = strtrim(m.label);
        m.value = strtrim(m.value);
    end
        
    if strcmp(m.label,'title')
        out.title = m.value;
    elseif strcmp(m.label,'recorded')
        a = sscanf(m.value,'%d.%d.%d %d.%d.%d');
        out.date.day = a(1);
        out.date.month = a(2);
        out.date.year = 2000 + a(3);
        out.date.hour = a(4);
        out.date.min = a(5);
        out.date.sec = a(6);
    elseif strcmp(m.label,'sampling')
        out.sampling = str2double(m.value);
    elseif strcmp(m.label,'subject')
        out.subject = m.value;
    elseif strcmp(m.label,'labels')
        out.labels = strread(m.value,'%s','delimiter',' ');
    elseif strcmp(m.label,'chan')
        out.channels = str2double(m.value);
    elseif strcmp(m.label,'units')
        out.units = m.value;
    end
end

data = csvread(file,1,0);
[n f] = size(data);
out.samples = n;
out.data = data;
out.file = file;

end

