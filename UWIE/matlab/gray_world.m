function output = gray_world(I)
    I_c = I;
    mean_I_c = mean(I_c, [1 2]); 
    mean_I_c = mean_I_c(:);                 % mean of RGB channel
    % gray = sum(mean_I_c) / 3;               % mean of all
    gray = max(mean_I_c);
    scale = gray ./ mean_I_c;               % ratio of three channel

    output(:,:,1) = I_c(:,:,1) * scale(1);
    output(:,:,2) = I_c(:,:,2) * scale(2);
    output(:,:,3) = I_c(:,:,3) * scale(3);
end