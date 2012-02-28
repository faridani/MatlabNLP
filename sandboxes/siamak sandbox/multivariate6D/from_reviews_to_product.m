clc;
close all;
clear all;

[num,txt,raw] = xlsread('data\final105.xls');

descriptions = raw(2:size(raw,1),2);
style_ratings = num(1:size(num,1),1);
comfort_ratings = num(1:size(num,1),4);
overal_ratings = num(1:size(num,1),5);

productids = cell2mat(raw(2:size(raw,1),7));
uniqueprodids =unique(productids);
outputdata = [];
outputdesc = {};

for productid = 1:size(uniqueprodids,1)

    rawdataindex = (find(productids==uniqueprodids(productid)));
    temp_style_rating = mean(style_ratings(rawdataindex));
    temp_comfort_ratings = mean(comfort_ratings(rawdataindex));
    temp_overal_ratings = mean(overal_ratings(rawdataindex));
    temp_individual_desc = descriptions(rawdataindex);
    temp_descriptions = strcat(temp_individual_desc{:},' ');
    outputdata = [outputdata; temp_style_rating, temp_comfort_ratings, temp_overal_ratings];
    outputdesc{end+1} = temp_descriptions;
end

hist(outputdata,500)
tic
%featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores)
[featureVector,selectedheaderskeys] = featurize_parallel(outputdesc', 20, 0, 1, 1, 4);
toc
csvwrite('data\productsdesc.csv', featureVector);
csvwrite('data\productsvocab.csv', selectedheaderskeys);
csvwrite('data\productsratings.csv', outputdata);
%