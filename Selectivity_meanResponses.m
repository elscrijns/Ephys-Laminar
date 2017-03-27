% Calculate the mean selectivity per phase and per rat
% This is done on a group of clusters (clu.mat files)
% Clusters are selected based on a significant response with respect to
% baseline activity
% Selectivity for reference SF should differ between orientations


%% Load the data: trial structures per cluster
clear all

Dir = 'E:\DATA Electrophysiology\';
Dir = uigetdir(Dir, 'Select the recording session you want to analyze');
fileNames = dir([Dir '\*.mat']);
n = size(fileNames,1)

%%  Calculate prefference  
 
 %  Define the required variables

    SignClu     = logical(zeros(1,n));
    Selective   = logical(zeros(1,n));
    SignSel     = logical(zeros(1,n));
    Pref        = nan(n,3);
    SEMpref     = nan(n,3);
    testPref    = nan(n,3);
    nonPref     = nan(n,3);
    SEMnonPref  = nan(n,3);
    testnonPref = nan(n,3);
    BL          = nan(n,1);
    
  % Define general variables for generating PSTH
    binWidth =  10; %ms
    before   = 300; %ms
    after    = 600; %ms
    stimDur  = 200 ;%ms
    edges       = -before:binWidth:after; % msec.
    onsetIndex  = (before - binWidth / 2) / binWidth + 1;
    offsetIndex = (before+stimDur - binWidth/2) / binWidth + 1;
 
for f = 1:n
    
