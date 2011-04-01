function [ A,b,datasets ] = load_file( filename )
%LOAD_FOLDER Summary of this function goes here
%   Detailed explanation goes here

f = fopen( filename );
% runs = textscan(f, line_format);

runs = cell(1,5); runs{1} = {};
line = fgets(f);
i = 1;
while ischar(line)
    t = regexp(line, '(.+?)\s+(\d+)\s+(\d+)\s+(\d+)\s+(failed|[.0-9eE-]+)', 'tokens');
    
    if length(t) == 0
        [~,name,ext] = fileparts(filename);
        fprintf(sprintf('Unable to load file: %s\n', [name, ext]));
        continue;
    else        
        t = t{1};
        runs{1} = [runs{1}, t{1}];
    %     for j=1:5
    %         runs{j}(i) = t{i};
    %     end
        if strcmp(t{5}, 'failed')
            t{5} = '1.0';
        end
        for j=2:5
            runs{j}(i) = str2double(t{j});
        end
        i = i+1;
    end
    line = fgets(f);
end
fclose(f);

for i=1:5
    runs{i} = runs{i}';
end
% scores = runs{5};
% for i=1:length(scores)
%     if strcmp(scores{i}, 'failed')
%         scores{i} = '1.0';
%     end
% end
% runs{5} = str2double(scores);

A = cell2mat( runs(:,2:4) );
b = cell2mat( runs(:,5) );
datasets = runs{1};

to_keep = (b ~= 1.0);

A = A(to_keep,:);
b = b(to_keep);
datasets = datasets(to_keep);