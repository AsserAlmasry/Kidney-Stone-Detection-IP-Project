% Final Project Asser
% KIDNEY STONE DETECTION USING MATLAB
clc;
clear;
close all;
warning off;

% Prompt for input file (image or video)
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.avi;*.mp4', 'Image and Video Files (*.jpg,*.jpeg, *.png, *.bmp, *.avi, *.mp4)'});
inputFile = fullfile(path, file);

% Check if the file is a video
[~, ~, ext] = fileparts(inputFile);
isVideo = any(strcmpi(ext, {'.avi', '.mp4'}));

if isVideo
    % Read the video
    videoObj = VideoReader(inputFile);
    
    % Extract the first frame
    frame = readFrame(videoObj);
    else
    % Read the input image
    frame = imread(inputFile);
end

figure;
t = tiledlayout(4, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
nexttile;
imshow(frame);
title('Original Frame');

% Convert the image RGB to GRAY
b = rgb2gray(frame);
nexttile;
imshow(b);
title('Grayscale Image');

% Binarize the image
c = b > 20;
nexttile;
imshow(c);
title('Binarized Image');

% Fill the holes
d = imfill(c, 'holes');
nexttile;
imshow(d);
title('Holes Filled');

% Remove unwanted parts
e = bwareaopen(d, 1000);
nexttile;
imshow(e);
title('Denoised Image');

% REPMAT function
PreprocessedImage = uint8(double(frame) .* repmat(e, [1, 1, 3]));
nexttile;
imshow(PreprocessedImage);
title('Preprocessed Image');

% Adjust the image
PreprocessedImage = imadjust(PreprocessedImage, [0.3 0.7], []) + 50;
nexttile;
imshow(PreprocessedImage);
title('Enhanced Image');

% Convert RGB to GRAY image
uo = rgb2gray(PreprocessedImage);
nexttile;
imshow(uo);
title('Gray Image After Preprocessing');

% Median filter
mo = medfilt2(uo, [5 5]);
nexttile;
imshow(mo);
title('Median Filtered');

% Removal of less intensity part
po = mo > 250;
nexttile;
imshow(po);
title('Thresholded for Intensity');

% Edge detection using Sobel, Prewitt, and Canny filters
sobelEdges = edge(mo, 'sobel');
prewittEdges = edge(mo, 'prewitt');
cannyEdges = edge(mo, 'canny');
nexttile;
imshow(sobelEdges);
title('Sobel Edges');
nexttile;
imshow(prewittEdges);
title('Prewitt Edges');
nexttile;
imshow(cannyEdges);
title('Canny Edges');

% Obtain the dimension of the image
[r, c] = size(po);
x1 = r / 2;
y1 = c / 3;
row = [x1 x1 + 200 x1 + 200 x1];
col = [y1 y1 y1 + 40 y1 + 40];

% ROI polynomial function
BW = roipoly(po, row, col);
nexttile;
imshow(BW);
title('ROI Mask');

% Mask the kidney stone area
k = po .* double(BW);
nexttile;
imshow(k);
title('Masked Kidney Stone Area');

M = bwareaopen(k, 4);
[~, number] = bwlabel(M);

if number >= 1
    disp('Stone is Detected in the kidney');
else
    disp('No Stone is detected in the kidney');
end