load([Dir '\' fileNames(f).name]);
    % trial = struct('start' 'onset' 'offset' 'condition' 'spikes')
    % Contains information on timing of stimulus presentation, type of stimulus
    % and timing of spiking activity. All times expressed in uSec, should be
    % converted to ms -> time/10^3
fileName = fileNames(f).name;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    psths       = [];
    conditions  = [];
    FR          = [];
    baselineFR  = [];
    spikeTimings= [];
    immediateFR = [];
    sustainedFR = [];
    p = [];
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% For every trial the psth are calculated %%%

    for i = 1:length(trial)
        spikeTimings     = (trial(i).spikes - trial(i).onset) / 10.0 ^ 3; % msec.
        psths(end+1, :)  = (10.0 ^ 3 / binWidth) * histc(spikeTimings, edges); % Hz. (spikes per sec) 
        conditions(i) = trial(i).condition;

        baselineIndex = spikeTimings > -95 & spikeTimings < 5 ;
            baselineFR(i) = (10.0 ^ 3 / 100) * sum(baselineIndex);
        immediateIndex = spikeTimings > 15 & spikeTimings < 115 ;
            immediateFR(i)= (10.0 ^ 3 / 100) * sum(immediateIndex);
        sustainedIndex = spikeTimings > 165 & spikeTimings < 200  ;
            sustainedFR(i)= (10.0 ^ 3 / 35) * sum(sustainedIndex);
    end

% Calculate the net firing rate for each trial (with respect to the BL response)
    BL(f) = mean(baselineFR); % mean response before stimulus onset for all trials
    SD = std(baselineFR);
    Threshold = BL+3*SD;
    
    netBL = baselineFR - BL(f);
    netFR = immediateFR - BL(f);
    
    clear i psths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Calculate for each condition the mean net FR, SD                %%%

   con2 = find(conditions == 2);
        FR2 = mean(netFR(con2));
        SD2 = sem(netFR(con2));
        test(2) = ttest(immediateFR(con2),BL(f));
        
   con5 = find(conditions == 5);
        FR5 = mean(netFR(con5));
        SD5 = sem(netFR(con5));
        test(5) = ttest(immediateFR(con5),BL(f));
        
   con1 = find(conditions == 1);     
        FR1 = mean(netFR(con1));
        SD1 = sem(netFR(con1));
        test(1) = ttest(immediateFR(con1),BL(f));
   con3 = find(conditions == 3);
        FR3 = mean(netFR(con3));
        SD3 = sem(netFR(con3));
        test(3) = ttest(immediateFR(con3),BL(f));
   con4 = find(conditions == 4);
        FR4 = mean(netFR(con4));
        SD4 = sem(netFR(con4));
        test(4) = ttest(immediateFR(con4),BL(f));
   con6 = find(conditions == 6);
        FR6 = mean(netFR(con6));
        SD6 = sem(netFR(con6));
        test(6) = ttest(immediateFR(con6),BL(f));
  
  if length(con2) > length(con5)
      x=length(con5);
      con2 = con2(1:x);
      con1 = con1(1:x);  
      con3 = con3(1:x);
      con4 = con4(1:x);
      con6 = con6(1:x);
  elseif length(con2) < length(con5)
      x=length(con2);
      con1 = con1(1:x);  
      con3 = con3(1:x);
      con4 = con4(1:x);
      con5 = con5(1:x);
      con6 = con6(1:x);
  end
  
   clear x
   
   % do any of the stimuli lead to a significant response? 
   if any(test == 1) & (FR2>1 | FR5>1)
   %if BL(f) > 2
        SignClu(f) = 1;
        ref  = ttest2(immediateFR(con2),immediateFR(con5), 'Vartype','unequal');
        low  = ttest2(immediateFR(con1),immediateFR(con4), 'Vartype','unequal');
        high = ttest2(immediateFR(con3),immediateFR(con6), 'Vartype','unequal');
        S = mean((immediateFR(con2)-immediateFR(con5)));
        [low ref high];
        if ref == 1 
            SignSel(f) = 1;
            disp(fileName)
        end
        if abs(S) > 1
            Selective(f) = 1;
        end
   end
  clear S ref low high

% Test difference in orientation selectivity between pairs of SF      
%     ref(f)  = ttest(netFR(con2),netFR(con5));
%     low(f)  = ttest(netFR(con1),netFR(con4));
%     high(f) = ttest(netFR(con3),netFR(con6));  

% Define the prefered orientation and group 
    if FR2 > FR5
       Pref(f,:)    = [FR1,FR2,FR3];
       SEMpref(f,:)  = [SD1,SD2,SD3];
       testPref(f,:)  = test(1:3);
       nonPref(f,:)   = [FR4,FR5,FR6] ;
       SEMnonPref(f,:) = [SD4,SD5,SD6] ;
       testnonPref(f,:)  = test(4:6);  
    else 
       Pref(f,:)    = [FR4,FR5,FR6] ;
       SEMpref(f,:)  = [SD4,SD5,SD6] ;
       testPref(f,:)= test(4:6);
       nonPref(f,:)   = [FR1,FR2,FR3] ;
       SEMnonPref(f,:) = [SD1,SD2,SD3];
       testnonPref(f,:)  = test(1:3); 
    end
  
    % Normalize the FR to the preffered orientation at ref SF
    nPref(f,:) = Pref(f,:) / Pref(f,2);
    nnonPref(f,:) = nonPref(f,:) / Pref(f,2);
    
    clear SD Threshold netBL netFR baselineFR immediateFR spikeTimmings
    clear -regexp ^con ^FR ^SD
end

     Responsive = sum(SignClu)
     Sign = sum(SignSel)
     
     clear before after onsetIndex offsetIndex stimDus sustainedIndex f edges fileName
     
    %xlswrite([Dir '\SelectiveClusters.xls' ], {fileNames(SignSel).name}', 'Rec 11-09')
%% summarize & save results in table

%     nSEMpref  = sem(nPref);
%     nSEMnonPref = sem(nnonPref); 
% % Select the clusters where atleast one of the figures results in a
% % significant response
% 
%    Preffered    = table(Pref(SignClu,:), SEMpref(SignClu,:), testPref(SignClu,:), 'VariableNames', {'Mean', 'StDev', 'ttest'})
%    nonPreffered = table(nonPref(SignClu,:), SEMnonPref(SignClu,:), testnonPref(SignClu,:), 'VariableNames', {'Mean', 'StDev', 'ttest'})
%     %ref(SignClu)

files = {fileNames.name}';
T = table(files, BL, Pref, SEMpref, testPref, nonPref, SEMnonPref, testnonPref, SignSel');
writetable(T,[Dir '\selectivity.csv']);

  %% Plot the normalized data (normalize to stim2 = 1) 
  %     Selective responses only
  
 figure;
 hold on
    errorbar(mean(nPref(SignSel,:)),sem(nPref(SignSel,:)) )
    errorbar([1.1 2.1 3.1],mean(nnonPref(SignSel,:)), sem(nnonPref(SignSel,:)))
        legend('Preffered orientation', 'Opposite orientation')
        set(gca, 'XTick', [1 2 3]);
        set(gca, 'XTickLabel', {'low SF', 'reference', 'high SF'});
        set(gca, 'FontSize', 14);
        ylabel('Normalized Firing Rate (mean+SEM)')
    [h,p, ci, stats] = ttest(nPref(SignSel,:),nnonPref(SignSel,:),'Tail', 'right')
    
    title(['Significantly Selective, n=' num2str(sum(SignSel))])
    %text([2 3],[1.1 1.1],'*','FontSize' ,18)
 hold off 
 
 %% plot selectivity
 hold on
 Selectivity = nPref(SignSel,:) - nnonPref(SignSel,:);
 selMean = mean(Selectivity);
 selSEM  = sem(Selectivity);
 errorbar(selMean, selSEM)
 
 legend('Pre-exposure','Post-exposure')
 title('Selectivity (nPref-nnonPref)')
%% distribution of BL responses
M = ceil(max(BL));

figure;
histogram(BL(SignClu), 'BinWidth', 1)
ylabel('n clusters')
xlabel('Baseline (spikes/s)')

title('Responsive clusters')

figure;
histogram(BL(SignSel), 'BinWidth', 1)
ylabel('n clusters')
xlabel('Baseline (spikes/s)')

title('Selective clusters')


%% Plot the normalized data (normalize to stim2 = 1) 
%   Significant responses only
figure;
 hold on
    errorbar(mean(nPref(SignClu,:), 'omitnan'),sem(nPref(SignClu,:)) )
    errorbar([1.1 2.1 3.1],mean(nnonPref(SignClu,:), 'omitnan'), sem(nnonPref(SignClu,:)))
        legend('Preffered orientation', 'Opposite orientation')
        set(gca, 'XTick', [1 2 3]);
        set(gca, 'XTickLabel', {'low SF', 'reference', 'high SF'});
        set(gca, 'FontSize', 14);
        ylabel('Normalized Firing Rate (mean+SEM)')
    [h,p, ci, stats] = signrank(nPref(SignClu,:),nnonPref(SignClu,:))
    title(['Responsive Clusters, n=' num2str(sum(SignClu))])
    %text([2 3],[1.1 1.1],'*','FontSize' ,18)
 hold off 


%% Plot the individual data for Preffered & nonPreffered orientation
figure;
plot(Pref')
title('Preffered orientation')
%ylim([-10 10])

figure;
plot(nonPref')
title('non-preffered orientation')
%ylim([-10 10])

%% Individual selectivity plots based on normalized responses

nRows = 3;
nColumns  = 3;
currentSubplot = 1;

for i = 1:n
    
   if mod(currentSubplot, nRows * nColumns) == 1
        figure;
        currentSubplot = 1;
   end
   
  %if Selective(i) == 1
  if SignSel(i) == 1
   subplot(nRows, nColumns, currentSubplot)
   hold on
        errorbar(Pref(i,:), SEMpref(i,:))
        errorbar(nonPref(i,:), SEMnonPref(i,:))
        cluster = fileNames(i).name;
        title(cluster(1:end-4), 'interpreter', 'none', 'FontSize',10);
        set(gca, 'XTick', [1 2 3]);
        set(gca, 'XTickLabel', {'low SF', 'reference', 'high SF'});
        set(gca, 'FontSize', 10);
        ylabel('netFR (mean+SEM)')
   hold off
   currentSubplot = currentSubplot + 1;
   else
       continue
   end     
   
end
legend('Preffered orientation', 'Opposite orientation')%% plot selectivity for clusters with a significant response


%% plot selectivity for all clusters with individual points
figure;
 hold on
    errorbar(mean(Pref),std(Pref) )
    errorbar([1.1 2.1 3.1],mean(nonPref), std(nonPref))
        legend('Preffered orientation', 'opposite orientation')
        set(gca, 'XTick', [1 2 3]);
        set(gca, 'XTickLabel', {'low SF', 'reference', 'high SF'});
        set(gca, 'FontSize', 12)
        title('All clusters')
        ylabel('Firing Rate (Spikes/s)')
    ttest(Pref,nonPref)
        plot(ones(n,1), Pref(:,1), '*k')
        plot(repmat(2,n,1), Pref(:,2), '*k')
        plot(repmat(3,n,1), Pref(:,3), '*k')
        plot(repmat(1.1,n,1), nonPref(:,1), '*k')
        plot(repmat(2.1,n,1), nonPref(:,2), '*k')
        plot(repmat(3.1,n,1), nonPref(:,3), '*k')
        text([2 3],[3 3],'*','FontSize' ,18)
%ylim([0 1])
 hold off 
%% Plot the normalized data of all clusters (normalize to stim2 = 1)

figure;
 hold on
    errorbar(mean(nPref),sem(nPref))
    errorbar([1.1 2.1 3.1],mean(nnonPref),sem(nnonPref))
        legend('Preffered orientation', 'Opposite orientation')
        set(gca, 'XTick', [1 2 3]);
        set(gca, 'XTickLabel', {'low SF', 'reference', 'high SF'});
        set(gca, 'FontSize', 12);
        ylabel('Normalized Firing Rate')
    ttest(nPref,nnonPref)
        title('Normalized response of all clusters')
        %text([ 3],[ 1.5],'*','FontSize' ,18)
 hold off 

%% plot selectivity

Selectivity = Pref-nonPref;%./Pref;
hold on 
%figure;
errorbar(mean(Selectivity),sem(Selectivity));
title('Difference in Selectivity')
set(gca, 'XTick', [1 2 3]);
set(gca, 'XTickLabel', {'low SF', 'reference', 'high SF'});
set(gca, 'FontSize', 14);
ylabel('(P-N) (mean+SEM)')
