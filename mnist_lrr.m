clear;

config = mnist_config();

method = 'lrr';

K = config.K; % number of classes/subspaces

%% add path
addpath('LRR/');
addpath('SSC/');

%% load data
data_file = config.data_file;
load(data_file);

result_file = sprintf(config.result_file_format, method, method);

%% compute Acc for LRR

fprintf('LRR: K = %d ', K);

[p, n] = size(Z);

tic;
[X, ~] = solve_lrr(Z, Z, 1/sqrt(n), 1, 1);
T = toc;

tic;

Xsym = BuildAdjacency(X);
groups = SpectralClustering(Xsym, K);
Acc = 1 - Misclassification(groups, gt);

T_spec = toc;

fprintf('Acc = %g\n', Acc);

save(result_file, 'Acc', 'T', 'T_spec');
fprintf('save to %s\n', result_file);