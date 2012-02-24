clc;
close all;
clear all;

% 
%  inputcellarray = {' MATLAB desktop keyboard shortcuts, such as Ctrl+S,  are now customizable.';' To customize keyboard shortcuts, use ';'Preferences. From there, you can also  ,';'restore previous default settings by following the ';'steps outlined in Help.'}
% nminFeatures = 1;
% removeStopWords = 0;
% doStem =1;
% grams = 1;
% cores = 1
% [featureVector_1core,selectedheaderskeys_1core] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores);
% 
% cores = 4
% [featureVector_4core,selectedheaderskeys_4core] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores);
% 
%  featureVector_singleMachine = featurize(inputcellarray, nminFeatures, removeStopWords, doStem)
%  
%  
%  subplot(1,3,1)
%  image(featureVector_1core);
%  title('1 core on parallel');
%  
%  subplot(1,3,2)
%  image(featureVector_4core);
%  title('4 core on parallel');
%  
%   subplot(1,3,3)
%  image(featureVector_singleMachine);
%  title('1 core on classical single machine implementation');
%  
% isequal(featureVector_1core, featureVector_1core)
% isequal(featureVector_1core, featureVector_singleMachine)
% 
% isequal(selectedheaderskeys_1core, selectedheaderskeys_4core)
%  
% 

%featuriziation
   
    [num,txt,raw] = xlsread('data\final104.xls');
    descriptions = raw(2:size(raw,1),2);
    inputcellarray = descriptions;
    nminFeatures = 10;
    removeStopWords = 0;
    doStem=1;
    grams=1;
    
    
    tic
cores = 4
[featureVector_4core,selectedheaderskeys_4core] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores);
toc

    tic 
    cores = 1
[featureVector_1core,selectedheaderskeys_1core] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores);
toc

tic
featureVector_singleMachine = featurize(inputcellarray, nminFeatures, removeStopWords, doStem);
toc

isequal(selectedheaderskeys_1core, selectedheaderskeys_4core)
isequal(featureVector_singleMachine, selectedheaderskeys_4core)
a = (featureVector_4core-featureVector_singleMachine);
b = find(a~=0)