% predicting numerical values using CCA regression

disp('===== Multi Label SVM ====');
disp('Reading featur vector');
num_data = 800 % size(featurs,1); %5000;


featurization = 'tfidf' %'multinomial'; % 'bernouli', 'tfidf'


featurs = csvread('data\forWeka_featuresonly.csv');
featurs = featurs(:,2:size(featurs,2));
if strcmp(featurization,'multinomial')
    %just pass
elseif strcmp(featurization,'bernouli')
    featurs = (featurs>0);
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
disp('Multilabel SVM ');

disp('Support Vector Machines');
%http://www.mathworks.com/help/toolbox/bioinfo/ref/svmtrain.html

tic;

a_orig = responsevals_training(:,3)';
b_orig = responsevals_test(:,3)';
b_out = [];
for i=5:-1:1
    disp(i);
    a = (a_orig==i);
    b = (b_orig==i);
    options = optimset('maxiter',1000);
    SVMStruct = svmtrain(trainingset,a','Kernel_Function','mlp','Method','QP','quadprog_opts',options); %SVMStruct = svmtrain(Training,Group)
    Group = svmclassify(SVMStruct,testset);
    b_out = [b_out,Group];
    toc;
end
output = (sum(b_out,2)==1)'.*max((b_out.*repmat([5,4,3,2,1],size(b_out,1),1))')
cMat2 = confusionmat(output,b_orig)
toc;



