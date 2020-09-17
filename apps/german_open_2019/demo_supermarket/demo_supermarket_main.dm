% 	Demo Supermarket
%       Denis, Noe, Ricardo, etc..

diag_mod(demo_supermarket_main,
[
	[  
      		id ==> move_origin,
      		type ==> recursive,
		embedded_dm ==> move(front_desk,_),
		  		arcs ==> [
        			success : empty => is,
        			error : say('Restart my navigation system') => is
			]
    	],

    	[
      		id ==> is,	
      		type ==> neutral,
      		arcs ==>  [
                	empty : [apply(initialize_KB_supermarket_ricardo,[]),
                        	robotheight(1.30),set(last_height,1.30),tiltv(0.0),set(last_tilt,0.0),
                        	say('Hello. My name is Golem and I am an assistant in the supermarket.')
                        	] => receive_comand
                ]
    ],	
    
    %Receive the command and translate it to Conversation Obligations (Golem's command).
    [  
      		id ==> receive_comand,
      		type ==> recursive,
      		embedded_dm ==> ask('What do you want me to do?',supermarket_command,false,1, Resp,_),
      		arcs ==> [
        		success: [ say(['The command is ', Res]), assign(ConversationObligations, apply(rsupermarket_parser(_),[Resp]))
        		         ] => dispatch( apply(action_reasoner_demo(S), [ConversationObligations]) ),
        		error : empty => error
        							
      			 ]
    ],
    		       
        
        % Dispatcher's base case (No more tasks)
    	[
		id ==> dispatch([]),
     		type ==> recursive,
     		embedded_dm ==> say('Going to waiting position', _),
     		arcs ==> [
			         % Move robot to waiting position for next round
		  	         success:empty => move,
		  	         error  :empty => move
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
       	 	         error   : [say(['There is an error I cannot recover from ', 'Going to waiting position'])] => move 
		         ]
       	],

  % Move to waiting position
    	[  
      		id ==> move,
      		type ==> recursive,
    		embedded_dm ==> move(wainting_position,_),
      		arcs ==> [
        		  success : empty =>  fs, %[get(right_arm, Obj_right), apply(reset_error_counters,[])] => apply(  when(If, True, False), [Obj_right == free,success,say_release]  ),
        		 error   : empty => fs %[apply(reset_error_counters,[]), say('I will try again')] => move				
                         ]
     	],
     	
     	
     	% Say an object is held
     	[  
      		id ==> say_release,
      		type ==> neutral,
      		arcs ==> [
        		 empty : [say(['I got an object in my right hand', 'I will give it to you'])]
        		       => release_obj
                         ]
     	],
     	
     	
     	% Release held object
     	[  
      		id ==> release_obj,
      		type ==> recursive,
    		embedded_dm ==> relieve_arg(0.0, 0.5, right, _),
      		arcs ==> [
        		 success : empty => success,
        		 error   : empty => release_obj
                         ]
     	],
     	

        % Success
       	[
      		id ==> success,
     		type ==> final
    	],
    	

        % Error
    	[
      		id ==> error,
     		type ==> final
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
