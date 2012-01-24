function out1 = countWords(in1,in2)
    %in1 is a cellarray that contains all the words
    %in2 is a cell array that contains headers
    
    out1 = zeros(size(in2,1),1);
    
    
    for l=1:size(in1,1)
        if mod(l,200)==0
            fprintf('Processing comment %1.0f out of words\n',l)
        end
        
        keyword = in1{l,1};
        for k=1:size(in2,1)
            if (size(keyword)==size((in2{k,1}))) % they need to be the same size so we can compare
                if (keyword==in2{k,1})
                    out1(k)= out1(k)+1;
                end

            end
        end
    end
    