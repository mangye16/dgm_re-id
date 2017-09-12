function [train_graph, selected_idx] = random_gen_train_graph(initial_label,video_feat)


uni_label  = unique(initial_label);
num = length(uni_label)-1;

candi_idx = find(initial_label==0);
random_idx = randperm(length(candi_idx));

selected_idx = candi_idx(random_idx(1:num));
for i = 1:num
    train_graph{1,i} = video_feat(:, selected_idx(i));
end

end