function displacements_dataset = create_dataset_displacements(data, T_lag, num_samples)
% This function loads the trajectories created with previous programs and
% calculates the number of steps done by the particle at a window of time
% of size Wsize.
%
% INPUT: - data: dataset of trajectories
%        - T_lag = size of the window from which we calculate the displacement
%        - num_samples: number of trajectories in the output vector
%
% OUTPUT: - disp_dataset: dataset composed of num_samples rows and 3 columns.
%                         The first column gives the process, the second the 
%                         anomalous exponent and the third the processed trajectory.      
%
% For details check <a href="matlab: web('https://arxiv.org/abs/1903.02850')">our paper</a>.



displacements_dataset = cell(num_samples, 3); % This variable will contain the dataset


process = data(:, 1); % Contains the processes of the trajectories
alphas = data(:, 2); % Contains the exponent of the trajectories
data = data(:, 3:end); % Contains the trajectories

for i1 = 1:num_samples      
    % We calculate the preprocessing for each trajectory
    jj = calculate_preprocessing(data(i1,:), T_lag);
    % We change the exponents in the desired format for the decision trees
    % function
    alp = cellstr(num2str(alphas(i1)));
    % We put everything together
    displacements_dataset(i1,:) = [process(i1) alp jj];    
    
end
end

    
    



