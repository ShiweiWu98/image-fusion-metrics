function [ metrics ] = analysis_Reference(image_vis,image_ir,image_f)

[s1,s2] = size(image_ir);
imgSeq = zeros(s1, s2, 2);
imgSeq(:, :, 1) = image_ir;
imgSeq(:, :, 2) = image_vis;

image1 = im2double(image_ir);
image2 = im2double(image_vis);
image_fused = im2double(image_f);

%VIF
metrics.VIF = (vifvec(image1, image_fused)+vifvec(image2, image_fused))/2;
%EN
metrics.EN = entropy(image_fused);
%MI
metrics.MI = analysis_MI(image1,image2,image_fused);
%Qabf
metrics.Qabf = analysis_Qabf(image1,image2,image_fused);
%FMI
metrics.FMI_pixel = analysis_fmi(image1,image2,image_fused);
metrics.FMI_dct = analysis_fmi(image1,image2,image_fused,'dct');
metrics.FMI_w = analysis_fmi(image1,image2,image_fused,'wavelet');
%Nabf
metrics.Nabf = analysis_Nabf(image_fused,image1,image2);
% SSIM_a
SSIM1 = ssim(image_fused,image1);
SSIM2 = ssim(image_fused,image2);
metrics.SSIM = (SSIM1+SSIM2)/2;
% Q_CV
metrics.Qcv = analysis_Qcv(image1,image2,image_fused);
% Q_CB
metrics.Qcb = analysis_Qcb(image1,image2,image_fused);
% % Q_C_1
Qc_1 = analysis_Qc(image1,image2,image_fused,1);
% % Q_C_2
Qc_2 = analysis_Qc(image1,image2,image_fused,2);
% %Q_y
Qy = analysis_Qy(image1,image2,image_fused);
%MS_SSIM
[MS_SSIM,t1,t2]= analysis_ms_ssim(imgSeq, image_f);
metrics.MS_SSIM = MS_SSIM;
%SCD
metrics.SCD = analysis_SCD(image1,image2,image_fused);

metrics.EPI = (analysis_EPI(image1, image_fused)+analysis_EPI(image2, image_fused))/2;

end







