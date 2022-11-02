function KL = KLdiv(prior,posterior,t)
%sampling approximation approximation of KL(prior||posterior)
%
% Inputs:
%     -prior: priors about distribution (pre-stimulus presentation)
%     -posterior: posterior obtained with items to be forgotten
%     -t : current trial
% Outputs :
%     -KL: approximated KL divergence

nf = size(prior.m{1},2);
p_prior = 0;
p_posterior = 0;

samples = [0.1:0.1:100]';
for c = 1:prior.nclusters
    p_prior = p_prior + prior.c(t,c)*...
        mvnpdf(samples,prior.m{c}(t,:),inv((prior.v(t,c)-nf-1)*prior.W{c}));
    end
    for c = 1:size(posterior.alpha,2)
        p_posterior = p_posterior + posterior.c(t,c)*...
            mvnpdf(samples,posterior.m{c}(t,:),inv((posterior.v(t,c)-nf-1)*posterior.W{c}));
    end
    KL = sum(p_prior.*(log(p_prior+eps)-log(p_posterior+eps)));
end