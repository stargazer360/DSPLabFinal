function output = normalizer(I, type, range)
    m = range(1);
    M = range(2);
    if type == 1
        output = rescale(I, m, M);
    else
        output = I;
        for i = 1:type
            output(:, :, i) =  rescale(I(:, :, i), m, M);
        end
    end
end