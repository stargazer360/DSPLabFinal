clc;
clear all;
refDir = "C:\Course\DSPFinalProject\reference-890\";
rawDir = "C:\Course\DSPFinalProject\raw-890\";
resDir = "C:\Course\DSPFinalProject\result\result_multi_white\";
lis = dir(rawDir);
len = length(lis);
checkPoint = 0;
A = ones(len, 3);
for i = 1:len
    if not(lis(i).isdir)
        rawName = rawDir + lis(i).name;
        refName = refDir + lis(i).name;
        resName = resDir + lis(i).name;
        raw_image = imread(rawName);
        ref_image = imread(refName);
        imageMod = UnderWaterEnhance(raw_image, 1);
        imwrite(imageMod, resName)
        A(i, :) = multissim(im2uint8(imageMod), ref_image);
        % A(i, :) = multissim(raw_image, ref_image);
        if (i > checkPoint)
            fprintf("Progress %g\n", i / len);
            checkPoint = checkPoint + floor(len / 10);
        end
    end
end
writematrix(A,(resDir+"ssim.csv"))
