%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Demo code on the MARS dataset for the following paper:
%%%
%%% Mang Ye, Andy J Ma, Liang Zheng, Jiawei Li and Pong C Yuen. 
%%% "Dynamic Label Graph Matching for Unsupervised Video Re-Identification". 
%%% International Conference on Computer Vision (ICCV), 2017.
%%%
%%% research purpose only. 
%%%
%%% Contact: mangye@comp.hkbu.edu.hk
%%% Last updated: 2017/7/20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc;
clear all; close all;

%% Add Path;
addpath ('lib/','data/');
addpath (genpath('mars_lib/'));
% addpath 'LOMO_XQDA/code'
% addpath 'CM_Curve/' % draw confusion matrix

%% setting
pcadim       = 600;
nTrial       = 10;
val          = 0; % 0: sequence cost only, 1: neighbor cost only, 2: both


% parameters for metric learning
P    = eye(pcadim);   %original metric

track_train = importdata('tracks_train_info.mat');
track_test = importdata('tracks_test_info.mat');


load('MARS_Feature_LOMO_PCA.mat');
% replace your video features here.
video_feat_train = TrainFeat(:,1:pcadim)'; % pooled video features for train
video_feat_test = TestFeat(:,1:pcadim)'; % video video features for test (gallery+query)

clear TrainFeat
clear TestFeat

query_IDX = importdata('query_IDX.mat');  % load pre-defined query index
video_feat_test  = [zeros(pcadim,length(find(track_test(:, 3)==-1))) video_feat_test];
% train, gallery, and query labels
label_train = track_train(:, 3);
label_gallery = track_test(:, 3);
label_query = label_gallery(query_IDX);
cam_train = track_train(:, 4);
cam_gallery = track_test(:, 4);
cam_query = cam_gallery(query_IDX);
feat_gallery = video_feat_test;
feat_query = video_feat_test(:, query_IDX);

ux_query = feat_query;
ux_gallery = feat_gallery;
clear feat_query feat_gallery video_feat_test 

%% label initialization
initial_label = initial_label_idx(track_train(:,3:4)); % initilize the tracklets in camera 1 
label_out = initial_label; % label out

ID_idx = unique(track_train(:,3));
groundtruth_label = zeros(length(initial_label),1);
for i = 1:length(ID_idx)
    tmp_ID = ID_idx(i);
    idx_se = find(track_train(:,3)==tmp_ID);
    groundtruth_label(idx_se) = i;
end

CMC_MARS = zeros(100,size(track_test,1));
Map_MARS = zeros(100,1);

% base graph generation
[ProbFeatA, count1 ] = gen_base_graph(initial_label,video_feat_train);

for iter = 1: nTrial * 10 
      
% randomly construct the graph for each iteration    
 [GallFeatB, select_idx] = random_gen_gallery_graph(initial_label,label_train,video_feat_train);

% Compute the original graph cost
Graph_Cost = compute_node_cost(ProbFeatA,GallFeatB,P,val);
mu = mean(Graph_Cost(:));

% Graph cost construction
Graph_Cost = Graph_Cost-mu;
Graph_Cost = log(1 + exp( Graph_Cost ));
Graph_Cost = sqrt(Graph_Cost);

% Graph matching
[X,score] = hungarian(Graph_Cost);
Yp    = label_reweighting(X,Graph_Cost);
% Yp    = label_transform(X,Graph_Cost);

% assign label
label_out    = assign_label_prob(label_out,select_idx,Yp);
label_metric = assign_label_prob(initial_label,select_idx,Yp); 

%% update the metric
% This part is partially from MLAPG in ICCV 2015.
% generate the training samples for metric learning
[probFea, gallFea] = gen_train_sample_metric(label_metric, cam_train, video_feat_train,1);
Yp = 2*eye(size(probFea,1))-ones(size(probFea,1),size(probFea,1));

P    = eye(pcadim);
tol = 1e-4;
L = 1 / 2^8;
gamma = 2;
prevAlpha = 0;
prevM  = P;
M      = P;
prevP2 = P;
nPos = length(find(Yp(:)>0.5));
nNeg = sum(Yp(:) == -1);
Wp = zeros(length(ProbFeatA), length(ProbFeatA));
Wp(Yp > 0.5) = 1 / nPos;
Wp(Yp == -1) = 1 / nNeg;
WYp = Wp .* Yp;

Dp = EuclidDist(probFea * P, gallFea * P);
mu = mean(Dp(:));
Dp(Yp == -1) = - Dp(Yp == -1);
Dp(Yp >0.5)  = Dp(Yp >0.5).*Yp(Yp >0.5);
newF = log(1 + exp( Dp )); % log(1 + exp( D ));
newF = Wp(:)' * newF(:); % sum(sum( W .* log(1 + exp( Y .* (D - mu) )) ));

% optimization
for r = 1:200
newAlpha = (1 + sqrt(1 + 4 * prevAlpha^2)) / 2;
V = M + (prevAlpha - 1) / newAlpha * (M - prevM);
alpha = -(prevAlpha - 1) / newAlpha; % for prevP1
beta = 1 + (prevAlpha - 1) / newAlpha; % for prevP2

prevP1 = prevP2;
prevP2 = P;
prevM = M;
prevF = newF;
prevAlpha = newAlpha;

Dp = alpha * EuclidDist(probFea * prevP1, gallFea * prevP1) + beta * EuclidDist(probFea * prevP2, gallFea * prevP2) - mu;

Dp(Yp == -1) = - Dp(Yp == -1);
Dp(Yp >0.5)  = Dp(Yp >0.5).*Yp(Yp >0.5);

T = WYp ./ (1 + exp( -Dp ));
X = probFea' * T * gallFea;
gradF = probFea' * bsxfun(@times, sum(T, 2), probFea) - X - X' + bsxfun(@times, gallFea', sum(T, 1)) * gallFea;

prevF_V =  log(1 + exp( Dp ));
prevF_V = Wp(:)' * prevF_V(:);

while true
    [optFlag, M, P, latent, rank, newF] = LineSearch(V, gradF, prevF_V, probFea, gallFea, Yp, Wp, L, mu);
    if ~optFlag
        L = gamma * L;
    else
        break;
    end
end
end

% evaluation at each iteration
dist_eu = EuclidDist(ux_gallery'* P,ux_query'* P);
[CMC_eu, map_eu, r1_pairwise, ap_pairwise] = evaluation_mars(dist_eu, label_gallery, label_query, cam_gallery, cam_query);
% [ap_CM, r1_CM] = draw_confusion_matrix(ap_pairwise, r1_pairwise, cam_query);

fprintf('Iter %d:    MAP = %d\n',iter, map_eu);
fprintf('Rank 1: %2.2f%%  Rank 5: %2.2f%%  Rank 10: %2.2f%%  Rank 20: %2.2f%%\n',CMC_eu([1,5,10,20])*100);
end
