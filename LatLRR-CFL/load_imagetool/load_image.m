function imgs = load_image(paths)

imgs = cell(size(paths));
for i = 1:numel(paths)
    X = imread(paths{i});
    if size(X, 3) == 3 % we extract our features from Y channel
%         X = rgb2ycbcr(X);
%         X = X(:, :, 1);
        A_YUV=ConvertRGBtoYUV(X);   
        imgs{i}=A_YUV(:,:,1); 
    else
         imgs{i} = X;   
    end
%     X = im2single(X); % to reduce memory usage

end
