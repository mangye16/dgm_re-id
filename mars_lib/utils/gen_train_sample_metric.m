function [probFeat, galFeat] = gen_train_sample_metric(label, cam, train_feat, pp)
 

uni_label = 1: length(unique(label))-1;

probFeat = zeros(length(unique(label))-1,size(train_feat,1));
galFeat  = probFeat;
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
        
        if pp==1
            cam1 = cam(tmp1);
            cam2 = cam(tmp2);
            pos2 = find(cam1~=cam2);
            if ~isempty(pos2)
                tmp1 = tmp1(pos2);
                tmp2 = tmp2(pos2);
            end
        end

        current1 = tmp1;
        current2 = tmp2;
    end
    tmp_feat = mean(train_feat(:, current1),2);
    probFeat(n,:) = tmp_feat';
    tmp_feat = mean(train_feat(:, current2),2);   
    galFeat(n,:) = tmp_feat';
end

end