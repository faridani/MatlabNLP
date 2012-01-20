% testing split_sentence()


inputtext = 'Hi There. How Are you? Jane doesnt have a strange cup. Ms. Brown doesn''t own a little camera. She doesn''t have a light pencil.';

n = split_sentence(inputtext);

for i= 1:size(n,2)
    text = sprintf('%s\n', n{i});
    disp(text)
    
    
end
