function output = bernoulli(featurs)
% takes a feature vector and returns the bernoulli feature vector
% basically determines if a term exists in the text or not
% also known as occurance model
%
% © Siamak Faridani, UC Berkeley, 2/2/2012
% 
% v 1.0
%
% inputs:
%       features
% output:
%       term occurance

output = double(featurs>0);

end
