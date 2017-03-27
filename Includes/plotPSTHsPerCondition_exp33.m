%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on March 31, 2016.
% Copyright by Dzmitry Kaliukhovich.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psths      = [];
conditions = [];
FR         = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

binWidth   = 20;                     % msec.
edges      = -before:binWidth:after; % msec.
onsetIndex = (before - binWidth / 2) / binWidth + 1;

for i = 1:length(trial)
    spikeTimings             = (trial(i).spikes - trial(i).onset) / 10.0 ^ 3; % msec.
    psths(end + 1, :)        = 10.0 ^ 3 / binWidth * histc(spikeTimings, edges); % Hz. (spikes per sec) 
    % each row will contain the bin counts per trial
    % the counts are converted to firing rate by 10^3/binwidts
    conditions(end + 1) = trial(i).condition;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uniqueConditions = unique(conditions);
nConditions      = length(uniqueConditions);
nRows            = 4;
nColumns         = 6;

BL = mean(mean(psths(:,1:14)))

for i = 1:nConditions
    
    currentCondition = uniqueConditions(i);
    conditionIndices = conditions == currentCondition;
    
    % if nConditions > nRows * nColumns : split the PSTHS over multiple
    % figures
    
    if mod(i, nRows * nColumns) == 1
        figure;
        currentSubplot = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    subplot(nRows, nColumns, currentSubplot)
    y = mean(psths(conditionIndices, :)) - BL;
    plot(y(1:end-1));
    
    % Normalizing the firing rate by calculating the mean of each bin
    % equivalent to dividing each bin by amount of trials
    xlim([1 size(psths, 2)]); ylim(lim);
    hold on, 
%         BL = mean(y(1:14));     %9:14
        Resp = mean(y(17:24));  %16:21
        p = ttest2(y(17:24),y(1:14));
        
        plot([1 50], [0 0 ], '-k');
        plot([16 21], [Resp Resp], '-k');
        plot([onsetIndex onsetIndex+15], [0 0], '-r', 'LineWidth', 2);
        plot([onsetIndex onsetIndex], lim,  ':r')
        plot([onsetIndex+15 onsetIndex+15], lim,  ':r')
    set(gca, 'XTick',      [1  onsetIndex onsetIndex+15 size(psths, 2)]);
    set(gca, 'XTickLabel', [-before  0 300  after]);
    set(gca, 'FontSize',12)
    xlabel('time, msec'), ylabel('firing rate, Hz');
%         Resp = Resp - BL ;
%         title(['Increased Response = ' num2str(Resp,'%.2f')])
%         text(0.05,0.1,['Resp=' num2str(Resp, '%.2f') ], 'Units', 'normalized')
%         text(0.35,0.1,['Sign=' num2str(p) ], 'Units', 'normalized')
        
title(['#' num2str(currentCondition) ', resp=' num2str(Resp, '%.2f')]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    currentSubplot = currentSubplot + 1;
    clear y p Resp
   
end
