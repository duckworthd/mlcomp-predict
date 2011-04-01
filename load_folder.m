function [ alg_scores, data_scores ] = load_folder( in_folder )
%LOAD_FOLDER Summary of this function goes here
%   Detailed explanation goes here

files = dir(in_folder);
n_files = length(files);
alg_scores = struct();
alg_ind = 1;
for i=1:n_files
    fname = fullfile(in_folder, files(i).name);
    if isdir(fname) || files(i).name(1) == '.'
        continue;
    end
    alg_scores(alg_ind).algorithm = files(i).name;
    [alg_scores(alg_ind).features, alg_scores(alg_ind).scores, ...
        alg_scores(alg_ind).datasets] = load_file(fname);
    alg_ind = alg_ind + 1;
end

data_scores = struct;
[data_names,~] = get_names(alg_scores);
n_data = length(data_names);
n_alg  = length(alg_scores);

for i=1:n_data
    data_scores(i).dataset = data_names(i);
    data_scores(i).features = [];
    data_scores(i).scores = [];
    data_scores(i).algorithms = {};
    
    for j=1:n_alg
        for i2=1:length(alg_scores(j).scores)
            if strcmp( alg_scores(j).datasets(i2), data_names(i) )
                data_scores(i).scores = [data_scores(i).scores; alg_scores(j).scores(i2)];
                data_scores(i).features = alg_scores(j).features(i2,:);
                data_scores(i).algorithms = [data_scores(i).algorithms; alg_scores(j).algorithm];
            end
        end
    end
end

end
