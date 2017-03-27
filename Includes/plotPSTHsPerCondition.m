%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on March 31, 2016.
% Copyright by Dzmitry Kaliukhovich.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psths      = [];
conditions = [];
BL         = [];
spikeTimings = [];
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
nRows            = 2;
nColumns         = 3;

BL = mean(mean(psths(:,1:14)));

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
        %BL = mean(y(1:14));     %9:14
        Resp = mean(y(16:21));  %16:21
        p = ttest2(y(16:21),y(1:14));
        
        plot([1 50], [0 0], '-k');
        plot([16 21], [Resp Resp], '-k');
        plot([onsetIndex onsetIndex+10], [0 0], '-r', 'LineWidth', 2);
        plot([onsetIndex onsetIndex], lim,  ':r')
        plot([onsetIndex+10 onsetIndex+10], lim,  ':r')
    set(gca, 'XTick',      [1  onsetIndex onsetIndex+10 size(psths, 2)]);
    set(gca, 'XTickLabel', [-before  0 200  after]);
    set(gca, 'FontSize',12)
    xlabel('time, msec'), ylabel('spikes/sec');
        %Resp = Resp - BL ;
        title(['Net Response = ' num2str(Resp,'%.2f')])
%         text(0.05,0.1,['BL=' num2str(BL, '%.2f') ], 'Units', 'normalized')
%         text(0.35,0.1,['Sign=' num2str(p) ], 'Units', 'normalized')
%         
%title(['#' num2str(currentCondition) ', ' num2str(sum(conditionIndices))]);
    responses(i) = Resp;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    currentSubplot = currentSubplot + 1;
    clear y p Resp conditionIndices currentCondition
   
end

% x = sprintf('Spiking activity (spikes/s)...... %.2f ... %.2f ... %.2f ... %.2f ... %.2f ... %.2f', responses);
% disp(x)
% Y = sprintf('Baseline activity (spikes/s)..... %.2f', BL);
% disp(Y)
clear responses BL psths currentSubplot n* i onsetIndex edges 
clear binWidth uniqueConditions conditions spikeTimings