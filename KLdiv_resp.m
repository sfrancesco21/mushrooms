function KL = KLdiv_resp(c,resp)
% KL divergence between two categorical distributions
% 
% Inputs:
%      -c: prior over clusters
%      -resp: estimated responsibilities
% Output:
%      -KL : KL divergence
%
KL = sum(c.*(log(c+eps)-log(resp+eps)));

end