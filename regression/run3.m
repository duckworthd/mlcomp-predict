clear;
close all;
addpath('../');

%%
input_folder = '../scraping/datafeatures/';
true_file = 'true_mat.txt';
predict_file = 'predict_mat.txt';

%%
% Load algorithm/dataset scores
[alg_scores,data_scores] = load_folder(input_folder);
[cf_mat, cf_data_names, cf_alg_names] = collab_filt_mat(alg_scores);
[ds_data_names, as_alg_names] = get_names(alg_scores, data_scores);

% Output read entries into a pretty data matrix
f = fopen(true_file,'w');
[m,n] = size(cf_mat);
for i=1:m
    for j=1:n
        if ~isnan(cf_mat(i,j))
            fprintf(f, '%d %d %f\n', i,j,cf_mat(i,j));
        end
    end
end
fclose(f);

% purge NaN's with 0s (NOT the right thing to do...)
nan_ind = isnan(cf_mat);
cf_mat_orig = cf_mat;
cf_mat(nan_ind) = 0;

files = dir(input_folder);
f = fopen(predict_file,'w');
for i=1:length(files)
    filename = files(i).name;
    path = fullfile(input_folder,filename);
    if isdir(path)
        continue;
    end
    
    [A,b,d_names] = load_file(path);
    
    % append scores of all other algorithms to each row
    [m,n] = size(A);
    A2 = zeros([m,n] + [0, size(cf_mat,2)]);    
    for j=1:m
        data_ind = reverseDictLookup(cf_data_names, d_names(j));
        A2(j,1:n) = A(j,1:n);
        A2(j,n+1:end) = cf_mat(data_ind,:);
    end
    A = A2;
    
    % Make A_test.  Each row is an algorithm for which we have no score.
    not_appearing = setdiff(cf_data_names, d_names);    % names of algs w/o scores
    A_test = zeros([length(not_appearing), n] + [0, size(cf_mat,2)]);
    for j=1:length(not_appearing);
        data_ind = reverseDictLookup(cf_data_names, not_appearing(j));
        A_test(j,n+1:end) = cf_mat(data_ind,:);
        
        data_ind = reverseDictLookup(ds_data_names, not_appearing(j));
        A_test(j,1:n) = data_scores(data_ind).features;
    end
    
    % remove column representing this algorithm
    A(:,reverseDictLookup(cf_alg_names,filename)+n) = 0;
    A_test(:,reverseDictLookup(cf_alg_names,filename)+n) = 0;
        
    % train/evaluate
    x = l2ridge_learn(A,b);
    b_prime = l2ridge_test(A_test,x);

    % constrain to [0,1]
    b_prime = max(min(b_prime,1),0);
    
    % output predictions
    for j=1:length(b_prime)
        data_ind = reverseDictLookup(cf_data_names, not_appearing(j));
        alg_ind = reverseDictLookup(cf_alg_names, filename);
        fprintf(f, '%d %d %f\n', data_ind, alg_ind, b_prime(j));
    end
end
fclose(f);