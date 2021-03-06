%
%
% navigation_error in the take behavior for the GPSR task
% Author: Noe Hernandez   
%
%
diag_mod(take_navigation_error(object(Name, _, _, _, _, _, _, _, _), Arm, Remaining_tasks, Tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [inc(tk_nav_error,Error_Number)] => apply( when(If, Verdadero, Falso), [Error_Number<2, recovery_protocol, error] )
             ]
    ],
    
    % This protocol makes Golem say what kind of error happened
    [
    id ==> recovery_protocol,
    type ==> neutral,
    arcs ==> [
             empty : [say('I had a problem while I was moving. I will try to take the object once again')]
                     => append_tasks_take
             ]
    ],
    
    % This situation appends various tasks to the remaining tasks in order to make another attempt to take the object
    [
    id ==> append_tasks_take,
    type ==> neutral,
    arcs ==> [
             empty : empty 
                   => save_list([find(object, [Name], [], [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, true, false, false, _),
	                             consult_kb(change_object_property, [golem,found,Name], _, _),
	                             consult_kb(value_object_property, [golem,found], Obj_Name, _),
	                             say(['Here is the',Obj_Name,'so I will take it'],_), 
	                             take(FoundObject, Arm, _, _),
	                             consult_kb(change_object_property, [golem,has,Obj_Name], _, _) | Remaining_tasks])
             ]
    ],
    
    % Save list of remaining tasks to be returned later on
    [
    id ==> save_list(List),
    type ==> neutral,
    out_arg ==> [ List ],
    arcs ==> [
             empty : empty => success
             ]
    ],

    % Final situation : success
    [
    id ==> success,
    type ==> final,
    in_arg ==> [Tasks],
    diag_mod ==> take_navigation_error(_, _, _, Tasks)
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

