function [samples, classes, weights, mean, covariance] = generate_class(dim, ...
    num_samples, num_classes, density)
% GENERATE_CLASS: Generate multilabel classification sample points
%   based on randomly sampled linear weights
%INPUT
% dim = dimension of input vector
% num_samples = number of samples to generate
% num_classes = number of unique classes
% density = a struct describing what percentage of terms should be non-zero
%       in each respective variable
%   density.cov = a number 0 to 1 specifying roughly what percentage of entries
%     in the covariance matrix generating samples are non-zero
%   density.sample = percentage of non-zero entries in samples
%   density.weight = a number 0 to 1 specifying what percentage of weights are
%     non-zero per weight vector
%OUTPUT
% samples = each row is a sample of dimension 'dim'
% classes = each element is the class label corresponding to the 'samples'
%   variable's rows
% weights = each column is the weight vector which, when multiplied by the
%   sample, provides the score for that label.  the argmax of this
%   multiplied by 1 sample is the class.
% mean = mean of samples
% covariance = covariance matrix for samples

%% Read out optional args
cov_density = 1;
sample_density = 1;
weight_density = 1;
if isfield(density, 'cov')
    cov_density = density.cov;
end
if isfield(density, 'sample')
    sample_density = density.sample;
end
if isfield(density, 'weight')
    weight_density = density.weight;
end

%% Choose parameters for Gaussian
fprintf('Generating parameters for samples...\n');
% S = sprandsym(dim,cov_density,rand(dim,1)); 
S = rand(dim,dim);
S = S'*S;
mean = randn(dim,1);

%% Sample Multivariate Gaussian
fprintf('Generating samples...\n');
X = mvnrnd(mean, S, num_samples);

parfor i=1:num_samples
    sample = X(i,:);
    for j=1:(dim - sample_density*dim)
        indices = find(sample);
        to_remove = indices( randi( length( indices ) ) );
        sample(to_remove) = 0;
    end
    X(i,:) = sample;
end
% while nnz(X)/numel(X) > sample_density
%     % Keep on zeroing out non-zero entries until percentage of non-zero
%     % elements is less than sample_density
%     indices = find(X);
%     to_remove = indices( randi(length(indices)) );
%     X(to_remove) = 0;
% end

%% Sample Weight Vectors
fprintf('Generating weights...\n');
W = sprandn(dim, num_classes, weight_density);

%% Generate Class Labels
fprintf('Generating class labels...\n');
C = X*W;
[~, classes] = max(C,[],2);

%% Set results
fprintf('done\n');
samples = X;
classes = classes;
weights = W;
mean = mean;
covariance = S;