% predicting numerical values using Linear Regression
clear all;
format long
disp('===== Linear Regression ====');
disp('Reading featur vector');



Indices = crossvalind('Kfold', 26548, 10);
figure;

subplot(3,2,1);

for feat = 1:3
      MSEarray =[];
    elapsedarray =[];
    for crossvalidateIter = 1:10
        (fprintf('%d',crossvalidateIter));
    featurs = csvread('data\forWeka_featuresonly.csv');
    num_data = size(featurs,1); %5000;
    %disp(sprintf('Number of datapoints %d',num_data))
    
    possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'};
    %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
    featurization  = possiblefeaturizations{feat};
    
    
    featurs = featurs(:,2:size(featurs,2));
    if strcmp(featurization,'multinomial')
        %just pass
    elseif strcmp(featurization,'bernouli')
        featurs = bernoulli(featurs);
    elseif strcmp(featurization,'tfidf')
        featurs = tfidf(featurs);
    end
    
     size_training = floor(.9*num_data);
        
        
        trainingset = featurs(Indices~=crossvalidateIter,:);
        testset = featurs(Indices==crossvalidateIter,:);
        
    
    %disp('Splitting up data into training/test sets');
    [num,txt,raw] = xlsread('data\final104.xls');
    
    % reading the description of each shoe
    descriptions = raw(2:size(raw,1),2);
    style_ratings = num(1:size(num,1),1);
    comfort_ratings = num(1:size(num,1),4);
    overal_ratings = num(1:size(num,1),5);
    
    % only take m data points
    m=num_data;
    descriptions = descriptions(1:m);
    style_ratings = style_ratings(1:m);
    comfort_ratings = comfort_ratings(1:m);
    overal_ratings = overal_ratings(1:m);
    
    responsevals = [style_ratings, comfort_ratings, overal_ratings];
    
  
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



