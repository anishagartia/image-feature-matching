% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale] = get_interest_points_scaling(image, feature_width)

scale_val = 0.5 .^[0:2];

for i = 1:size(scale_val,2)
    image1 = imresize(image, scale_val(i));
    [x1, y1, confidence1] = get_interest_points(image1,feature_width, scale_val(i));
    if (i == 1)
        x = x1;
        y = y1;
        scale = scale_val(i) * ones(size(y1,1),1);
        confidence = confidence1;
    else
        x = [x;x1];
        y = [y;y1];
        
        scale1 = scale_val(i) * ones(size(y1,1),1);
        scale = [scale;scale1]; 
        
        confidence = [confidence;confidence1];
    end


end

