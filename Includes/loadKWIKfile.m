%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on May 6, 2016.
% Copyright by Dzmitry Kaliukhovich.
% Adjusted by Els Crijns
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[filenameKWIK, directoryKWIK] = uigetfile('*.kwik', 'Select file with sorted spike waveforms (*.kwik)', currentSession , 'MultiSelect', 'off');

% No file has been selected.
if isnumeric(filenameKWIK)
    clear *KWIK;
    return;
end

% Full path to the file with spike timestamps and clusters information.
fullpathKWIK = [directoryKWIK filenameKWIK];

% Find the starting position of the .KWIK file extension.
extensionIndex = strfind(fullpathKWIK, '.kwik');
if isempty(extensionIndex)
    clear extensionIndex;
    return;
end

% Full path to the file with raw and filtered spike waveforms (.kwx).
fullpathKWX = [fullpathKWIK(1:extensionIndex) 'kwx'];

clear filenameKWIK directoryKWIK extensionIndex;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    % Note that the channel group number refers to the shank number which
    % starts from 0. Change if needed.
    timings           = hdf5read(fullpathKWIK, '/channel_groups/0/spikes/time_samples');
    clusters          = hdf5read(fullpathKWIK, '/channel_groups/0/spikes/clusters/main');
    waveformsRaw      = hdf5read(fullpathKWX,  '/channel_groups/0/waveforms_raw');
    waveformsFiltered = hdf5read(fullpathKWX,  '/channel_groups/0/waveforms_filtered'); 
catch err
    error('Something went wrong when uploading data into the Matlab workspace!');
end

