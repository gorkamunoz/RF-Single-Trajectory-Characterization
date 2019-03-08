function [X_a, Y_a, X_e, Y_e] = create_training_set(num_traj, alpha_range, t_max, ratio_aN, processes, proc_expo, T_lag, ratio_tT, path_trajectories)
% Creates a training and test set of trajectories. 
%
% Inputs: - num_traj = number of trajectories contained in the dataset
%         - alpha_range = range of anomalous exponents to consider
%         - t_max = time lengths of the trajectories
%         - ration_aN = ratio between anomalous and normal diffusing trajectories
%         - processes = processes to include in the dataset. In the
%                       following example, only FBM will be considered
%         - proc_expo = if proc_expo=0, the labels of the trajectories will 
%                       be the process they have been generated from. If
%                       proc_expo=1, the label tells if the trajectory is 
%                       normal or anomalous diffusing. If proc_expo=2, the
%                       label is the anomalous exponent.
%         - T_lag = size of the window from which we calculate the
%                   displacement
%         - ratio_tT = ratio between training and test set.
%         - path_trajectories = folder where simulated trajectories are stored.
%
%         
% Outputs: - X_a = trajectories of the training set
%          - Y_a = labels of the training set. 
%          - X_e = trajectories of the test set
%          - Y_e = labels of the test set.
%
% For details check <a href="matlab: web('https://arxiv.org/abs/1903.02850')">our paper</a>.

%% 1- Load the trajectories
% We load the trajectories from the different datasets we have create. For
% the current case, the trajectories should be placed in the following
% folder give by the variable path_trajectories.

dataset_training = []; % This variable will contain the training set
label = 0; % This variable takes record of how many processes are contained in the dataset

% If a certain process is contained in the variable 'processes', we include
% it in the dataset. The dataset will number of processes times num_traj
% rows and t_max+2 columns. The first column tells us from which processes
% is the trajectory coming and the second its anomalous exponent.
if ismember('fbm', processes)
    label = label + 1;
    sprintf('Loading FBM trajectories...')
    dataset_training = [dataset_training; [label*ones(num_traj,1) load_fbm(num_traj, alpha_range, t_max, ratio_aN, path_trajectories)]];
end
if ismember('ctrw', processes)
    label = label + 1;
    sprintf('Loading CTRW trajectories...')
    dataset_training = [dataset_training; [label*ones(num_traj,1) load_ctrw(num_traj, alpha_range, t_max, ratio_aN, path_trajectories)]];
end
% if ismember('lw_', processes)
%     label = label + 1;
%     dataset_training = [dataset_training; [label*ones(num_traj,1) dataset_lw(num_traj, alpha_range, t_max, ratio_aN)]];
% end

%% 2- Creating the displacements dataset
    
disp_dataset = create_dataset_displacements(dataset_training, T_lag, num_traj);

% We shuffle the rows of the dataset so the diferent classes are mixed
disp_dataset = disp_dataset(randperm(num_traj, num_traj),:);    
% We define X, the future input of the ML algorithm, as the trajectories
X = disp_dataset(:, 3);
X = cell2mat(X);
% The labels will be defined depending on the value of proc_expo
if proc_expo == 0
    Y = disp_dataset(:,1); % labels are processes
elseif proc_expo >= 1
    Y = disp_dataset(:,2); % labels are exponents
end
% We separate the train/test set with given ratio.
X_a = X(1:numel(Y)*ratio_tT, :); Y_a = Y(1:numel(Y)*ratio_tT); % train set
X_e = X(numel(Y)*ratio_tT+1:end, :); Y_e = Y(numel(Y)*ratio_tT+1:end); % test set

% We arrange the labels in the right format:
if proc_expo == 0 % Processes classification
    Y_a = cellstr(num2str(cell2mat(Y_a)));
    Y_e = cellstr(num2str(cell2mat(Y_e)));
elseif proc_expo == 1 % Anomalous vs Normal classification
    Y_a = str2double(Y_a);
    Y_a(Y_a ~= 1) = 0;
    Y_a = cellstr(num2str(Y_a));

    Y_e = str2double(Y_e);
    Y_e(Y_e ~= 1) = 0;
    Y_e = cellstr(num2str(Y_e));
elseif proc_expo == 2 % Anomalous exponen characterization
    % nothing needs to be done in this case.
end

end

