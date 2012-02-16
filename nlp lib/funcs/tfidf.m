function output = tfidf(featurs)
% Takes a feature vector and returns the tfidf vector
%
% © Siamak Faridani, UC Berkeley, 2/2/2012
% 
% inputs:
%       features
% output:
%       tfidf


    occurance = (featurs>0);
    idf = repmat(log(size(featurs,1)./sum(occurance)), size(featurs,1),1);
	tf = featurs.* repmat((sum(featurs').^(-1))',1,size(featurs,2));
    
    if (sum(sum(isnan(tf)))>0)
        disp('Warning, at least one row in feature vector is all zero')
        disp('Will be automatically repalced with zeros')
        % relpacing the NaN row with 0
        tf(find(isnan(tf)))=0;
        
    end
    
    output = tf.*idf;
end
