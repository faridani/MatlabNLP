% predicting numerical values using Linear Regression
clear all;
format long
disp('===== Linear Regression ====');
disp('Reading featur vector');


figure;
possiblefeaturizations =  {'all','logmultinomial', 'logmultinomial2', 'logmultinomial3','bernouli', 'tfidf','multinomial'};
possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'};
       
subplot(6,2,1);

for feat = 1:3
      MSEarray =[];
    elapsedarray =[];
    for crossvalidateIter = 1:10
       (fprintf('%d',crossvalidateIter));
     
        %disp('Splitting up data into training/test sets');
        [num,txt,raw] = xlsread('data\final106.xls');
        
        % reading the description of each shoe
        descriptions = raw(2:size(raw,1),2);
        style_ratings = num(1:size(num,1),1);
        comfort_ratings = num(1:size(num,1),4);
        overal_ratings = num(1:size(num,1),5);
        shoe_width = num(1:size(num,1),6);
        shoe_size_rating = num(1:size(num,1),9);
        shoe_arch_rating = num(1:size(num,1),10);
        
%         % only take m data points
%         m=num_data;
%         descriptions = descriptions(1:m);
%         style_ratings = style_ratings(1:m);
%         comfort_ratings = comfort_ratings(1:m);
%         overal_ratings = overal_ratings(1:m);
%         shoe_width = shoe_width(1:m);
%         shoe_size_rating = shoe_size_rating(1:m);
%         shoe_arch_rating =  shoe_arch_rating(1:m);
        valididx = (~isnan(shoe_width) & ~isnan( shoe_arch_rating)) & ~isnan(shoe_size_rating);
        
        descriptions = descriptions(valididx);
        style_ratings = style_ratings(valididx);
        comfort_ratings = comfort_ratings(valididx);
        overal_ratings = overal_ratings(valididx);
        shoe_width = shoe_width(valididx);
        shoe_size_rating = shoe_size_rating(valididx);
        shoe_arch_rating =  shoe_arch_rating(valididx);
        Indices = crossvalind('Kfold', sum(valididx), 10);
        
                %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
        featurization  = possiblefeaturizations{feat};
        featurs = csvread('data\forWeka_featuresonly.csv');
        featurs = featurs(:,2:size(featurs,2));
        
        featurs = featurs(valididx,:);
        num_data = size(featurs,1); %5000;
        
        
        %disp(sprintf('Number of datapoints %d',num_data))
        if strcmp(featurization,'multinomial')
            %just pass
        elseif strcmp(featurization,'bernouli')
            featurs = bernoulli(featurs);
        elseif strcmp(featurization,'tfidf')
            featurs = tfidf(featurs);
        elseif strcmp(featurization,'logmultinomial')
            featurs = log(featurs+1)./log(2);
        elseif strcmp(featurization,'logmultinomial2')
            featurs = round(log(featurs+1)./log(2)); 
        elseif strcmp(featurization,'logmultinomial3')
            featurs = (log(featurs+1));       
        elseif strcmp(featurization,'all')
            featurs = [bernoulli(featurs), tfidf(featurs), (log(featurs+1))] ;            
        
        end
        
        
        size_training = floor(.9*num_data);
        
        
        trainingset = featurs(Indices~=crossvalidateIter,:);
        testset = featurs(Indices==crossvalidateIter,:);
   
        
        responsevals = [style_ratings, comfort_ratings, overal_ratings,shoe_width,shoe_size_rating,shoe_arch_rating];
        
        responsevals_training = responsevals(Indices~=crossvalidateIter,:);
        responsevals_test = responsevals(Indices==crossvalidateIter,:);
        
         
    %disp('Linear Regression');
    % 
    
    tic;
    
    predictions = [];
    actual = [];
    for i =1:3
        a = responsevals_training(:,i);
        b = responsevals_test(:,i)';
        regresscoeff = regress(a, trainingset);
        C2 = (regresscoeff'*(testset'));
        predictions = [predictions, C2'];
        predictions( predictions>5)=5;
        predictions( predictions<1)=1;
        actual = [actual, b'];
    end
    
    
    MSE = mean(sum(((predictions-actual).^2)'))
     elapsed = toc;
        MSEarray = [MSEarray MSE];
        elapsedarray = [elapsedarray elapsed];
        
    end
    featurization  = possiblefeaturizations{feat}
    fprintf('Avergae MSE for Linear Regression is %0.10f\n', mean(MSEarray));
    subplot(3,2,feat*2-1)
    plot(MSEarray,'-o');
    title(strcat('MSE for Linear Regression (',featurization,') ', sprintf(' avergae MSE = %0.10f\n', mean(MSEarray))));
    xlabel('10 fold cross-validation (iteration no)')
    ylabel('MSE')
    subplot(3,2,feat*2)
    plot(elapsedarray,'-o');
    title(strcat('Elapsed time for Linear Regression (',featurization, ') ' , sprintf(' avergae elapsed time = %0.10f\n', mean(elapsedarray))));
    xlabel('10 fold cross-validation (iteration no)')
    ylabel('Elapsed Time')
    drawnow;
end



