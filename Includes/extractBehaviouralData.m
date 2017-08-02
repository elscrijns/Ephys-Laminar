%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Original script by Dzmitry Khaliukhovic
%   Edit by Els Crijns
%
%   Extracting behavioral data from a recording session 
%   Input: Events.nev
%   Output: trial.m contains:
%       - timestamps (usec)
%       - header events (start = 284, stop = 283, expType and condition)
%       - photocell events (ON or OFF = 1)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [trial, consolidated] = extractBehaviouralData(filename, varargin)

    [timestamps, ttls] = Nlx2MatEV(filename, [1 0 1 0 0], 0, 1, 1);
    photocells         = bitand(ttls, 3); % 3 decimal = 00000011 binary.
    events             = bitshift(ttls, -2);
    consolidated       = [timestamps; events; photocells]'; 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    headersStart       = find(consolidated(:, 2) == 254);
    headersStop        = find(consolidated(:, 2) == 253);

% % In case of timing problems: some events might be registered several
% % times, these errors need to be manually removed
% % Both headears must have the same length for the code to work
%       headersStart(end+1) = 0;
%       headersStop(end+1) = 0;
% % Find the position where there is a conflict: start and stop signal must
% % be 6 timestamps apart
%       n = find(headersStart + 6 ~= headersStop,1); x = headersStart(n)
% % If there is an additional stop header you may want to try x for n-1
% 
% % visually explore the problem region: % How is it supposed to look? 
% %   ex: 254     0    33     0    20     0   253
% %   ex: start   0    exp    0 condition 0   stop
%       consolidated(x:x+30,2)'
% % Remove the line that is giving errors
%       consolidated(x+3,:) = [];
% % Redefing the headers and check of there are remaining errors. There might
% % be several in one file

    
    % Examine the retrieved trials information for consistency.
    if isempty(headersStart)                       || ...
       length(headersStart) ~= length(headersStop) || ...
       any(headersStart + 6 ~= headersStop)        || ...
       any(consolidated(headersStart + 1, 2))      || ...
       any(consolidated(headersStart + 3, 2))      || ...
       any(consolidated(headersStart + 5, 2)) 
        error('Corrupted format of the transferred trials information!');
    end         
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only run this section when there are no more errors
% % clear the additional variables that were created when there ate no more 
% % errors and entire scripthas run
%    clearvars -except trial Dir currentSession
    
    nTrials    = length(headersStart)-1;   
    experiment = unique(consolidated(headersStart + 2, 2));
    conditions = consolidated(headersStart + 4, 2);
    
    if length(experiment) > 1
        error('More than one experiment identifier has been detected!');
    end
      
    disp(['Number of trials ........ ' num2str(nTrials)]);
    disp(['Experiment identifier ... ' num2str(experiment)]);    
    disp(['Unique conditions ....... ' mat2str(unique(conditions))]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:nTrials
        % Indices of the current trial, first and last photocell events.
        currentTrial       = headersStart(i);
        firstPhotocell     = currentTrial + 8;
        if i == nTrials % photocell (3rd column in consolidated) must be 0.
            lastPhotocell  = size(consolidated, 1) - 1;
        else
            lastPhotocell  = headersStart(i + 1) - 2;
        end
        % All timings in usec.
        trial(i).start     = consolidated(currentTrial, 1);
        trial(i).onset     = consolidated(firstPhotocell, 1);        
        trial(i).offset    = consolidated(lastPhotocell, 1);
        trial(i).condition = conditions(i);
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if nargin > 1
        
        dt = zeros(1, nTrials);
        for i = 1:nTrials
            % Last detected photocell event - First detected photocell event.
            dt(i) = trial(i).offset - trial(i).onset;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Convert usec into msec.
        dt = dt / 10 ^ 3; 
        
        figure, plot(dt);
        xlim([1 nTrials-1]), set(gca, 'XTick', [1 25:25:(nTrials - 1)]);
        xlabel('trial #'), ylabel('\it{dt}\rm = last photocell event - first photocell event, ms');        
        title(['(min; mean; median; max) of \it{dt}\rm = ' sprintf('(%.2f; %.2f; %.2f; %.2f) ms', [min(dt) mean(dt) median(dt) max(dt)])]);

    end
    
end
