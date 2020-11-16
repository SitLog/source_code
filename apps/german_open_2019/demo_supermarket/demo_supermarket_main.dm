% 	Demo Supermarket
%       Denis, Noe, Ricardo, etc..

diag_mod(demo_supermarket_main,
[
	[  
      		id ==> move_origin,
      		type ==> recursive,
		embedded_dm ==> move(welcome_point,_),
		arcs ==> [
        		 success : empty => is,
        		 error : say('Restart my navigation system') => is
			 ]
    	],

    	[
      		id ==> is,	
      		type ==> neutral,
      		arcs ==> [
                	 empty : [apply(initialize_KB_supermarket_ricardo,[]),
                        	 tiltv(0.0),set(last_tilt,0.0),
                        	 say('Hello my name is Golem and I am an assistant in the supermarket')
                        	 ] => receive_comand
                         ]
    ],	
    
    %Receive the command and translate it to Conversation Obligations (Golem's command).
    [  
      		id ==> receive_comand,
      		type ==> recursive,
      		embedded_dm ==> ask('What can I do for you?',supermarket_command,false,1, Resp,_),
      		arcs ==> [
        	         success: [
			     apply(when(_,_,_),
				   [
				       Resp=='bring me a coke please',
				       say('ok I will bring it to you'),
				       empty
				   ]),
			     assign(Obligations, apply(rsupermarket_parser(_),[Resp]))
        		          ] => receive_more_commands(Obligations),%dispatch( apply(action_reasoner_demo(_),[Obligations]) ),
        		 error : empty => fs
        							
      			 ]
    ],

    [
	id ==> receive_more_commands(Obligations),
	type ==> recursive,
	embedded_dm ==> ask('Anything else?',supermarket_command,false,1, Resp,_),
	arcs ==> [
	    success: empty => answer_more_commands(Resp,Obligations),
	    error  : empty => fs
	         ]
    ],

    [
	id ==> answer_more_commands(no,Ob),
	type ==> neutral,
	arcs ==> [
	         empty : empty => dispatch(apply(action_reasoner_demo(_),[Ob]))
	    ]
    ],

    [
	id ==> answer_more_commands(Resp,Ob),
	type ==> neutral,
	arcs ==> [
	    empty:[
		assign(MoreOb,apply(rsupermarket_parser(_),[Resp])),
		append(Ob,MoreOb,NewOb)
		  ] => receive_more_commands(NewOb)
	    ]
    ],
    		       
        
        % Dispatcher's base case (No more tasks)
    	[
		id ==> dispatch([]),
     		type ==> recursive,
     		embedded_dm ==> say('Your request has been completed good bye', _),
     		arcs ==> [
			         success:empty => fs,
		  	         error  :empty => fs
		         ]
      	],
      	
		
    	% Dispatcher's inductive case (Execute list of behaviors)
     	[
		id ==> dispatch([Current_Task|Rest_Tasks]),
      		type ==> recursive,
      		embedded_dm ==> Current_Task,
      		arcs ==> [
		         success : empty => dispatch(Rest_Tasks),
                	 error   : empty => manage(Current_Task, Rest_Tasks)
		         ]
       	],
       	
       	
       	% Error manager
     	[
		id ==> manage(Current_Task, Remaining_Tasks),
      		type ==> recursive,
		embedded_dm ==> error_manager_demo(Current_Task, Remaining_Tasks, New_Tasks),
      		arcs ==> [
		         success : empty => dispatch(New_Tasks),
       	 	         error   : say('There is an error I cannot recover from aborting task') => fs
		         ]
       	],

	%Final Situation
       	[
      		id ==> fs,
     		type ==> final
    	]

 ],
 %List of local variables
 [
 ]
).
