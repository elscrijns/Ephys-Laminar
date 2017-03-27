%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on May 6, 2016.
% Copyright by Dzmitry Kaliukhovich.
% Adjusted by Els Crijns
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [selectedSpikeTimestampsInUsec, selectedClusters] = extractMUdata(clusters, timings, timeStamps, selectedClusters)

% Number of detected spikes in each cluster.
    nSpikes = length(clusters);

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
end