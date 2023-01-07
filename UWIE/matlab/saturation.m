function output = saturation(I, mode) 
    if mode == 1
        Lum = rgb2gray(I);
    else
        Lum = rgb2lab(I);
        Lum = Lum(:,:,1);
    end
    output = sqrt(((I(:,:,1) - Lum).^2 + (I(:,:,2) - Lum).^2 + (I(:,:,3) - Lum).^2) / 3);
end
