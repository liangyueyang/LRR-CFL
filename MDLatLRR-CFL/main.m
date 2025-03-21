clear all
clc
addpath(genpath(cd));
disp('----------vector_main------------');
% load matrices
load('./models/L_8_detail_mix_2000_s1000.mat');
load('./models/L_16_detail_mix_2000_s1000.mat');

% 0 - without zca, 1 - use zca
isZCA = 0;
is_overlap = 1;
opts.T = 3; % number of nonzer entries in sparse vectors
opts.rho = 5; % penalty parameter
opts.print_res = true; % print decomposition results
%% performing decomposition and fusion
n = 16; % number of atoms in dictionaries
b = 8; % patch size
D0 = DCT(n,b);  % initializing the dictionaries with DCT matrices
% parameters setting
stride_cell = {1,2,4,6,8,10,12,14}; % for 16*16. In our paper is 1.
[n_s, m_s] = size(stride_cell);
norm_cell = {'l1', 'nu'}; % l1 - l1 norm; nu - nuclear norm. In our paper is nuclear norm.
[n_norm, m_norm] = size(norm_cell);
L_cell = {'8', '16'}; % projecting matrix. In our paper is 16.
[n_L, m_L] = size(L_cell);
level_cell = {1,2,3,4,5,6,7,8}; % decomposition level. In our paper is 1 to 4.
[n_le, m_le] = size(level_cell);

for s=1:1
stride = stride_cell{s}; 
% l1, nu
for kk=2:m_norm
    norm = norm_cell{kk};
    %%%%% 8, 16 %%%%%%%%%%%%%%%
    for k=2:m_L
        eval(['L = L_', L_cell{k}, ';'])
        unit = str2double(L_cell{k});
        % decomposition level 1 - 8
        for jj=1:4
            de_level = level_cell{jj};
            str_t = ['L_',L_cell{k},'; level: ',num2str(de_level),'; norm: ',norm, '; stride: ', num2str(stride)];
            disp(str_t);
            t = 0;
            for j=1:15
                index = j;
                path1 = ['./IV_images/IR',num2str(index),'.jpg'];
                path2 = ['./IV_images/VIS',num2str(index),'.jpg'];
                if is_overlap == 1
                    path_temp = './fused/';
                    if exist(path_temp,'dir')==0
                        mkdir(path_temp);
                    end
                    fuse_path = [path_temp, 'fused',num2str(index), '_mdlatlrr_level_',num2str(de_level),'_',norm,'_stride_',num2str(stride),'.jpg'];
                end
                if exist(fuse_path,'file')~=0
                    continue;
                end
                % Fusion
                img1 = imread(path1);
                img1 = im2double(img1);
                img2 = imread(path2);
                img2 = im2double(img2);
                [h,w] = size(img1);
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
                str_o = [str_t, '; index: ', num2str(index), '; time: ', num2str(toc)];
                disp(str_o);
                imwrite(F,fuse_path,'jpg');
            end
        end
    end
end
end
% end






