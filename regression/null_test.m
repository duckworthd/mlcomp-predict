function [ b ] = null_test( A,x )
%NULL_TEST Summary of this function goes here
%   Detailed explanation goes here

b = [ones(size(A,1),1)]*x;
end

