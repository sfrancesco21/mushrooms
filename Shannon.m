function surprise = Shannon(y,prior,t)
% Information-theoretic surprise (negative log probability)
% 
% Inputs:
%     -y : stimuli
%     -prior : beliefs about stimuli distributions
%     -t : current trial
% Output:
%     -surprise : -log(p(y(t) | prior)

nf = size(y.data,2)-1;
p = zeros(size(prior.c,2),1);
for c = 1:size(prior.c,2)
    logp = log(eps+prior.c(t,c))+...
        sum(log(eps+mvnpdf(y.data(t,1:end-1),prior.m{c}(t,:),inv((prior.v(t,c)-nf-1)*prior.W{c}))));
    p(c) = exp(logp);
   
end
surprise = -log(sum(p));
end