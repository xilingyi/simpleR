%
% simpleR: SIMPLE REGRESSION DEMO.
%        Version: 3.1
%        Date   : 29-Ja6n-201
%
%    This demo shows the training and testing of several state-of-the-art statistical models for regression.
%
%    simpleRegression.m ....... A demo script running all the methods in a single dataset
%    assessment.m ............. A simple function to evaluate classifiers/regression models
%    /vhgpr ................... The folder contains all necessary functions to run both GPR and VHGPR
%    /standard ................ The folder contains all necessary functions to run standard regression models
%
%   --------------------------------------
%   METHODS: Several statistical algorithms are used:
%   --------------------------------------
%
%    * Least squares Linear regression (LR)
%           -- Note that the solution is not regularized
%
%    * Least Absolute Shrinkage and Selection Operator (LASSO).
%           -- This is a Mathworks implementation so you will need the corresponding Matlab toolbox
%           -- We use a 5-fold cross-validation scheme here
%
%    * Elastic Net (ELASTICNET).
%           -- This is a Mathworks implementation so you will need the corresponding Matlab toolbox
%           -- The tradeoff l_1-norm alpha parameter was fixed to 0.5 and could be also crossvalidated
%           -- We use a 5-fold cross-validation scheme here
%
%    * Decision trees (TREE)
%           -- The minimum number of samples to split a node was fixed to 30 and could be also crossvalidated
%           -- The code for doing pruning is commented
%
%    * Bagging trees (BAGTREE)
%           -- The maximum number of trees was set to 200 but could be also crossvalidated
%
%    * Boosting trees (BOOST)
%           -- The maximum number of trees was set to 200 but could be also crossvalidated
%
%    * Neural networks (NN)
%           -- Functions included to automatically train and test standard 1-layer neural
%              networks using the Matlab functions "train" and "sim". The code might not
%              work in newer versions of Matlab, say >2012
%           -- The number of hidden neurons is crossvalidated but no regularization is included
%
%    * Extreme Learning Machines (ELM)
%           -- The standard version of the ELM with random initialization of the weights
%              and pseudoinverse of the output spanning subspace.
%           -- The number of hidden neurons is crossvalidated but no regularization is included
%
%    * Support Vector Regression (SVR)
%           -- Standard support vector implementation for regression and function approximation using the libsvm toolbox.
%           -- Three parameters are adjusted via xval: the regularization term C, the \varepsilon insensitivity
%              tube (tolerated error) and a kernel lengthscale \sigma.
%           -- We include Matlab wrappers for automatic training of the SVR. The
%              wrappers call libsvm compiled functions for training and testing.
%           -- The original source code of libsvm can be obtained from http://www.csie.ntu.edu.tw/~cjlin/libsvm/
%              Please cite the original implementation when appropriate.
%
%           -- We also include our own compilation of the libsvm functions for
%              Linux, Windows and Mac. You are encouraged to use our source and binaries for other
%              platforms in http://www.uv.es/~jordi/soft.htm
%
%             [Smola, 2004] A. J. Smola and B. Schölkopf, “A tutorial on support vector regression,"
%              Statistics and Computing, vol. 14, pp. 199–222, 2004.
%
%    * Kernel Ridge Regression (KRR), aka Least Squares SVM
%           -- Standard least squares regression in kernel feature space.
%           -- Two parameters are adjusted: the regularization term \lambda and an RBF kernel lengthscale \sigma.
%
%    * Relevance Vector Machine (RVM)
%
%           -- We include here the MRVM implementation by Arasanathan Thayananthan (at315@cam.ac.uk)
%              (c) Copyright University of Cambridge
%           -- Please cite the original implementation when appropriate.
%
%              [Thayananthan 2006] Multivariate Relevance Vector Machines for Tracking
%                        Arasanathan Thayananthan et al. (University of Cambridge)
%                        in Proc. 9th European Conference on Computer Vision 2006.
%
%    * Gaussian Process Regression (GPR)
%           -- We consider an anisotropic RBF kernel that has a scale, lengthscale
%              per input feature (band), and a constant noise power parameter as hyperparameters
%           -- The full GP toolbox can be downloaded from http://www.gaussianprocess.org/gpml
%              We include here just two functions "gpr.m" and "minimize.m" in the
%              folder /vhgpr for the sake of convenience.
%           -- Please cite the original implementation when appropriate.
%
%              [Rasmussen 2006] Carl Edward Rasmussen and Christopher K. I. Williams
%                   Gaussian Processes for Machine Learning
%                   The MIT Press, 2006. ISBN 0-262-18253-X.
%
%    * Variational Heteroscedastic Gaussian Process Regression (VHGPR)
%           -- We consider an anisotropic RBF kernel that has a scale, lengthscale
%              per input feature (band), and a input-dependent noise power parameter as hyperparameters
%           -- The original source code can be downloaded from http://www.tsc.uc3m.es/~miguel/
%              Here we include for convenience. If you're interested in VHGPR, please cite:
%
%              [Lázaro-Gredilla, 2011] M. Lázaro-Gredilla and M. K. Titsias, "Variational
%                     heteroscedastic gaussian process regression,"
%                     28th International Conference on Machine Learning, ICML 2011.
%                     Bellevue, WA, USA: ACM, 2011, pp. 841–848.
%
%   --------------------------------------
%   NOTE:
%   --------------------------------------
%
%   All the programs included in this package are intended for illustration
%   purposes and as accompanying software for the paper:
%
%           Miguel Lázaro-Gredilla, Michalis K. Titsias, Jochem Verrelst and
%           Gustavo Camps-Valls. "Retrieval of Biophysical Parameters with
%           Heteroscedastic Gaussian Processes". IEEE Geoscience and Remote
%           Sensing Letters, 2013
%
%   Shall the software is useful for you in other geoscience and remote sensing applications,
%   we would greatly acknowledge citing our paper above. Also, please consider
%   citing these papers for particular methods included herein:
%
%   [KRR, NN]  Nonlinear Statistical Retrieval of Atmospheric Profiles from MetOp-IASI and MTG-IRS Infrared Sounding Data
%     Gustavo Camps-Valls, Jordi Muñoz-Marí, Luis Gómez-Chova, Luis Guanter and Xavier Calbet
%     IEEE Transactions on Geoscience and Remote Sensing, 50(5), 1759 - 1769 2012
%
%   [SVR]  Robust Support Vector Regression for Biophysical Parameter Estimation from Remotely Sensed Images
%     Gustavo Camps-Valls, L. Bruzzone, Jose L. Rojo-Álvarez, Farid Melgani
%     IEEE Geoscience and Remote Sensing Letters, 3(3), 339-343, July 200
%
%   [RVM]  Retrieval of Oceanic Chlorophyll Concentration with Relevance Vector Machines
%     G. Camps-Valls, L. Gomez-Chova, J. Vila-Francés, J. Amorós-López, J. Muñoz-Marí, and J. Calpe-Maravilla
%     Remote Sensing of Environment. 105(1), 23-33, 2006
%
%   [GPR]  Retrieval of Vegetation Biophysical Parameters using Gaussian Processes Techniques
%     J. Verrelst, L. Alonso, G. Camps-Valls, J. Delegido and J. Moreno
%     IEEE Transactions on Geoscience and Remote Sensing, 50(5), 1832 - 1843. 2012
%
%   [GPR/VHGPR]  Retrieval of Biophysical Parameters with Heteroscedastic Gaussian Processes
%     Miguel Lázaro-Gredilla, Michalis K. Titsias, Jochem Verrelst and Gustavo Camps-Valls.
%     IEEE Geoscience and Remote Sensing Letters, 2013
%
%   --------------------------------------
%   Copyright & Disclaimer
%   --------------------------------------
%
%   The programs contained in this package are granted free of charge for
%   research and education purposes only. Scientific results produced using
%   the software provided shall acknowledge the use of this implementation
%   provided by us. If you plan to use it for non-scientific purposes,
%   don't hesitate to contact us. Because the programs are licensed free of
%   charge, there is no warranty for the program, to the extent permitted
%   by applicable law. except when otherwise stated in writing the
%   copyright holders and/or other parties provide the program "as is"
%   without warranty of any kind, either expressed or implied, including,
%   but not limited to, the implied warranties of merchantability and
%   fitness for a particular purpose. the entire risk as to the quality and
%   performance of the program is with you. should the program prove
%   defective, you assume the cost of all necessary servicing, repair or
%   correction. In no event unless required by applicable law or agreed to
%   in writing will any copyright holder, or any other party who may modify
%   and/or redistribute the program, be liable to you for damages,
%   including any general, special, incidental or consequential damages
%   arising out of the use or inability to use the program (including but
%   not limited to loss of data or data being rendered inaccurate or losses
%   sustained by you or third parties or a failure of the program to
%   operate with any other programs), even if such holder or other party
%   has been advised of the possibility of such damages.
%
%   NOTE: This is just a demo providing a default initialization. Training
%   is not at all optimized. Other initializations, optimization techniques,
%   and training strategies may be of course better suited to achieve improved
%   results in this or other problems. We just did it in the standard way for
%   illustration purposes and dissemination of these models.
%
% Copyright (c) 2013 by Gustavo Camps-Valls
% gustavo.camps@uv.es
% http://isp.uv.es/
% http://www.uv.es/gcamps
%

