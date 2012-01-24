

% Genralized Sentiment Analysis
% 

clc;
close all;
clear all;

tic;

% params 
% n:minimum appearances of a stem
n=10;

% reading the data file
% xls is easier to read than csv
[num,txt,raw] = xlsread('C:\MatlabNLP\examples\gsa\data\final104.xls');

% reading the description of each shoe
descriptions = raw(2:size(raw,1),2);
style_ratings = num(1:size(num,1),1);
comfort_ratings = num(1:size(num,1),4);
overal_ratings = num(1:size(num,1),5);

%descriptions = descriptions(1:2000);
g = containers.Map();

for i = 1:size(descriptions,1)
    comment = descriptions{i};
    comment = sanitizeComment(comment);
    comment = lower(comment);
    r=regexp(comment,' ','split');
    for j =1:size(r,2)
        word = porterStemmer(cell2mat(r(j)));
        if isKey(g, word)
            g(word) = g(word)+1;
        else
            g(word) = 1;
        end
        
    end
    
    
    
    
end

selectedheaders =containers.Map();
gkeys = keys(g);

for i=1:size(gkeys,2)
    if g(gkeys{i})>=n
        
        selectedheaders(gkeys{i})=1;
        
    end
        
end
headers = keys(selectedheaders);

outputMatrix = [];
for i = 1:size(descriptions,1)
    comment = descriptions{i};
    comment = sanitizeComment(comment);
    comment = lower(comment);
    
    r=regexp(comment,' ','split');
    comment = [];
    for j =1:size(r,2)
        word = porterStemmer(cell2mat(r(j)));
       
        comment = [comment,' ',word];
    end
    outputMatrix = [outputMatrix;term_count(comment, headers)];
    
    
    
    
end


toc;

