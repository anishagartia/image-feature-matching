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

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

%Placeholder that you can delete. Empty features.%

features = zeros(size(x,1), 128);
impatch_or = zeros(feature_width,feature_width,size(x,1));
image_filtered = zeros(size(image));
imgrad_mag = zeros(size(image));
imgrad_orient = zeros(size(image));
imghist = zeros([size(x,1), (feature_width/4)^2 * 8 ]);

% Create Gaussian filter
Sigma = 0.5;
Hsize = 3; 
H = fspecial('gaussian', Hsize,Sigma);

% Filter image with gaussian, and take gradient 
image_filtered = imfilter (image, H,'symmetric','same','conv');
[imgrad_mag , imgrad_orient] = imgradient(image_filtered, 'sobel');

% Create blockproc function for histcounts
fun = @(block_struct) histcounts(block_struct.data, [-180:45:180]);

%Create 16x16 image patches around interest points
for i = 1:size(x,1)   
    impatch_or(:,:,i) = imgrad_orient((y(i)-7):(y(i)+8),(x(i)-7):(x(i)+8));    
    hist_temp = blockproc(impatch_or(:,:,i),[feature_width/4 feature_width/4], fun);
    imghist(i,:) = reshape(hist_temp',[1 (8*(feature_width/4)^2)]);
    
    imghist(i,:) = imghist(i,:)/norm(imghist(i,:),2);
    tempy = find(imghist(i,:) > 0.2);
    imghist(i,tempy) = 0.2;
    imghist(i,:) = imghist(i,:)/norm(imghist(i,:),2);
end

% for i = 1:size(y,1)
%     features(i,:) = reshape(impatch(:,:,i),[1 256]);
% end
%impatch = reshape(impatch,[16*16, size(y,1)]);


% Filter the patches using the above gaussian filter
%image_filtered = imfilter (impatch, H,'symmetric','same','conv');

% Find gradient of each 4x4 cell of each patch
% indx_st = [1:4:feature_width];
% indx_end = [4:4:feature_width];
% 
% indy_st = [1:4:feature_width];
% indy_end = [4:4:feature_width];

%hist_ind = 1;

% for k = 1:size(y,1)
%     [imgrad_mag(:,:,k) , imgrad_or(:,:,k)] = imgradient(image_filtered(:,:,k), 'sobel');
%     hist_ind = 1;
%     for i = 1:feature_width/4
%         for j = 1:feature_width/4
%            %[imgrad_mag(indx_st(i):indx_end(i),indy_st(j):indy_end(j),k), imgrad_or(indx_st(i):indx_end(i),indy_st(j):indy_end(j),k)] = imgradient( image_filtered(indx_st(i):indx_end(i),indy_st(j):indy_end(j),k), 'sobel' );
%            imghist(k,hist_ind:hist_ind + 7) = histcounts(imgrad_or(indy_st(i):indy_end(i),indx_st(j):indx_end(j),k) , [-180:45:180]);
%            hist_ind = hist_ind + 8;
%         end
%     end
%     imghist(k,:) = imghist(k,:)/norm(imghist(k,:),2);
%     tempy = find(imghist(k,:) > 0.2);
%     imghist(k,tempy) = 0.2;
%     imghist(k,:) = imghist(k,:)/norm(imghist(k,:),2);
% end

% fun = @(block_struct) histcounts(block_struct, [-180:45:180]);
% img_hist = zeros(size(image_filtered));
% for k = 1:size(y)
%     [imgrad_mag(:,:,k) , imgrad_or(:,:,k)] = imgradient(image_filtered(:,:,k), 'sobel');
%     hist_count = blockproc(imggrad_or(:,:,k),[feature_width/4 feature_width/4], fun);
% end

% indx_st(1:4) = 1;
% indx_st(5:8) = 5;
% indx_st(9:12) = 9;
% indx_st(13:16) = 13;
% indx_end = indx_st + 3;
% 
% indy_st = [1:4:feature_width];
% indy_st = repmat(indy_st,[1,4]);
% indy_end = indy_st + 3;
% indhist_st = [1:8:8*4];
% indhist_end = [9:8:8*4+1];
% 
% for k = 1:size(y)
%     [imgrad_mag(indx_st:indx_end,indy_st:indy_end,k), imgrad_or(indx_st:indx_end,indy_st:indy_end,k)] = imgradient( image_filtered(indx_st:indx_end,indy_st:indy_end,k), 'sobel' );
%     imhist([1:4],indhist_st:indhist_end) = histcounts(imgrad_or(indx_st:indx_end,indy_st:indy_end,k) , [-180:45:180]);
% end

features = imghist;

end








