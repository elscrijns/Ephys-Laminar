%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Analysis of MU data %%%%
%
% All clusters within a group of recording channels are loaded and processed
%       output: MU datafile and PSTH can be saved (if relevant)
%
% For each individual cluster an initial PSTH can be generated to help
%       with selecting SUs in KlustaViewa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Select the recording session and load behavioral data
clear all
Dir = 'E:\DATA Electrophysiology\';
currentSession = uigetdir(Dir, 'Select the recording session you want to analyze');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract all the required behavioral data for the selected session from Events.nev
% and save the trial structure:
% 

filename    = [currentSession '\Events.nev'];
trial       = extractBehaviouralData(filename);
save([currentSession '\trial.mat'], 'trial' )

clear fileNEV filename Dir
% or the trial structure can be loaded if generated previously
% load([currentSession '\trial.mat'])

%% Extract SpikeWaveforms and Timestamps

loadKWIKfile;       % clusters and timings for each presentation
extractTimestamps;  % Timestamps of spikes

clear fullpath* waveforms*

%% Select the cluster you want to analyze and generate a PSTH

[selectedSpikeTimestampsInUsec, selectedClusters] = extractClusterData(clusters, timings, timeStamps);
    before = 300;
    after = 600;
[trial] = linkSpikesAndBehaviour(trial, selectedSpikeTimestampsInUsec, before, after);

%% plot the PSTH with prespecified Y-axis limits

lim = [-10 20 ];
plotPSTHsPerCondition

clear before after lim
%% Save the Trial as a .mat file for future reference

spikes = size(selectedSpikeTimestampsInUsec,2);
outFile = ['11-24_TC2_Ch06-12_clu' num2str(selectedClusters') '_#' num2str(spikes)];
outFile = strrep(outFile, ' ', '_');
outFile = strrep(outFile, '__', '_');
outFile = strrep(outFile, '__', '_');
fileName = [currentSession '/' outFile '.mat'];
save(fileName, 'trial' );

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5,0.98, outFile,'HorizontalAlignment' ,'center','VerticalAlignment', 'top', 'FontSize', 14, 'Interpreter','none')

figName = [currentSession '/' outFile '.jpeg'];
saveas(gca , figName, 'jpeg');
close all

clear spikes outFile ha fileName figName selectedSpikeTimestampsInUsec selectedClusters
