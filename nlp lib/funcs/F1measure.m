function output = F1measure(P,R)
% Calculates the F1 measure with alpah = .5
% 
% © Siamak Faridani, UC Berkeley, 2/2/2012
% 
% v 1.0 
% 
% F = 1/(alpha(1/P)+(1-alpha)(1/R))
% F1 is when alpha is 0.5
%
% (see page 268 of Manning and Schutze)
%
% Inputs 
%    P: precision
%    R: Recall
% Outputs
%    F1-measure

output = 2*(P*R)/(P+R);


end