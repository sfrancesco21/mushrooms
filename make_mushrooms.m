function y = make_mushrooms(mushrooms)
% Function to sample stimuli for a single simulation
%
% Input: 
%     -mushrooms : struct with the cahracteristics of the sampling distributions
% Outputs:
%     -y : shuffled stimuli


nf = mushrooms.nfeatures; % number of features
n = mushrooms.n; % number of stimuli to sample from each cluster
cat = mushrooms.cat; % labels
sigma = mushrooms.sigma; % variance or covariance matrix if nf > 1
means = mushrooms.means; %cluster means
y.data = [];

for m = 1:length(means)
    y.data = [y.data;[mvnrnd(means(m,:),sigma.*eye(nf),n(m)) cat(m)*ones(n(m),1)]];
end

y.data = y.data(randperm(size(y.data,1)),:);

end
