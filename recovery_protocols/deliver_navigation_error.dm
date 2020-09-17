%
%
% Move error for the GPSR task
% Author: Noe Hernandez   
%
%
diag_mod(deliver_navigation_error(Object, Position, Mode, Remaining_tasks, Tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [inc(mv_error,Error_Number)] => apply( when(If, Verdadero, Falso), [Error_Number<2, move_case, error] )
             ]
    ],
    
    % Initial situation
    [
    id ==> move_case,
    type ==> neutral,
    arcs ==> [
             empty : [
	             say('If a person is preventing from moving, please, let me go through'),
		     say('Please, open any closed door or remove any obstacle in front of me')
		     ]
	            => see_door_resume %is_person
             ]
    ],
    
    % This situation checks if it is a person or an object blocking Golem
    [
    id ==> is_person,
    type ==> recursive,
    embedded_dm ==> detect_head([coord3(_,_,Y)|_], _), 
    arcs ==> [
             success : [apply(when(If,True,False),[Y<2.0,
                                                   say(['I see you, could you please move?', 'Afterwards, I will resume moving']),
                                                   say(['Help anybody by opening the door or removing any obstacle in front of me', 'Afterwards, I will resume moving'])])] 
                     => see_door_resume,
             error : [say('Help anybody by opening the door or removing any obstacle in front of me'), 
                      say('Afterwards, I will resume moving')] 
                   => see_door_resume                          			
             ]
    ],

    
    % This situation verifies that there is no obstacle in front of Golem, then he resumes his moving
    [
    id ==> see_door_resume,
    type ==> recursive,
    embedded_dm ==> detect_door(_), 
    arcs ==> [
             success : [say('Thank you')] => append_task,
             error: empty => error                          			
             ]
    ],
        
    % This situation appends move(X, _) to the remaining tasks. The list we obtained by doing so
    % is the result of this dialogue model, which Golem will carry out now
    [
    id ==> append_task,
    type ==> neutral,
    out_arg ==> [[deliver(Object, Position, Mode, _)|Remaining_tasks]],
    arcs ==> [
             empty : empty => success
             ]
    ],
    
    % Final situation : success
    [
    id ==> success,
    type ==> final,
    in_arg ==> [Tasks],
    diag_mod ==> deliver_navigation_error(_, _, _, _, Tasks)
    ],
    
    % Final situation : error
    [
    id ==> error,
    type ==> final
    ]
],

% Second argument: list of local variables
[
]

).
