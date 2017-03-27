% Make a summary PSTH of all selected clusters

Dir = 'E:\DATA Electrophysiology\';
Dir = uigetdir(Dir, 'Select the recording session you want to analyze');
fileNames = dir([Dir '\*.mat']);
n=length(fileNames)

psths       = [];
conditions  = [];
before      = 300; %ms
after       = 600; %ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combine all the relevant MU.mat files

for i= 1:n-1
    load([Dir '\' fileNames(i).name]);
    fileNames(i).name
    binWidth   = 10;                     % msec.
    edges      = -before:binWidth:after; % msec.
    onsetIndex = (before - binWidth / 2) / binWidth + 1;

    for i = 1:length(trial)
        spikeTimings             = (trial(i).spikes - trial(i).onset) / 10.0 ^ 3; % msec.
        psths(end + 1, :)        = 10.0 ^ 3 / binWidth * histc(spikeTimings, edges); % Hz. (spikes per sec) 
        conditions(end + 1) = trial(i).condition;
    end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract spiking activity only for the responsive conditions

% RF mapping (300ms)
clear y
uniqueConditions = unique(conditions);
responsiveConditions = [2:4 8 9];
nRespConditions = length(responsiveConditions);

% for each condition:
for i = 1:nRespConditions
    
    currentCondition = responsiveConditions(i);
    conditionIndices = conditions == currentCondition;
    
    PSTH = mean(psths(conditionIndices, :));
    
    % Baseline correction
    BL1 = mean(PSTH(1:29));
    SD = std(PSTH(1:29));
    Resp = PSTH - BL1;
    
    % set maximum response to 1 (normalization
    maxResp = max(Resp);
    y(i,:) = Resp/maxResp;
end
    
    % plot the normalized mean PSTH of all responsive conditions
    y = mean(y);
    plot(y(1:end-1)); % last time point can be ignored

    % Find peak response and latency to peak
    [pks,locs] = findpeaks(y(30:50), 'Annotate','extents', 'WidthReference','halfheight', 'SortStr', 'descend');
    Latency(2) = (locs(1)*binWidth);
        
    % find the amplitude of mean response to the stimuli
    BL = mean(y(1:29));
    SD = std(y(1:29));
    Resp = mean(y(31:46));
    
    [X,Y] = intersections([30 50], [(3*SD) (3*SD)], 30:50 ,y(30:50));
       if isempty(X)
           Latency(1) = 0;
           X = 0;
           Y = 0;
       else
           Latency(1) = (X(1)-30)*binWidth;
       end
           
     %ylim(lim);
     hold on
     % mark stimulus presentation
         plot([1 90], [0 0], '-k');
         plot([onsetIndex onsetIndex+30], [0 0], '-r', 'LineWidth', 2);
         plot([onsetIndex onsetIndex], ylim,  ':r')
         plot([onsetIndex+30 onsetIndex+30], ylim,  ':r')
         
     % plot the mean response and latency
         plot([31 46], [Resp Resp], '-k');
         plot([1 90], [(3*SD) (3*SD)], ':k');
         plot([1 90], [(-3*SD) (-3*SD)], ':k');
         plot([X(1) locs(1)+29],[Y(1) pks(1)], 'ok')
         
    % Axis properties    
        set(gca, 'XTick',      [1  onsetIndex onsetIndex+30 size(psths, 2)]);
        set(gca, 'XTickLabel', [-before  0 300  after]);
        set(gca, 'FontSize',12)
        set(gca, 'Ylim', [-0.5 1]);
        xlabel('time, msec'), ylabel('firing rate, spikes/s');

       % title(['Increased Response = ' num2str(Resp,'%.2f')])
       % text(0.05,0.5,['BL=' num2str(BL, '%.2f') ], 'Units', 'normalized')
        
        
%     title(['BL =' num2str(BL, '%.2f') ', # ' num2str(sum(conditionIndices))]);
     title(['Onset = ' num2str(Latency(1),'%.2f') 'ms, Peak = ' num2str(Latency(2),'%d') 'ms'])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Latency 
    %csvwrite([Dir '\Latency.csv'], Latency);
    
figName = [Dir '\summaryPSTH_responsiveConditions.jpeg'] ;
   saveas(gca , figName, 'jpeg');
   close 
   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temporal Contig (200ms)
clear y
uniqueConditions = unique(conditions);
responsiveConditions = 1:6;
nRespConditions = length(responsiveConditions);

% resonsive conditions
for i = 1:nRespConditions
    
    currentCondition = responsiveConditions(i);
    conditionIndices = conditions == currentCondition;
    
    PSTH = mean(psths(conditionIndices, :));
    
    BL1 = mean(PSTH(1:29));
    SD = std(PSTH(1:29));
    Resp = PSTH - BL1;
        
    maxResp = max(Resp);
    y(i,:) = Resp/maxResp;
end
y = mean(y);

    plot(y);
    [pks,locs] = findpeaks(y(30:50), 'Annotate','extents', 'WidthReference','halfheight', 'SortStr', 'descend');
    Latency(2) = (locs(1)*binWidth);
        
    BL = mean(y(1:29));
    SD = std(y(1:29));
    Resp = mean(y(31:46));
    
    [X,Y] = intersections([30 50], [(3*SD) (3*SD)], 30:50 ,y(30:50));
           if isempty(X)
               Latency(1) = 0;
               X = 0;
               Y = 0;
           else
               Latency(1) = (X(1)-30)*binWidth;
           end
           
    % Normalizing the firing rate by calculating the mean of each bin
    % equivalent to dividing each bin by amount of trials
    xlim([1 size(psths, 2)]); 
    hold on, 
         plot([1 90], [BL BL], '-k');
         plot([1 90], [(3*SD) (3*SD)], ':k');
         plot([1 90], [(-3*SD) (-3*SD)], ':k');
         plot([31 46], [Resp Resp], '-k');
         plot([onsetIndex onsetIndex+20], [0 0], '-r', 'LineWidth', 2);
         plot([onsetIndex onsetIndex], ylim,  ':r')
         plot([onsetIndex+20 onsetIndex+20], ylim,  ':r')
         plot([X(1) locs(1)+29],[Y(1) pks(1)], 'ok')
    set(gca, 'XTick',      [1  onsetIndex onsetIndex+20 size(psths, 2)]);
    set(gca, 'XTickLabel', [-before  0 200  after]);
    set(gca, 'FontSize',12)
    set(gca, 'Ylim', [-0.5 1]);
    xlabel('time, msec'), ylabel('firing rate, spikes/s');
        Resp = Resp - BL ;
       % title(['Increased Response = ' num2str(Resp,'%.2f')])
       % text(0.05,0.5,['BL=' num2str(BL, '%.2f') ], 'Units', 'normalized')  
       % title(['BL =' num2str(BL, '%.2f') ', # ' num2str(sum(conditionIndices))]);
       title(['Onset = ' num2str(Latency(1),'%.2f') 'ms, Peak = ' num2str(Latency(2),'%d') 'ms'])
   