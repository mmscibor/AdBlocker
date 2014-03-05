%
% Christian Sherland
% Sameer Chauhan
% Michael Scibor
%
% featureSelectionCorrelation.m
%   Attempt to select best features by choosing
%   features with maximum correlation to output

%clear all
%close all
%clc

addpath(genpath('..'));
prtPath( 'alpha', 'beta' );

%% Read dataset and choose features using correlation

fprintf('Reading input data ... ');
[adData, adLabel] = getData();
fprintf('Done.\n');

fprintf('Selecting features ... ');
correlation = corr(adData, adLabel);

[sortedValues,sortIndex] = sort(correlation(:),'descend');                                                           

topValues = sortIndex(1:10);
adData = adData(:, topValues);

dataSet = prtDataSetClass(adData, adLabel);
fprintf('Done.\n');


%% Cross validate classification using k-folds with 10 folds

fprintf('K-folds cross validation ... ')

knnClassifier = prtClassMatlabTreeBagger; 
knnClassifier.internalDecider = prtDecisionMap;
yOutKfoldsCorr = knnClassifier.kfolds(dataSet,10);
subplot(3,1,2);
prtScoreConfusionMatrix(yOutKfoldsCorr);

fprintf('Done\n\n')