function ProbY = label_reweighting(X,BDs)
% label re-weighting

ProbY = X;
c0 = mean(mean(BDs));

% positive reweighting
for i = 1:size(X,1)    
    pos = find(X(i,:)==1); 
    if BDs(i,pos)<=c0
        ProbY(i,pos) = exp(-(BDs(i,pos))/max(BDs(i,:)));
    else
        ProbY(i,pos) = 0.001;
    end
end

% negative  reweighting
ProbY(BDs>c0) = 0.001;
ProbY (ProbY == 0)  = -1;
ProbY (ProbY <= 0.5& ProbY >0) = 0;
end