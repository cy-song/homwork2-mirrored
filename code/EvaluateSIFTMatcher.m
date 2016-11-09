%% Close all
clc; close all; clear all;

%% Test Data (You should not change the data here)
load('C:\Users\jenny\Downloads\CV\homework2-master\homework2-master\checkpoint\Match_input.mat');

%% Call my implementation of SIFTSimpleMatcher.m
M = SIFTSimpleMatcher( input_d1, input_d2 );

%% Load data and check solution (You should not change this part.)
load('C:\Users\jenny\Downloads\CV\homework2-master\homework2-master\checkpoint\Match_ref.mat');
fprintf('%s\n', 'Your error with the reference solution...');
display( sum(sum((M-solution).^2)) );

if sum(sum(M-solution).^2) < 1e-30,
    fprintf('%s\n', 'Accepted!');
else
    fprintf('%s\n', 'There is something wrong.');
end