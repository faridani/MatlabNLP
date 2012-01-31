function output = tfidf(featurs)
% takes a feature vector and returns the tfidf vector

    occurance = (featurs>0);
    idf = log(size(featurs,1)./sum(occurance));
    output = featurs.*repmat( idf, size(featurs,1),1);
end
