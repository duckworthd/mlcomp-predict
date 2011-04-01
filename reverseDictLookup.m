function [ index ] = reverseDictLookup( dict, term, col_ind )
%REVERSEDICTLOOKUP Find the index corresponding to the given term in the
%   dictionary.

index = find( strcmp(dict, term) );
if length(index) >= 1
    if nargin == 3
        index = find(col_ind == index(1));
    else
        index = index(1);
    end
elseif length(index) == 0
    index = -1;
end

end

