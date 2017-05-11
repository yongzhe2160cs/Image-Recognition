function findMarkers()
% Global threshold
threshold=0.8;

% templateEdgeLen
templateEdgeLen=11;

% Resolution in the scale dimension of HG
scaleSteps =2;
% Minimum and maximum scale to be considered
scaleRange = [1,1.2];

% Resolution in the orientation dimension of HG
angleSteps = 23;
% Minimum and maximum angle
angleRange = [0, 2*pi];

% Filtersize to use when computing complex gradients
gradKernelSize = 1;         %e.g. 1.2

% Compute the test image and complex gradients (scale and rotate original)
testImg = imread('./img/markers_contrast.jpg');
if (length(size(testImg)) > 2)
    testImg = rgb2gray(testImg);
end
testImg = double(testImg);
gradImg = calcDirectionalGrad(testImg, gradKernelSize);

figure, imshow(abs(gradImg),[]);

% Compute the object template
template = makeMarkerTemplate(templateEdgeLen);

% Compute the Hough space
houghSpace = generalHough(gradImg, template, scaleSteps, scaleRange, angleSteps, angleRange);

% Vislualise the four dimensional Hough space
[a b c d ]= size(houghSpace);
result_hough = zeros(a,b);

for i = 1 : a 
   for j = 1 : b 
       C= max(houghSpace(i,j,:,:));
       result_hough(i,j) = max(C(:));
   end 
end    
figure,imshow(result_hough,[]);

[maxMask, maxInd]=findHoughMaxima(houghSpace, threshold);
figure,plotMarkerDetectionResult(testImg, template, maxInd, scaleSteps, scaleRange, angleSteps, angleRange);
