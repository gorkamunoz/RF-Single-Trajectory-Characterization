function  ctrw_trajectories(alpha, file_name)
% This function creates a dataset of trajectories simulated via CTRW
% INPUTS: - file_name: name of the file where we create the dataset
%         - alpha: value of the anomalous exponent
% OUTPUTS: - saves the dataset.
% For details check <a href="matlab: web('https://arxiv.org/abs/1903.02850')">our paper</a>.


sprintf('Creating CTRW dataset for alpha = %0.2f', alpha)
t_max = 1e3; num_traj = 1e5;

%% Launching parallel

tic
dataset = zeros(num_traj+8, t_max+1); % This variable will contain the dataset of CTRW trajectories

for i1 = 1:num_traj
    
    %% Creating a CTRW trajectory
    pos = 0; % Position of the particle
    time = 0; % Vector keeping track of time
    count = 2; % keeps trackt of the number of times the while loop is done
        
    % Evolution of a CTRW   
    cumulative_t = 0;
    while cumulative_t < t_max
        
        if rand > 0.5
            pos(count) = pos(count-1) + 1;
        else
            pos(count) = pos(count-1) - 1;
        end
        % We retrieve a random waiting time from the distribution 
        % P(t) = (alpha-1)t^(-alpha-1)  
        t_i = (1-rand)^(-1/alpha);        
        time(count) = time(count-1)+t_i;  
        cumulative_t = cumulative_t+t_i;
        
        count = count+1;
        
    end
    
    % Regularizing time    
    t_r = 1:t_max;    
    pos_r = zeros(1,numel(t_r));
    
    for l = 1:t_r(end)        
        idx = find(time > t_r(l), 1);        
        pos_r(l)=pos(idx-1); % position of the rabbit in regular time        
    end        
    
    % Saving the trajectory in the dataset    
    dataset(i1,:) = [alpha pos_r];
    
end

sprintf('Time taken to create the dataset: %0.2f secs.', toc)
dataset = dataset(1:num_traj,:);
save(file_name,'dataset');




