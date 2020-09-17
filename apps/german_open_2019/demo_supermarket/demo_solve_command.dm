% GPSR Main Dialogue Model
diag_mod(demo_solve_command, 
[
    	
	% Listening situation: requesting a command
        [  
      		id ==> listen_command,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, tell me a new command', gpsr2015, true, 1, Res, _),
      		%embedded_dm ==> qr_code(2, true, Res, Status),
      		arcs ==> [
        			 success : [say(['The command is ', Res])] => parse(Res),
        			 error   : [say('I was unable to understand the command. Terminating GPSR')] => error				
                         ]
        ],

        [
                id ==> parse(X),
     		type ==> neutral,
     		arcs ==> [ 
			  empty:empty => check_before_ar(apply(get_logic_form(Input), [X]))					
			 ]
      	],
      	      	
      	
      	% Check acts before action reasoner
        [
                id ==> check_before_ar(Acts),
                type ==> neutral,
                arcs ==> [
                          empty:[assign(NewActs, apply(check_acts_gpsr(A_),[Acts] ))] => action_reasoner(NewActs)
                         ]
        ],

	[
		id ==> action_reasoner(Speech_Acts),
     		type ==> neutral,
     		arcs ==> [ 
			  empty:empty => dispatch( apply(actions_reasoner(S), [Speech_Acts]) )
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
		embedded_dm ==> error_manager(Current_Task, Remaining_Tasks, New_Tasks),
      		arcs ==> [
		         success : empty => dispatch(New_Tasks),
       	 	         error   : [say(['There is an error I cannot recover from ', 'Going to waiting position'])] => move 
		         ]
       	],


        % Move to waiting position
    	[  
      		id ==> move,
      		type ==> recursive,
    		embedded_dm ==> move(waiting_position,_),
      		arcs ==> [
        		 success : [get(right_arm, Obj_right), apply(reset_error_counters,[])] => apply(  when(If, True, False), [Obj_right == free,success,say_release]  ),
        		 error   : [apply(reset_error_counters,[]), say('I will try again')] => move				
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
    	]

],

% Second argument: list of local variables
[
]

).
