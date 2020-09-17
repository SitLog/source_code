% Say Dialogue Model
%
% 	Description	The robot says a message
%
%	Arguments	Message: Text which will be said by the robot. The text must have simple quotes. 
%	
%			Status:	
%				ok .- when the message finishes

diag_mod(say(Message,Status),
[
    
    		[
      		 id ==> is,	
     		 type ==> neutral,
     		 arcs ==> [
      		  	empty : say(Message) => success
      			]
   		],

  	        [
		 id ==> success, 
		 type ==> final,
		 diag_mod ==> say(_, ok)
		],

		[
                 id ==> error, 
		 type ==> final,
		 diag_mod ==> say(_, error)
		]

  ],
  % Second argument: list of local variables
  [
  ]
).


