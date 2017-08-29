function [ result ] = calc_CMC( dist)
%distÎª¾àÀë¾ØÕó
result = zeros(1,size(dist,2));
for pairCounter=1:size(dist,1)
    distPair = dist(pairCounter,:);  
    [tmp,idx] = sort(distPair,'ascend');
    result(idx==pairCounter) = result(idx==pairCounter) + 1;
end

tmp = 0;
for counter=1:length(result)
    result(counter) = result(counter) + tmp;
    tmp = result(counter);
end

result = result / size(dist,1);
disp('Accuracy of rank 1 5 10 15 20');
disp(result([1 5 10 15 20]));
end

