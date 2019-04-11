% Visualize joint boundary estimation from learned filters
clear;
close all;

%% Debug options
verbose = 'all';

%% Load the data

addpath('./image_helpers');
CONTRAST_NORMALIZE = 'local_cn'; 
ZERO_MEAN = 1;   
COLOR_IMAGES = 'gray';                         
[b] = CreateImages('../datasets/Images/fruit_100_100',CONTRAST_NORMALIZE,ZERO_MEAN,COLOR_IMAGES);
b = reshape(b, size(b,1), size(b,2), [] ); 

%% Load reconstruction result
filter_file = '../learned_filters/filters_ours_obj1.26e04.mat';
kernels = load(filter_file);
Dz = kernels.Dz;
d = kernels.d;

%Save stuff
outputfolder = 'results_boundary';
fprintf('Saving results now under %s!\n', outputfolder)
mkdir(outputfolder);

%Save
psf_radius = floor( size(d,1)/2 );
for i = 1:size(Dz,3)
    
    %Write stuff
    max_sig = max(reshape(b(:,:,i),[],1));
    min_sig = min(reshape(b(:,:,i),[],1));
    sig_rec_disp = (Dz(:,:,i) - min_sig)/(max_sig - min_sig);
    
    %Add boundary
    us = 5;
    sig_rec_disp = imresize( sig_rec_disp, us, 'nearest');
    bnd = zeros(size(sig_rec_disp));
    bnd(1 + (psf_radius*us - 0):end - (psf_radius*us - 0), 1 + (psf_radius*us - 0):end - (psf_radius*us - 0), :) = 1;
    bnd(1 + (psf_radius*us + 1):end - (psf_radius*us + 1), 1 + (psf_radius*us + 1):end - (psf_radius*us + 1), :) = 0;
    
    bnd = repmat( bnd, [1,1,3]);
    bnd(:,:,2:3) = 0;
    sig_rec_disp = cat(3, sig_rec_disp, sig_rec_disp, sig_rec_disp );
    sig_rec_disp(logical(bnd)) = 1;   
    
    %Orig
    signal_disp = (b(:,:,i) - min_sig)/(max_sig - min_sig);
    signal_disp = imresize( signal_disp, us, 'nearest');
    
    %Save stuff
    imwrite(signal_disp , sprintf('%s/signal_%d.png',outputfolder,i),'bitdepth', 16);
    imwrite(sig_rec_disp , sprintf('%s/inpainted_signal_%d.png',outputfolder,i),'bitdepth', 16);
end
