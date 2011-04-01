function [ b ] = l2_test( A,x )
%L2_TEST Summary of this function goes here
%   Detailed explanation goes here

A = x2fx(A, 'linear');
b =  A*x;

end

