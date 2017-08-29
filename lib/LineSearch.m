function [optFlag, M, P, latent, r, newF] = LineSearch(V, gradF, prevF_V, galX, probX, Y, W, L, mu)
    M = V - gradF / L;
    M =(M + M') / 2; % correct the rounding-off error to make sure M is symmetric
    [U, S] = eig(M);
    latent = max(0, diag(S));
    M = U * diag(latent) * U';
    r = sum(latent > 0);
    [latent, index] = sort(latent, 'descend');
    latent = latent(1:r);
    P = U(:, index(1:r)) * diag(sqrt( latent ));
    
    D = EuclidDist(galX * P, probX * P) - mu;
    D(Y == -1) = - D(Y == -1);
    D(Y >0.5)  = D(Y >0.5).*Y(Y >0.5);
    
    newF = Logistic(D); % log(1 + exp( D ));
    newF = W(:)' * newF(:);
    
    diffM = M - V;
    optFlag = newF <= prevF_V + diffM(:)' * gradF(:) + L * norm(diffM, 'fro')^2 / 2;
end

function Y = Logistic(X)
    Y = log(1 + exp(X));
    Y(isinf(Y)) = X(isinf(Y));
end