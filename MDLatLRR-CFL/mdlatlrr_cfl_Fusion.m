function F = mdlatlrr_cfl_Fusion(image1,image2,D0,opts,norm,L)

img1 = im2double(image1);
img2 = im2double(image2);
[h,w] = size(image2);
F = zeros(h,w);
                is_block = 0;
                tic
                if h>512 || w>512
                    % get image block
                    is_block = 1;
                    [img1_1, img1_2, img1_3, img1_4] = getImgBlock(img1);
                    [img2_1, img2_2, img2_3, img2_4] = getImgBlock(img2);
                end
                if is_block == 1
                    F_1 = vector_fusion_method(img1_1, img2_1, L, unit, isZCA, de_level, norm, is_overlap, stride,D0,opts);
                    F_2 = vector_fusion_method(img1_2, img2_2, L, unit, isZCA, de_level, norm, is_overlap, stride,D0,opts);
                    F_3 = vector_fusion_method(img1_3, img2_3, L, unit, isZCA, de_level, norm, is_overlap, stride,D0,opts);
                    F_4 = vector_fusion_method(img1_4, img2_4, L, unit, isZCA, de_level, norm, is_overlap, stride,D0,opts);
                    F = reconsFromBlock(F,F_1, F_2,F_3, F_4);
                elseif is_block == 0
                    F = vector_fusion_method(img1, img2, L, unit, isZCA, de_level, norm, is_overlap, stride,D0,opts);
                end



F=uint8(F*255);