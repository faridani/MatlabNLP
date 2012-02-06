clc;
clear all;
close all;
tic;

addpath('funcs');
negfiles = getAllFiles('data\txt_sentoken\neg\');
posfiles = getAllFiles('data\txt_sentoken\pos\');
labels = [zeros(size(negfiles,1),1); ones(size(posfiles,1),1)];

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


featureVector = featurize(mycellarray, 20, 0, 0);

save('featureVectorn50.dump','featureVector')

%10 fold validation 
Fresults = []
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

mean(Fresults)

toc;

