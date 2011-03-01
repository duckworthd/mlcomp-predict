clear;
close all;
addpath('../');

%%
input_folder = '../scraping/datafeatures/';

%%
scores = [];
files = dir(input_folder);
for i=1:length(files)
    filename = files(i).name;
    path = fullfile(input_folder,filename);
    if ~isdir(path)
        [A,b] = load_folder(path);
        
        if size(A,1) <= size(A,2)
            continue;
        end
        
        x = L1LinearRegression(A,b);
%         x = robustfit(A,b);
%         x = A\b;
    
        [b_sorted, b_index] = sort(b);
        Ax = [ones(size(A,1),1), A]*x;
%         Ax = A*x;
        Ax_sorted = Ax(b_index);
        
        score = norm(b-Ax,1)/size(A,1);
        fprintf('%s\t\t%f\n', filename, score);
        scores = [scores;score];
        
%         figure('Name', filename);
%         hold on;
%         plot(1:length(b), b_sorted, 'r*');
%         plot(1:length(b), Ax_sorted, 'b+');
%         legend('true', 'estimated');
%         hold off;
    end
end
fprintf('Average error: %f\n', mean(scores));