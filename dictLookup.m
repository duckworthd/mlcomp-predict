function [ term ] = dictLookup( dict, index, col_ind )
%DICTLOOKUP Return the string corresponding to the integer index in a
%   dictionary.


if nargin == 3 && index > 0 && index <= length(dict)
    index = col_ind(index);
end

term = dict(index);


end

