function [prob_sample, gall_sample,count1,count2] = gen_train_graph(label, cam, train_feat)

uni_label = unique(label);

i = 1;

idx = randperm (length(uni_label));
% slected_label = uni_label(idx(1:200));
slected_label = uni_label;
for n = 1:length(slected_label)
    pos = find(label == slected_label(n));
    if length(pos)==1
        current1 = pos;
        current2 = pos;
    else
        perm = randperm(length(pos));
        tmp1 = pos(perm(1:floor(length(pos)/2)));
        tmp2 = pos(perm(floor(length(pos)/2)+1:floor(length(pos)/2)*2));
        cam1 = cam(tmp1);
        cam2 = cam(tmp2);
        pos2 = find(cam1~=cam2);
        tmp1 = tmp1(pos2);
        tmp2 = tmp2(pos2);

        current1 = tmp1;
        current2 = tmp2;
    end
    
    if ((length(current1))>0)&&((length(current2))>0)
        
        prob_sample{1,i} = train_feat(:, current1);
        count1{1,i} = current1;
    
        gall_sample{1,i} = train_feat(:, current2);
        count2{1,i} = current2;
        i = i+1;
    end
%     count2(n) = length(current2);
end
