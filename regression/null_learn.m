function [ x ] = null_learn( A,b )
%NULL_LEARN Summary of this function goes here
%   Detailed explanation goes here

x = ones(size(A,1),1)\b;

end

