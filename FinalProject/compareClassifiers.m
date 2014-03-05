%
% Christian Sherland
% Sameer Chauhan
% Michael Scibor
% 
% ECE 414 - Machine Learning
% Final Project
% Professor Sam Keene
%
% compareClassifiers.m
%   Classifies data set using four different classifiers.
%       1.) PRT K-nearest neighbors
%       2.) Lib Support Vector Machine
%       3.) RVM Figuerido
%       4.) PRT Tree Bagger
%
%   Compares performance by 
%

clear all; close all; clc;

addpath(genpath('..'));
prtPath( 'alpha', 'beta' );

fprintf('Reading input data ... ');

adDataFile  = 'Ad Data/adData2.txt';
adNameFile  = 'Ad Data/adNames.txt';

Alldata = csvread(adDataFile,1,1);

adData  = Alldata(:,1:end-1);
adLabel = Alldata(:,end);

dataSet = prtDataSetClass(adData, adLabel);

fprintf('Successfully read in data! \n');

% Create several different classifiers
knnClassifier = prtClassKnn;
svmClassifier = prtClassLibSvm;
rvmClassifier = prtClassRvmFigueiredo;
treeBaggerClassifier = prtClassMatlabTreeBagger;

knnClassifier.internalDecider = prtDecisionMap;
svmClassifier.internalDecider = prtDecisionMap;
rvmClassifier.internalDecider = prtDecisionMap;
treeBaggerClassifier.internalDecider = prtDecisionMap;

% k-folds cross validation for each classifier, as well as plots
k = 10;

yOutKnn = knnClassifier.kfolds(dataSet,k);
subplot(2,2,1)
prtScoreConfusionMatrix(yOutKnn);

yOutSvm = svmClassifier.kfolds(dataSet,k);
subplot(2,2,2)
prtScoreConfusionMatrix(yOutSvm);

yOutRvm = rvmClassifier.kfolds(dataSet,k);
subplot(2,2,3)
prtScoreConfusionMatrix(yOutRvm);

yOutTreeBagger = treeBaggerClassifier.kfolds(dataSet,k); 
subplot(2,2,4)
prtScoreConfusionMatrix(yOutTreeBagger);

fprintf('Done\n\n')