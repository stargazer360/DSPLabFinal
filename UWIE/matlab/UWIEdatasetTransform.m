
% dataDir = "C:\Course\DSPFinalProject\DeepFishSet\DeepFishDataSetModV2\Localization\images\empty\";
% dataDir = "C:\Course\DSPFinalProject\DeepFishSet\DeepFishDataSetModV2\Localization\images\valid\";
% dataDir = "C:\Course\DSPFinalProject\DeepFishSet\DeepFishDataSetModV2\Segmentation\images\empty\";
dataDir = "C:\Course\DSPFinalProject\DeepFishSet\DeepFishDataSetModV2\Segmentation\images\valid\";

lis = dir(dataDir);
len = length(lis);
checkPoint = 0;
i = 0;
for i = 1:len
    if not(lis(i).isdir)
        fileName = dataDir + lis(i).name;
        image = imread(fileName);
        imageMod = UnderWaterEnhance(image);
        imwrite(imageMod, fileName);
        if (i > checkPoint)
            fprintf("Progress %g\n", i / len);
            checkPoint = checkPoint + floor(len / 10);
        end
    end
end

