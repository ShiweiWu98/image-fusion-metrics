%% Li H, Wu X J. DenseFuse: A Fusion Approach to Infrared and Visible Images[J]. arXiv preprint arXiv:1804.08361, 2018. 
%% https://arxiv.org/abs/1804.08361
clear all
clc

addpath('./vif');
fileName_source_ir  = ["C:\Users\17248\Desktop\Project\IVFusion\code\input/0ir.jpg"];
fileName_source_vis = ["C:\Users\17248\Desktop\Project\IVFusion\code\input/0vis.jpg"];
% fileName_fused      = ["C:\Users\17248\Desktop\Project\IVFusion\code\output/ours-0.jpg"];
fileName_fused      = ["C:\Users\17248\Desktop\Project\IVFusion\code\output1/ours-0.jpg"];

source_image_ir = imread(fileName_source_ir);
source_image_vis = imread(fileName_source_vis);
fused_image   = imread(fileName_fused);

disp("Start");
disp('---------------------------Analysis---------------------------');
metrics = analysis_Reference(source_image_vis,source_image_ir,fused_image);
metrics.AG = AG_evaluation(fused_image);
metrics.SF = SF_evaluation(fused_image);
metrics.SD = SD_evaluation(fused_image);
disp('Done');


