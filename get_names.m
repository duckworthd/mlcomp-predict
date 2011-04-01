function [ data_names, alg_names ] = get_names( alg_scores, data_scores )
%DATASET_NAMES Extract algorithm names and dataset names from
%alg_scores/data_scores struct created by load_folder() method.
%data_scores argument is optional

n_alg = length(alg_scores);
alg_names = {};         % algorithm names
data_names = {};        % dataset names
for i=1:n_alg
    n_data = length(alg_scores(i).datasets);
    alg_names = [alg_names; alg_scores(i).algorithm];
end

if nargin == 2
    n_data = length(data_scores);
    for i=1:n_data
        data_names = [data_names; data_scores(i).dataset];
    end
else
    for i=1:n_alg
        n_data = length(alg_scores(i).scores);
        for j=1:n_data
            data_name = alg_scores(i).datasets{j};
            data_ind = reverseDictLookup(data_names, data_name);
            if data_ind <= 0
                data_names = [data_names; data_name];
            end
        end
    end
end

