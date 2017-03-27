%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on May 6, 2016.
% Copyright by Dzmitry Kaliukhovich.
% Adjusted by Els Crijns
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [selectedSpikeTimestampsInUsec, selectedClusters] = extractClusterData(clusters, timings, timeStamps)

% Unique cluster identifiers.
clusterIdentifiers = unique(clusters);

% Number of different clusters. 
nClusters = length(clusterIdentifiers);

% Number of detected spikes in each cluster.
nSpikes = [];

% String description of all retrieved clusters in a form "Cluster # (Number of detected spikes)".
clusterDescriptors = {};

for counter = 1:nClusters
    currentCluster              = clusterIdentifiers(counter);
    nSpikes(end + 1)            = sum(clusters == currentCluster);
    clusterDescriptors{end + 1} = [num2str(currentCluster) ' (' num2str(nSpikes(counter)) ')'];
end

% Display a list selection dialog box with all the retrieved clusters.
[selection, ok]  = listdlg('PromptString', 'Select a cluster (or clusters)', ...
                           'SelectionMode', 'multiple', ...
                           'ListString', clusterDescriptors); 
                       
% List of cluster identifiers selected by user.
selectedClusters = clusterIdentifiers(selection);
                       
clear counter currentCluster selection ok;

% No cluster has been selected.
if isempty(selectedClusters)
    clear selectedClusters;
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extractSpikes
% True, if a spike belongs to one of the selected clusters, and false otherwise.
selectedSpikeIndices = false(sum(nSpikes), 1);

% Gather all spikes of the selected clusters.
for counter = 1:length(selectedClusters)
    currentCluster       = selectedClusters(counter);
    selectedSpikeIndices = selectedSpikeIndices | clusters == currentCluster;
end
clear counter currentCluster;

%msgbox({['Selected clusters = ' mat2str(selectedClusters)], ['Total number of spikes = ' num2str(sum(selectedSpikeIndices))]});
disp(['Selected clusters ....... ' mat2str(selectedClusters)]);
disp(['Total number of spikes .. ' num2str(sum(selectedSpikeIndices))]);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extractTimestamps
% load(fullpathMAT, 'timeStamps');

if max(timings) > length(timeStamps)
    disp('Max timestamp index exceeds the range of available spike timestamps stored in the specified .mat file!');
else
    selectedSpikeTimestampIndices = timings(selectedSpikeIndices);
    selectedSpikeTimestampsInUsec = timeStamps(selectedSpikeTimestampIndices);
end