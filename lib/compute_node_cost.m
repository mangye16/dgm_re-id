function Cost = compute_node_cost(ProbFeatA,GallFeatB,P,val)

% val = 0, only sequence to sequence cost
[FeatMat1, Count1] = feature_cell2mat(ProbFeatA); %cell2mat
[FeatMat2, Count2] = feature_cell2mat(GallFeatB); %cell2mat

distanceAB = EuclidDist(FeatMat1' * P, FeatMat2'* P); 

index1 = count2index(Count1);
index2 = count2index(Count2);

Cost_set   = zeros(length(Count1),length(Count2));
Cost_neigh = zeros(length(Count1),length(Count2));

if val==0
    % compute sequence cost
    for i = 1:length(Count1)
        for j = 1:length(Count2)
            tempDist      = distanceAB(index1(i,1):index1(i,2),index2(j,1):index2(j,2));   
    %       Cost_set(i,j) = min(min(tempDist)); %min
            Cost_set(i,j) = mean(mean(tempDist)) ;  %mean
        end
    end
elseif val==1
    % compute neighborhood cost
    mProbFeature = get_mean_feature(ProbFeatA);  
    mGallFeature = get_mean_feature(GallFeatB); 

    DistAA = EuclidDist(mProbFeature'* P, FeatMat1'* P);  %For finding neighbors
    DistBB = EuclidDist(mGallFeature'* P, FeatMat2'* P);  %For finding neighbors
    knn = 3;
    for i = 1:length(Count1)
        tmpDistAA = DistAA(i,:);
        [~ ,Idx_A] = sort(tmpDistAA);
        Idx_nnA = Idx_A(1:knn);
        for j =1:length(Count2)
            tmpDistBB = DistBB(j,:);
            [~ ,Idx_B] = sort(tmpDistBB);
            Idx_nnB = Idx_B(1:knn);      
            tmp_nndist = distanceAB(Idx_nnA,Idx_nnB);
            Cost_neigh(i,j) = mean(mean(tmp_nndist));
        end 
    end

elseif val==2    
    % compute sequence cost
    for i = 1:length(Count1)
        for j = 1:length(Count2)
            tempDist      = distanceAB(index1(i,1):index1(i,2),index2(j,1):index2(j,2));   
    %       Cost_set(i,j) = min(min(tempDist)); %min
            Cost_set(i,j) = mean(mean(tempDist)) ;  %mean
        end
    end
    
     % compute neighborhood cost
    mProbFeature = get_mean_feature(ProbFeatA);  
    mGallFeature = get_mean_feature(GallFeatB); 

    DistAA = EuclidDist(mProbFeature'* P, FeatMat1'* P);  %For finding neighbors
    DistBB = EuclidDist(mGallFeature'* P, FeatMat2'* P);  %For finding neighbors
    knn = 3;
    for i = 1:length(Count1)
        tmpDistAA = DistAA(i,:);
        [~ ,Idx_A] = sort(tmpDistAA);
        Idx_nnA = Idx_A(1:knn);
        for j =1:length(Count2)
            tmpDistBB = DistBB(j,:);
            [~ ,Idx_B] = sort(tmpDistBB);
            Idx_nnB = Idx_B(1:knn);      
            tmp_nndist = distanceAB(Idx_nnA,Idx_nnB);
            Cost_neigh(i,j) = mean(mean(tmp_nndist));
        end 
    end    
end

Cost = Cost_set +  0.5*Cost_neigh;
end


function meanFeature = get_mean_feature(FeatCell)
    meanFeature = zeros(size(FeatCell{1},1),length(FeatCell));
    for i = 1:length(FeatCell)
        tmpProbFea = mean(FeatCell{i}, 2);
        meanFeature(:,i) = tmpProbFea;
    end
end

function index = count2index(NumCount)
    % count to label index
    index =zeros(length(NumCount),2);   
    index(1,1) = 1;
    index(1,2) = NumCount(1);
    for i=2:length(NumCount)
        index(i,2) = sum(NumCount(1:i));
        index(i,1) = index(i-1,2)+1;
    end
end