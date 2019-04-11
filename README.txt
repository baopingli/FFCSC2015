***Code for Fast and Flexible Convolutional Sparse Coding ***

The code in this package contains the core implementations of our paper: F. Heide, W. Heidrich, G. Wetzstein "Fast and Flexible Convolutional Sparse Coding", IEEE Conference on Computer Vision and Pattern Recognition (CVPR Oral) , to appear, 2015 

The following features are demonstrated:

1) Learning from dense data --> 'learn_kernels_2D.m' 
2) Learning from sparse data --> 'learn_kernels_2D_sparse.m' 
3) Reconstruction from sparse data --> 'reconstruct_LMM_2D_sparse.m' 
4) Joint boundary estimation --> 'visualize_boundary_inpainting.m'

I have tried to comment every step as good as possible. So most of the code should hopefully be self-explanatory. Do not hesitate to ask me if anything is unclear.

Datasets and third-party code:

We have included the datasets and some image loading files of Matthew Zeiler et al.'s. Adaptive Deconvolutional Networks Toolbox:

Adaptive Deconvolutional Networks for Mid and High Level Feature Learning
Matthew D. Zeiler, Graham W. Taylor, and Rob Fergus
International Conference on Computer Vision (November 6-13, 2011)

The individual code files borrowed can be found in the folder 'image_helpers'. 

The datasets can be found in the folder 'datasets'. A precomputed learned filter set is located in 'learned_filters'.

Further questions:

For any further questions send me an email !

Copyright (C) 2015. Felix Heide
Email: fheide@cs.ubc.ca