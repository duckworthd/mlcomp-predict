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

[data, row_labels, col_labels] = load_heatmap_data(input_file);

% heatmap = HeatMap(data, 'RowLabels', row_labels{1}, ...
%     'ColumnLabels', col_labels);

heatmaptextmod(data, 'ROWLABELS', row_labels, 'COLLABELS', col_labels);
end

