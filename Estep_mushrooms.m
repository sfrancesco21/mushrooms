function posterior = Estep_mushrooms(y,prior,posterior,window,t,ispost)      
% E step in EM algorithm. Estimates cluster reposnsibilities
% 
% Inputs:
%     -y : stimuli
%     -prior : beliefs about distributions
%     -posterior : current posteriors
%     -window : trials in working memory
%     -t : current trial
%     -ispost : if 1, this happens after feedback (i.e. label is known)
% Outputs:
%     -posterior ; updated posterior to be used in M step

nf = size(y.data,2)-1;
resp = zeros(1,prior.nclusters);

for w = window    
    for c = 1:prior.nclusters  
        lnpi = psi(posterior.alpha(t,c))-psi(sum(posterior.alpha(t,:)));
        lnlambda = sum(psi((posterior.v(t,c)+1-(1:nf)))+nf*log(2)+log(eps+det(posterior.W{c})));
        ln_rho = lnpi+0.5*lnlambda-nf/(2*posterior.b(t,c))-(posterior.v(t,c)/2).* ...
            (y.data(w,1:end-1)-posterior.m{c}(t,:))*posterior.W{c}* ...
            (y.data(w,1:end-1)-posterior.m{c}(t,:))';
        resp(c) = exp(ln_rho);
    end
    if ispost || w<t 
        resp(prior.cat~=y.data(w,end))=0;
    end
    posterior.resp(w,:) = resp/sum(resp);
    
end
end