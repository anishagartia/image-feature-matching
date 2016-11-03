% Automated Panorama Stitching stencil code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu <henryhu@gatech.edu> and James Hays

% Visualizes corresponding points between two images. Corresponding points
% will be matched by a line of random color.

% This function provides another method of visualization. You can use
% either this function or show_correspondence.m

% You do not need to modify anything in this function, although you can if
% you want to.
function [ h ] = show_correspondence2(imgA, imgB, X1, Y1, X2, Y2)

h = figure(3);
Height = max(size(imgA,1),size(imgB,1));
Width = size(imgA,2)+size(imgB,2);
numColors = size(imgA, 3);
newImg = zeros(Height, Width,numColors);
newImg(1:size(imgA,1),1:size(imgA,2),:) = imgA;
newImg(1:size(imgB,1),1+size(imgA,2):end,:) = imgB;
imshow(newImg, 'Border', 'tight')
shiftX = size(imgA,2);
hold on
% set(h, 'Position', [100 100 900 700])
for i = 1:size(X1,1)
    cur_color = rand(3,1);
    plot([X1(i) shiftX+X2(i)],[Y1(i) Y2(i)],'*-','Color', cur_color, 'LineWidth',2)
end
hold off

fprintf('Saving visualization to vis.jpg\n')
visualization_image = frame2im(getframe(h));
% getframe() is unreliable. Depending on the rendering settings, it will
% grab foreground windows instead of the figure in question. It could also
% return an image that is not 800x600 if the figure is resized or partially
% off screen.
% try
%     %trying to crop some of the unnecessary boundary off the image
%     visualization_image = visualization_image(81:end-80, 51:end-50,:);
% catch
%     ;
% end
imwrite(visualization_image, 'vis_arrows.jpg', 'quality', 100)