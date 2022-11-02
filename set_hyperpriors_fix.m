function prior = set_hyperpriors_fix(y,nfeatures,ncl,cat,means)
% set Gaussian Mixture Model (GMM) priors with fixed number of components
% 
% Inputs:
%     -y : stimuli
%     -nfeatures : dimensionality of the stimuli
%     -ncl : number of clusters (Gaussian components) 
%     -cat : labels
%     -means : initial cluster means 
% Output: 
%     -prior : initial priors

prior.w = 1; %online learning
prior.cat = cat;
prior.nclusters = ncl;
prior.delta = 0.7; %made irrelevant by prior.w
for c = 1:prior.nclusters
prior.m{c} = means(c).*ones(size(y.data,1),1);
prior.W{c} = 8e-4*eye(nfeatures);
end
prior.v = nfeatures+2.*ones(size(y.data,1),prior.nclusters);
prior.b = 1.*ones(size(y.data,1),prior.nclusters);
prior.c = ones(size(y.data,1),prior.nclusters)/prior.nclusters;
prior.alpha = 0.5.*ones(size(y.data,1),prior.nclusters);
end