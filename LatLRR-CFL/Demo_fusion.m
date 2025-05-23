clear all
clc
addpath(genpath(cd));

%% Fusion
method = {'latlrr_cfl_average'};
params.method = method;
test_image=mygetdirfiles('test_images');
test_imagecell=load_image(test_image);
index_a = 1:2:size(test_imagecell);
index_b = 2:2:size(test_imagecell);
A=cell(size(index_a,2),1);
B=cell(size(index_b,2),1);
k = 1;%%显示方法
t = 1;%%控制方法行数
q = 1;
m = 1;%%sheet
for i = 1:numel(test_imagecell)/2
    f = test_image{index_a(i)};
    [p, n, x] = fileparts(f);
    params.p = p;
    params.n = n;
    params.x1 = x;
    xlswrite('time.xls',{n},m,['A',num2str(t)]);
    xlswrite('time.xls',method',m,['A',num2str(t+1)]);
    A{i}=test_imagecell{index_a(i)};
    B{i}=test_imagecell{index_b(i)};

    tic;
    y_F_latlrr_cfl{i}=latlrr_cfl_Fusion(A{i},B{i});
     time_latlrr_cfl=toc;
    xlswrite('time.xls', time_latlrr_cfl,m,['B',num2str(t+1)]);
   
    t = t + size(method,2) + 1;
    q = q + 3;
    k = 1;
%%%将各种方法所得到的融合图像放到同一个大的矩阵中
   result = cat(3,y_F_latlrr_cfl{i});
   conf.fusion_image{i} = {};
%%%%将融合图像写入到指定的文件夹里
   for j = 1:numel(method)
        conf.fusion_image{i}{j} = fullfile(p, 'results', [n sprintf('[%d-%s]', j, method{j}) x]);
        imwrite(uint8(result(:, :, j)), conf.fusion_image{i}{j});%%%%将各种方法的结果放到result文件夹中
    end
end


