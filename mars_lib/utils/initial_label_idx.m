function label_idx = initial_label_idx(train_idx)

label_idx = zeros(size(train_idx,1),1);

ori_idx = unique(train_idx(:,1));

for i = 1:length(ori_idx)   
    idx_1 = find(train_idx(:,1)==ori_idx(i)) ;
    idx_2 = find(train_idx(:,2)==1) ;
    idx = intersect(idx_1,idx_2);    
    if isempty(idx)
        idx = idx_1;
    end 
    
    label_idx(idx) = i;   
end

end