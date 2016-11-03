% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% This function is provided for development and debugging but cannot be
% used in the final handin. It 'cheats' by generating interest points from
% known correspondences. It will only work for the three image pairs with
% known correspondences.

% 'eval_file' is the file path to the list of known correspondences.
% 'scale_factor' is needed to map from the original image coordinates to
%   the resolution being used for the current experiment.

% 'x1' and 'y1' are nx1 vectors of x and y coordinates of interest points
%   in the first image.
% 'x1' and 'y1' are mx1 vectors of x and y coordinates of interest points
%   in the second image. For convenience, n will equal m but don't expect
%   that to be the case when interest points are created independently per
%   image.
function [x1, y1, x2, y2] = cheat_interest_points(eval_file, scale_factor)

load(eval_file)

x1 = x1 .* scale_factor;
y1 = y1 .* scale_factor;
x2 = x2 .* scale_factor;
y2 = y2 .* scale_factor;

end

