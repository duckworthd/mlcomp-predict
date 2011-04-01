function [ M, row_names, col_names ] = collab_filt_mat( alg_scores )
%COLLAB_FILT_MAT Create a collaborative filtering matrix

%%
[data_names, alg_names] = get_names(alg_scores);
n_alg = length(alg_names);
n_data = length(data_names);

%% compute data-algorithm score matrix.  NaN's for unknown entries.
data_alg = zeros(n_data,n_alg);
for i=1:n_alg
    for j=1:n_data
        data_alg(j,i) = NaN;
    end
    for j=1:length(alg_scores(i).datasets)
        dataset = alg_scores(i).datasets(j);
        data_ind = reverseDictLookup(data_names,dataset);
        data_alg(data_ind,i) = alg_scores(i).scores(j);
    end
end

M = data_alg;
row_names = data_names;
col_names = alg_names;


end

