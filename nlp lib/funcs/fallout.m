function output = fallout(fp, tn)
%
% 
% Fallout = fp/(fp+tn)
% (see page 268 of Manning and Schutze)
%
% Inputs 
%    fp: False Positive
%    tn: True Negative
% Outputs
%    fallout

output = fp/(fp+tn);


end