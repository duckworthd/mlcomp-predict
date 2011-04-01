function [ b ] = l2ridge_test( A,x )
%L2RIDGE_TEST Summary of this function goes here
%   Detailed explanation goes here

b = [ones(size(A,1),1), A]*x;

end

