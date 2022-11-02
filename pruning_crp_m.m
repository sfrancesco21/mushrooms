function [prior,posterior,temp_posterior,toss] = ...
    pruning_crp_m(prior,posterior,temp_posterior,t)
% Function for pruning unnecessary clusters
%
% Inputs:
%     -prior : beliefs about distributions
%     -posterior : non-updated posteriors
%     -temp_posterior : posteriors containing updated responsibilities
%     -t : current trial
% Outputs:
%     -prior : updated prior
%     -posterior : updated posterior (only number of clusters)
%     -temp_posterior : updated temporary posterior (only number of clusters)
%     -toss : clusters to be pruned

assignments = zeros(t,prior.nclusters);

%Assing stimuli to clusters with highest responsibilities
for j = 1:t
    assignments(j,temp_posterior.resp(j,:)==max(temp_posterior.resp(j,:)))=1;
end

empty = find(sum(assignments,1)==0); %clusters with no items assigned to them
post_c = sum(temp_posterior.resp,1)/sum(sum(temp_posterior.resp)); 
obsolete = find(post_c<0.02); %clusters with very low mixing component
keep = setdiff(1:prior.nclusters,[empty obsolete]);
toss = setdiff(1:prior.nclusters,keep);

prior.nclusters = length(keep);
prior.cluster_birth = prior.cluster_birth(keep);
prior.c = prior.c(:,keep);
prior.alpha = prior.alpha(:,keep);
prior.b = prior.b(:,keep);
prior.v = prior.v(:,keep);
prior.cat = prior.cat(keep);
prior.m(toss) = [];
prior.W(toss) = [];

posterior.c = posterior.c(:,keep);
posterior.resp = posterior.resp(:,keep);
posterior.m(toss) = [];
posterior.W(toss) = [];
posterior.alpha = posterior.alpha(:,keep);
posterior.b = posterior.b(:,keep);
posterior.v = posterior.v(:,keep);

temp_posterior.c = temp_posterior.c(:,keep);
temp_posterior.resp = temp_posterior.resp(:,keep);
temp_posterior.m(toss) = [];
temp_posterior.W(toss) = [];
temp_posterior.alpha = temp_posterior.alpha(:,keep);
temp_posterior.b = temp_posterior.b(:,keep);
temp_posterior.v = temp_posterior.v(:,keep);

end
