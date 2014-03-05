% Various feature selection methods, and their corresponding
% classifications with the TreeBagger classifier. 

clear all; close all; clc;
fprintf('Reading input data ... ');

adDataFile  = 'Ad Data/adData2.txt';
adNameFile  = 'Ad Data/adNames.txt';

allData = csvread(adDataFile,1,1);

adData  = allData(:,1:end-1);
adLabel = allData(:,end);

N = 20; % Number of features to select

% Correlation method for feature selection
corrData = adData(:,1:end);
corrData = corr(corrData, adLabel);

[~,sortIndex] = sort(corrData(:),'descend');  
selectedFeatures = sortIndex(1:N);

adDataCorr = allData(:, [1:3, selectedFeatures']);
dataSetCorr = prtDataSetClass(adDataCorr, adLabel);

% Entropy method for feature selection
entropyData = adData(:,4:end);
p1 = sum(entropyData)/size(entropyData,1);
p0 = 1 - p1;
h = -(p1.*log(p1) + p0.*log(p0));

[~,sortIndex] = sort(h(:),'descend');  
selectedFeatures = sortIndex(1:N);

adDataEntropy = allData(:, [1:3, selectedFeatures']);
dataSetEntropy = prtDataSetClass(adDataEntropy, adLabel);

fprintf('Successfully read in data! \n');

% prtFeatSel tool for feature selection
featSel = prtFeatSelSfs;
featSel.nFeatures = N;

dataSet = prtDataSetClass(adData, adLabel);
featSel = featSel.train(dataSet);
dataSetPrt = featSel.run(dataSet);

% Create the TreeBagger classifer
treeBaggerClassifier = prtClassMatlabTreeBagger;
treeBaggerClassifier.internalDecider = prtDecisionMap;

% k-folds cross validation for each classifier, as well as plots
k = 10;

yOutCorr = treeBaggerClassifier.kfolds(dataSetCorr,k);
figure
prtScoreConfusionMatrix(yOutCorr);
title('Correlation Method Feature Selection')

yOutEntropy = treeBaggerClassifier.kfolds(dataSetEntropy,k);
figure
prtScoreConfusionMatrix(yOutEntropy);
title('Entropy Method Feature Selection')

yOutPrt = treeBaggerClassifier.kfolds(dataSetPrt,k);
figure
prtScoreConfusionMatrix(yOutPrt);
title('PRT Feature Selection')

fprintf('Done\n\n')