%
%
% FIND error for the GPSR task
% Author: Ivette Velez, Arturo Rodriguez and Noe Hernandez   
%
%
diag_mod(find_not_found_prsn(person, X, Pos, Ori, Tilt, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [
                      inc(find_not_fnd_prsn_error,Error_Number),
                      assign(LenPos,apply(check_size(L_,S_,T_,F_), [Pos,1,true,false] ))
                     ] 
                     => apply( when(If, Verdadero, Falso), [(Error_Number<3,LenPos), find_prsn_case(Error_Number), error] )
             ]
    ],
    
    % If this is the first time a not_found error for persons happens, Golem tries again
    [
    id ==> find_prsn_case(1),
    type ==> neutral,
    arcs ==> [
             empty : [say('I did not see any person. I will try again')]
                     => append_task( apply(find_pos(P), [Pos]) )
             ]
    ],
    
    % If a not_found error happens more than once, Golem stops searching for such a person and
    % carries on with the remaining task
    [
    id ==> find_prsn_case(_),
    type ==> neutral,
    out_arg ==> [ New_Tasks ],
    arcs ==> [
             empty : [apply( new_tasks_find(S,T),[Remaining_tasks, New_Tasks] )] => success
             ]
    ],
    
    % This situation appends a 'find' to the remaining tasks. The list we obtained by doing so
    % is the result of this dialogue model, which Golem will carry out now
    [
    id ==> append_task(Posiciones),
    type ==> neutral,
    arcs ==> [
             empty : empty => save_list( [find(person, X, Posiciones, Ori, Tilt, Mode, Found_Persons, New_Pos, ScanFst, TiltFst, SeeFst, St)|Remaining_tasks] )
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
    diag_mod ==> find_not_found_prsn(_, _, _, _, _, _, _, _, _, _, _, _, Tasks)
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