%% Setup
clear;clc;close all;

fontname = 'Bookman';
fontsize = 20;
fontunits = 'points';
set(0,'DefaultAxesFontName',fontname,'DefaultAxesFontSize',fontsize,'DefaultAxesFontUnits',fontunits,...
    'DefaultTextFontName',fontname,'DefaultTextFontSize',fontsize,'DefaultTextFontUnits',fontunits,...
    'DefaultLineLineWidth',3,'DefaultLineMarkerSize',10,'DefaultLineColor',[0 0 0]);

% Paths
addpath('./AUX')        % Auxiliary functions for visualization, results analysis, plots, etc.
addpath('./standard')   % Standard statistical regression: LR, LASSO, TREES, SVR, KRR, GPR
addpath('./SVM')        % libsvm code and kernel matrix
addpath('./MRVM')       % Relevance vector machine (RVM)
addpath('./VHGPR')      % VHGPR [Lázaro-Gredilla, 2011]
addpath('./ARES')       % ARESLab -- Adaptive Regression Splines toolbox for Matlab/Octave, ver. 1.5.1, by Gints Jekabsons
addpath('./LWP')        % Locally-Weighted Polynomials, Version 1.3, by Gints Jekabsons
addpath('./WGP')        % Warped GPs
addpath('./SSGP')       % Sparse Spectrum Gaussian Process (SSGP)  [Lázaro-Gredilla, 2008]
addpath('./TGP')        % Twin Gaussian Process (TGP) [Liefeng Bo and Cristian Sminchisescu]  http://www.maths.lth.se/matematiklth/personal/sminchis/code/TGP.html

