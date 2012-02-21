clc;

close all;
clear all;

disp('Running all the experiments together')

%featuriziation
% comment out when done with featurizer
promptresponse = input('would you like to featurize? [Y/N enter for N]', 's');
if (promptresponse=='y' || promptresponse=='Y')
    
    [num,txt,raw] = xlsread('data\final104.xls');
    descriptions = raw(2:size(raw,1),2);
    style_ratings = num(1:size(num,1),1);
    comfort_ratings = num(1:size(num,1),4);
    overal_ratings = num(1:size(num,1),5);
    [featurs, headers] = featurize_bigram(descriptions,20,0,1);
    csvwrite('data\forWeka_featuresonly.csv', featurs);
    csvwrite('data\headers.csv', headers);
end


ccaregression_generalized
ccaregression_generalized_adjusted
linearRegression_generalized
naivbayes_generalized
regresstree_generalized
%svm_generalized

