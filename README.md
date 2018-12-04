# MATLAB---Image-Compression-and-Threshold-Detection

This project demonstrates a potential application of MATLAB in image processing using Singular Value Decomposition (SVD). It is a threshold study, which answers the question of how many singular values are needed to represent a gray-scaled image so that it cannot be differentiated from the original image by human eyes.

MATLAB represents images as matrices of pixels. By decomposing the singular values of an image and re-arranging them in a descending order, the low dimension representation of the image which is given by the first few largest singular values can be identified. A threshold is thus found by pinpointing the singular value beyond which the accuracy of telling a compressed picture from the original one fell below 75%

Response.mat is a sample dataset which includes 1024 trails.
Lena.png is the image I used in this project.
Lowrank_SVD.m is the SVD function I used in this project.
