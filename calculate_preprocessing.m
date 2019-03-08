function displacements = calculate_preprocessing(traj, T_lag)
% Preprocess a trajectory by performing three steps:
%       1- Calculates the displacement in a certain T_lag
%       2- Calculates the standard deviation of displacements and divides the vector by it.
%       3- Recreates the normalized trajectory using cumsum
% 
% Inputs: - traj: trajectory to be processed
%         - T_lag: size of the window the displacement will be calculated on.
% 
% For details check <a href="matlab: web('https://arxiv.org/abs/1903.02850')">our paper</a>.

% If T_lag = 0, we return the raw trajectory
if T_lag == 0
    displacements = traj;
    return
end

%% 1 - Calculate displacements
if T_lag == 1 
    displacements = diff(traj);
else    
    ini = 1;
    fin = T_lag;
    c = 0;
    displacements = zeros(1,numel(1:T_lag:numel(traj)));
    while fin<=numel(traj)
        c = c + 1;
        displacements(c)=traj(fin)-traj(ini);
        ini = ini + (T_lag-1);
        fin = fin + (T_lag-1);
    end
end

%% 2 - Calculate STF and normalize 
displacements = round(displacements./std(displacements));

%% 3 - Recreates the normalized trajectory using cumsum
displacements = cumsum(displacements);

    
end



