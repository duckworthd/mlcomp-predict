function [ heatmap ] = generate_heatmap( input_file )
%GENERATE_HEATMAP Display a HeatMap from input data
%
%INPUT
% input_file = a labeled input matrix with the following format
%   <irrelevent>    <col_1_label> <col_2_label> <col_3_label> ...
%   <row_1_label>   <element_1,1> <element_1,2> <element<1,3> ...
%   <row_2_label>   <element_2,1> <element_2,2> <element_2,3> ...
%        .
%        .
%        .
%
%OUTPUT
% a HeatMap object, as created by the Bioinformatics Toolbox of MATLAB

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

% heatmap = HeatMap(data, 'RowLabels', row_labels{1}, ...
%     'ColumnLabels', col_labels);

heatmaptextmod(data, 'ROWLABELS', row_labels, 'COLLABELS', col_labels);
end

