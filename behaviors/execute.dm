% Execute Task Dialogue Model
%
% 	Description	The robot executes a bash script 
%	
%	Arguments	Script: Name of the script to execute
%	
%			Status:	
%				ok .- if the script is executed sucessfully
%			       	not_executed .- otherwise


diag_mod(execute(Script,Status),
[
	[
      		id ==> is,	
      		type ==> neutral,
      		arcs ==> [
        		empty : execute(Script) => success
			]		
    	],

	[
      		id ==> success,
      		type ==> final,
		diag_mod ==> execute(_, ok)	
    	],

	[
      		id ==> error,
      		type ==> final,
		diag_mod ==> execute(_, not_executed)	
    	]

  ],
  
  [
  ]
).
