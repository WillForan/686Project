function [ i ] = strIndexOf( str, c )
%STRINDEXOF Returns the index of str in cell c

for i = 1:length(c)
    if strcmp(str,c{i})
        return;
    end
end

throw MException('IllegalArgument','the string is not in the cell array');

end

