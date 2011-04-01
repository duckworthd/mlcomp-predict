function [ x ] = l2ridge_learn( A,b )
%L2RIDGE_LEARN Summary of this function goes here
%   Detailed explanation goes here

x = ridge(b,A,0.1,0);

end

