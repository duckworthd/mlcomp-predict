function [ b ] = l1_test( A,x )
%L1_TEST Summary of this function goes here
%   Detailed explanation goes here

b = [ones(size(A,1),1), A]*x;

end

