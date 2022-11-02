function VFE = free_energy(y,prior,posterior,window,t)
% Calculates VFE on a mixture of Gaussians
% 
% Inputs:
%     -y : stimuli
%     -prior : beliefs about distributions
%     -posterior : current posteriors
%     -window : trials in working memory
%     -t : current trial
% Outputs:
%     -VFE : Variational Free Energy


nf = size(y.data,2)-1;
lnpi = psi(posterior.alpha(t,:))-psi(sum(posterior.alpha(t,:)));
lnlambda = zeros(1,prior.nclusters);
E_lnpy = zeros(1,prior.nclusters);
E_lnpz = zeros(1,prior.nclusters);
E_lnpml = zeros(1,prior.nclusters);
E_lnqz = zeros(1,prior.nclusters);
E_lnqml = zeros(1,prior.nclusters);
for c = 1:prior.nclusters  
    sumresp = sum(posterior.resp(window,c));
    x_hat = (1./(sumresp+eps)).* ...
       sum(posterior.resp(window,c).*y.data(window,1:end-1),1);
    serr = 0;
    for w = window
        serr = serr + posterior.resp(w,c).*(y.data(w,1:end-1)-x_hat)'*(y.data(w,1:end-1)-x_hat);
    end
    S = (1./(sumresp+eps)).*serr;   
    lnlambda(c) = sum(psi((posterior.v(t,c)+1-(1:nf)))+nf*log(2)+log(eps+det(posterior.W{c})));
    %use gammaln to avoid overflow
    lnphi = (prior.v(t,c)*nf/2)*log(2)+(nf*(nf-1)/4)*log(pi)+...
        sum(gammaln((prior.v(t,c)+1-(1:nf))/2));
    lnB = (-prior.v(t,c)/2)*log(eps+det(prior.W{c}))-lnphi;
    lnphi_post = (posterior.v(t,c)*nf/2)*log(2)+(nf*(nf-1)/4)*log(pi)+...
        sum(gammaln((posterior.v(t,c)+1-(1:nf))/2));
    lnBpost = (-posterior.v(t,c)/2)*log(eps+det(posterior.W{c}))-lnphi_post;    
    H = -lnBpost-0.5*(posterior.v(t,c)-nf-1)*lnlambda(c)+0.5*posterior.v(t,c)*nf;
    E_lnpy(c) = 0.5*sumresp.*(lnlambda(c)-nf/posterior.b(t,c)- ...
        posterior.v(t,c).*trace(S*posterior.W{c})- ...
        posterior.v(t,c).*(x_hat-posterior.m{c}(t,:))*posterior.W{c}*(x_hat-posterior.m{c}(t,:))' ...
        -nf*log(2*pi));
    E_lnpz(c) = sumresp.*lnpi(c);
    E_lnpml(c) = 0.5*(nf*log(eps+(prior.b(t,c)/(2*pi)))+lnlambda(c)-nf*prior.b(t,c)/posterior.b(t,c) ...
        -prior.b(t,c).*posterior.v(t,c).* ...
        (posterior.m{c}(t,:)-prior.m{c}(t,:))*posterior.W{c}*(posterior.m{c}(t,:)-prior.m{c}(t,:))') ...
        +lnB+0.5*(prior.v(t,c)-nf-1).*lnlambda(c)-0.5*posterior.v(t,c).*trace(prior.W{c}*posterior.W{c});
    E_lnqz(c) = sum(posterior.resp(window,c).*log(eps+posterior.resp(window,c)));
    E_lnqml(c) = 0.5*lnlambda(c)+0.5*nf*log(eps+(posterior.b(t,c)/(2*pi)))-(nf/2)-H;
end    
    E_lnpc = gammaln(sum(prior.alpha(t,:)))-sum(gammaln(prior.alpha(t,:)))...
        +sum((prior.alpha(t,:)-1).*lnpi);
    E_lnqc = sum((posterior.alpha(t,:)-1).*lnpi)+ ...
        gammaln(sum(posterior.alpha(t,:)))-sum(gammaln(posterior.alpha(t,:)));
    
VFE = sum(E_lnpy)+sum(E_lnpz)+sum(E_lnpml)+E_lnpc-sum(E_lnqz)-sum(E_lnqml)-E_lnqc;
if isnan(VFE)
    warning('something is wrong')
end
end

    