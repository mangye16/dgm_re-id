function label_out = generate_label_prob(ori_idx,labelled_in,count1,count2,ProbY)


label_out = labelled_in;

Yp = ProbY;
Yp (Yp < 0.5)  = 0;
% Yp (Yp <= 0.5& Yp >0) = 0;

[idx1, idx2] = find(Yp>0.5);

for i = 1:length(idx1)
    
    temp_1 = count1(idx1(i));
    temp_2 = count2(idx2(i));
    
    idx = temp_1{1,1};
    ori_label = labelled_in(idx(1));
    
    temp_idx = temp_2{1,1};
    for j = 1:length(temp_idx)
     if ~ori_idx (temp_idx(j))>0
        label_out(temp_idx(j)) = ori_label;
     end
    end
end

end