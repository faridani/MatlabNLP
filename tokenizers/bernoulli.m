function output = bernoulli(featurs)
% takes a feature vector and returns the bernoulli feature vector
% basically determines if a term exists in the text or not
% also known as occurance model

output = double(featurs>0);

end
