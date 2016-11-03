% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
% num_features = min(size(features1, 1), size(features2,1));


% ------- Direct distance implementation ---------- %
nnthreshold = 0.9991;

nnratio = zeros(size(features1,1),1);
nnfeatindex = zeros(size(features1,1),2);
i1 = size(features1,1);
i2 = size(features2,1);

dist = pdist2(features1,features2);
[sortdist, sortindex] = sort(dist,2,'ascend');
nnratio(:) = sortdist(:,1)./sortdist(:,2);

nnfeatindex(:,1) = [1:size(features1)];
nnfeatindex(:,2) = sortindex(:,1);

nn_th = nnratio < nnthreshold;

nn_thindex = find(nn_th);
matches = [nnfeatindex(nn_thindex,1), nnfeatindex(nn_thindex,2)];    
confidences = nnratio(nn_thindex);
% ------- --------------------- ---------- %


% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.

[confidences, ind] = sort(confidences, 'ascend');
confidences = flip(confidences(1:100));
ind = flip(ind(1:100));
matches = matches(ind,:);
