function feature_cell=feature_mat2cell(feature_mat,count)

NumOfPerson = length(count);
feature_cell=cell(1,NumOfPerson);
temp_start=1;
for iPerson=1:NumOfPerson
 %   disp(['mat2cell person:',num2str(iPerson)])
    num_count=count(iPerson);
    temp_end=temp_start+num_count-1;
    feature_cell{iPerson}=zeros(size(feature_mat,1),num_count);
    feature_cell{iPerson}=feature_mat(:,temp_start:temp_end);
%     feature_cell{iPerson}=mean(feature_mat(:,temp_start:temp_end),2);
%     feature_cell{iPerson}=max(feature_mat(:,temp_start:temp_end),[],2);
    temp_start=temp_end+1;
    
end

end