clear;clc;close all;

%% Data 1:
% N     = 1000;
% X     = [sin(1:N)', cos(1:N)', tanh(1:N)'] + 0.1*randn(N,3);
% Y     = sin(1:N)';
% % Y = [sin(1:N)', cos(1:N)', tanh(1:N)'];
% VARIABLES = {'SIN', 'COS', 'TANH'};

%% Data 2:
% load motorcycle.mat
% Y = y;

%% Data 3:
load cloroSeaBAM.mat
X = [SamplesT;SamplesV];
Y = [LabelsT;LabelsV];

%% Data 4:
% data = load('J_SPARC_one_day.txt');
% Y  = data(2,2:end)';
% X  = data(5:end,2:end)';

if 1
    %% Split training-testing data
    rate = 0.1; %[0.05 0.1 0.2 0.3 0.4 0.5 0.6]
    % Fix seed random generator (important: disable when doing the 100 realizations loop!)
    rand('seed',12345);
    randn('seed',12345);
    [n d] = size(X);                 % samples x bands
    r = randperm(n);                 % random index
    ntrain = round(rate*n);          % #training samples
    Xtrain = X(r(1:ntrain),:);       % training set
    Ytrain = Y(r(1:ntrain),:);       % observed training variable
    Xtest  = X(r(ntrain+1:end),:);   % test set
    Ytest  = Y(r(ntrain+1:end),:);   % observed test variable
end
[ntest do] = size(Ytest)

%% Remove the mean of Y for training only
my      = mean(Ytrain);
Ytrain  = Ytrain - repmat(my,ntrain,1);

%% SELECT METHODS FOR COMPARISON
% METHODS = {'KRR'}
% METHODS = {'RLR' 'LASSO' 'ENET'} % LINEAR
% METHODS = {'LWP' 'ARES'} % SPLINES
% METHODS = {'KNNR' 'WKNNR'} % NEIGHBORS
% METHODS = {'TREE' 'BAGTREE' 'BOOST' 'RF1' 'RF2'}   % TREES
% METHODS = {'NN' 'RBFNET' 'ELM'}  % NEURAL NETS
% METHODS = {'SVR' 'KRR' 'RVM' 'KSNR' 'SKRRrbf' 'SKRRlin' 'RKS'}   % KERNELS
% METHODS = {'KRR' 'SKRRrbf' 'SKRRlin'}   % KERNELS
% METHODS = {'GPR' 'VHGPR' 'WGPR' 'SSGPR' 'TGP'}  % GPs

%%%% ALL!
%  METHODS = {'RLR' 'LASSO' 'ENET' 'LWP'  'ARES' 'KNNR' 'WKNNR', ...
%      'TREE' 'BAGTREE' 'BOOST' 'RF1' 'RF2', ...
%      'NN' 'ELM', 'SVR' 'KRR' 'RVM' 'KSNR' 'SKRRrbf' 'SKRRlin' 'RKS', ...
%      'GPR' 'VHGPR' 'WGPR' 'SSGPR' 'TGP'}

%%%% REPRESENTATIUS PER FAMILIA
%  METHODS = {'RLR' 'LASSO' ,...
%             'LWP' 'ARES', ...
%             'KNNR', ...
%             'TREE' 'RF1', ...
%             'NN', ...
%             'SVR' 'KRR', ...
%             'GPR' 'VHGPR' 'WGPR' 'TGP'}

%%%% MULTIOUTPUT
METHODS = {'RLR' 'NN' 'KRR' 'KSNR' 'SKRRrbf' 'SKRRlin' 'RKS' 'TGP'}

%% TRAIN ALL MODELS
numModels = numel(METHODS);

% One model (very costly for kernel methods!)
for m=1:numModels
    fprintf(['Training ' METHODS{m} '... \n'])
    t=cputime;
    eval(['model = train' METHODS{m} '(Xtrain,Ytrain);']); % Train the model
    eval(['Yp = test' METHODS{m} '(model,Xtest);']);       % Test the model
    
    if do==1
        Ypred(:,m)     = Yp + repmat(my,ntest,1);
        results(m)     = assessment(Ypred(:,m),Ytest,'regress');
    else    % IF MO:
        Ypred      = Yp + repmat(my,ntest,1);
        results(m) = norm(Ytest-Ypred,'fro');
    end
    
    CPUTIMES(m) = cputime-t;
end

results
CPUTIMES

% % Fast training (divide and conquer strategy, nice for kernel machines)
% for m=1:numModels
%     fprintf(['Fast Training ' METHODS{m} '... \n'])
%     t=cputime;
%     eval(['model2 = fastTrain(''' METHODS{m} ''',Xtrain,Ytrain);']); % fast Train the model
%     eval(['Yp = fastTest(''' METHODS{m} ''',model2,Xtest);']);       % fast Test the model
%     Ypred(:,m)     = Yp + my;
%     results2(m)     = assessment(Ypred(:,m),Ytest,'regress');
%     CPUTIMES2(m) = cputime-t;
% end

%% NUMERICAL COMPARISON
% clc
fprintf('----------------------------------------------------------------------------------- \n')
fprintf('#\t METHOD\t & ME\t & RMSE\t & MAE\t & R \\\\ \n')
fprintf('----------------------------------------------------------------------------------- \n')
for m=1:numModels
    fprintf([num2str(m) '\t' METHODS{m} '\t & %3.3f\t & %3.3f\t & %3.3f\t & %3.3f \\\\ \n'],abs(results(m).ME),results(m).RMSE,results(m).MAE,results(m).R)
end
fprintf('----------------------------------------------------------------------------------- \n')

% [val idx] = min([results.RMSE]);
% disp(['The best method in RMSE terms is: ' METHODS{idx}])
% [val idx] = min(abs([results.ME]));
% disp(['The best method in ME terms is: ' METHODS{idx}])
% [val idx] = max([results.R]);
% disp(['The best method in correlation terms is: ' METHODS{idx}])

figure,
barh([CPUTIMES])
set(gca,'Ytick',1:length(METHODS),'YTickLabel',METHODS);
xlabel('CPU Time [s]')
ylabel('Methods')
grid

break
%% THE ERROR BOXPLOTS
figure,
ERRORS = Ypred - repmat(Ytest,1,size(Ypred,2));
boxplot(ERRORS,'labels',METHODS)
h = findobj(gca, 'type', 'text');
set(h, 'Interpreter', 'tex');
ylabel('Residuals')

%% STATISTICAL ANALYSIS OF THE BIAS
anova1(ERRORS)

%% STATISTICAL ANALYSIS OF THE ACCURACY OF THE RESIDUALS
anova1(abs(ERRORS))

%% THE CPU TIMES


%% SCATTER PLOTS OF THE BEST METHOD IN RMSE

figure,
plot(Ytest,Ypred(:,idx),'k.'),
xlabel('Observed signal')
ylabel('Predicted signal')
grid

figure,
plot(Ytest,Ypred(:,idx)-Ytest,'k.'),
xlabel('Observed signal')
ylabel('Residuals')
grid

%% RMSE vs #predictions
[ntest do] = size(Ytest);
REALIZ = 100;
RMSEvsNumPredictions = zeros(REALIZ,ntest,size(Ypred,2));
for realiza=1:REALIZ
    r=randperm(ntest);
    for i=1:ntest
        for m=1:size(Ypred,2)
            RMSEvsNumPredictions(realiza,i,m) = sqrt( mean(  ( Ytest(r(1:i)) - Ypred(r(1:i),m) ).^2  ));
        end
    end
end

M =  squeeze(mean(RMSEvsNumPredictions,1));
S =  1.96/sqrt(REALIZ)*squeeze(std(RMSEvsNumPredictions,1));

figure,
myeb(M,S);
xlabel('# Predictions')
ylabel('RMSE')
grid
axis tight
legend(METHODS)

break

%% RANKING FEATURES with DIFFERENT METHODS

d = size(Xtest,2);

% LR
figure, bar(model_RLR.W(2:end)), set(gca,'Xtick',1:d,'XtickLabel',VARIABLES)
grid,title('LR Feature relevance.')

% LASSO

% Display the weights
figure, bar(model_LASSO.W), set(gca,'Xtick',1:d,'XtickLabel',VARIABLES)
grid,title('LASSO Feature relevance.')

% Display a trace plot of the lasso fits.
axTrace = lassoPlot(model_LASSO.B,model_LASSO.S);

% Display the sequence of cross-validated predictive MSEs.
axCV = lassoPlot(model_LASSO.B,model_LASSO.S,'PlotType','CV');

% ELASTICNET
figure, bar(model_ElasticNet.W), set(gca,'Xtick',1:d,'XtickLabel',VARIABLES)
grid,title('ELASTIC NET Feature relevance.')

% Display a trace plot of the lasso fits.
axTrace = lassoPlot(model_ElasticNet.B,model_ElasticNet.S);

% Display the sequence of cross-validated predictive MSEs.
axCV = lassoPlot(model_ElasticNet.B,model_ElasticNet.S,'PlotType','CV');

% TREE
view(model_TREE)
figure, bar(varimportance(model_TREE)), set(gca,'Xtick',1:d,'XtickLabel',VARIABLES)
grid,title('TREE Feature relevance.')

% GPR
figure, bar(1./exp(model_GP.loghyper(1:d))), set(gca,'Xtick',1:d,'XtickLabel',VARIABLES)
grid,title('GPR Feature relevance.')

% VHGPR
figure, bar(1./exp(model_VHGP.loghyper(1:d))), set(gca,'Xtick',1:d,'XtickLabel',VARIABLES)
grid,title('VHGPR Feature relevance.')

%% Arrange figures on the desktop

tile

