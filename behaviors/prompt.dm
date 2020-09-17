% Prompt Dialogue Model 
%
% 	Description	The robot promts a question and expects an answer to be introduced using the keyboard 
%	
%	Arguments	
%			Promt: Question to ask
%			ReadText: Message introduced in the keyboard
%
%
%  Status:	
%			ok .- when a message was obtained from the keyboard
     

diag_mod(prompt(Prompt, ReadText, Status), 

[
		
        	[
			id ==> is,
		 	type ==> neutral,
			arcs ==> [ 
				empty : say(Prompt) => next(  apply( read_text_command, [] )  )
			]
		],

		[
			id ==> next(X),
		 	type ==> neutral,
			diag_mod==> prompt(_, X, ok),
			arcs ==> [ 
				empty : empty => success
			]
		],
						
		[
			id ==> success,
			type ==> final			
		],

		[
			id ==> error,
			type ==> final
		]

	    ], 

	% List of Local Variables
	[ ]

   ). 















