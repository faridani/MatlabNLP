clc;
clear all;
close all;

addpath('funcs');
negfiles = getAllFiles('data\txt_sentoken\neg\');
posfiles = getAllFiles('data\txt_sentoken\pos\');
labels = [zeros(size(negfiles,1),1); zeros(size(posfiles,1),1)];

allfiles = [negfiles;posfiles];
mycellarray ={};

for i = 1:size(allfiles,1)
    disp(sprintf('%d out of %d', i, size(allfiles,1)));
    myfile = allfiles{i};
    fid = fopen( myfile);
    s = textscan(fid,'%s','Delimiter','\n');
    mystr = '';
    for mycellindex = 1:size(s{1,1},1)
        mystr = strcat(mystr, s{1,1}{mycellindex});
    end
    fclose(fid);
    mycellarray{end+1} = mystr;
end
mycellarray = mycellarray';
%mycellarray2 = mycellarray;
%mycellarray = mycellarray(1:5);

featureVector = featurize(mycellarray, 1, 0, 0);


