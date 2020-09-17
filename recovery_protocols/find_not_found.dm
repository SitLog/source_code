%
%
% not_found error in the find behavior for the GPSR task
% Author: Ivette Velez, Arturo Rodriguez and Noe Hernandez   
%
%
diag_mod(find_not_found(object, X, Positions, Ori, Tilt, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [
                      inc(find_not_fnd_error,Error_Number),
                      assign(LenPos,apply(check_size(L_,S_,T_,F_), [Positions,1,true,false] ))
                     ] 
                     => apply( when(If, Verdadero, Falso), [(Error_Number<3,LenPos), not_found_case(X), error] )
             ]
    ],
    
    % If this is the first time a not_found error happens, Golem tries again
    [
    id ==> not_found_case([Id]),
    type ==> neutral,
    arcs ==> [
             empty : [say('I did not find the object I was looking for, I will search for objects in the same class')]
                     => append_task_changing_obj(object, apply(get_class_of_obj(N), [Id]), Positions, Ori, Tilt, category, object(Name, U, V, W, O1, O2, O3, O4, Conf), New_Pos, ScanFst, TiltFst, SeeFst)
             ]
    ],
    
    % If this is the second time a not_found error happens, Golem searches in some other locations
    [
    id ==> not_found_case(Sought),
    type ==> neutral,
    arcs ==> [
             empty : [say('I did not find the object I was looking for. I will search somewhere else')]
                     => append_task_changing_obj(object, Sought, apply(get_path_class(Class), [Sought]), Ori, Tilt, category, object(Name, U, V, W, O1, O2, O3, O4, Conf), New_Pos, ScanFst, TiltFst, SeeFst)
             ]
    ],
    
    % Terminate task with error if the arguments do not match with previous cases
    [
    id ==> not_found_case(_),
    type ==> neutral,
    arcs ==> [
             empty : [say('I did not find the object I was looking for. Terminating tasks')]
                     => error
             ]
    ],
    
    % This situation appends Task to the remaining tasks. The list we obtained by doing so
    % is the result of this dialogue model, which Golem will carry out now
    [
    id ==> append_task_changing_obj(Obj, Sought, Pos, Ori, Tilt, Mode, object(Name, U, V, W, O1, O2, O3, O4, Conf), New_Pos, ScanFst, TiltFst, SeeFst),
    type ==> neutral,
    arcs ==> [
             empty : empty => save_list(apply(replace_taks_obj(L), 
                                              [ [find(Obj, Sought, Pos, Ori, Tilt, Mode, [object(Name, U, V, W, O1, O2, O3, O4, Conf)|More], New_Pos, ScanFst, TiltFst, SeeFst, _)|Remaining_tasks] ] ))
             ]
    ],
    
    
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
    diag_mod ==> find_not_found(_, _, _, _, _, _, _, _, _, _, _, _, Tasks)
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
