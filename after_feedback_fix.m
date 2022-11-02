function [prior,posterior,temp_posterior] = after_feedback_fix(y,prior,posterior,window,t)
% Update function after current label is learned for parametric models
% 
% Inputs:
%     -y : stimuli
%     -prior : beliefs about distributions
%     -posterior : current posteriors
%     -window : trials in working memory
%     -t : current trial
% Outputs:
%     -prior : updated prior
%     -posterior : updated posterior (only affected y pruning)
%     -temp_posterior : temporary posterior to update temporary prior 

     temp_posterior = posterior;
     free_en = 1;
     free_en_old = 0;
     while round(free_en,6)~=round(free_en_old,6)
         free_en_old = free_en;
         temp_posterior = Estep_mushrooms(y,prior,temp_posterior,window,t,1);             
         temp_posterior = Mstep(y,prior,temp_posterior,window,t);         
         free_en = free_energy(y,prior,temp_posterior,window,t);
     end
     
end