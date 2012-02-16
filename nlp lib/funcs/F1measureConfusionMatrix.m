function output = F1measureConfusionMatrix(C)
% Takes the confusion matrix and calculates the 
% F1 measure from the matrix
% 
% v 1.0
% 
% F = 1/(alpha(1/P)+(1-alpha)(1/R))
% F1 is when alpha is 0.5
%
% (see page 268 of Manning and Schutze)
%
% Inputs 
%    C: Confusion Matrix
% Outputs
%    F1-measure
%

tn = C(1,1);
tp = C(2,2);
fn = C(1,2);
fp = C(2,1);

P = precision(tp,fp);
R = recall(tp,fn);

output = 2*(P*R)/(P+R);


end