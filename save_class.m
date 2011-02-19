function [ success ] = save_class( samples, labels, filename )
%SAVE_CLASS Save samples and labels into a file for mlcomp
%
% samples = a matrix where each row is a sample input
% labels = each entry is the label corresponding to the row in 'samples'
% filename = where to save file
%
% success = 1 on success, failure otherwise

if size(samples,1) ~= length(labels)
    fprintf('Number of samples must match number of labels\n');
end

%% Open File
f = fopen(filename, 'w');
if f < 0
    success = f;
    return;
end

%% Fill file
for i=1:length(labels)
    fprintf(f, '%d ', labels(i));
    for j=find(samples(i,:))
        fprintf(f, '%d:%f ', j, samples(i,j));
    end
    fprintf(f,'\n');
end

%% Fin
success = fclose(f);

end

