function output = white_balance(I, p, t)
    switch t
        case 1 % native gray world
            output = gray_world(I);
        case 2 % red/blue channel compensation gray world
            mean_I = mean(I, [1 2]);
            mean_I = mean_I(:); 
            I(:,:,1) = I(:,:,1) + p(1) .* (1 - I(:,:,1)) .* (mean_I(2) - mean_I(1)) .* I(:,:,2);    % red compensation
            I(:,:,3) = I(:,:,3) + p(2) .* (1 - I(:,:,3)) .* (mean_I(2) - mean_I(3)) .* I(:,:,2);    % blue compensation
            I = double(I <= 1.0).*I + double(I > 1.0);
            output = gray_world(I);
            output = double(output <= 1.0).*output + double(output > 1.0);
    end
    
end