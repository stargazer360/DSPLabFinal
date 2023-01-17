clear
video = VideoReader('temp_video.mp4');
frameInterval = [4256, 4856];
frames = read(video, frameInterval);

outputVideo = VideoWriter('non_turbid2.avi');
outputVideo.FrameRate = video.FrameRate;
open(outputVideo);

for i = 1:(frameInterval(2) - frameInterval(1))
    if any(frames(:, :, :, i))
        modImage = [UnderWaterEnhance(frames(:, :, :, i), 0), im2single(frames(:, :, :, i))];
    else
        modImage = im2single([frames(:, :, :, i), frames(:, :, :, i)]);
    end
    writeVideo(outputVideo, modImage);
    disp(i);
end

close(outputVideo)