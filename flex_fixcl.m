function [prior,posterior,trialinfo] = flex_fixcl(y,prior)
% Simulation of the task with a parametric variational Gaussian Mixture
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
temp_prior = prior; %temporary prior (for retrospective inference)
posterior = makepost_mushrooms_fix(prior); %initialise posterior object
delay = []; %initilise wm component 

for t = 1:size(y.data,1)

if t>1 % Skip trial 1 as clusters are initialised at random
    trialinfo.surprise(t) = Shannon(y,temp_prior,t); %negative log probability
end
window = [delay t]; %add current stimulus to working memory
posterior = init_post(prior,posterior,t); %initilaise posterior for current trial
temp_posterior = posterior; %temporary posterior (see temp_prior)

% decision
r = inference(y,prior,temp_posterior,window,t); %cluster responsibilities estimation
posterior.correct(t) = (sum(r(prior.cat==y.data(t,end))))/sum(r); %probability associated with correct label

% update after feedback
[prior,posterior,temp_posterior] = after_feedback_fix(y,prior,posterior,window,t); %update after feedback
tprior = update(prior,temp_posterior,t); %belief update (using all items in window)
temp_prior = tprior; 
h = entropy_discrete(temp_posterior.resp(window,:)); %entropy of responsibilities 
[keep,delay] = keep_or_delay(y,prior,window,h); %decide what items to keep in working memory
    
if ~isempty(keep) %if there are stimuli to use and then forget
    posterior.resp(keep,:) = temp_posterior.resp(keep,:); 
    posterior = Mstep(y,prior,posterior,keep,t); %Final distribution update
    if t>1
        trialinfo.KL(t) = KLdiv(prior,posterior,t); %KL divergence between beliefs before and after trial t
    end
    tprior = update(prior,posterior,t); %belief update (using only items to be forgotten)
    prior = tprior;
else
    [prior,posterior] = wait(prior,posterior,t); %If there is no item to be forgotten, keep everything as is
end

end
end