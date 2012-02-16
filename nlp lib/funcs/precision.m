function output = precision(tp,fp)
%
% 
% Precision = tp/(tp+fp)
% (see page 268 of Manning and Schutze)
%
% Inputs 
%    tp: True Positive
%    fp: False Positive
% Outputs
%    precision measure

output = tp/(tp+fp);


end
