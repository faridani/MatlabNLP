% predicting numerical values using CCA
clc;

clear all;
format long
warning off all;

disp('===== Linear CCA for Regression ====');
%disp('Reading featur vector');

runResults = [];
tic;

for nData =500:500:25000
    for feat = 1:3
        possiblefeaturizations =  {'bernouli', 'tfidf','multinomial'};
        %featurization = 'bernouli'%'tfidf'%'tfidf'%'multinomial'%'tfidf' %'multinomial'; % 'bernouli', 'tfidf'
        featurization  = possiblefeaturizations{feat};
        featurs = csvread('data\forWeka_featuresonly.csv');
        featurs = featurs(:,2:size(featurs,2));
        
        % killed my computer ones featurs = sparse(featurs);
        
        num_data = nData; %size(featurs,1); %5000;
        
        
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
        
        responsevals_training = responsevals(1:size_training,:);
        responsevals_test = responsevals((size_training+1):num_data,:);
        
        
        % http://www.mathworks.com/help/toolbox/stats/classregtree.html
        
        
        
        predictions = [];
        actual = [];
        
        
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
        runResults = [runResults; nData, feat, MSE];
        
        
    end
end
toc;
save('runResultsforCCA.dump','runResults');


%figure;
%hold on;
[row,col] = find(runResults==1);
x1 = runResults(row,1);
y1 = runResults(row,3);
%plot(x1,y1,'r','LineWidth',2 )
[row,col] = find(runResults==2);
x2 = runResults(row,1);
y2 = runResults(row,3);
%plot(x2,y2,'b','LineWidth',2 )
[row,col] = find(runResults==3);
x3 = runResults(row,1);
y3 = runResults(row,3);
%plot(x3,y3,'g','LineWidth',2 )


figure
plot(x1,y1,x2,y2,x3,y3);
hleg = legend('Bernoulli','tf-idf','Multinomial',...
    'Location','NorthEastOutside')
% Make the text of the legend italic and color it brown
set(hleg,'FontAngle','italic','TextColor',[.3,.2,.1])
xlabel('Number of Training Data')
ylabel('MSE Error')
set(gca,'XTickLabel',{'0','5,000','10,000','15,000','20,000','25,000'})

figure
plot(x1,y1,'-o',x2,y2,'-*',x3,y3,'-+', 'MarkerSize',3);
hleg = legend('Bernoulli','tf-idf','Multinomial',...
              'Location','NorthEast')
% Make the text of the legend italic and color it brown
set(hleg,'FontAngle','italic','TextColor',[.3,.2,.1])
%title('MSE Error vs. Number of Reviews Used in Model') 
ylabel('Mean Squared Error');
xlabel('Number of reviews used for training');
set(gca,'XTickLabel',[0, 5000,10000,15000,20000,25000])