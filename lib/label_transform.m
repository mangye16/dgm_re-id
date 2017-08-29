function ProbY = label_transform(X,BDs)
% label label_transform

ProbY = X;
ProbY (ProbY == 0)  = -1;
end