function Y = runFeaturizerWithLargeAmountofText(comments, min_no_of_appearance)
%finding top headers (words that appear a lot)
fid = fopen('data\english.stop');

stopwords = textscan(fid, '%s');
stopwords = stopwords{1,1};
fclose(fid);
mydata = comments;
file_1 = fopen('tempoutput1.txt','w')


number_of_comments = size(mydata,1);
userCommentsTable=[];
for i=2:number_of_comments
    %getting information for each commentor
    fprintf('Processing comment %1.0f out of %6.0f comments \n',i,number_of_comments)

    initarray=mydata(i,:);
    
    %id = cell2mat(initarray(1)); % the original data is in cell format
    %user_id = cell2mat(initarray(2));
    comment = cell2mat(initarray(1));
    comment = SanitizeComment(comment);
    comment = lower(comment);
    r=regexp(comment,' ','split');
    rstemmed=[];
    for st = 1:size(r,2)
        if (isStopWord(cell2mat(r(st)),stopwords))
            % do nothing it is a stop word
        else 
            rstemmed = [rstemmed,' ', porterStemmer(cell2mat(r(st)))];
        end
        
    end
    
    comment = rstemmed;
    %comment = SanitizeComment(comment);
    fprintf(file_1,'%s\n\n\n',comment);
    %userCommentsTable = [userCommentsTable; [user_id, strcat(comment)]];
    
    

end
fclose(file_1);

%% Now generating the feature vector
 fid = fopen('tempoutput1.txt');
 featureHeader = textscan(fid, '%s');
featureContents= featureHeader{1,1};
featureHeader = unique(featureHeader{1,1});
% start counring 
tic;
wordcounts = countWords(featureContents,featureHeader);
toc;

fclose(fid);















save('wordcounts.mat','wordcounts')
wordcounts = load('wordcounts.mat');
wordcounts = wordcounts.wordcounts;
B = (wordcounts>min_no_of_appearance) %have been seen at least 5 times
updatedHeader=featureHeader(find(wordcounts>min_no_of_appearance),1);
%X=[];

tic;
Y=[];

for i=2:number_of_comments
    %getting information for each commentor
    fprintf('Processing comment %1.0f out of %6.0f comments \n',i,number_of_comments)

    initarray=mydata(i,:);
    
    %id = cell2mat(initarray(1)); % the original data is in cell format
    %user_id = cell2mat(initarray(2));
    comment = cell2mat(initarray(1));
    comment = SanitizeComment(comment);
    comment = lower(comment);
    r=regexp(comment,' ','split');
    rstemmed=[];
    for st = 1:size(r,2)
        if (isStopWord(cell2mat(r(st)),stopwords))
            % do nothing it is a stop word
        else 
            rstemmed = [rstemmed,' ', porterStemmer(cell2mat(r(st)))];
        end
        
    end
    
    comment = rstemmed;
    comment = SanitizeComment(comment);
    r=regexp(comment,' ','split');
    r=r';
    Y = [Y; [countWords(r,updatedHeader)]'];
    %X = [X; userRatingsTable(find(userRatingsTable(:,1)'==str2num(user_id)),1:6)];
    
    
    

end

toc;
save('FeaturizedOrigY.mat','Y');
output = Y;
end
