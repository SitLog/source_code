%
%
% Say error for the GPSR task
% Author: Ivette Velez, Arturo Rodriguez and Noe Hernandez   
%
%
diag_mod(say_error(X, Remaining_Tasks, Res_Tasks),
[
    % Initial situation. Golem indicates that a say error ocurred
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [inc(say_error,Error_Number)] => apply( when(If, Verdadero, Falso), [Error_Number<3, say_case(Error_Number), error] )
             ]
    ],
    
    % Case for the say task
    % Case 1: First time that the say behavior failed. The task: say(X, _) is appended to the remaining tasks. 
    % The list we obtained by doing so is the result of this dialogue model, which Golem will carry out now
    [
    id ==> say_case(1),
    type ==> neutral,
    out_arg ==> [[say(X, _)|Remaining_tasks]],
    arcs ==> [
             empty : [say('I will execute the say task once again')] => success
             ]
    ],
    
    % Case 2: If the say behavior fail more than once, keep going with the remaining tasks.Then the remaining tasks 
    % are set as the result of this dialogue model, which Golem will carry out now
    [
    id ==> say_case(2),
    type ==> neutral,
    out_arg ==> [Remaining_tasks],
    arcs ==> [
             empty : [say('There is a problem with the say task, I will proceed with the remaining ones')] 
                    => success
             ]
    ],
    
    % Final situation : success
    [
    id ==> success,
    type ==> final,
    in_arg ==> [Tasks],
    diag_mod ==> say_error(_, _, Tasks)
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
