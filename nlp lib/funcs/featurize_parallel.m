function [featureVector,selectedheaderskeys] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores)
%
%
% function [featureVector,selectedheaderskeys] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores)
%
% Takes an input cell array in which each cell is a review or text and
% outputs a feature vector with a number of features (nminFeatures is the
% number of times that a feature should be presented in the corpus to be
% included in the feature vector.)
%
% The approach is basically a bag-of-word but we also add bigrams to the
% feature vector too
%
% removeStopWords is a flag, if it is true it will remove the stop words.
%
% Inputs:
%       inputcellarray: a cell array with texts as the content of each cell
%       nFeatures: the number of features that we like to see in the vetor
%       removeStopWords: if ==1 it will remove all the stop words
%       doStem: a flag if true porter stemmer will be used
%       grams: 1 for 1-grams, 2 for bigrams (mixed with one grams)
%       cores: up to 4 on local machine
%
% Outputs:
%       featureVector
%       selectedheaderskeys: text of the features


% Test case:

% inputcellarray = {' MATLAB desktop keyboard shortcuts, such as Ctrl+S,  are now customizable.';' To customize keyboard shortcuts, use ';'Preferences. From there, you can also  ,';'restore previous default settings by following the ';'steps outlined in Help.'}
% nminFeatures = 1;
% removeStopWords = 0;
% doStem =1;
% grams =1;
% cores = 1;
% [featureVector,selectedheaderskeys] = featurize_parallel(inputcellarray, nminFeatures, removeStopWords, doStem, grams, cores)


%

if size(inputcellarray,1)==1
    disp 'ERROR: you are probably sending a row vector to this function, the size of the cell array should be (n,1)'
    featureVector = [];
    selectedheaderskeys =[];
    return
end

isOpen = matlabpool('size') > 0;
if isOpen
    matlabpool close
end

matlabpool(cores)

fid = fopen('english.stop');
stopwords = textscan(fid, '%s');
stopwords = stopwords{1,1};
fclose(fid);


% params
% n:minimum appearances of a stem
n=nminFeatures;

if cores>4
    disp('ERROR: up to 4 cores supported at the moment');
    return
end

g = {containers.Map(),containers.Map(),containers.Map(),containers.Map()};
bigs = {containers.Map(),containers.Map(),containers.Map(),containers.Map()};

%MAPPER
%breaking the data randomly into pieces 
dataindex = crossvalind('Kfold', size(inputcellarray,1), cores);
datapar = {[],[],[],[]};
parfor corjobs = 1:cores
    datapar{corjobs} = inputcellarray(dataindex==corjobs);
end

parfor corjobs = 1:cores
    lastword = '';
    
    for i = 1:size(datapar{corjobs},1)
        %fprintf('%d/%d\n', i, size(datapar{corjobs},1));
        comment = datapar{corjobs}{i};
        comment = SanitizeComment(comment);
        comment = lower(comment);
        r=regexp(comment,' ','split');
        for j =1:size(r,2)
            
            if doStem
                word = porterStemmer(cell2mat(r(j)));
            else
                word = (cell2mat(r(j)));
            end
            
            if removeStopWords % if the function caller wants to remove stopwords
                tfflag = ~isStopWord(word, stopwords);
            else
                tfflag = 1;
            end
            
            if isKey(g{corjobs}, word) && tfflag
                g{corjobs}(word) = g{corjobs}(word)+1;
            elseif tfflag && (~strcmp(word,' ')) && (~strcmp(word,''))
                g{corjobs}(word) = 1;
            end
            if  (grams==2) && (~strcmp(lastword,'')) && (~strcmp(word,' ')) && (~strcmp(lastword,' ')) && (~strcmp(word,''))
                bigram = char(strcat(lastword, {' '}, word));
                % for debugging :) fprintf('DDD%sDDDDDD%sDDD%sDDD\n',bigram,lastword,word);
                if isKey(g{corjobs}, bigram)
                    g{corjobs}(bigram) = g{corjobs}(bigram)+1;
                else
                    bigs{corjobs}(bigram) =1;
                    g{corjobs}(bigram) = 1;
                    
                end
            end
            lastword = word;
            
        end
        
        
        
        
    end
end


%REDUCER
gReduced = g{1};
for i=2:cores
    mycontainermap = g{i};
    
    
    mykeys = keys(mycontainermap);
    
     
    for j=1:size(mykeys,2)
        mykey = mykeys(j);
      
        if ~isKey(gReduced,  mykey)
            
            gReduced(char(mykey)) =  mycontainermap(char(mykey));
        else
            
            gReduced(char(mykey)) =  gReduced(char(mykey))+ mycontainermap(char(mykey));
        end
    end
    
end

clear g

selectedheaders =containers.Map();
gkeys = keys(gReduced);

for i=1:size(gkeys,2)
    if gReduced(gkeys{i})>=n
        
        selectedheaders(gkeys{i})=1;
        
    end
    
end
headers = keys(selectedheaders);

outputMatrix = {[],[],[],[]}; 
%%MAPPER
parfor corjobs = 1:cores
outputMatrix{corjobs} = zeros(size(datapar{corjobs},1),length(headers));
for i = 1:size(datapar{corjobs},1)
    %fprintf('%d/%d ', i, size(datapar{corjobs},1));
    comment = datapar{corjobs}{i};
    comment = SanitizeComment(comment);
    comment = lower(comment);
    
    r=regexp(comment,' ','split');
    comment = [];
    for j =1:size(r,2)
        if doStem
            word = porterStemmer(cell2mat(r(j)));
        else
            word = (cell2mat(r(j)));
        end
        
        comment = [comment,' ',word];
    end
    outputMatrix{corjobs}(i,:) = term_count(comment, headers);
    
    if mod(i,300)==0
        a = sprintf('%d', i);
        disp(a)
    end
    
    
    
end
end

%%REDUCER
ids = 1:size(inputcellarray,1);
featureVector = zeros(size(outputMatrix{1},1)+size(outputMatrix{2},1)+size(outputMatrix{3},1)+size(outputMatrix{4},1),size(outputMatrix{1},2));
for corjobs = 1:cores
 myids = ids(dataindex==corjobs);
 featureVector(myids,:) =outputMatrix{corjobs};
 
 
end


selectedheaderskeys = keys(selectedheaders);
%csvwrite('forWeka_featuresonly.csv', outputMatrix);
disp('');


matlabpool close

end

