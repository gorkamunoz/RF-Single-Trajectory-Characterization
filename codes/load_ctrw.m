function data = load_ctrw(num_traj, alpha_range, t_max, ratio_aN, path_trajectories)
% Creates a dataset of CTRW trajectories with the given variables
%
% Inputs: - num_traj = number of trajectories contained in the dataset
%         - alpha_range = range of anomalous exponents to consider
%         - t_max = time lengths of the trajectories
%         - ration_aN = ratio between anomalous and normal diffusing trajectories
%
%         
% Outputs: - data = dataset of CTRW of size num_traj x (t_max+1)
%
% For details check <a href="matlab: web('https://arxiv.org/abs/1903.02850')">our paper</a>.

if t_max > 1e3
    error('The value chosen for t_max is too big. The trajectories considered in this example only allow for t_max < 1e3.')
end

%% First, we define the number of trajectories per alpha given the ratio_aN
c_a = 0; num_alpha = zeros(1, numel(alpha_range));
% CTRW is subdiffusive, then superdiffusive exponents do not need to be
% taken into account
alpha_range = alpha_range(alpha_range <= 1);
if numel(alpha_range)>1 % if we have more than one exponent
    for alpha = alpha_range
        c_a = c_a + 1;
        if round(alpha, 1) == 1
            num_alpha(c_a) = ceil(num_traj*ratio_aN);
        else
            num_alpha(c_a) = ceil(num_traj*(1-ratio_aN)/(numel(alpha_range)-1));
        end
        if num_alpha(c_a) > 1e5
            error('The dataset you asked for is too big, decrease the number of trajectories. The current example only allows for num_traj<1e5.')
        end
    end
else
    num_alpha = num_traj;
end

%% Now we create the dataset
c_a = 0; data = [];
for alpha = alpha_range    
    c_a = c_a + 1;
    
    % Name of the file containing the dataset of trajectories
    file_name = [path_trajectories 'ctrw_alpha_' sprintf('%0.2f', alpha) '.mat'];

    % If the dataset for given alpha does not exist, we create a new one.
    % As a default, the datasets are created with t_max = 1e3 and contain
    % 1e5 trajectories
    if exist(file_name, 'file') ~= 2        
        ctrw_trajectories(alpha, file_name);        
    end
    % We load the trajectory dataset
    L = load(file_name);
    data_alpha = L.dataset;
    % We truncate the dataset depending on the number of trajectories
    % desired and t_max.
    data_alpha = data_alpha(1:(num_alpha(c_a)), 1:t_max+1);

    data = vertcat(data, data_alpha);  
end
% To prevent extra trajectories entering the dataset due to poor rounding
% when choosing number of trajectories per alpha we truncate it to the
% exact value desired:
data = data(1:num_traj, :);