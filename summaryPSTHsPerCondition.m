% Make a summary PSTH of all selected clusters

Dir = 'E:\DATA Electrophysiology\';
Dir = uigetdir(Dir, 'Select the recording session you want to analyze');
fileNames = dir([Dir '\*.mat']);
n=length(fileNames) - 1 

psths       = [];
conditions  = [];
before      = 300;
after       = 600;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i= 1:n
    load([Dir '\' fileNames(i).name]);
    
    binWidth   = 10;                       % msec.
    edges      = -before:binWidth:after;   % msec.
    onsetIndex = (before - binWidth / 2) / binWidth + 1;

    for i = 1:length(trial)
        spikeTimings             = (trial(i).spikes - trial(i).onset) / 10.0 ^ 3; % msec.
        psths(end + 1, :)        = 10.0 ^ 3 / binWidth * histc(spikeTimings, edges); % Hz. (spikes per sec) 
        conditions(end + 1)      = trial(i).condition;
    end
end

BL = mean(mean(psths))
SD = std(std(psths))
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uniqueConditions = unique(conditions);
nConditions      = length(uniqueConditions);
nRows            = 4;
nColumns         = 6;
currentSubplot   = 1;

for i = 1:nConditions
    
    currentCondition = uniqueConditions(i);
    conditionIndices = conditions == currentCondition;
    
%     if nConditions > nRows * nColumns : split the PSTHS over multiple
%     figures
%     
    if mod(i, nRows * nColumns) == 1
        figure;
        currentSubplot = 1;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    subplot(nRows, nColumns, currentSubplot)
    y = mean(psths(conditionIndices, :)) - BL;
    
%     BL = mean(y(1:29));
%     maxPSTH = max(PSTH);

    
%     SD = std(y(1:29));
    Resp = mean(y(31:46));
     
    plot(y);
    [pks,locs] = findpeaks(y(30:50), 'Annotate','extents', 'WidthReference','halfheight', 'SortStr', 'descend');
    Latency(2,i) = (locs(1)*binWidth);
        
   
    [X,Y] = intersections([30 50], [(BL+3*SD) (BL+3*SD)], 30:50 ,y(30:50));
           if isempty(X)
               Latency(1,i) = 0;
               X = 0;
               Y = 0;
           else
               Latency(1,i) = (X(1)-30)*binWidth;
           end
    % Normalizing the firing rate by calculating the mean of each bin
    % equivalent to dividing each bin by amount of trials
    xlim([1 size(psths, 2)]); ylim([-100 200]);
    hold on, 
        plot([1 90], [0 0], '-k');
        plot([1 90], [(+3*SD) (+3*SD)], ':k');
        plot([1 90], [(-3*SD) (-3*SD)], ':k');
        plot([31 46], [Resp Resp], '-k');
        plot([onsetIndex onsetIndex+20], [0 0], '-r', 'LineWidth', 2);
        plot([onsetIndex onsetIndex], [-100 200],  ':r')
        plot([onsetIndex+20 onsetIndex+20], [-100 200],  ':r')
        plot([X(1) locs(1)+29],[Y(1) pks(1)], '*k')
    set(gca, 'XTick',      [1  onsetIndex onsetIndex+20 size(psths, 2)]);
    set(gca, 'XTickLabel', [-before  0 200  after]);
    set(gca, 'FontSize',11)
    xlabel('time, msec'), ylabel('firing rate, spikes/s');
       % Resp = Resp - BL ;
       % title(['Increased Response = ' num2str(Resp,'%.2f')])
       % text(0.05,0.5,['BL=' num2str(BL, '%.2f') ], 'Units', 'normalized')
        
        
    title(['BL =' num2str(BL, '%.2f') ', # ' num2str(sum(conditionIndices))]);
   % title(['Onset = ' num2str(Latency(1,i),'%.2f') 'ms, Peak = ' num2str(Latency(2,i),'%d') 'ms'])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    currentSubplot = currentSubplot + 1;

end


Latency 
    csvwrite([Dir '\Latency.csv'], Latency);
    
figName = [Dir '\summaryPSTHs.jpeg'] ;
    saveas(gca , figName, 'jpeg');
    close
   