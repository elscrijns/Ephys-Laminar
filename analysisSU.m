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
% extract all the required behavioral data for the selected session

filename    = [currentSession '\Events.nev'];
trial       = extractBehaviouralData(filename);
save([currentSession '\trial.mat'], 'trial' )

clear fileNEV filename Dir
%  load([currentSession '\trial.mat'])

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
plotPSTHsPerCondition%_exp33

clear before after lim
%% Save the Trial as a .mat file for future reference
%  x       = strfind(currentSession, '- ') + 2;
%  session = currentSession(x:end);
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

%% process the data
% 
% % Define the PSTH plot and save figure
% binWidth = 20;
% nRows    = 2;
% nColumns = 3;
% h        = 25;
% 
% [psths, trialFR, Peaks, medianFR] = plotPSTH(trial, binWidth, nRows, nColumns, before, after, h);
% 
% clear binWidth n* h

%% Create raster plot per condition
% spikes = {trial.spikes}.';
% start = {trial.start}.';
% condition = {trial.condition}.';
% C = cellfun(@minus,spikes,start,'Un',0);
% condition = [trial(1).condition].';
% 
% for i = 1:6
%     conditionIndices = conditions == i;
%     subplot(2,3,i);
%     plotSpikeRaster(C(conditionIndices),'PlotType','vertline');
%     xlim([0 900000])
% end
% %plotSpikeRaster(C,'PlotType','scatter');
%% Save data
% x       = strfind(currentSession, '- ') + 2;
% session = currentSession(x:end);
% outFile = [session '_Clu_' num2str(selectedClusters')];
% outFile = strrep(outFile, ' ', '_');
% outFile = strrep(outFile, '__', '_');
% saveas(gca ,[currentSession '\' outFile '.tif'], 'tif');
% csvwrite([currentSession '\trialFR_' outFile '.csv'] ,trialFR);
% csvwrite([currentSession '\medianFR_' outFile '.csv'] ,medianFR);
% csvwrite([currentSession '\PSTH_' outFile '.csv'] , psths);

%close all
%clear y trialFR Peaks medianFR selected* after before ans x outFile