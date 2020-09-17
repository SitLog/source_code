% GPSR Main Dialogue Model
diag_mod(gpsr_solve_command, 
[
    	

	% Listening situation: wake up
        [  
      		id ==> is,
      		type ==> recursive,
      		embedded_dm ==> ask('Tell me wakeup when you want to start',wakeup,true,100,Res,Status),
      		arcs ==> [
        			success : empty => listen_command,
        			error : empty => error				
      			]
        ],

	% Listening situation: requesting a command
        [  
      		id ==> listen_command,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, tell me a command',gpsr,true,1,Res,Status),
      		arcs ==> [
        			success : [say('You said'),say(Res)] => parse(Res),
        			error : empty => error				
      			]
        ],

	[
		id ==> parse(X),
     		type ==> neutral,
     		arcs ==> [ 
				empty: gfInterpret(X,Y) => 
					action_reasoner(apply(get_logic_form(In),[Y]))					
			]
      	],

	[
		id ==> text(X),
     		type ==> neutral,
     		arcs ==> [ 
				%empty:empty => action_reasoner([move(shelf),move(sofa),move(exit)])
				%empty:empty => action_reasoner([move(shelf),find(jelly),take(jelly)])
				%empty:empty => action_reasoner([move(sofa),get_item(soup),deliver(sofa)])
				%empty:empty => action_reasoner([move(sofa),get_item(soup),deliver(me)])
				%empty:empty => action_reasoner([move(sofa),get_item(soup),move(exit)])
				%empty:empty => action_reasoner([move(sofa),say,follow])
				%empty:empty => action_reasoner([move(shelf),say,move(exit)])
				%empty:empty => action_reasoner([move(sofa),memorize,recognize])
				%empty:empty => action_reasoner([move(shelf),find(human),carry(soup,sofa)])
				%empty:empty => action_reasoner([move(shelf),find(human),say])
				%empty:empty => action_reasoner([memorize,follow,move(exit)])
				%empty:empty => action_reasoner([get_item(soup),deliver(sofa),say])				
				%empty:empty => action_reasoner([get_item(soup),deliver(me),say])
				%empty:empty => action_reasoner([find(human),carry(soup,sofa),move(exit)])
				%empty:empty => action_reasoner([carry(drink,restplace)])
				%empty:empty => action_reasoner([find(food)])	
				%empty:empty => action_reasoner([move(restplace)])
				%empty:empty => action_reasoner([carry(food,me)])
				empty:empty => action_reasoner([point(restingplace)])
								
				%empty:empty => action_reasoner([carry(food,me)])
			
							
				
			]
      	],

	[
		id ==> action_reasoner(Speech_Acts),
     		type ==> neutral,
     		arcs ==> [ 
				empty:apply(actions_reasoner(S,L), [Speech_Acts,Logic_Form]) => dispatch(Logic_Form)
			]
     	],

%	[
%		id ==> action_reasoner(Speech_Acts),
%     		type ==> neutral,
%     		arcs ==> [ 
%				empty:apply(actions_reasoner(S,L), [Speech_Acts,Logic_Form]) => dispatch(Logic_Form)
%			]
%      	],

	% Third situation: Dispatcher's base case (No more behaviors)
    	[
		id ==> dispatch([]),
     		type ==> recursive,
     		embedded_dm ==> say('Going to waiting position', ok),
     		arcs ==> [
			% Move robot to waiting position for next round
		  	success:empty => move
		]
      	],
		
    	% Third situation: Dispatcher's inductive case (Execute list of behaviors)
     	[
		id ==> dispatch([Current_Task|Rest_Tasks]),
      		type ==> recursive,
      		embedded_dm ==> Current_Task,
      		arcs ==> [
			success:empty => dispatch(Rest_Tasks),
                	error:empty => manage(Current_Task, Rest_Tasks)
			]
       	],

	% Fourth situation: Task manager
     	[
		id ==> manage(Current_Task, Remaining_Tasks),
      		type ==> recursive,
		embedded_dm ==> say('I need to do something to solve this problem',Status),		
		%embedded_dm ==> manage(Current_Task),
      		arcs ==> [
			success:empty => dispatch(Remaining_Tasks),
       	 		error:empty => error
		]
       	],

	% Fifth Situation: Move to waiting position and waits for next turn
	[  
      		id ==> move,
      		type ==> recursive,
		embedded_dm ==> move(apply(consult_waiting_position,[]),Status),
      		arcs ==> [
        			success : [say('I will wait here')] => success,
        			error : [say('I could not arrive to waiting position. I will try again')] => move				
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

  % Second argument: list of local variables
  [
  ]

).
