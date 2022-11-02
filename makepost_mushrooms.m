function posterior = makepost_mushrooms(y)
%Initialise posteriors for non-parametric agent
%
% Input:
%     -y : stimuli
% Output:
%     -posterior : initialised posterior object

posterior.alpha = [];
posterior.m = [];
posterior.W = [];
posterior.b = [];
posterior.v = [];
posterior.c = [];
posterior.resp = [];
posterior.choice = zeros(1,size(y.data,1));
posterior.correct = zeros(1,size(y.data,1));
posterior.bounds = [27.2 49.9 72.7]; %Depend on stimuli
posterior.cats = [2 1 2 1];
posterior.optimal = zeros(1,size(y.data,1));

end