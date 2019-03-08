# RF-Single-Trajectory-Characterization
This repository contains an example of the implementation of a Random Forest algorithm for the characterisation of trajectory arising from diffusion processes, as proposed in our paper ['Machine learning method for single trajectory characterization](https://arxiv.org/abs/1903.02850).

The example covers what is shown in *Section II - Trajectory characterization as a classification problem* of the paper. The method is initialized from the file 'RFtraj_example.m'. Here is a brief description of each function used:
- RFtraj_example.m : main part of the program. The diferent parameters are declared here.
- create_training_set.m : creates a training and test set with the given hyperparameters.
- load_fbm: loads a dataset of fractional brownian motion (fbm) trajectories.
- fbm_trajectories: simulates fbm trajectories and creates a dataset.
- load_ctrw: loads a dataset of continuous time random walk (ctrw) trajectories.
- ctrw_trajectories: simulates ctrw trajectories and creates a dataset.
- create_dataset_displacements: launches the preprocessing procedure described in the paper to create a dataset of normalized trajectories.
- calculate_preprocessing: normalizes a trajectory by means of its displacements.

