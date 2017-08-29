function [feature_mat, CountOfSample]= feature_cell2mat(feature_cell)
% input:
%   feature_cell :N*1 cell N is the nmuber of samples
    
% output:
%   feature_mat
%	CountOfSample: The number of each sample

feature_mat   = [];
CountOfSample = zeros(1,length(feature_cell));

for iPerson = 1:length(feature_cell)
    temp_feature = feature_cell{iPerson};
    CountOfSample(iPerson) = size(temp_feature,2);
    feature_mat = [feature_mat temp_feature];
end

end