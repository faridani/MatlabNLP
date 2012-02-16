function output = term_presence(inputtext, headers)
% Bernoulli Featurizer
%
% takes:
%      inputtext: a long string
%      headers: a cell array containing a number of keywords
% output:
%      an array of 0,1
%      showing how many times each term is repeated in the text
output = [];
    for i= 1:size(headers,2)
        pattern = headers{i};
        temp = regexp(inputtext, pattern, 'match');
        
        
        %inputtext = regexprep(inputtext, pattern, ' '); %removes the terms for efficiency 
        output = [output, (size(temp,2)>0)];
    end

end
