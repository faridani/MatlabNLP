% predicting numerical values using CCA regression
% I have realized that the svmtrain in MATLAB will not work on this
% I am using the libSVM library
% you just need to copy and paste mex files here

disp('===== Multi Label SVM ====');
disp('Reading featur vector');
clear all;
format long



for feat = 1:3
    possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'}
    %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
    featurization  = possiblefeaturizations{feat}
    featurs = csvread('data\forWeka_featuresonly.csv');
    num_data =  size(featurs,1); %5000;
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
    
    
    % see libsvm reademe
    
    tic;
    
    predictions = [];
    actual = [];
    for i =1:3
        a = responsevals_training(:,i)';
        b = responsevals_test(:,i)';
        a = double(a);
        b = double(b);
        
        
        model = svmtrain(a', trainingset, '-c 1 -g 0.07');
        Group = svmpredict(b', testset, model); % test the training data
        %class = classregtree(trainingset,a');
        %yfit = (eval(class,testset));
        predictions = [predictions, Group];
        actual = [actual, b'];
    end
    
    
    MSE = mean(sum(((predictions-actual).^2)'))
    toc;
    
end


