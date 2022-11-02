function h = entropy_discrete(distr)
% entropy of categorical distribution
%
% Inputs:
%     -distr : distribution
% Outputs:
%     -h: entropy
%
h = -sum(distr.*log(eps+distr),2);

end