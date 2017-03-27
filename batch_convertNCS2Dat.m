%srcDirectory = 'E:\DATA Electrophysiology\2016-11-29_rat 915 RF mapping\14. 6138559505 To 6414220875 - RF pos 6\' ;  
clear all
Dir = 'E:\DATA Electrophysiology\';
srcDirectory =  uigetdir(Dir, 'Select the recording session you want to process');
%srcDirectory = 'L:\DATA Electrophysiology\rat 68 950 Low\2016-11-23_Rat950 low\05. 1796929705 To 4990062367 - exposure';

FileNames =  {'\CSC1.ncs'    '\CSC2.ncs'    '\CSC3.ncs'    '\CSC4.ncs'    '\CSC5.ncs'    '\CSC6.ncs'    '\CSC7.ncs'; ...
       '\CSC6.ncs'     '\CSC7.ncs'     '\CSC8.ncs'     '\CSC9.ncs'     '\CSC10.ncs'    '\CSC11.ncs'    '\CSC12.ncs'; ...
       '\CSC11.ncs'    '\CSC12.ncs'    '\CSC13.ncs'    '\CSC14.ncs'    '\CSC15.ncs'    '\CSC16.ncs'    '\CSC17.ncs';...
       '\CSC16.ncs'    '\CSC17.ncs'    '\CSC18.ncs'    '\CSC19.ncs'    '\CSC20.ncs'    '\CSC21.ncs'    '\CSC22.ncs'; ...
       '\CSC21.ncs'    '\CSC22.ncs'    '\CSC23.ncs'    '\CSC24.ncs'    '\CSC25.ncs'    '\CSC26.ncs'    '\CSC27.ncs'; ...
       '\CSC26.ncs'    '\CSC27.ncs'    '\CSC28.ncs'    '\CSC29.ncs'    '\CSC30.ncs'    '\CSC31.ncs'    '\CSC32.ncs'};
folders = dir([srcDirectory '\channels*'] ); Folders = {folders.name};
%Folders = {'\channels 01-07\' '\channels 06-12\' '\channels 11-17\' '\channels 16-22\' '\channels 21-27\' '\channels 26-32\'};

%%
   for i = 1:6
       srcFileNames = {FileNames{i,:}};
       destFileName = '\chunk.dat';
       destDirectory = ['\' Folders{i} '\'] ;
       convertNCS2Dat(srcFileNames, srcDirectory, destFileName, destDirectory);
   end

