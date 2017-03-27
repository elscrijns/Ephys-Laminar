%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[filenameMAT, directoryMAT] = uigetfile('*.mat', 'Select file with timestamps (*.mat)', currentSession, 'MultiSelect', 'off');
fullpathMAT                 = [directoryMAT filenameMAT];
clear button filenameMAT directoryMAT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Retrieve a list of variable names stored in the specified .mat file.
info = whos('-file', fullpathMAT);
vars = {info(1:end).name};

% Terminate if the specified .mat file does not contain variable
% 'timeStamps' (spike timestamps in usec).
if any(cellfun(@(x) isequal(x, 'timeStamps'), vars))
    load(fullpathMAT, 'timeStamps');
    clear info vars;
else
    disp('Specified .mat file does not contain spike timestamps in usec!');
    clear info vars;
    return;
end