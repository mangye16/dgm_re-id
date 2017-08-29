function SetDist = compute_set_distance(distance,NumCount1,NumCount2)


index1 = count2index(NumCount1);
index2 = count2index(NumCount2);

SetDist = zeros(length(NumCount1),length(NumCount2));
for i = 1:length(NumCount1)
    for j =1:length(NumCount2)
    tempDist = distance(index1(i,1):index1(i,2),index2(j,1):index2(j,2));   
%     SetDist(i,j)= min(min(tempDist)); %min
    SetDist(i,j)= mean(mean(tempDist));  %mean
    end 

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