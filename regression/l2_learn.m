function [ x ] = l2_learn( A,b )
%L2_LEARN Summary of this function goes here
%   Detailed explanation goes here

A = x2fx(A, 'linear');
x = A\b;

end

