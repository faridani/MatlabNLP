function out1 = isStopWord(in1,in2)
    %in1 is a string
    %in2 is a cell array that contains stop words
    out1 = 0;
    for k=1:size(in2,1)


        if (size(in1)==size((in2{k,1}))) % they need to be the same size so we can compare
            if (in1==in2{k,1})
                out1 = 1;
                return;
            end
            
        end
    end
    