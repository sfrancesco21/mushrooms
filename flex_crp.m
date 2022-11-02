function [prior,posterior,trialinfo] = flex_crp(y,prior)
% Simulation of the task with a non-parametric variational Gaussian Mixture
% Model incorporating a working memory component
%
% Inputs:
%     -y: stimuli
%     -prior: initial priors
% Outputs:
%     -prior: updated priors (i.e. beliefs about stimuli distributions)
%     -posterior: posteriors and behaviour info
%     -trialinfo: info about individual trials

%Initialise matrices
trialinfo.surprise = zeros(1,size(y.data,1)); %surprise when presented a stimulus
trialinfo.KL = zeros(1,size(y.data,1)); %KL divergence between prior and posterior distributions
trialinfo.KLr = zeros(1,size(y.data,1)); %KL divergence between cluster responsibilities before and after feedback
trialinfo.cost = zeros(1,size(y.data,1)); %Memory cost
temp_prior = prior; %temporary prior (for retrospective inference)
posterior = makepost_mushrooms(y); %initialise posterior
delay = []; %initilise wm component 

for t = 1:size(y.data,1)

    if t>1 %the agent starts with no clusters, so skip trial 1
        trialinfo.surprise(t) = Shannon(y,temp_prior,t); %negative log probability
    end

    window = [delay t]; %add current stimulus to working memory
    trialinfo.cost(t) = length(window);
    prior_start = prior;
    [prior,posterior] = newcluster_w(y,prior,posterior,t); %form new candidate cluster
    posterior = init_post(prior,posterior,t); %initilaise posterior for current trial
    temp_posterior = posterior; %temporary posterior (see temp_prior)

    % decision
    r = inference(y,prior,temp_posterior,window,t); %cluster responsibilities estimation
    if t>1
        trialinfo.KLr(t) = KLdiv_resp(prior.c(t,:),r); %KL divergence between prior and posteiror responsibilities
    end
    posterior.correct(t) = (sum(r(prior.cat==y.data(t,end)))+0.5*r(end))/sum(r); %probability associated with correct label

    % update after feedback
    prior.cat = [prior.cat y.data(t,end)]; %label of new cluster
    [prior,posterior,temp_posterior] = after_feedback(y,prior,posterior,window,t); %update after feedback
    tprior = update(prior,temp_posterior,t); %belief update (using all items in window)
    temp_prior = tprior; 
    h = entropy_discrete(temp_posterior.resp(window,:)); %entropy of responsibilities 
    [keep,delay] = keep_or_delay(y,prior,window,h); %decide what items to keep in working memory

    if ~isempty(keep) %if there are stimuli to use and then forget
        posterior.resp(keep,:) = temp_posterior.resp(keep,:);
        posterior = Mstep(y,prior,posterior,keep,t); %Final distribution update
        if t>1
            trialinfo.KL(t) = KLdiv(prior_start,posterior,t); %KL divergence between beliefs before and after trial t
        end
        tprior = update(prior,posterior,t); %belief update (using only items to be forgotten)
        prior = tprior; 
    else
        [prior,posterior] = wait(prior,posterior,t); %If there is no item to be forgotten, keep everything as is
    end
    prior.nclusters_pos(t) = length(find(prior.cat==1));
    prior.nclusters_neg(t) = length(find(prior.cat==2));
end
end