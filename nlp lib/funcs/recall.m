function output = recall(tp,fn)
%
% 
% Recall = tp/(tp+fn)
% (see page 268 of Manning and Schutze)
%
% Inputs 
%    tp: True Positive
%    fn: False Negative
% Outputs
%    recall measure

output = tp/(tp+fn);


end
