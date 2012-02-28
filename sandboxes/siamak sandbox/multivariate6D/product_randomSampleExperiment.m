% Calculates the MSE is we throw in a random sample


clear all;
format long



disp('Reading ratings');

[num,txt,raw] = xlsread('data\productsratings.csv');
 
actual = num;

MSEarrayR =[];
meanMSEarrayR =[];
x = [];
pvalsR = [];
harrayR = [];


MSEarray5 =[]; % what if we predict everything as 5
meanMSEarray5 =[]; % what if we predict everything as 5

pvals5 = [];
harray5 = [];

%importance sampling
MSEarrayImportanceSampling =[]; % what if we predict everything as 5
meanMSEarrayImportanceSampling =[]; % what if we predict everything as 5
figure;

for i = 1:7500
    
   
    sizeofmatrix = size(actual);
    predictions = randi([1 5],sizeofmatrix);
    MSE = mean(sum(((predictions-actual).^2)'));
    MSEarrayR =[MSEarrayR MSE];
    meanMSEarrayR = [meanMSEarrayR (mean( MSEarrayR))];
    
    %predicting all 5
    predictions5 = randi([5 5],sizeofmatrix);
    MSE5 = mean(sum(((predictions5-actual).^2)'));
    MSEarray5 =[MSEarray5 MSE5];
    meanMSEarray5 = [meanMSEarray5 (mean( MSEarray5))]; 
    
    %predicting all by taking samples from the actual matrix
    predictionsImportanceSampling = actual(randi([1 sizeofmatrix(1)],[sizeofmatrix(1), 1]),:);
    MSEImportanceSampling= mean(sum(((predictionsImportanceSampling-actual).^2)'));
    MSEarrayImportanceSampling =[MSEarrayImportanceSampling MSEImportanceSampling];
    meanMSEarrayImportanceSampling = [meanMSEarrayImportanceSampling (mean( MSEarrayImportanceSampling))]; 
    
    
    x = [x i];
    
    subplot(3,1,1);
    plot(x, meanMSEarrayR,'-k', 'LineWidth',1.5);
    title(sprintf('Random Number Generator [1..5] \n Mean MSE =  %0.4f', (mean( MSEarrayR))))
    %xlabel('# Simulations')
    ylabel('Mean MSE')
    
 
    subplot(3,1,2);
    plot(x, meanMSEarrayImportanceSampling,'-k', 'LineWidth',1.5);
    title(sprintf('Random Samples from the Actual Distribution\n Mean MSE = %0.4f', (mean( MSEarrayImportanceSampling))))
    %xlabel('# Simulations')
    ylabel('Mean MSE')
    
    subplot(3,1,3);
    plot(x, meanMSEarray5,'-k', 'LineWidth',1.5);
    title(sprintf('All 5 Predictor\n Mean MSE = %0.4f', (mean( MSEarray5))))
    %xlabel('# Simulations')
    ylabel('Mean MSE')
   
%     
%     if i>1000
%         % calculating p-value to see if it has stabilized
%         newvector1 = round(meanMSEarrayR((length(meanMSEarrayR)-500):(length(meanMSEarrayR))).*1000)./1000;
%         newvector2 = round(meanMSEarrayR((length(meanMSEarrayR)-1000):(length(meanMSEarrayR)-500)).*1000)./1000;
%         [h,p,ci] = ttest2(newvector1, newvector2);
%         pvalsR  = [pvalsR p];
%         harrayR =[harrayR h];
% %         if h==0
% %             fprintf('h is %d and p is %f\n', h, p)
% %         end
%         
%         subplot(2,2,2);
% 
%         plot(pvalsR,'-or', 'LineWidth',.2, 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','r',...
%                 'MarkerSize',3);
%     else
%         pvalsR  = [pvalsR 0];
%         subplot(2,2,2);
%         plot(pvalsR);
%     end
%     title('p-value of t-test analysis (last 1000 results are broken into two sets)')
%     xlabel('# Simulations')
%     ylabel('p-value (if simulation is stable p = 1)')
%     
    if (mod(i,50)==0)
        drawnow;
    end
    
    
end


