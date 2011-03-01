function [ data, row_labels, col_labels ] = load_heatmap_data( input_file )
%LOAD_HEATMAP_DATA Summary of this function goes here
%   Detailed explanation goes here


f = fopen(input_file);
if f == -1
    fprintf('Unable to open file\n');
    return;
end

line = fgets(f);
col_labels = textscan(line, '%s');
col_labels = col_labels{1}(2:end);
row_labels = {};
data = [];

i = 1;
line = fgets(f);
while ischar(line)
    line_data = textscan(line, '%s');
    row_labels(i) = line_data{1}(1);
    data(i,:) = str2double( line_data{1}(2:end) )';
    i = i+1;
    line = fgets(f);
end
fclose(f);
row_labels = row_labels';

end