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
function [matches, confidences] = match_features_knnsearch(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
% num_features = min(size(features1, 1), size(features2,1));

% ------- kdtree implementation ---------- %
[idx ,d] = knnsearch(features1,features2,'K', 2, 'NSMethod', 'kdtree');
matches = [idx(:,1) , [1:size(features2,1)]'];
confidences = d(:,1)./d(:,2);
% ------- --------------------- ---------- %


% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.

[confidences, ind] = sort(confidences, 'ascend');
confidences = flip(confidences(1:100));
ind = flip(ind(1:100));
matches = matches(ind,:);
