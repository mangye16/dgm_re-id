function [train_graph, selected_idx] = random_gen_gallery_graph(initial_label, label_train, video_feat)

uni_label = unique(initial_label);
slected_label = uni_label;
selected_idx = zeros(length(slected_label)-1,1);

candi_idx = find(initial_label==0);

label = unique(label_train);

for n = 1:length(slected_label)-1
    pos1 = find(label_train == label(n)); 
    pos2 = find(initial_label == n); 
    pos = setdiff(pos1,pos2);
    if isempty(pos)
        pos = pos1(1);
    end 
    idx = randperm(length(pos));
    current = pos(idx(1));
    train_graph{1,n} = video_feat(:, current);
    selected_idx(n)  =  current;
end
