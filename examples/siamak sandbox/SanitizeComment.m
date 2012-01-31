function out1 = SanitizeComment(in1)
    % clears a string from puctuations
	
	
   
    myoutstring =regexprep(char(in1), '[^\w\s]', ' ');
	myoutstring =regexprep(myoutstring, '[\d]', ' '); %removes numbers 
	myoutstring =regexprep(myoutstring, '_', ' '); %removes numbers 
	
	% the following part takes care of \n in MATLAB
	% MATLAB's regex has a bug and could not handle these two cases
	
	myoutstring(myoutstring==13)=[];
	myoutstring(myoutstring==10)=[];
    
    out1 =  myoutstring;
    