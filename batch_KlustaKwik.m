
Dir = 'E:\DATA Electrophysiology\';
srcDirectory = uigetdir(Dir, 'Select the recording session you want to proces');

folders = dir([srcDirectory '\channels*'] ); folders = {folders.name};
% folders = {'\channels 01-07' '\channels 06-12' '\channels 11-17' '\channels 16-22' '\channels 21-27' '\channels 26-32'};
% folders = {'\channels 01-07'  '\channels 11-17' '\channels 21-27' };

job = batch('KlustaKwik', 'CurrentFolder', srcDirectory, 'CaptureDiary', true);

% wait(job);   % Wait for the job to finish
% diary(job)   % Display the diary
% delete(job)