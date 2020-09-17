% DOAs Dialogue Model
%
% 	Description	Obtain the current DOA of the active sound sources.
%
%	Arguments	Mode: can be
%				all or []: provide all the doas in a list
%				all: provide all the doas in a list
%				one: provide all the doas in a list
%
%                       Angles: The current DOAs 
%	
%			Status:	
%				ok .- heard something
%				error .- did not hear anything

diag_mod(doas(Mode, Angles, Status),
[
                [  
      		 id ==> is,
                 type ==> doas,
                 arcs ==> [
                        doas(A) : empty => next(Mode,A),
                        doas([]) : empty => error
      			]
                ],
    		[
      		 id ==> next(all,A),	
     		 type ==> neutral,
		 out_arg ==> [A],
     		 arcs ==> [
                        empty : empty => success
      			]
   		],
    		[
      		 id ==> next([],A),	
     		 type ==> neutral,
		 out_arg ==> [[]],
     		 arcs ==> [
                        empty : empty => error
      			]
   		],
   		[
      		 id ==> next(one,[A1|Arest]),	
     		 type ==> neutral,
		 out_arg ==> [A1],
     		 arcs ==> [
                        empty : empty => success
      			]
   		],
   		
		% Final Situations
		[
		 id ==> success,
		 type ==> final,
                 in_arg ==> [A],
		 diag_mod ==> doas(_,A,ok)
		],
		[
		 id ==> error,
		 type ==> final,
		 diag_mod ==> doas(_,_,error)
		]
],
% Second argument: list of local variables
[]
).


