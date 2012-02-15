function out1 = isStopWord(in1,in2)
%in1 is a tring
    %in2 is a cell array that contains stop words
    out1 = 0;
    for k=1:size(in2,2)


        if (size(in1)==size((in2{1,k}))) % they need to be the same size so we can compare
            if (in1==in2{1,k})
                out1 = 1;
                return;
            end
            
        end
    end