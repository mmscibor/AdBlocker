%
% Christian Sherland
% Sameer Chauhan
% Michael Scibor
%
% featureSelectionEntropy.m
%   Attempt to select best features by choosing
%   features with maximum entropy

clear all
close all
clc

addpath(genpath('..'));
prtPath( 'alpha', 'beta' );

%% Read dataset and choose features using entropy

[adData, adLabel] = getData();
dataSet = prtDataSetClass(adData, adLabel);

% Calculate entropies
entropyData = adData(:,4:end);
p1 = sum(entropyData)/size(entropyData,1);
p0 = 1 - p1;
h = -(p1.*log(p1) + p0.*log(p0));

% Select highest entropy features (include dimension features)
[~,sortIndex] = sort(h(:),'descend');  
selectedFeatures = sortIndex(1:7);

adDataEntropy = adData(:, [1:3, selectedFeatures']);
dataSetEntropy = prtDataSetClass(adDataEntropy, adLabel);

%% Cross validate classification using k-folds with 10 folds

fprintf('K-folds cross validation ... ')

knnClassifier = prtClassMatlabTreeBagger; 
knnClassifier.internalDecider = prtDecisionMap;
yOutKfoldsEntropy = knnClassifier.kfolds(dataSetEntropy,10);
prtScoreConfusionMatrix(yOutKfoldsEntropy);

fprintf('Done\n\n')



