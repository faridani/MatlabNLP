% testing split_sentence()


inputtext = 'Hi There. How Are you? Jane doesnt have a strange cup. Ms. Brown doesn''t own a little camera. She doesn''t have a light pencil.';

n = split_sentence(inputtext);

for i= 1:size(n,2)
    text = sprintf('%s\n', n{i});
    disp(text)
    
    
end

% Reading corpora text 
addpath(genpath('corpora\'));
fid1 = fopen('declaration of independence.txt','r'); %# open csv file for reading

while ~feof(fid1)
    line = fgets(fid1); %# read line by line
    n = split_sentence(line);

    for i= 1:size(n,2)
        text = sprintf('%s\n', n{i});
        disp(text)


    end
end
fclose(fid1);
