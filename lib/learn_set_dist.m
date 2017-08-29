function set_dist = learn_set_dist(ProbFeatA, GallFeatB, P)

lambda1 = 1e-1;  %the first parameter in RNP
lambda2 = 1e-1;  %the second parameter in RNP

set_dist = zeros(length(ProbFeatA),length(GallFeatB));
for i = 1:length(ProbFeatA)
    for j = 1:length(GallFeatB)
        set_dist(i,j)= learn_rnp(ProbFeatA{1,i}'*P,GallFeatB{1,j}'*P,lambda1,lambda2); 
    end
end

end

function dist = learn_rnp(X1,X2,lambda1,lambda2)
% learn regularized nearest point distance

X1 = X1';  %each column represents a sample
X2 = X2';

X1  =  X1./( repmat(sqrt(sum(X1.*X1)), [size(X1,1),1]) );
X2  =  X2./( repmat(sqrt(sum(X2.*X2)), [size(X2,1),1]) );

newy = [zeros(size(X1,1),1); 1;1];
tem1 = [ones(1,size(X1,2)) zeros(1,size(X2,2))];
tem2 = [zeros(1,size(X1,2)) sqrt(lambda1/lambda2)*ones(1,size(X2,2))];
newD = [[X1 -sqrt(lambda1/lambda2)*X2];tem1;tem2];

DD            =  newD'*newD;
Dy            =  newD'*newy;
x             =  (DD+lambda1*eye(size(newD,2)))\Dy;

coef1      = x(1:size(X1,2),1);
coef2      = sqrt(lambda1/lambda2)*x(size(X1,2)+1:end,1);
dist       = norm(X1*coef1-X2*coef2,2)^2;

end