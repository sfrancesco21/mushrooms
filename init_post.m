function posterior = init_post(prior,posterior,t)
% Initilises posterior variable for current trial inference
% 
% Inputs:
%     -prior : beliefs about stimuli distributions
%     -posterior : posterior, to be initialised according to prior
%     -t : current trial
% Output:
%     -posterior : initialised posterior

posterior.alpha(t,:) = prior.alpha(t,:);
posterior.b(t,:) = prior.b(t,:);
posterior.v(t,:) = prior.v(t,:);
posterior.c(t,:) = prior.c(t,:);

for c = 1:prior.nclusters
posterior.m{c}(t,:) = prior.m{c}(t,:);
posterior.W{c} = prior.W{c};
end

end