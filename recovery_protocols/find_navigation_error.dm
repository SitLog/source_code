%
%
% Move error for the GPSR task
% Author: Ivette Velez, Arturo Rodriguez and Noe Hernandez   
%
%
diag_mod(find_navigation_error(Kind, Entity, Positions, Ori, Tilt, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Res_tasks),
[
    % Initial situation
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : empty => mv_error(Positions)
             ]
    ],
    
    % If the list of positions where to find is empty, exit with error
    [
    id ==> mv_error([]),
    type ==> neutral,
    arcs ==> [
             empty: empty => error                          			
             ]
    ],
    
    % If the navigation error ocurred trying to go to Place, then call the protol error for move which will go to Place, and afterwards    
    % execute the find task again. Note that Found is the same as the corresponding dialogue model argument, there is a new variable 
    % for Positions and ScanFirst is set to true
    [
    id ==> mv_error([Place|More]),
    type ==> recursive,
    out_arg ==> [New_Resulting_Tasks],
    embedded_dm ==> move_error(Place, [find(Kind, Entity, More, Ori, Tilt, Mode, Found, New_Pos, true, TiltFst, SeeFst, _)| Remaining_tasks], New_Resulting_Tasks), 
    arcs ==> [
             success : empty => success,
             error: empty => error                          			
             ]
    ],
    
    % Final situation : success
    [
    id ==> success,
    type ==> final,
    in_arg ==> [Tasks],
    diag_mod ==> find_navigation_error(_, _, _, _, _, _, _, _, _, _, _, _, Tasks)
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
