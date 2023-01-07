function output = laplacian(I)
    L = [0 -1 0; -1 4 -1; 0 -1 0];
    Lum = rgb2lab(I);
    Lum = Lum(:,:,1);
    %Lum = rgb2gray(I);
    output = abs(imfilter(Lum, L, "replicate", "same"));
end