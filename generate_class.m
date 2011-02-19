function [samples, classes, weights, mean, covariance] = generate_class(dim, ...
    num_samples, num_classes, cov_density, sample_density, weight_density)
% GENERATE_CLASS: Generate multilabel classification sample points
%   based on randomly sampled linear weights
%INPUT
% dim = dimension of input vector
% num_samples = number of samples to generate
% num_classes = number of unique classes
% cov_density = a number 0 to 1 specifying roughly what percentage of entries
%   in the covariance matrix generating samples are non-zero
% sample_density = percentage of non-zero entries in samples
% weight_density = a number 0 to 1 specifying what percentage of weights are
%   non-zero per weight vector
%OUTPUT
% samples = each row is a sample of dimension 'dim'
% classes = each element is the class label corresponding to the 'samples'
%   variable's rows
% weights = each column is the weight vector which, when multiplied by the
%   sample, provides the score for that label.  the argmax of this
%   multiplied by 1 sample is the class.
% mean = mean of samples
% covariance = covariance matrix for samples

%% Choose parameters for Gaussian
S = full(sprandsym(dim,cov_density,rand(dim,1))); 
mean = randn(dim,1);

%% Sample Multivariate Gaussian
X = mvnrnd(mean, S, num_samples);

while nnz(X)/prod(size(X)) > sample_density
    % Keep on zeroing out non-zero entries until percentage of non-zero
    % elements is less than sample_density
    indices = find(X);
    to_remove = indices( randi(length(indices)) );
    X(to_remove) = 0;
end

%% Sample Weight Vectors
W = sprandn(dim, num_classes, weight_density);

%% Generate Class Labels
C = X*W;
[trash, classes] = max(C,[],2);

%% Set results
samples = X;
classes = classes;
weights = W;
mean = mean;
covariance = S;