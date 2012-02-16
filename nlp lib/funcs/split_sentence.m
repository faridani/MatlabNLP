function output = split_sentence(inputtext)

% Takes a text and splits it into sentences
% accounts for Mr. Mrs. and similar words 


% 
%inputtext = 'Hi There. How Are you? Jane doesnt have a strange cup. Ms. Brown doesn''t own a little camera. She doesn''t have a light pencil.'
myoutstring = inputtext; 

% remove carriage return
myoutstring(myoutstring==13)=[];
myoutstring(myoutstring==10)=[];

% Replace Ms. with Ms*
myoutstring =regexprep(myoutstring, '[mM]s.', 'Ms');
myoutstring =regexprep(myoutstring, '[mM]r.', 'Mr');
myoutstring =regexprep(myoutstring, '[mM]rs.', 'Mrs');


pattern = '(\S.+?[.!?])(?=\s+|$)';
n = regexp(myoutstring, pattern, 'match');


output= n;

end
