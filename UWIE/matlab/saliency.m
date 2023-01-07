function output = saliency(I)
    I = rgb2lab(I);
    mean_I = mean(I, [1 2]);
    mean_I = mean_I(:);
    f = [1 4 6 4 1] / 16;
    g = f' * f;
    I_g = imfilter(I, g, "replicate", "same");
    output = sqrt((mean_I(1) - I_g(:,:,1)).^2+(mean_I(2) - I_g(:,:,2)).^2+(mean_I(3) - I_g(:,:,3)).^2);
end