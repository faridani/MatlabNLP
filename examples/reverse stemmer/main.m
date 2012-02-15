% Finds the stem for each word

clc;
close all;
clear all;
tic;

disp 'Revese Stemmer by Siamak Faridani'
disp '---------------------------------'


disp 'Reading corpus'
% the corpus is in input.txt
fid1 = fopen('input.txt','r');
fid2 = fopen('output.txt','w');

stems = {};
origwords ={};

while ~feof(fid1)
    line = fgets(fid1); %# read line by line
    comment = SanitizeComment(line);
    comment = lower(comment);
    r=regexp(comment,' ','split');
    
    for st = 1:size(r,2)
            % if word is read before flag would be 0
            try
                myflag = ~(ismember(char(r(st)), origwords)==1); % i
            catch
                myflag = 1;
            end
            myflag;
            if (myflag) && ~(isempty(char(r(st))))
                fprintf(fid2,'%s,%s\n',char(r(st)),porterStemmer(cell2mat(r(st))));
                %cprintf('text', '%s-->%s\n', char(r(st)),porterStemmer(cell2mat(r(st))) );
                stems{end+1} = porterStemmer(cell2mat(r(st)));
                origwords{end+1} = char(r(st));
            else
                %pass
            end
            
    end
end
fclose(fid1);
fclose(fid2);
toc

    

