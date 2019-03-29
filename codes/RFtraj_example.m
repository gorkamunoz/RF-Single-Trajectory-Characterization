% This program introduces an example of the algorithm presented in the 
% paper: 
% https://arxiv.org/abs/1903.02850
% The goal is to use a Random Forest to characterize the diffusion of a
% particle by means of three features: the theoretical model that better
% describes it, if the particle is anomalous or normal diffusing and its
% anomalous exponent. In this example, we will use simulated trajectories
% to benchmark the method. It means that the same kind of simulated dataset 
% will be used to train and test the RF. This corresponds to what is 
% exposed in Section II of the paper.
% For inquiries, you can write to: gorka.munoz@icfo.eu

% Warnings:
% Please take care on the path

%% Parameters
% Time length of the trajectories
t_max = 1e3;
% Number of trajectories considered in the dataset
num_traj = 1e4;
% Theoretical models included in the training set
processes = {'ctrw'};
% Range of anomalous exponent to consider
alpha_range = 0.2:.2:1;
% Ratio between training and test set.
ratio_tT = 0.8;
% The following variable controls which kind of classificationt problem we
% create. You can choose between discriminate over processes (0), between
% normal and anomalous trajectories (1) and between values of the anomalous
% exponent (2)
proc_expo = 2;
% Ratio Anomalous/Normal trajectory. You should take care on having always
% a balanced number of trajectories per class. As a rule of thumb, for
% process discrimination and exponent characterization, you should have the
% same number of trajectories for each alpha. For anom vs. normal, you
% should have 1/2 in anomalous and 1/2 in normal.
if proc_expo == 1
    ratio_aN = 0.5;
else
    ratio_aN = 1/numel(alpha_range);
end
% Size of the window from which we calculate the displacement in the
% preprocessing. If T_lag = 0, we consider the trajectory without preprocess
T_lag = 0;
% Path where the simulated trajectories will be stored
path_trajectories = '~/MLtraj_data/trajs/';

%% Create the dataset
% We create two sets: i) the training set (X_a, Y_a), which we will use to
% train the ML model ii) the test set (X_e, Y_e) which will be used to test
% the accuracy of the model. 
sprintf('Creating the training dataset...')
[X_a, Y_a, X_e, Y_e] = create_training_set(num_traj, alpha_range, t_max, ratio_aN, processes, proc_expo, T_lag, ratio_tT, path_trajectories);

%% Train the Random Forest algorithm
% We use in this case the Treebagger function contained in the ML toolbox
% of Matlab
% If you have acces to parallel computing, uncomment following line:
% paroptions = statset('UseParallel',true);
% Then add to the TreeBagger function: 'Options', paroptions
sprintf('Training...')
tic
CT = TreeBagger(100, X_a, Y_a, 'OOBPrediction','On','Method','classification');
sprintf('Training has taken %0.2f secs.', toc)

%% Benchmarking the model with the test set
% Predict new instances
y_pred = predict(CT, X_e);
% Changes format of the predictions and correct labels
y_p = str2double(y_pred);
y_e = str2double(Y_e);

% Depending on the kind of classification problem we are in, different
% explorations of the results will be made. We will follow the structue of
% our paper and start with process discrimination:

if proc_expo == 0
    % We will use the confusion matrix from Matlab to explore the results
    % of this class. problem
    C = confusionmat(y_e, y_p);
    % The number of classes of this problem will depend on the number of
    % processes considered. In the present example, only two processes are
    % considered, so the accuracy of the model can be calculated as
    accuracy = (C(1)+C(4))/numel(y_p);
    
    sprintf('The accuracy of the process discriminating RF algorithm is %.2f', accuracy)    

elseif proc_expo == 1
    % This is a binary problem so we can use the Matlab confusion matrix to
    % check the results:
    C = confusionmat(y_e, y_p);
    accuracy = (C(1)+C(4))/numel(y_p);
    
    sprintf('The accuracy of the anomalous vs normal classification RF algorithm is %.2f.', accuracy)
    
elseif proc_expo == 2
    % In this case, we are interested in the mean square error (MSE) of the
    % predictions.     
    MSE = immse(y_e, y_p);     
    % We will also create a figure where we show an histogram
    % of the error made in the exponent prediction. See the paper for
    % details. First, we calculate the error for each trajectory
    error_prediction = round(abs(y_p-y_e), 1); 
    % The rounding is only included to solve a Matlab bug when calculating
    % the unique function used later. Let's now do an histogram of the errors
    hist_error = histcounts(error_prediction, numel(unique(error_prediction)))./numel(error_prediction);
    % Last, we plot the results
    bar(unique(error_prediction), hist_error);
end



    