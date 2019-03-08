function  fbm_trajectories(alpha, file_name)
% This function creates a dataset of trajectories simulated via CTRW
% INPUTS: - file_name: name of the file where we create the dataset
%         - alpha: value of the anomalous exponent
% OUTPUTS: - saves the dataset.
%
% For details check <a href="matlab: web('https://arxiv.org/abs/1903.02850')">our paper</a>.

compose(sprintf('Creating FBM dataset for alpha = %0.2f', alpha)+".\n"+"The dataset will be saved in the desired path."+"\n"+"This procedure will only happen once per alpha.")

% Default t_max and num_traj for the trajectory dataset.
t_max = 1e3; num_traj = 1e5; 
% We define the Hurst exponent of the FBM as alpha/2:
H = alpha*0.5; 

  
dataset = zeros(num_traj, t_max +1); % Variable containing the dataset
tic % To save the time
for i1 = 1:num_traj % Parfor may be introduced here depending on specs.           
            dataset(i1,:) = [alpha wfbm(H, t_max)];
end

% Save the dataset in the desire path
save(file_name,'dataset');

sprintf('Time taken to create the dataset: %0.2f secs.', toc)