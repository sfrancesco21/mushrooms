function posterior = Mstep(y,prior,posterior,window,t)
% M step in EM algorithm. Estimates posterior stimuli distributions
% 
% Inputs:
%     -y : stimuli
%     -prior : beliefs about distributions
%     -posterior : current posteriors
%     -window : trials in working memory
%     -t : current trial
% Outputs:
%     -posterior ; updated posterior to be used in E step

posterior.b(t,:) = prior.b(t,:)+sum(posterior.resp(window,:),1);
posterior.v(t,:) = prior.v(t,:)+sum(posterior.resp(window,:),1);
posterior.alpha(t,:) = prior.alpha(t,:)+sum(posterior.resp(window,:),1);
posterior.c(t,:) = posterior.alpha(t,:)/sum(posterior.alpha(t,:));

for c = 1:prior.nclusters
sumresp = sum(posterior.resp(window,c));
x_hat = (1./(sumresp+eps)).* ...
    sum(posterior.resp(window,c).*y.data(window,1:end-1),1);

serr = 0;
for w = window
    serr = serr + posterior.resp(w,c).*(y.data(w,1:end-1)-x_hat)'*(y.data(w,1:end-1)-x_hat);
end
S = (1./(sumresp+eps)).*serr;
posterior.m{c}(t,:) = (sumresp.*x_hat+ ...
    prior.b(t,c).*prior.m{c}(t,:))./posterior.b(t,c); 
invW = inv(prior.W{c})+sumresp.*S+((prior.b(t,c).*sumresp)./(prior.b(t,c)+sumresp+eps)) ...
    .*(x_hat-prior.m{c}(t,:))'*(x_hat-prior.m{c}(t,:));
posterior.W{c} = inv(invW);
end
end