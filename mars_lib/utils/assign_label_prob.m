function label_out = assign_label_prob(label_out,select_idx,Yp)

ground_label = 1:max(label_out);


[idx1, idx2] = find(Yp>0.5);

for i = 1:length(idx1)
    tmp_label = ground_label(idx1(i));
    tmp_idx   = select_idx(idx2(i));
    label_out(tmp_idx) = tmp_label;
end


end