function [prior,posterior] = ...
        newcluster_w(y,prior,posterior,t)
% Create a new candidate cluster centered around current stimulus
% 
% Inputs:
%     -y : stimuli
%     -prior : beliefs about stimuli distributions
%     -posterior : posterior, to be updated
%     -t : current trial
% Output:
%     -prior : updated prior
%     -posterior : updated posterior

nf = size(y.data,2)-1;
prior.nclusters = prior.nclusters+1;

prior.cluster_birth = [prior.cluster_birth t];

prior.m{prior.nclusters} = y.data(t,1:end-1).*ones(size(y.data,1),nf);
prior.W{prior.nclusters} = prior.W0;

prior.alpha = [prior.alpha prior.alpha0*ones(size(y.data,1),1)];

prior.b = [prior.b prior.b0*ones(size(y.data,1),1)];

prior.v = [prior.v prior.v0*ones(size(y.data,1),1)];

prior.c = [prior.c zeros(size(y.data,1),1)];
prior.c(t,:) = prior.alpha(t,:)/sum(prior.alpha(t,:));

posterior.m{prior.nclusters} = zeros(size(y.data,1),nf);
posterior.W{prior.nclusters} = prior.W0;

posterior.resp = [posterior.resp zeros(size(y.data,1),1)];
posterior.c = [posterior.c zeros(size(y.data,1),1)];
posterior.alpha = [posterior.alpha zeros(size(y.data,1),1)];
posterior.b = [posterior.b zeros(size(y.data,1),1)];
posterior.v = [posterior.v zeros(size(y.data,1),1)];

end