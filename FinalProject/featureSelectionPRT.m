%
% Christian Sherland
% Sameer Chauhan
% Michael Scibor
%
% featureSelectionCorrelation.m
%   Attempt to select best features by using
%   PRT sequential feature selection tool

%clear all
%close all
%clc

addpath(genpath('..'));
prtPath( 'alpha', 'beta' );


%% Read dataset and choose features using PRTFeatureSelSeq

fprintf('Reading input data ... ');
[adData, adLabel] = getData();
dataSet = prtDataSetClass(adData, adLabel);
fprintf('Done.\n');

% prtFeatSel tool for feature selection
fprintf('Selecting features ... ');
featSel = prtFeatSelSfs;
featSel.nFeatures = 10;

dataSet = prtDataSetClass(adData, adLabel);
featSel = featSel.train(dataSet);
dataSetPrt = featSel.run(dataSet);

fprintf('Done.\n');


%% Cross validate classification using k-folds with 10 folds

fprintf('K-folds cross validation ... ')

knnClassifier = prtClassMatlabTreeBagger; 
knnClassifier.internalDecider = prtDecisionMap;
yOutKfoldsPRT = knnClassifier.kfolds(dataSetPrt,10); %3-Fold cross-validation
subplot(3,1,3);
prtScoreConfusionMatrix(yOutKfoldsPRT);

fprintf('Done\n\n')
