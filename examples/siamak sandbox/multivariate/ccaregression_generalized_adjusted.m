% predicting numerical values using CCA
% large values and small values are corrected

clear all;
format long
disp('===== Linear CCA for Regression ====');
disp('Reading featur vector');



for feat = 1:3
    possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'}
    %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
    featurization  = possiblefeaturizations{feat}    
    featurs = csvread('data\forWeka_featuresonly.csv');    
    featurs = featurs(:,2:size(featurs,2));
    
    
    num_data = size(featurs,1); %5000;
    
    
    disp(sprintf('Number of datapoints %d',num_data))
   if strcmp(featurization,'multinomial')
        %just pass
    elseif strcmp(featurization,'bernouli')
        featurs = bernoulli(featurs);
    elseif strcmp(featurization,'tfidf')
        featurs = tfidf(featurs);
    end
    
    
    size_training = floor(.8*num_data);
    
    
    trainingset = featurs(1:size_training,:);
    testset = featurs((size_training+1):num_data,:);
    
    
    disp('Splitting up data into training/test sets');
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
    
    responsevals_training = responsevals(1:size_training,:);
    responsevals_test = responsevals((size_training+1):num_data,:);
    
    disp('Linear CCA ');
    % http://www.mathworks.com/help/toolbox/stats/classregtree.html
    
    tic;
    
    predictions = [];
    actual = [];
    
    
    [Wx, Wy, r, U, V]  = canoncorr(trainingset,responsevals_training);
    % in [A,B,r,U,V],  U and V are cannonical scores
    % U = (X-repmat(mean(X),N,1))*A
    % V = (Y-repmat(mean(Y),N,1))*B

    
    %recheck this part 
    N =  size(testset,1)
    predictions = ((testset-repmat(mean(testset),N,1))*Wx*pinv(Wy))+repmat(mean(responsevals_test),N,1);
    actual = responsevals_test;
     predictions( predictions>5)=5;
     predictions( predictions<1)=1;
    MSE = mean(sum(((predictions-actual).^2)'))
    toc;
    
end


