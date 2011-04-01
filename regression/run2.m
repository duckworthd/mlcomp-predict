clear;
close all;
addpath('../');

s=RandStream('mt19937ar', 'Seed', 0);
RandStream.setDefaultStream(s);

%%
input_folder = '../scraping/datafeatures/';
n_cuts = 10;
cutsize = 0.2;

%%
% Load algorithm/dataset scores
alg_scores = load_folder(input_folder);
cf_mat = collab_filt_mat(alg_scores);
[data_names, alg_names] = get_names(alg_scores);

% purge NaN's with 0s (NOT the right thing to do...)
nan_ind = isnan(cf_mat);
cf_mat_orig = cf_mat;
cf_mat(nan_ind) = 0;

scores = [];        % error of every run, every algorithm
avg_scores = [];    % average error of each algorithm
files = dir(input_folder);
for i=1:length(files)
    filename = files(i).name;
    path = fullfile(input_folder,filename);
    if isdir(path)
        continue;
    end
    
    [A,b,d_names] = load_file(path);
    if size(A,1) <= size(A,2)
        continue;
    end
    
    % append scores of all other algorithms to each row
    [m,n] = size(A);
    A2 = zeros([m,n] + [0, size(cf_mat,2)]);    
    for j=1:m
        data_ind = reverseDictLookup(data_names, d_names(j));
        A2(j,1:n) = A(j,1:n);
        A2(j,n+1:end) = cf_mat(data_ind,:);
    end
    A = A2;
    
    % remove column representing this algorithm
    A(:,reverseDictLookup(alg_names,filename)+n) = 0;
    
    % Put in quadratic terms
    A = x2fx(A,'linear');
    A = A(:,2:end); % Remove column of 1's
    
    % remove entries where algorithm did perfect
    imperfect_idx = (b ~= 0);
    A = A(imperfect_idx,:);
    b = b(imperfect_idx,:);

%     figure; hold on;
%     xlabel('true error');
%     ylabel('estimated error');
    
    alg_scores = [];    % error of every run, one algorithm
    n_examples = size(A,1);
    n_train = floor((1-cutsize)*n_examples);
    for j=1:n_cuts
        train_idx = randi(n_examples, [n_train,1]);
        A_train = A(train_idx,:);
        b_train = b(train_idx,:);
        test_idx = setdiff(1:n_examples,train_idx);
        A_test  = A(test_idx,:);
        b_test  = b(test_idx,:);
        
        % move to log space
%         b_train = log(b_train);
        
        % train/evaluate
        x = l2ridge_learn(A_train,b_train);
        b_prime = l2ridge_test(A_test,x);
        
        % move back to linear space
%         b_prime = exp(b_prime);
        
        % constrain to [0,1]
        b_prime = max(min(b_prime,1),0);

        % calculate/plot error
        score = norm(b_test-b_prime,1)/length(b_test);
        fprintf('%40s%10f\n', filename, score);
        scores = [scores;score];
        alg_scores = [alg_scores; score];

%         scatter(b_test,b_prime);
    end
    avg_scores = [avg_scores; mean(alg_scores)];
    
%     axis([0,1,0,1]);
%     hold off;
end
fprintf('Mean error.stddev: %f/%f\n', mean(scores), std(scores));
fprintf('Easiest/Hardest to predict: %f/%f\n', min(avg_scores), max(avg_scores));