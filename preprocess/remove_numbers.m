function output = remove_numbers(inputtext)
% takes a string and removes the numbers from the string

output =regexprep(inputtext, '[\d]', ' '); %removes numbers 
end
