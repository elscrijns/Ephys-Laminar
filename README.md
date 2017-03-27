# Ephys-Laminar

* These MATLAB scripts allow to analyze data from extracellular recordings on a MU and SU level

* Many of the includes originally come from https://github.com/departutto/laminar

* Recordings:   Neuralynx cheetah system
* Probe:        Neuronexus A1x32-edge-10mm-20-177-CM32
* Clustering:   Klusta-Team https://github.com/klusta-team
* Includes:     Functions that are used in the scripts below

- batch_convertNCS2Dat.m
  ** converts the neuralynx NCS files to Matlab data files
  ** NCS files are grouped per 7 channels into 1 .dat file

- batch_KlustaKwik.m
  ** runs KlustaKwik.m as a batch job on a worker
  ** the clustering is performed for each .dat file in python using the Klusta suite
   
- analysisMUA.m
  ** MU activity can be plotted as a PSTH for each group of 7 channels
  ** PSTH can also be plotted for each cluster or a set of clusters individually

Perform manual confirmation of clustering in KlustaViewa and select SU clusters that are possible responsive to our stimuli

- analysisSU.m
  ** SU activity is plotted as a PSTH and the figure can be saved.
  ** Spikecounts of the relevant cluster(s) is extracted and saved for further analysis.
   
Statistical analysis on all selected SUs

- selectivity_meanResponses
  **Test all selected SU clusters for significant responses and selectivity
  
- summaryPSTHsPerdCondition.m
  ** Make summary PSTHs combining all selected clusters

- summaryPSTHsResponsiveConditions.m
  ** Select a folder with cluster.mat files to analyze
  ** Make summary PSTH for all conditions that are responsive in the selected clusters
