% Genralized Sentiment Analysis
%

clc;
close all;
clear all;

tic;
% 
 fid = fopen('data\english.stop');
 
 stopwords = textscan(fid, '%s');
 stopwords = stopwords{1,1};
 fclose(fid);


% params
% n:minimum appearances of a stem
n=30;

% reading the data file
% xls is easier to read than csv
[num,txt,raw] = xlsread('C:\MatlabNLP\examples\gsa\data\final104.xls');

% reading the description of each shoe
descriptions = raw(2:size(raw,1),2);
style_ratings = num(1:size(num,1),1);
comfort_ratings = num(1:size(num,1),4);
overal_ratings = num(1:size(num,1),5);

% only take m data points


m=50;
m = length(descriptions);
descriptions = descriptions(1:m);
style_ratings = style_ratings(1:m);
comfort_ratings = comfort_ratings(1:m);
overal_ratings = overal_ratings(1:m);
g = containers.Map();
toc;

for i = 1:size(descriptions,1)
    comment = descriptions{i};
    comment = SanitizeComment(comment);
    comment = lower(comment);
    r=regexp(comment,' ','split');
    for j =1:size(r,2)
        word = porterStemmer(cell2mat(r(j)));
        tfflag = ~isStopWord(word, stopwords);
        if isKey(g, word) && tfflag
            g(word) = g(word)+1;
        elseif tfflag
            g(word) = 1;
        end
        
    end
    
    
    
    
end
toc;
selectedheaders =containers.Map();
gkeys = keys(g);

for i=1:size(gkeys,2)
    if g(gkeys{i})>=n
        
        selectedheaders(gkeys{i})=1;
        
    end
    
end
headers = keys(selectedheaders);

outputMatrix = zeros(m,length(headers));
for i = 1:size(descriptions,1)
    comment = descriptions{i};
    comment = SanitizeComment(comment);
    comment = lower(comment);
    
    r=regexp(comment,' ','split');
    comment = [];
    for j =1:size(r,2)
        word = porterStemmer(cell2mat(r(j)));
        
        comment = [comment,' ',word];
    end
    outputMatrix(i,:) = term_count(comment, headers);
    
    if mod(i,300)==0
        a = sprintf('%d', i);
        disp(a)
    end
    
    
    
end


toc;
csvwrite('forWeka_featuresonly.csv', outputMatrix);

outputmatrix_all = [style_ratings,comfort_ratings,overal_ratings, outputMatrix];
outputmatrix_all = [ones(1,size(outputmatrix_all,2));outputmatrix_all];
csvwrite('forWeka_everything.csv', outputmatrix_all);

