%
%
% Say error for the GPSR task
% Author: Ivette Velez, Arturo Rodriguez and Noe Hernandez   
%
%
diag_mod(question_error(Remaining_Tasks, Res_Tasks),
[
    % Initial situation. Golem indicates that a say error ocurred
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [inc(question_error,Error_Number)] => apply( when(If, Verdadero, Falso), [Error_Number<2, recovery_protocol, continue] )
             ]
    ],
    
    % Case for the say task
    % If the answer question behavior failed, then it tries again.
    [
    id ==> recovery_protocol,
    type ==> neutral,
    out_arg ==> [[answer_question|Remaining_tasks]],
    arcs ==> [
             empty : [say('I will try again answering a question')] => success
             ]
    ],
    
    [
    id ==> continue,
    type ==> neutral,
    out_arg ==> [Remaining_tasks],
    arcs ==> [
             empty : [say('I will continue with the remaining tasks')] => success
             ]
    ],
    
    % Final situation : success
    [
    id ==> success,
    type ==> final,
    in_arg ==> [Tasks],
    diag_mod ==> question_error(_, Tasks)
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
