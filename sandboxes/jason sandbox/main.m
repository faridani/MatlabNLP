

% Genralized Sentiment Analysis
% 

clc;
close all;
clear all;

tic;

n = 200;

% reading the data file
% xls is easier to read than csv
[num,txt,raw] = xlsread('C:\Users\FLOW\Desktop\faridani-MatlabNLP-2e75adc\examples\jason\data\final104.xls');

% reading the description of each shoe
descriptions = raw(2:size(raw,1),2);
style_ratings = num(1:size(num,1),1);
comfort_ratings = num(1:size(num,1),4);
overal_ratings = num(1:size(num,1),5);

%Y = runFeaturizerWithLargeAmountofText(descriptions, 4);
descriptions = descriptions(1:200,1);

% create maps (global and local to cell) with <key,value> => <keyword,frequency>
globMap = containers.Map();
mapOfMaps = containers.Map(1, containers.Map());  % map of cellMaps


% for each string (inside each cell), clean up text split by ' ' char, stem
% each string (word) created by split, and then update the globMap and
% cellMap
for i = 1:size(descriptions,1)
    cellMap = containers.Map();
    comment = lower(sanitizeComment(descriptions{i}));
    r = regexp(comment, ' ', 'split');  % r is a cellArray of strings(words)
    for j = 1:size(r, 2)
        word = porterStemmer(cell2mat(r(j)));
        
        % check globMap key and update
        if isKey(globMap, word)
            globMap(word) = globMap(word) + 1;
        else
            globMap(word) = 1;
        end
        
        % check cellMap key and update
        if isKey(cellMap, word)
            cellMap(word) = cellMap(word) + 1;
        else
            cellMap(word) = 1;
        end
        
    end
    
    % place the cellMap into mapOfMaps
    mapOfMaps(i) = cellMap;
    
end

selectedHeaders = containers.Map();
globKeys = keys(globMap);

for i = 1:size(globKeys,2)
    if globMap(globKeys{i}) >= n
        
        selectedHeaders(globKeys{i})=1;

    end
        
end

headers = keys(selectedHeaders);    % headers is a cell array of keys

outputMatrix = [];
for i = 1:size(descriptions,1)
    outArray = [];
    ithCell = mapOfMaps(i);
    for j = 1:size(headers,2)
        if isKey(ithCell, headers{j})
            wordCount = ithCell(headers{j});
            outArray = [outArray, wordCount];
        else
            outArray = [outArray, 0];
        end
    end
    outputMatrix = [outputMatrix; outArray];
end

% csvwrite('outputJ.csv',outputMatrix);

toc;
