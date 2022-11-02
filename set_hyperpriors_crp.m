function prior = set_hyperpriors_crp(nfeatures,y)
% set Chinese Restaurant Process (CRP) priors for mixture of Gaussians
% 
% Inputs:
%     -nfeatures : dimensionality of the stimuli
%     -y : stimuli
% Output: 
%     -prior : initial priors

prior.w = 1; %will be overwritten in main script
prior.cluster_birth = [];
prior.cat = [];
prior.delta = 0.7; %will be overwritten in main script
prior.alpha0 = 0.6; %will be overwritten in main script
prior.nclusters = 0;
prior.nclusters_pos = zeros(1,size(y.data,1));
prior.nclusters_neg = zeros(1,size(y.data,1));
prior.m = [];
prior.W = [];
prior.W0 = 0.002*eye(nfeatures);
prior.v0 = nfeatures+2;
prior.b0 = 1;
prior.b = [];
prior.v = [];
prior.c = [];
prior.alpha = [];
end