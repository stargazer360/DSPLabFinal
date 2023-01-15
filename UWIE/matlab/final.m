close all
clear all
clc
%% load 'Im.jpg'
frame = imread('test13.jpg');
frame_N = im2single(frame);
frame_N = imresize(frame_N, 1);
%% Variables
alpha = [2, 1];
w_type = 2;
gamma = 1.5;
s_type = 1;
sigma = 10;     % 30
n_x_sigma = 10; % 10
delta = 0.1;
level = 3;
%% White balance
tic
I = white_balance(frame_N, alpha, w_type);
%% Gamma correction
input1 = gamma_correct(I, gamma);
%% Sharpen image
% g = fspecial('gaussian', max(1, floor(2 * n_x_sigma * sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma
g = fspecial('gaussian', max(1, 2 * ceil(2 * sigma) + 1), sigma);
I_g = imfilter(I, g, "replicate", "same");
input2 = (I + normalizer(I - I_g, 1, [0, 1]))/2;
%% Laplacian
l1 = laplacian(input1);
l2 = laplacian(input2);
% saliency
sal1 = saliency(input1);
sal2 = saliency(input2);
% saturation
sat1 = saturation(input1, s_type);
sat2 = saturation(input2, s_type);
% Combine map
W1 = l1+sal1+sat1;
W2 = l2+sal2+sat2;
WN1 = (W1+delta)./(W1+W2+2*delta);
WN2 = (W2+delta)./(W1+W2+2*delta);
toc
%% Native fusion
R = I;
R(:, :, 1) = WN1.*input1(:, :, 1) + WN2.*input2(:, :, 1);
R(:, :, 2) = WN1.*input1(:, :, 2) + WN2.*input2(:, :, 2);
R(:, :, 3) = WN1.*input1(:, :, 3) + WN2.*input2(:, :, 3);
%% Multiscale fusion
tic
I_LP1 = l_pyramid(input1, level, 0.5, n_x_sigma);
W_GP1 = g_pyramid(WN1, level, 0.5, n_x_sigma);
I_LP2 = l_pyramid(input2, level, 0.5, n_x_sigma);
W_GP2 = g_pyramid(WN2, level, 0.5, n_x_sigma);
R_P = cell(level, 1);
for i = 1:level
    R_P{i, 1} = W_GP1{i, 1}.*I_LP1{i, 1}+W_GP2{i, 1}.*I_LP2{i, 1};
end
% reconstruction from multiscale
result = R_P{1};
i_size = size(R_P{1});
for i = 2:(level)
    result = result + imresize(R_P{i}, [i_size(1) i_size(2)]);
end
toc
%% Display
close all
show_image(frame_N, 0);
% show_image(I, 0);
% show_image(R, 0);
show_image(result, 0);
imwrite(result, 'out1.jpg')

%% increase contrast
sigma = 20;
g = fspecial('gaussian', max(1, 2 * ceil(2 * sigma) + 1), sigma);
temp = result - 0.4 * imfilter(result, g, "replicate", "same");
temp = normalizer(temp, 1, [0, 1]);
show_image(temp, 0);
imwrite(temp, 'out2.jpg')