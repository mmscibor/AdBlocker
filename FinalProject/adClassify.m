%
% Christian Sherland
% Sameer Chauhan
% Michael Scibor
%
% adClassify.m
%   Trains a tree bagger classifier with the data set found 
%   at:
%
%   Prompts user to specify a web url. Extracts images from that
%   url and classifies images as ad/not ad.
%
%   Outputs classifications after execution so that user
%   can check the accuracy 
%

clear all
close all
clc

%% Read training data

fprintf('Training a classifier ... ');

[adData, adLabel] = getData();
dataSet = prtDataSetClass(adData, adLabel);

fprintf('Done.');

%% Train a tree bagger classifier

fprintf('Training the classifier ... ')

adClassifier = prtClassMatlabTreeBagger; 
adClassifier.internalDecider = prtDecisionMap;

fprintf('Done\n\n')

%% Get user input and data

url = input('Specify a url: ','s');
cmd = horzcat('python extractFeatures.py ', url);
system(cmd);

%% Classify data and write output

fprintf('Reading testing data ... ')

testDataFile = 'urlData.csv';
testData = csvread(testDataFile);
testSet  = prtDataSetClass(adData);
adClassifier.run(testSet)

fprintf('Done.')