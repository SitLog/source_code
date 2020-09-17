%
%
% Move error for the GPSR task
% Author: Ivette Velez, Arturo Rodriguez and Noe Hernandez   
%
%
diag_mod(find_empty_scene(object, [X], Positions, Ori, Tilt, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [
                      inc(find_empty_scn_error,Error_Number),
                      assign(LenPos,apply(check_size(L_,S_,T_,F_), [Positions,1,true,false] ))
                     ]
                     => apply( when(If, Verdadero, Falso), [(Error_Number<3,LenPos), empty_scene_case(Error_Number), error] )
             ]
    ],
    
    % If this is the first time an empty_scene error happens, Golem tries again
    [
    id ==> empty_scene_case(1),
    type ==> neutral,
    arcs ==> [
             empty : [say('I did not see anything. I will try again')]
                     => append_task(object, [X], Positions, Ori, Tilt, Mode, Obj, New_Pos, ScanFst, TiltFst, SeeFst)	
             ]
    ],
    
    % If an empty_scene error happens more than once, Golem searches in some other locations
    [
    id ==> empty_scene_case(_),
    type ==> neutral,
    arcs ==> [
             empty : [say('I did not see anything. I will search somewhere else')]
                     => append_task(object, [X], apply(get_path_obj(Obj), [X]), Ori, Tilt, Mode, Obj, New_Pos, ScanFst, TiltFst, SeeFst)	
             ]
    ],
    
    % This situation appends Task to the remaining tasks. The list we obtained by doing so
    % is the result of this dialogue model, which Golem will carry out now
    [
    id ==> append_task(Object, [XX], Pos, Ori, Tilt, Mode, Obj, New_Pos, ScanFst, TiltFst, SeeFst),
    type ==> neutral,
    arcs ==> [
             empty : empty => save_list(apply(replace_take(L), 
                                              [ [find(Object, [XX], Pos, Ori, Tilt, Mode, [Obj|More], New_Pos, ScanFst, TiltFst, SeeFst, _)|Remaining_tasks] ] ))
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
    diag_mod ==> find_empty_scene(_, _, _, _, _, _, _, _, _, _, _, _, Tasks)
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
