% Code for running the mushroom picking task simulation.
% The simulated agents are presented with a series of stimuli (mushrooms) and 
% have to decide whether to pick them or not. There are different species of
% mushrooms (clusters), some of which are edible and some of which are
% poisonous. 

clear

% settings for stimuli generation
mushrooms.nfeatures = 1; % dimensionality of the stimuli
mushrooms.means = [40;80;60;20]; % cluster means (must be consistent with dimensionality)
mushrooms.n = [10 5 10 5]; % number of stimuli to be sampled from each cluster
mushrooms.cat = [1 1 2 2]; % cluster label (i.e. is this an edible mushroom species?)
mushrooms.sigma = 9^2; % cluster variance (here common to all clusters, change into covariance matrix for multi-dimensional stimuli)

nsim = 1000; % number of simulations to run
max_wm = 7; % maximum number of stimuli the agent can hold in working memory
ncl_fix = [2 4]; % number of clusters if the agent does not perform structure learning

%set empty matrices. The '_fix' extension indicates parametric agents not 
%performing structure learning (i.e. number of clusters is fixed); the
%'_h' extension indicates agents with an entropy-based cognitive window
%(not discussed in the paper); no extension indicates agents with a
%fixed-length congitive window (performing fixed-lag smoothing).

% log likelihhod of correct answer (summed over trials)
sumloglik = zeros(nsim,max_wm); 
sumloglik_fix = zeros(nsim,length(ncl_fix)); 
sumloglik_h = zeros(nsim,max_wm); 
% number of estimated clusters after the end of the task
nclusters = zeros(nsim,max_wm); 
nclusters_fix = zeros(nsim,length(ncl_fix)); 
nclusters_h = zeros(nsim,max_wm); 
% surprise 
surprise = zeros(nsim,max_wm);
surprise_fix = zeros(nsim,length(ncl_fix));
surprise_h = zeros(nsim,max_wm);
% correlation between Shannon and Bayesian surprise
KL_sur = zeros(nsim,max_wm);
KL_sur_fix = zeros(nsim,length(ncl_fix));
KL_sur_h = zeros(nsim,max_wm);
% total 'memory cost' 
tot_cost = zeros(nsim,max_wm);
tot_cost_h = zeros(nsim,max_wm);

%simulation oprions
do_fix = 1; % 1 to simulate parametric agent, 0 otherwise
do_h = 1; %1 to simulate agent with entropy-based window, 0 otherwise

%simulate
for j = 1:nsim
    
    % Sample stimuli
    y = make_mushrooms(mushrooms);
  
    for w = 1:7
        
        %Non-parametric + fixed-window retrospective inference
        
        %set initial priors
        prior = set_hyperpriors_crp(mushrooms.nfeatures,y);
        prior.w = w; %working memory capacity
        prior.alpha0 = 0.5; % CRP hyperparameter
        prior.delta = -222; %Large negative number to make the agent retain in memory as many stimuli as possible
        
        % simulate task
        [prior,posterior,trialinfo] = flex_crp(y,prior); %simulate the task
        surprise(j,w) = mean(trialinfo.surprise); %average surprise
        KL_sur(j,w) = corr(trialinfo.KL(w+1:end)',trialinfo.surprise(w+1:end)'); %correlation between Bayesian and Shannon surprise
        sumloglik(j,w) = sum(log(posterior.correct)); % Performance metric
        nclusters(j,w) = prior.nclusters; %number of clusters
        tot_cost(j,w) = sum(trialinfo.cost); %memory cost

        %Non-parametric + entropy-based retrospective inference
        if do_h == 1
            
            %set initial priors
            prior = set_hyperpriors_crp(mushrooms.nfeatures,y);
            prior.w = w; % working memory capacity
            prior.alpha0 = 0.5; 
            prior.delta = 0.1; % entropy threshold
            
            % simulate task, same as above
            [prior,posterior,trialinfo] = flex_crp(y,prior);
            surprise_h(j,w) = mean(trialinfo.surprise);
            KL_sur_h(j,w) = corr(trialinfo.KL(w+1:end)',trialinfo.surprise(w+1:end)');
            sumloglik_h(j,w) = sum(log(posterior.correct));
            nclusters_h(j,w) = prior.nclusters;
            tot_cost_h(j,w) = sum(trialinfo.cost);
        end
    end
    
    if do_fix == 1
        
        cat_all = [1 2 1 2]; %Labels are predetermined
        counter = 0;
        %parametric agents
        for ncl = ncl_fix

            counter = counter + 1;
            cat = cat_all(1:ncl); %get only the labels you need
            means = unifrnd(0,100,1,ncl); %randomise cluster prior means
            
            %set initial priors
            prior = set_hyperpriors_fix(y,mushrooms.nfeatures,ncl,cat,means);
            prior.w = 1; % Fully online learning only
            prior.delta = -222; % irrelevant as working memory capacity is 1
            
            %simulate task, see above
            [prior,posterior,trialinfo] = flex_fixcl(y,prior); %simulate with parametric model
            surprise_fix(j,counter) = mean(trialinfo.surprise);
            KL_sur_fix(j,counter) = corr(trialinfo.KL(prior.w+1:end)',trialinfo.surprise(prior.w+1:end)');
            sumloglik_fix(j,counter) = sum(log(posterior.correct));
            nclusters_fix(j,counter) = prior.nclusters;

        end
    end
end
