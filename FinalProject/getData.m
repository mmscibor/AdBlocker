function [data, labels] = getData()
%GETDATA reads data from input files and parses it into
% the variables data and labels, where data corresponds
% to the boolean features and labels corresponds to the
% correct class labels
%
% Authors: Christian Sherland
%          Sameer Chauhan
%          Michael Scibor
%

adDataFile  = 'Ad Data/adData2.txt';
fileContents = csvread(adDataFile,1,1);
data   = fileContents(:,1:end-1);
labels = fileContents(:,end);

end

