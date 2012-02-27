% predicting numerical values using CCA
% large values and small values are corrected

clear all;
format long
disp('===== Linear CCA for Regression ====');
disp('Reading featur vector');

Indices = crossvalind('Kfold', 1107, 10);
figure;

subplot(3,2,1);

for feat = 1:3
    MSEarray =[];
    elapsedarray =[];
    for crossvalidateIter = 1:10
        (fprintf('%d',crossvalidateIter));
        possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'};
        %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
        featurization  = possiblefeaturizations{feat};
        featurs = csvread('data\productsdesc.csv');
        featurs = featurs(:,2:size(featurs,2));
        
        
        num_data = size(featurs,1); %5000;
        
        
        %disp(sprintf('Number of datapoints %d',num_data))
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
        [num,txt,raw] = xlsread('data\productsratings.csv');
        
        responsevals = num;
        
        responsevals_training = responsevals(Indices~=crossvalidateIter,:);
        responsevals_test = responsevals(Indices==crossvalidateIter,:);
        
        %disp('Adjusted Linear CCA ');
        % http://www.mathworks.com/help/toolbox/stats/classregtree.html
        
        tic;
        
        %predictions = [];
        %actual = [];
        
        
        [Wx, Wy, r, U, V]  = canoncorr(trainingset,responsevals_training);
        % in [A,B,r,U,V],  U and V are cannonical scores
        % U = (X-repmat(mean(X),N,1))*A
        % V = (Y-repmat(mean(Y),N,1))*B
        
        
        %recheck this part
        N =  size(testset,1);
        predictions = ((testset-repmat(mean(testset),N,1))*Wx*pinv(Wy))+repmat(mean(responsevals_test),N,1);
        actual = responsevals_test;
        predictions( predictions>5)=5;
        predictions( predictions<1)=1;
        MSE = mean(sum(((predictions-actual).^2)'));
        elapsed = toc;
        MSEarray = [MSEarray MSE];
        elapsedarray = [elapsedarray elapsed];
        
    end
    featurization  = possiblefeaturizations{feat}
    fprintf('avergae MSE for adjusted CCA is %0.10f\n', mean(MSEarray));
    subplot(3,2,feat*2-1)
    plot(MSEarray,'-o');
    title(strcat('MSE adjusted CCA (',featurization,') ', sprintf(' avergae MSE = %0.10f\n', mean(MSEarray))));
    xlabel('10 fold cross-validation (iteration no)')
    ylabel('MSE')
    subplot(3,2,feat*2)
    plot(elapsedarray,'-o');
    title(strcat('Elapsed time for adjusted CCA (',featurization, ') ' , sprintf(' avergae elapsed time = %0.10f\n', mean(elapsedarray))));
    xlabel('10 fold cross-validation (iteration no)')
    ylabel('Elapsed Time')
    drawnow;
end



