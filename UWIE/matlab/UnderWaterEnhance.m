function output = UnderWaterEnhance(image)
%     alpha = [2, 1];     % white balance parameter
%     w_type = 2;         % white balance type
%     gamma = 2;          % gamma correction
%     s_type = 1;         % saturation type
%     sigma = 10;         % sigma of gaussian filter
%     n_x_sigma = 10;     % pyramid parameter
%     delta = 0.1;        % small num to avoid div 0
%     level = 3;          % pyramid level

    alpha = [2, 1];     % white balance parameter
    w_type = 2;         % white balance type
    gamma = 1.5;          % gamma correction
    s_type = 1;         % saturation type
    sigma = 10;         % sigma of gaussian filter
    n_x_sigma = 10;     % pyramid parameter
    delta = 0.1;        % small num to avoid div 0
    level = 3;          % pyramid level

    image = im2single(image);
    I = white_balance(image, alpha, w_type);
    
    input1 = gamma_correct(I, gamma);
    
    g = fspecial('gaussian', max(1, 2 * ceil(2 * sigma) + 1), sigma);
    I_g = imfilter(I, g, "replicate", "same");
    input2 = (I + normalizer(I - I_g, 1, [0, 1]))/2;

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

    output = result;
    