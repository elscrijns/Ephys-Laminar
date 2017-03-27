%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Analysis of MU data %%%%
%
% All clusters within a group of recording channels are loaded and processed
%       output: MU datafile and PSTH can be saved (if relevant)
%
% For each individual cluster an initial PSTH can be generated to help
%       with selecting SUs in KlustaViewa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For eacht group of channels the CSC files are combined into chunk.dat
% batch_convertNCS2Dat;

% Spike detection and Clustering is performed in Python with KlustaKwik
% batch_KlustaKwik.m    % Runs a batch job in the background, clustering 
                        % is performed for an entire recording session
% KlustaKwik.m          % Clustering for 1 .dat file

%% Select the recording session and load behavioral data
clear all; clc;

Dir = 'E:\DATA Electrophysiology\';
currentSession = uigetdir(Dir, 'Select the recording session you want to analyze');

% extract all the required behavioral data for the selected session
filename    = [currentSession '\Events.nev'];
trial       = extractBehaviouralData(filename);
    % in case of an error go to extractBehaviouralData.m and follow
    % instructions
save([currentSession '\trial.mat'], 'trial' )

clear fileNEV filename
%or  load([currentSession '\trial.mat'])
%% Extract SpikeWaveforms and Timestamps for all clusters within a specified timewindow

loadKWIKfile;       % clusters and timings for each presentation
extractTimestamps;  % Timestamps of spikes

clear fullpath* waveforms*

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Unique cluster identifiers.
clusterIdentifiers = unique(clusters);

% Number of different clusters. 
nClusters = length(clusterIdentifiers);

% Include all clusters for MUA
selectedClusters = [clusterIdentifiers];

% Extract the spike timestampts for all selected clusters  
[selectedSpikeTimestampsInUsec, selectedClusters]   = extractMUdata(clusters, timings, timeStamps, selectedClusters);
    before = 300; %ms
    after = 600;  %ms
[trial] = linkSpikesAndBehaviour(trial, selectedSpikeTimestampsInUsec, before, after);

%% plot PSTH with prespecified Y-axis limits
% 2x3 subplots on 1 figure
% exp33 : RF mapping 4x6 subplots

lim = [-20 50 ];
plotPSTHsPerCondition%_exp33

clear before after lim
%% Save the MU PSTH and datafile

outFile = ['MM-DD_session_Ch##-##_MUA'];
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5,0.98, outFile,'HorizontalAlignment' ,'center','VerticalAlignment', 'top', 'FontSize', 14, 'Interpreter','none')

    figName = [currentSession '\' outFile '.jpeg'] ;
    saveas(gca , figName, 'jpeg');
    
 fileName = [currentSession '\' outFile '.mat']; save(fileName, 'trial' );
 close all
% clearvars -except currentSession trial 

%% Calculate PSTH per cluster

lim = [-3 20];
for i = 1:nClusters
       
    selectedClusters = clusterIdentifiers(i);
        if ismember(selectedClusters, [1])
           continue; 
        end

    [selectedSpikeTimestampsInUsec, selectedClusters]   = extractMUdata(clusters, timings, timeStamps, selectedClusters);
        before = 300;
        after = 600;
    [trial] = linkSpikesAndBehaviour(trial, selectedSpikeTimestampsInUsec, before, after);

    plotPSTHsPerCondition%_exp33

    spikes = size(selectedSpikeTimestampsInUsec,2);
    outFile = ['Cluster # ' num2str(selectedClusters') '_#' num2str(spikes)];
        outFile = strrep(outFile, ' ', '_');
        outFile = strrep(outFile, '__', '_');
        outFile = strrep(outFile, '__', '_');

    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5,0.98, outFile,'HorizontalAlignment' ,'center','VerticalAlignment', 'top', 'FontSize', 14, 'Interpreter','none')

end

