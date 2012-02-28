% predicting numerical values using Naive Bayes
clear all;
format long
disp('===== Naive Bayes ====');
disp('Reading featur vector');



for feat = 1:2
    featurs = csvread('data\forWeka_featuresonly.csv');
    num_data = size(featurs,1); %5000;
    possiblefeaturizations = {'bernouli', 'multinomial'} %'tfidf',
    featurization  = possiblefeaturizations{feat}
    disp(sprintf('Number of datapoints %d',num_data))
    
    
    featurs = featurs(:,2:size(featurs,2));
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
    
    disp('Naive Bayes');
    % http://www.mathworks.com/help/toolbox/stats/naivebayesclass.html
    tic;
    
    predictionsKernel1 = [];
    predictionsKernel2 = [];
    actual = [];
    
    
    for i =1:3
        
        
        
        
        
        a = responsevals_training(:,i)';
        b = responsevals_test(:,i)';
        actual = [actual, b'];
        
        O1 = NaiveBayes.fit(trainingset,a,'dist','mn'); % or  'mvmn'
        C2 = O1.predict(testset);
        predictionsKernel1 = [predictionsKernel1, C2];
        %cMat2 = confusionmat(b,C2)
%         
%         disp('Second Kernel');
%         O1 = NaiveBayes.fit(trainingset,a,'dist','mvmn'); % or  'mvmn'
%         C2 = O1.predict(testset);
%         %cMat2 = confusionmat(b,C2)
%         predictionsKernel2 = [predictionsKernel2, C2];
%         
    end
    
    
    MSE1 = mean(sum(((predictionsKernel1-actual).^2)'))
    %MSE2 = mean(sum(((predictionsKernel2-actual).^2)'))
    toc;
    
end


