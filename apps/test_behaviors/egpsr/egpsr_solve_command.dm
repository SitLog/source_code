% GPSR Main Dialogue Model
diag_mod(egpsr_solve_command, 
[

    % Listening situation: requesting a command
    [  
    id ==> listen_command,
    type ==> recursive,
    embedded_dm ==> ask('Please, tell me a new command', gpsr2015, true, 1, Res, _),
    arcs ==> [
             success : [say('The command is'), say(Res)] => parse(Res),
             error   : empty => error				
             ]
    ],

    %%
    [
    id ==> parse(X),
    type ==> neutral,
    arcs ==> [ 
             empty : empty => action_reasoner(apply(get_logic_form(Input),[X]))					
             ]
    ],

    %%
    [
    id ==> action_reasoner(Speech_Acts),
    type ==> neutral,
    arcs ==> [ 
             empty : empty => dispatch( apply(actions_reasoner(S), [Speech_Acts]) )
             ]
    ],


    % Third situation: Dispatcher's base case (No more behaviors)
    [
    id ==> dispatch([]),
    type ==> recursive,
    embedded_dm ==> say('Going to waiting position', ok),
    arcs ==> [
             success : empty => move
             ]
    ],
		
    
    % Third situation: Dispatcher's inductive case (Execute list of behaviors)
    [
    id ==> dispatch([Current_Task|Rest_Tasks]),
    type ==> recursive,
    embedded_dm ==> Current_Task,
    arcs ==> [
             success : empty => dispatch(Rest_Tasks),
             error   : empty => manage(Current_Task, Rest_Tasks)
             ]
    ],

    % Fourth situation: Error manager
    [
    id ==> manage(Current_Task, Remaining_Tasks),
    type ==> recursive,
    embedded_dm ==> error_manager(Current_Task, Remaining_Tasks, New_Tasks),
    arcs ==> [
             success : empty => dispatch(New_Tasks),
             error   : [say('There is an error I cannot recover from')] => move 
             ]
    ],


    % Fifth Situation: Move to waiting position
    [  
    id ==> move,
    type ==> recursive,
    embedded_dm ==> move(waiting_position,_),
    arcs ==> [
             success : [get(right_arm, Obj_right), apply(reset_error_counters,[]), 
                        say('I will wait here')] => apply( when(If, True, False),[Obj_right == free, sleep, say_release] ),
             error   : [apply(reset_error_counters,[]), say('I will try again')] => move				
             ]
    ],
    
    %
    [  
    id ==> say_release,
    type ==> neutral,
    arcs ==> [
             empty : [say(['I got an object in my right hand', 'I will give it to you'])]
      		   => release_obj
             ]
    ],
    
    %
    [  
    id ==> release_obj,
    type ==> recursive,
    embedded_dm ==> relieve_arg(0.0, 0.5, right, _),
    arcs ==> [
             success : empty => sleep,
             error   : empty => release_obj
             ]
    ],
    
    
    %%
    [
    id ==> sleep,
    type ==> recursive,
    embedded_dm ==> ask('Tell me wake up when you want me to execute the next command', wakeup, true, 2, _, _),
    arcs ==> [
             success : empty => listen_command,
             error   : empty => sleep				
             ]
    ],


    %%
    [
    id ==> success,
    type ==> final
    ],


    %%
    [
    id ==> error,
    type ==> final
    ]

],


% Second argument: list of local variables
[
]

).
