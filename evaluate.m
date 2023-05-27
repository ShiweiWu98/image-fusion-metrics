clear all;
close all;
clc;

disp('Start');
disp('---------------------------Analysis---------------------------');
addpath('D:\A_My_Files\Project\ImageProcessingMatlab\analysis_MatLab');
addpath('D:\A_My_Files\Project\ImageProcessingMatlab\analysis_MatLab/vif');
img_format = '*.png';
vis_path = 'D:\Experiment\IV_images\VIS\';
vis_list = dir(fullfile(vis_path,img_format));
vis_list = sort_nat({vis_list.name});

ir_path = 'D:\Experiment\IV_images\IR\';
ir_list = dir(strcat(ir_path,img_format));
ir_list = sort_nat({ir_list.name});

fusion_path = 'D:\A_My_Files\my_model\DeepNet\result\model_100.0winssim_0.0int_1.0tv_iter20_nonconcate\';
fusion_list = dir(strcat(fusion_path,img_format));
fusion_list = sort_nat({fusion_list.name});

image_num = length(vis_list);
mat = struct([]);
mat{1,1} = 'name';
mat{1,2} = 'EN';
mat{1,3} = 'SD';
mat{1,4} = 'MI';
mat{1,5} = 'Qabf';
mat{1,6} = 'FMI_pixel';
mat{1,7} = 'FMI_dct';
mat{1,8} = 'FMI_w';
mat{1,9} = 'Nabf';
mat{1,10} = 'SCD';
mat{1,11} = 'SSIM';
mat{1,12} = 'MS_SSIM';
mat{1,13} = 'EPI';
mat{1,14} = 'AG';
mat{1,15} = 'SF';
mat{1,16} = 'VIF';
mat{1,17}='CC';
n=1;
for i=1:image_num
    % read image
    fusion_name = fusion_list(i);
    fusion_file = strcat(fusion_path,fusion_name);
    image_f=imread(cell2mat(fusion_file));
    ir_name = ir_list(i);
    ir_file = strcat(ir_path,ir_name);
    image_ir=imread(cell2mat(ir_file));
    vis_name = vis_list(i);
    vis_file = strcat(vis_path,vis_name);
    image_vis=imread(cell2mat(vis_file));
    
    % Convert to single channel
    if size(image_ir, 3)~=1
        image_ir  = rgb2gray(image_ir);
    end
    if size(image_vis, 3)~=1
        image_vis = rgb2gray(image_vis);
    end
    if size(image_f, 3)~=1
        image_f = rgb2gray(image_f);
    end
    [s1,s2] = size(image_ir);
    imgSeq = zeros(s1, s2, 2);
    imgSeq(:, :, 1) = image_ir;
    imgSeq(:, :, 2) = image_vis;
    
    AG = AG_evaluation(image_f);
    SF = SF_evaluation(image_f);
    SD = SD_evaluation(image_f);
    
    image1 = im2double(image_ir);
    image2 = im2double(image_vis);
    image_fused = im2double(image_f);
    
    %EN
    EN = entropy(image_fused);
    %MI
    MI = analysis_MI(image_ir,image_vis,image_f);
    %Qabf
    Qabf = analysis_Qabf(image1,image2,image_fused);
    %FMI
    FMI_pixel = analysis_fmi(image1,image2,image_fused);
    FMI_dct = analysis_fmi(image1,image2,image_fused,'dct');
    FMI_w = analysis_fmi(image1,image2,image_fused,'wavelet');
    %Nabf
    Nabf = analysis_Nabf(image_fused,image1,image2);
    %SCD
    SCD = analysis_SCD(image1,image2,image_fused);
    % SSIM_a
    SSIM1 = ssim(image_fused,image1);
    SSIM2 = ssim(image_fused,image2);
    SSIM = (SSIM1+SSIM2)/2;
    %MS_SSIM
    [MS_SSIM,t1,t2]= analysis_ms_ssim(imgSeq, image_f);
    %EPI
    EPI = (analysis_EPI(image1, image_fused)+analysis_EPI(image2, image_fused))/2;
    %VIF
    VIF = (vifvec(image1, image_fused)+vifvec(image2, image_fused))/2;
    CC=CC_evalution(image1,image2,image_fused);
    mat{i+1,1}=fusion_name;
    mat{i+1,2} = EN;
    mat{i+1,3} = SD;
    mat{i+1,4} = MI;
    mat{i+1,5} = Qabf;
    mat{i+1,6} = FMI_pixel;
    mat{i+1,7} = FMI_dct;
    mat{i+1,8} = FMI_w;
    mat{i+1,9} = Nabf;
    mat{i+1,10} = SCD;
    mat{i+1,11} = SSIM;
    mat{i+1,12} = MS_SSIM;
    mat{i+1,13} = EPI;
    mat{i+1,14} = AG;
    mat{i+1,15} = SF;
    mat{i+1,16} = VIF;
    mat{i+1,17} = CC;
    fprintf('已经处理%d张图片\n',n);
    n=n+1;
end
save(strcat(fusion_path,'metrics.mat'),'mat');
xlswrite(strcat(fusion_path,'metrics.xlsx'),mat);
disp('Done');
