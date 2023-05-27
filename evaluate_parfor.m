%并行计算各个指标，写入到csv文件中%
clear all;

disp('---------------------------Start---------------------------');
addpath('./vif');
addpath('./sort_nat');

% 图像格式
img_format = '*.png';

%可见光图像、红外图像、融合图像路径(以'\'结尾)
vis_path = 'D:\Experiment\IV_images\VIS\';
ir_path = 'D:\Experiment\IV_images\IR\';
fusion_path = 'D:\A_My_Files\my_model\DeepNet\result\model_1.0ssim_0.0int_1.0grad_iter20_concate\';

%将路径下所有文件名按顺序添加到list中
vis_list = dir(fullfile(vis_path,img_format));
vis_list = sort_nat({vis_list.name});
ir_list = dir(strcat(ir_path,img_format));
ir_list = sort_nat({ir_list.name});
fusion_list = dir(strcat(fusion_path,img_format));
fusion_list = sort_nat({fusion_list.name});

%计算指标
image_num = length(vis_list);
parfor i=1:image_num
    % 读取图像
    fusion_name = fusion_list(i);
    fusion_file = strcat(fusion_path,fusion_name);
    image_f=imread(cell2mat(fusion_file));
    ir_name = ir_list(i);
    ir_file = strcat(ir_path,ir_name);
    image_ir=imread(cell2mat(ir_file));
    vis_name = vis_list(i);
    vis_file = strcat(vis_path,vis_name);
    image_vis=imread(cell2mat(vis_file));
    
    % RGB->gray
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
    
    AG(i,1) = AG_evaluation(image_f);
    SF(i,1) = SF_evaluation(image_f);
    SD(i,1) = SD_evaluation(image_f);
    
    image1 = im2double(image_ir);
    image2 = im2double(image_vis);
    image_fused = im2double(image_f);
    
    %EN
    EN(i,1) = entropy(image_fused);
    %MI
    MI(i,1) = analysis_MI(image_ir,image_vis,image_f);
    %Qabf
    Qabf(i,1) = analysis_Qabf(image1,image2,image_fused);
    %FMI
    FMI_pixel(i,1) = analysis_fmi(image1,image2,image_fused);
    FMI_dct(i,1) = analysis_fmi(image1,image2,image_fused,'dct');
    FMI_w(i,1) = analysis_fmi(image1,image2,image_fused,'wavelet');
    %Nabf
    Nabf(i,1) = analysis_Nabf(image_fused,image1,image2);
    %SCD
    SCD(i,1) = analysis_SCD(image1,image2,image_fused);
    % SSIM_a
    SSIM1 = ssim(image_fused,image1);
    SSIM2 = ssim(image_fused,image2);
    SSIM(i,1) = (SSIM1+SSIM2)/2;
    %MS_SSIM
    [MS_SSIM(i,1),t1,t2]= analysis_ms_ssim(imgSeq, image_f);
    %EPI
    EPI(i,1) = (analysis_EPI(image1, image_fused)...
               +analysis_EPI(image2, image_fused))/2;
    %VIF
    VIF(i,1) = (vifvec(image1, image_fused)+vifvec(image2, image_fused))/2;
    CC(i,1) = CC_evalution(image1,image2,image_fused);
    
    LastName(i,1) = fusion_name;
    fprintf('已经处理第%d张图片\n',i);
end

% 计算各个指标的平均值
EN(image_num+1,1) = mean(EN);
SD(image_num+1,1) = mean(SD);
MI(image_num+1,1) = mean(MI);
Qabf(image_num+1,1) = mean(Qabf);
FMI_pixel(image_num+1,1) = mean(FMI_pixel);
FMI_dct(image_num+1,1) = mean(FMI_dct);
FMI_w(image_num+1,1) = mean(FMI_w);
Nabf(image_num+1,1) = mean(Nabf);
SCD(image_num+1,1) = mean(SCD);
SSIM(image_num+1,1) = mean(SSIM);
MS_SSIM(image_num+1,1) = mean(MS_SSIM);
EPI(image_num+1,1) = mean(EPI);
AG(image_num+1,1) = mean(AG);
SF(image_num+1,1) = mean(SF);
VIF(image_num+1,1) = mean(VIF);
CC(image_num+1,1) = mean(CC);
LastName(image_num+1,1) = {'average'};

%写入到csv文件(保存到融合图像所在的路径)
T = table(EN,SD,MI,Qabf,FMI_pixel,FMI_dct,FMI_w,Nabf,...
          SCD,SSIM,MS_SSIM,EPI,AG,SF,VIF,CC,'RowNames',LastName);
writetable(T,strcat(fusion_path,'metrics.csv'),'WriteRowNames',true) ;
disp('---------------------------Done---------------------------');
