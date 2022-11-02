function r = inference(y,prior,posterior,window,t)
% Cluster responsibilities estimation
%
% Inputs: 
%     -y : stimuli
%     -prior : beliefs about distributions
%     -posterior : initialised posteriors
%     -window : trials in working memory
%     -t : current trial
free_en = 1;
free_en_old = 0;

%Loop until Variational Free Energy converges (6 decimal places)

while round(free_en,6)~=round(free_en_old,6)
     free_en_old = free_en;
     posterior = Estep_mushrooms(y,prior,posterior,window,t,0); % E step        
     posterior = Mstep(y,prior,posterior,window,t); % M step
     free_en = free_energy(y,prior,posterior,window,t); %calculate VFE
end
 r = posterior.resp(t,:);

end
