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
function [x, y, confidence] = get_interest_points(image, feature_width, scale)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete -- random points
%x = ceil(rand(500,1) * size(image,2));
%y = ceil(rand(500,1) * size(image,1));

SIGMA = 0.5;
alpha = 0.05;

%HSIZE = (ceil(4*SIGMA +1));
HSIZE = 3;

H = fspecial('gaussian',HSIZE,SIGMA);
[Hx, Hy] = imgradientxy(H, 'sobel');

Ix = imfilter(image, Hx, 'symmetric', 'same', 'conv');
Iy = imfilter(image, Hy, 'symmetric', 'same', 'conv');

Ix_sq = Ix.*Ix;
Iy_sq = Iy.*Iy;

IxIy = Ix.*Iy;

SIGMA = 1;
%HSIZE = (ceil(4*SIGMA +1));
HSIZE = 3;

H = fspecial('gaussian',HSIZE,SIGMA);

gIx_sq = imfilter(Ix_sq,H,'symmetric','same', 'conv');
gIy_sq = imfilter(Iy_sq,H,'symmetric','same', 'conv');
gIxIy = imfilter(IxIy,H,'symmetric','same', 'conv');

% Computing Corneryness 
R = gIx_sq.*gIy_sq - (gIxIy .* gIxIy) - alpha*((gIx_sq + gIy_sq).*(gIx_sq + gIy_sq));


%% ---------------------------- Harris corner detection --------------------------------- %
% % Thresholding 
 Rthreshold = 1.54e-3 * scale; %NotreDame
% Rthreshold = 1.54e-2 * scale; %Rushmore
R_th = R > Rthreshold;
R_th2 = R .* R_th;
% 
% % % Non-maximum suppression
R_nms = imregionalmax(R_th2);
R_nms2 = R .* R_nms;

eq = (R_th2 == R_nms2);
R_th_nms = eq .* R_nms2;

[y,x, confidence] = find(R_th_nms > 0);

%[y,x, confidence] = find(R_th > 0);

low_ind = feature_width/2 - 1;
high_ind = feature_width/2;

ind_rmx = find ((x-low_ind) < 1);
x(ind_rmx) = [];
y(ind_rmx) = [];
ind_rmy = find((y-low_ind) < 1);
x(ind_rmy) = [];
y(ind_rmy) = [];
ind_rmx = find ((x+high_ind) > size(image,2));
x(ind_rmx) = [];
y(ind_rmx) = [];
ind_rmy = find ((y+high_ind) > size(image,1));
x(ind_rmy) = [];
y(ind_rmy) = [];
% -------------------------------------------------- %



end

