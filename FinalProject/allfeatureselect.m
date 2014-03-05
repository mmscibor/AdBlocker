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

figure()
hold on;

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
subplot(3,1,1)
prtScoreConfusionMatrix(yOutKfoldsEntropy);

fprintf('Done\n\n')

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