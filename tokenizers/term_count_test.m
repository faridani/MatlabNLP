addpath('..\funcs')
term_count('I love books', {'love','book'})
term_count('hello', {'love','book'})
term_count_old('hello', {'love','book'})

term = 'a way of swimming by lying on your front and moving your arms together over your head while your legs move up and down'
term_count(term, {'a','way', 'front', 'your'})
term_count_old(term, {'a','way', 'front', 'your'})
tic;
  disp('New One')
for i =1:500
  
    term_count(term, {'a','way', 'front', 'your'});
end
toc;

tic;
    disp('Old One')
for i =1:500

    term_count_old(term, {'a','way', 'front', 'your'});
end
toc;
