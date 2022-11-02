function [prior,posterior] = wait(prior,posterior,t)
% keep beliefs as they are if there is not item to be forgotten
%
% Inputs:
%     -prior : prior beliefs about distributions
%     -posterior : history of posteriors/actions
%     -t : current trial
% Outputs:
%     -prior : prior beliefs about distributions
%     -posterior : history of posteriors/actions

prior.alpha(t+1,:) = prior.alpha(t,:);
prior.b(t+1,:) = prior.b(t,:);
prior.v(t+1,:) = prior.v(t,:);

for c = 1:prior.nclusters
    prior.m{c}(t+1,:) = prior.m{c}(t,:);
end

end

