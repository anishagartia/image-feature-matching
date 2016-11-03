% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features_scaling(image, x, y, feature_width, scale)

scale_val = 0.95 .^[0:5];
for i = 1:size(scale_val,2)
    image1 = imresize(image,scale_val(i));
    scale1 = (scale == scale_val(i));
    [ind1, ind2] = find(scale1);
    x1 = x(ind1);
    y1 = y(ind1);
    features1 = get_features(image1, x1,y1,feature_width);
   if (i == 1)
       features = features1;
   else
       features = [features; features1];               
   end


end








