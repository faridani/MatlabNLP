function out1 = isStopWord(inStr,inMap)
    %in1 is a string
    %in2 is a containers.map which contains stop words
    out1 = 0;
    if isKey(inMap,inStr)
        out1 = 1;
    end