% predicting numerical values using Logistic Regression
clear all;
format long
disp('===== Logistic Regression ====');
disp('Reading featur vector');



for feat = 1:3
    featurs = csvread('data\forWeka_featuresonly.csv');
    num_data = 50%size(featurs,1); %5000;
    disp(sprintf('Number of datapoints %d',num_data))
    
    possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'};
    %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
    featurization  = possiblefeaturizations{feat}
    
    
    featurs = featurs(:,2:size(featurs,2));
    if strcmp(featurization,'multinomial')
        %just pass
    elseif strcmp(featurization,'bernouli')
        featurs = double(featurs>0);
    elseif strcmp(featurization,'tfidf')
        occurance = (featurs>0);
        idf = log(size(featurs,1)./sum(occurance));
        featurs = featurs.*repmat( idf, size(featurs,1),1);
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
    
    disp('Logistic Regression');
    % 
    
    tic;
    
    predictions = [];
    actual = [];
    for i =1:3
        a = responsevals_training(:,i);
        b = responsevals_test(:,i)';
        [COEFF,SCORE] = princomp(trainingset);
        regresscoeff = mnrfit(SCORE,a);
        C2 = (regresscoeff'*(testset'));
        predictions = [predictions, C2'];
        actual = [actual, b'];
    end
    
    
    MSE = mean(sum(((predictions-actual).^2)'))
    toc;
    
end
