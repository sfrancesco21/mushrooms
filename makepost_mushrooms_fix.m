function posterior = makepost_mushrooms_fix(prior)
%Initialise posteriors for parametric agent. Values are initialised based
%on priors
%
% Input:
%     -y : stimuli
% Output:
%     -posterior : initialised posterior object

posterior.alpha = prior.alpha;
posterior.m = prior.m;
posterior.W = prior.W;
posterior.b = prior.b;
posterior.v = prior.v;
posterior.c = prior.c;
posterior.resp = zeros(size(prior.c));
posterior.choice = zeros(1,size(prior.c,1));
posterior.correct = zeros(1,size(prior.c,1));

end