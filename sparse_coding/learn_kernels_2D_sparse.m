% Learning test from sparse data convolutional coding

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

%One long dataset iterating over color if defined
b = reshape(b, size(b,1), size(b,2), [] ); 

%% Subsample for sparse data

%Sampling matrix
MtM = zeros(size(b));
%MtM(1:2:end, 1:2:end) = 1;
MtM(rand(size(MtM)) < 0.75 ) = 1;

%Subsample
b_sparse = b;
b_sparse( ~MtM ) = 0;

%% Define the parameters
kernel_size = [11, 11, 100];
lambda_residual = 1.0;
lambda = 1.0; %2.8


%% Do the reconstruction  
fprintf('Doing sparse coding kernel learning for k = %d [%d x %d] kernels.\n\n', kernel_size(3), kernel_size(1), kernel_size(2) )

%Optim options
verbose_admm = 'all';
max_it = [60];
tol = 1e-3;

tic();
prefix = 'ours';
[ d, z, Dz, obj]  = admm_learn_conv2D_weighted_sparse(b_sparse, kernel_size, MtM, lambda_residual, lambda, max_it, tol, verbose_admm);
tt = toc;

%Show result
if strcmp(verbose, 'brief ') || strcmp(verbose, 'all') 
    figure();    
    pd = 1;
    sqr_k = ceil(sqrt(size(d,3)));
    d_disp = zeros( sqr_k * [kernel_size(1) + pd, kernel_size(2) + pd] + [pd, pd]);
    for j = 0:size(d,3) - 1
        d_disp( floor(j/sqr_k) * (kernel_size(1) + pd) + pd + (1:kernel_size(1)) , mod(j,sqr_k) * (kernel_size(2) + pd) + pd + (1:kernel_size(2)) ) = d(:,:,j + 1); 
    end
    imagesc(d_disp), colormap gray, axis image, colorbar, title('Final filter estimate');
end

%Save
save(sprintf('filters_%s_obj%3.3g_sparse.mat', prefix, obj), 'd', 'z', 'Dz', 'obj');

%Debug
fprintf('Done sparse coding learning! --> Time %2.2f sec.\n\n', tt)

%Save
for i = 1:size(Dz,3)
    %Write stuff
    max_sig = max(reshape(b(:,:,i),[],1));
    min_sig = min(reshape(b(:,:,i),[],1));

    %Transform and save
    signal_disp = (b(:,:,i) - min_sig)/(max_sig - min_sig);
    signal_sparse_disp = (b_sparse(:,:,i) - min_sig)/(max_sig - min_sig);
    signal_sparse_disp( ~MtM(:,:,i) ) = 0;
    sig_rec_disp = (Dz(:,:,i) - min_sig)/(max_sig - min_sig);
    
    %Save stuff
    imwrite(signal_disp , sprintf('signal_%d.png',i),'bitdepth', 16);
    imwrite(signal_sparse_disp ,sprintf('signal_%d_sparse.png',i),'bitdepth', 16);
    imwrite(sig_rec_disp ,sprintf('signal_%d_reconstruction.png',i),'bitdepth', 16);
end