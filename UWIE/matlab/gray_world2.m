function output = gray_world2(I)
    I_lin = rgb2lin(I);
    percentiles = 5;
    illuminant = illumgray(I_lin, percentiles);
    I_lin = chromadapt(I_lin,illuminant, 'ColorSpace', 'linear-rgb');
    output = abs(lin2rgb(I_lin));
end