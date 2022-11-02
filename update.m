function tprior = update(prior,posterior,t)
% Function for belief update with all available information
%
% Inputs:
%     -prior : beliefs about distributions
%     -posterior : posteriors using all stimuli in cognitive window
%     -t : current trial
% Outputs:
%     -tprior : updated prior with all stimuli in working memory

tprior = prior;

tprior.alpha(t+1,:) = posterior.alpha(t,:);
tprior.c(t+1,:) = tprior.alpha(t+1,:)/sum(tprior.alpha(t+1,:));
tprior.b(t+1,:) = posterior.b(t,:);
tprior.v(t+1,:) = posterior.v(t,:);

for c = 1:prior.nclusters
    tprior.m{c}(t+1,:) = posterior.m{c}(t,:);
    tprior.W{c} = posterior.W{c};
end

end