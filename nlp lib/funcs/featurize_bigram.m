function [featureVector,selectedheaderskeys] = featurize_bigram(inputcellarray, nminFeatures, removeStopWords, doStem)
%
%
% featureVector = featurize_bigram(inputcellarray, nminFeatures, removeStopWords, doStem)
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
% Outputs:
%       featureVector


% Test case:

% inputcellarray = {' MATLAB desktop keyboard shortcuts, such as Ctrl+S,  are now customizable.';' To customize keyboard shortcuts, use Preferences. From there, you can also  restore previous default settings by following the steps outlined in Help.'}
% nminFeatures = 1;
% removeStopWords = 0;
% doStem =1;
% featureVector = featurize_bigram(inputcellarray, nminFeatures, removeStopWords, doStem)


%
fid = fopen('english.stop');

stopwords = textscan(fid, '%s');
stopwords = stopwords{1,1};
fclose(fid);


% params
% n:minimum appearances of a stem
n=nminFeatures;

g = containers.Map();
bigs = containers.Map();
lastword = '';
for i = 1:size(inputcellarray,1)
    fprintf('%d/%d\n', i, size(inputcellarray,1));
    comment = inputcellarray{i};
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
        
        if isKey(g, word) && tfflag
            g(word) = g(word)+1;
        elseif tfflag & (~strcmp(word,' ')) & (~strcmp(word,''))
            g(word) = 1;
        end
        if  (~strcmp(lastword,'')) & (~strcmp(word,' ')) & (~strcmp(lastword,' ')) & (~strcmp(word,''))
            bigram = char(strcat(lastword, {' '}, word));
            % for debugging :) fprintf('DDD%sDDDDDD%sDDD%sDDD\n',bigram,lastword,word);
            if isKey(g, bigram)
                g(bigram) = g(bigram)+1;
            else
                bigs(bigram) =1;
                g(bigram) = 1;
                
            end
        end
        lastword = word;
        
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

outputMatrix = zeros(size(inputcellarray,1),length(headers));
for i = 1:size(inputcellarray,1)
    fprintf('%d/%d ', i, size(inputcellarray,1));
    comment = inputcellarray{i};
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
    outputMatrix(i,:) = term_count(comment, headers);
    
    if mod(i,300)==0
        a = sprintf('%d', i);
        disp(a)
    end
    
    
    
end


featureVector = outputMatrix;
selectedheaderskeys = keys(selectedheaders);
%csvwrite('forWeka_featuresonly.csv', outputMatrix);
disp('');

end

