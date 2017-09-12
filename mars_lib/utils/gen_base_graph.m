function  [base_graph, count]= gen_base_graph(initial_label,video_feat)

uni_label = unique(initial_label);

for i = 2:length(uni_label)
    idx = find(initial_label==uni_label(i));
    base_graph{1,i-1} = video_feat(:, idx);
    count{1,i-1} = length(idx);
end