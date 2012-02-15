function output = term_count(inputtext, headers)
% Multinomial Featurizer
%
% takes:
%      inputtext: a long string
%      headers: a cell array containing a number of keywords
% output:
%      an array of numbers
%      showing how many times each term is repeated in the text
output = [];
    for i= 1:size(headers,2)
        g = containers.Map();
            comment = inputtext;
    r=regexp(comment,' ','split');
    for j =1:size(r,2)
        
        
            word = (cell2mat(r(j)));
        
        
        if isKey(g, word) 
            g(word) = g(word)+1;
        else
            g(word) = 1;
        end
        
    end
    
    
    
        %pattern = headers{i};
        %temp = regexp(inputtext, pattern, 'match');
        
        
        %inputtext = regexprep(inputtext, pattern, ' '); %removes the terms for efficiency 
        %output = [output, size(temp,2)];
        if isKey(g, headers{i}) 
        output = [output, g(headers{i})];
        else
             output = [output, 0];
        end
        
    end

end
