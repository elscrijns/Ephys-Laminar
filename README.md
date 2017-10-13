# Ephys-Laminar

 These MATLAB scripts allow to analyze data from extracellular recordings on a MU and SU level

  * Many of the includes originally come from https://github.com/departutto/laminar
  
  * Recordings:   Neuralynx cheetah system
 
  * Probe:        Neuronexus 32 channel probe (A1x32-edge-10mm-20-177-CM32)
 
  * Clustering:   Klusta-Team https://github.com/klusta-team
 
  * Includes:     Functions that are used in the scripts below
 

Starting with csc##.ncs files saved by the neuralynx cheetah system during recording

1) batch_convertNCS2Dat.m : convertNCS2Dat.m converts the neuralynx NCS files to Matlab data files. The batch file runs this conversion on 6 overlapping groups of 7 channels. For each group a 'Channels ##-##' folder needs to be present where the .dat and .dat.mat files are saved for further analysis.

2) batch_KlustaKwik.m : runs KlustaKwik.m as a batch job on a worker. The clustering is performed per channels-folder in python using the Klusta suite.
   
3) analysisMUA.m : MU activity can be calculated and plotted as a PSTH for each channels-folder. PSTHs can also be plotted individually for each cluster or a set of clusters.

 Perform manual confirmation of clustering in KlustaViewa and select SU clusters that are possible responsive to our stimuli

4) analysisSU.m : SU activity is plotted as a PSTH and the figure can be saved. Spikecounts of the relevant cluster(s) is extracted and saved for further analysis as a cluster.mat file.
   
 Statistical analysis on all selected SUs (Select a folder with cluster.mat files to analyze)

- selectivity_meanResponses : Tests all selected SU clusters for significant responses and selectivity based on the spikecounts
  
- summaryPSTHsPerCondition.m : Generates summary PSTHs combining all selected clusters with a subplot for each condition

- summaryPSTHsResponsiveConditions.m : Define the conditions that are responsive and make one summary PSTH to define the response pattern of the MU region
