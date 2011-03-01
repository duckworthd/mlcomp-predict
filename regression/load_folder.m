function [ A,b ] = load_folder( filename )
%LOAD_FOLDER Summary of this function goes here
%   Detailed explanation goes here

line_format = '%s %f %f %f %s';

f = fopen( filename );
runs = textscan(f, line_format);
fclose(f);

% fprintf('%s\n', filename);

scores = runs{5};
for i=1:length(scores)
    if strcmp(scores{i}, 'failed')
        scores{i} = '1.0';
    end
end
runs{5} = str2double(scores);

A = cell2mat( runs(:,2:4) );
b = cell2mat( runs(:,5) );

to_keep = (b ~= 1.0);

A = A(to_keep,:);
b = b(to_keep);