Ad Blocker
==========

The ad blocker project attempts an alternative approach to blocking advertisements than black / white listing. Instead of 
that, it takes as an input training data in the form of binary features of the metadata of various elements on a given
webpage. In the training data, it is known whether an element is or is not an ad.

The feature space in the training data, however, it extremely large and much of it is redundant and not helpful.

The initial portion of this project attempts to cut down the feature space using various methods: a PRT function in MATLAB
eliminates features based on an elimination criterion, however, very good results were also obtained by finding the correlation between the correct classification and that particular binary feature, then selecting those features with the greatest correlations.

This step was necessary because the training time on the algorithm utilized was initially very high, however the improvements made on the percentage of correctly sorted advertisements was not substantial enough to merit use of all the features.

The algorithm utilized was the TreeBagger algorithm, provided by the PRT toolikit in MATLAB. 

The benefits of utilizing such an algorithm instead of a black / white list is that it needs to be maintained less, can be improved by expanding the training data (allow a user to mark an ad if it gets through, and that will automatically update the training data for all users). 

The training phase, depending on the processing power of the machine, would last at most a few minutes, however after training is complete, classification is near instant.

Authors
-------

-Christian Sherland
-Michael Scibor
-Sameer Chauhan
