% Conversion of Neuralynx NCS files to Matlab .dat files
% This conversion is done  in batch for all desired channel groups of 1 recording session

clear all; clc;

% Select the folder containing all .ncs fils of one recording session
Dir = 'E:\DATA Electrophysiology\';
srcDirectory =  uigetdir(Dir, 'Select the recording session you want to process');

% Each row contains the filenames of .ncs files that need to be combined (1 group = 1 subfolder)
FileNames =  {'\CSC1.ncs'    '\CSC2.ncs'    '\CSC3.ncs'    '\CSC4.ncs'    '\CSC5.ncs'    '\CSC6.ncs'    '\CSC7.ncs'; ...
       '\CSC6.ncs'     '\CSC7.ncs'     '\CSC8.ncs'     '\CSC9.ncs'     '\CSC10.ncs'    '\CSC11.ncs'    '\CSC12.ncs'; ...
       '\CSC11.ncs'    '\CSC12.ncs'    '\CSC13.ncs'    '\CSC14.ncs'    '\CSC15.ncs'    '\CSC16.ncs'    '\CSC17.ncs';...
       '\CSC16.ncs'    '\CSC17.ncs'    '\CSC18.ncs'    '\CSC19.ncs'    '\CSC20.ncs'    '\CSC21.ncs'    '\CSC22.ncs'; ...
       '\CSC21.ncs'    '\CSC22.ncs'    '\CSC23.ncs'    '\CSC24.ncs'    '\CSC25.ncs'    '\CSC26.ncs'    '\CSC27.ncs'; ...
       '\CSC26.ncs'    '\CSC27.ncs'    '\CSC28.ncs'    '\CSC29.ncs'    '\CSC30.ncs'    '\CSC31.ncs'    '\CSC32.ncs'};

% Subfolders where the .dat & .dat.mat files are saved
folders = dir([srcDirectory '\channels*'] ); Folders = {folders.name};
% Folders = {'\channels 01-07\' '\channels 06-12\' '\channels 11-17\' '\channels 16-22\' '\channels 21-27\' '\channels 26-32\'};

% Perform the clustering for each channels group/folder
n = length(Folders)
   for i = 1:n
       srcFileNames = {FileNames{i,:}};
       destFileName = '\chunk.dat';
       destDirectory = ['\' Folders{i} '\'] ;
       convertNCS2Dat(srcFileNames, srcDirectory, destFileName, destDirectory);
   end

