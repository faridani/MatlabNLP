% Calculates the MSE is we throw in a random sample


clear all;
format long



disp('Reading ratings');
[num,txt,raw] = xlsread('data\final104.xls');

% reading the description of each shoe
descriptions = raw(2:size(raw,1),2);
style_ratings = num(1:size(num,1),1);
comfort_ratings = num(1:size(num,1),4);
overal_ratings = num(1:size(num,1),5);


actual = [style_ratings, comfort_ratings, overal_ratings];

MSEarray =[];
meanMSEarray =[];
x = [];
pvals = [];
harray = [];
figure;

for i = 1:7500
    
   
    sizeofmatrix = size(actual);
    predictions = randi([1 5],sizeofmatrix);
    MSE = mean(sum(((predictions-actual).^2)'));
    MSEarray =[MSEarray MSE];
    meanMSEarray = [meanMSEarray (mean( MSEarray))];
    
    
    x = [x i];
    subplot(2,1,1);
    plot(x, meanMSEarray,'-k', 'LineWidth',2);
    title(sprintf('Mean MSE is %0.4f', (mean( MSEarray))))
    %xlabel('# Simulations')
    ylabel('Mean MSE')
    
    if i>1000
        % calculating p-value to see if it has stabilized
        newvector1 = round(meanMSEarray((length(meanMSEarray)-500):(length(meanMSEarray))).*1000)./1000;
        newvector2 = round(meanMSEarray((length(meanMSEarray)-1000):(length(meanMSEarray)-500)).*1000)./1000;
        [h,p,ci] = ttest2(newvector1, newvector2);
        pvals  = [pvals p];
        harray =[harray h];
%         if h==0
%             fprintf('h is %d and p is %f\n', h, p)
%         end
        
        subplot(2,1,2);

        plot(pvals,'-or', 'LineWidth',.2, 'MarkerEdgeColor','k',...
                'MarkerFaceColor','r',...
                'MarkerSize',3);
    else
        pvals  = [pvals 0];
        subplot(2,1,2);
        plot(pvals);
    end
    title('p-value of t-test analysis (last 1000 results are broken into two sets)')
    xlabel('# Simulations')
    ylabel('p-value (if simulation is stable p = 1)')
    
    if (mod(i,50)==0)
        drawnow;
    end
    
    
end


