clc;
clear all;
close all;
tic;

addpath('funcs');
addpath('libsvm');

negfiles = getAllFiles('data\txt_sentoken\neg\');
posfiles = getAllFiles('data\txt_sentoken\pos\');
labels = [-ones(size(negfiles,1),1); ones(size(posfiles,1),1)];

allfiles = [negfiles;posfiles];
mycellarray ={};

for i = 1:size(allfiles,1)
    disp(sprintf('%d out of %d', i, size(allfiles,1)));
    myfile = allfiles{i};
    fid = fopen( myfile);
    s = textscan(fid,'%s','Delimiter','\n');
    mystr = '';
    for mycellindex = 1:size(s{1,1},1)
        mystr = strcat(mystr, s{1,1}{mycellindex});
    end
    fclose(fid);
    mycellarray{end+1} = mystr;
end
mycellarray = mycellarray';
%mycellarray2 = mycellarray;
%mycellarray = mycellarray(1:5);

n=30
tic;

featureVector = featurize(mycellarray, n, 0, 1);
featureVectorOrig = featureVector;
save('featureVectorn30.dump','featureVector')

disp('Naive Bayes - Multinomial');
%10 fold validation
Fresults = [];

for i = 1:10
    randomindices = randperm(2000);
    randomindices = randomindices(1:1800);
    otherindices = (1:2000)';
    testsetindex = setdiff(otherindices,randomindices)';
    trainingsetindex = randomindices ;
    trainingset = featureVector(trainingsetindex,:);
    traininglabel = labels(trainingsetindex,:);
    
    testset = featureVector(testsetindex,:);
    testlabel = labels(testsetindex,:);
    O1 = NaiveBayes.fit(trainingset,traininglabel,'dist','mn'); % or  'mvmn'
    C2 = O1.predict(testset);
    cMat2 = confusionmat(testlabel,C2);
    Fresults = [Fresults,F1measureConfusionMatrix(cMat2)];
end
disp(n);
mean(Fresults)

toc;

disp('SVM - Multinomial');
%10 fold validation
Fresults = [];

for i = 1:10
    randomindices = randperm(2000);
    randomindices = randomindices(1:1800);
    otherindices = (1:2000)';
    testsetindex = setdiff(otherindices,randomindices)';
    trainingsetindex = randomindices ;
    trainingset = featureVector(trainingsetindex,:);
    traininglabel = labels(trainingsetindex,:);
    
    testset = featureVector(testsetindex,:);
    testlabel = labels(testsetindex,:);
    
    
       model = svmtrain(traininglabel, trainingset, '-c 1 -g 0.07');
        Group = svmpredict(testlabel, testset, model); % test the training data
   
    
    
    
    
    cMat2 = confusionmat(testlabel,Group);
    Fresults = [Fresults,F1measureConfusionMatrix(cMat2)];
end
disp(n);
Fresults(isnan(Fresults))=[]
mean(Fresults)

toc;


disp('Naive Bayes - Bernoulli');
%10 fold validation
Fresults = [];
featureVector = bernoulli(featureVectorOrig);

for i = 1:10
    randomindices = randperm(2000);
    randomindices = randomindices(1:1800);
    otherindices = (1:2000)';
    testsetindex = setdiff(otherindices,randomindices)';
    trainingsetindex = randomindices ;
    trainingset = featureVector(trainingsetindex,:);
    traininglabel = labels(trainingsetindex,:);
    
    testset = featureVector(testsetindex,:);
    testlabel = labels(testsetindex,:);
    O1 = NaiveBayes.fit(trainingset,traininglabel,'dist','mn'); % or  'mvmn'
    C2 = O1.predict(testset);
    cMat2 = confusionmat(testlabel,C2);
    Fresults = [Fresults,F1measureConfusionMatrix(cMat2)];
end
disp(n);
mean(Fresults)

toc;


%Results
%featurize(mycellarray, n, 0, 0)
%n = 20, ans =    0.7821, Elapsed time is 505.936294 seconds.
%n = 30, ans =     0.8104, Elapsed time is 411.716600 seconds.
%n =40, ans =    0.8061, Elapsed time is 368.420113 seconds
%      50,     0.8007,  336.780544 seconds.
% 60,    0.7817, Elapsed time is 327.073380 seconds.
% 70,    0.8011, Elapsed time is 301.389434 seconds.
%   80,    0.7965, Elapsed time is 288.748270 seconds.
% 90,   0.7910, Elapsed time is 277.748261 seconds.
%  100,    0.8015, Elapsed time is 267.136191 seconds.


