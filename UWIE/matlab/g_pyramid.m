function output = g_pyramid(I, Level, scale, n_x_sigma) % return a cell array of laplacian pyramid
    gamma = 1/(2*scale);
    g = fspecial('gaussian', max(1, floor(2 * n_x_sigma * gamma)), gamma);
    output = cell(Level, 1);
    I_S = I;
    for i = 1:(Level-1)
        I_G = imfilter(I_S, g, "replicate", "same");
        output{i, 1} = I_G;
        I_S = imresize(I_G, scale);
    end
    output{Level, 1} = I_S;
end