function show_img(I, is_norm)
    figure();
    if is_norm == 1
        I = normalize(I);
    end
    imshow(I);
    
end