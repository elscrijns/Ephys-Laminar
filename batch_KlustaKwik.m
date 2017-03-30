
% Select the source directory (1 recording session) which contains the channels folders for clustering
Dir = 'E:\DATA Electrophysiology\';
srcDirectory = uigetdir(Dir, 'Select the recording session you want to proces');

% Define the subfolders in which clustering should be performed
folders = dir([srcDirectory '\channels*'] ); folders = {folders.name};
% folders = {'\channels 01-07' '\channels 06-12' '\channels 11-17' '\channels 16-22' '\channels 21-27' '\channels 26-32'};

% Send the KlustaKwik script to the worker
job = batch('KlustaKwik', 'CurrentFolder', srcDirectory, 'CaptureDiary', true);
% Clustering is performed in python for each subfolder.
% The Klusta-suite has to be installed

% wait(job);   % Wait for the job to finish
% diary(job)   % Display the diary
% delete(job)
