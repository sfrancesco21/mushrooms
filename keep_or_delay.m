function [keep,delay] = keep_or_delay(y,prior,window,h)
% Function to decide which items to keep in working memory. 
%
% Inputs:
%     -y : stimuli
%     -prior : beliefs about distributions
%     -window : items in working memory
%     -h : entropy of responsibilities for items in working memory
% Outputs:
%     -keep: items to perform inference on and the forget
%     -delay : items to hold in working memory for at least another trial

delta = prior.delta; %entropy threshold, will be a large negative number in fixed-window agents
keep = window(h<delta);
delay = window(h>=delta);
t = window(end); 

if t==size(y.data,1) %Use all stimuli if this is the last trial
    keep = window;
    delay = [];
elseif ~isempty(delay) 
    while min(delay)<t-prior.w+2 % Use oldest memory if exceeding working memory capacity
        keep = [delay(1) keep];
        delay = delay(2:end);
    end
end

end
