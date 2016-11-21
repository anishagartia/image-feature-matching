# Local Feature Matching of images using SIFT

In this project, we implemented Harris Corner Detector to get interest points corresponding to corner pixels. Designed to detect corners in multiple scales of the image. Implemented SIFT algorithm for obtaining local feature descriptor of the corner points found earlier. Each corner point is described using Histogram of Gradients (HoG) of image patches surrounding it. Implemented Feature Matching using nearest 
distance matching, and KNN search using k-d tree. 

1. Harris corner detection: uncomment function call get_interest_points
2. Adaptive non-maximal suppression: uncomment call get_interest_points_anms
3. scaling: uncomment function call get_interest_points_scaling and get_features_scaling
4. knnsearch: uncomment function call match_features_knnsearch

The results, analysis and visualization of the project can be found on the html page:  
http://htmlpreview.github.io/?https://github.com/anishagartia/image-feature-matching/blob/master/html/index.html
