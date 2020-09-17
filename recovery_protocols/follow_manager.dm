%
%
% Follow error for the GPSR task
% Author: Noe Hernandez   
%
%
diag_mod(follow_manager(learn, gesture_only, Remaining_tasks, Tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [inc(follow_error,Error_Number)] => apply( when(If, Verdadero, Falso), [Error_Number<3, follow_mngr_case(Error_Number), error] )
             ]
    ],
    
    % If this is the first time a follow_error happens, Golem tries again
    [
    id ==> follow_mngr_case(1),
    type ==> neutral,
    arcs ==> [
             empty : [say('I cannot follow you. I will try again')]
                     => append_task
             ]
    ],
    
    % If a follow_error happens more than once, Golem stops following such a person and
    % carries on with the remaining task
    [
    id ==> follow_mngr_case(_),
    type ==> neutral,
    out_arg ==> [ New_Tasks ],
    arcs ==> [
             empty : [apply( new_tasks_follow(S,T),[Remaining_tasks, New_Tasks] )] => success
             ]
    ],
    
    % This situation appends a 'follow' to the remaining tasks. The list we obtained by doing so
    % is the result of this dialogue model, which Golem will carry out now
    [
    id ==> append_task,
    type ==> neutral,
    arcs ==> [
             empty : empty => save_list( [follow(learn,gesture_only,Happened_Event,_)|Remaining_tasks] )
             ]
    ],
    
    %%
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
    diag_mod ==> follow_manager(_, _, _, Tasks)
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
