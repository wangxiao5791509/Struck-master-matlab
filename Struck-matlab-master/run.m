% clear all;
close all;
clc;
addpath('Tools');
IS_CHOOSE_VIDEO = 0;
DATA_SET_BASE_DIR = 'G:\Tracking_Benchmark\OTB100\OTB100\Benchmark';
GEN_RESULT_IMG = 1;
SHOW_RESULTS_PLOTS = 1;
OUTPU_DIR = './Results/';
if IS_CHOOSE_VIDEO 
	video = choose_video(DATA_SET_BASE_DIR);
else
    load('sequences50');
	videoList = sequences; 
end




for ii = 8:size(videoList, 2)
    
    
    video = videoList{1, ii}; 
    disp(['==>> deal with video sequence: ', video, ' , hold on please ... ']); 
    
    if GEN_RESULT_IMG
        if ~exist([OUTPU_DIR])
            mkdir([OUTPU_DIR]);
        end
        if ~exist([OUTPU_DIR video])
           
            mkdir([OUTPU_DIR video]);
        end
    end

    
    %%reading dataset:
    [img_files, pos, target_sz, theta,ground_truth, video_path] = load_video_info(DATA_SET_BASE_DIR, video);
    for i = 1:length(img_files)
        img_files{i} =[ DATA_SET_BASE_DIR '\' video '\img\'  img_files{i} ];
    end
    seq.s_frames = img_files;
    rect = ground_truth(1,:);
    seq.len = length(img_files);
    seq.init_rect = [rect([1 2]) - rect([3 4])/2,rect([3 4])];
    res_path = [OUTPU_DIR video '\'];
    bSaveImage = GEN_RESULT_IMG;
    
    
    results = run_PFS(seq, res_path, bSaveImage);
    res = results.res;
    res(:,1:2) = res(:,1:2) + res(:,3:4)/2;

    %% save the txt results 
    txtname = [video '_Struck.txt'];
    txtsavepath = [OUTPU_DIR video '\' txtname];
    fid = fopen(txtsavepath, 'w'); 
    for kkk = 1:size(res, 1)
        line = res(kkk, :); 
        fprintf(fid, '%s', num2str(line(1)));
        fprintf(fid, '%s', ',');    
        fprintf(fid, '%s', num2str(line(2)));
        fprintf(fid, '%s', ',');            
        fprintf(fid, '%s', num2str(line(3)));
        fprintf(fid, '%s', ',');         
        fprintf(fid, '%s\n', num2str(line(4)));     
    end 
    fclose(fid);
     
end



















