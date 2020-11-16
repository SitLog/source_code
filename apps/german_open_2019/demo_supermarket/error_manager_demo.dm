%
%
% Error manager for the GPSR task
% Author: Noe Hernandez
% Author: Carlos Ricardo Cruz Mendoza
%
%
diag_mod(error_manager_demo(Current_task, Remaining_tasks, Res_tasks),
[
    % Initial situation. Golem performs a big case intruction to analyze the type of error that occurred
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [say('Something went wrong')                
                     ]
                   =>  analyze_error(Current_task)
             ]
    ],
    
    % Case SCAN: not_found error in the scan behaviour for objects
    [
    id ==> analyze_error( scan(object, Entity, Ori, Til, Mode, Found, TiltFst, SeeFst, not_found) ),
    type ==> recursive,
    out_arg ==> [Tasks],
    embedded_dm ==> find_not_found(object, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==>[
             success : empty => success,
             error : empty => error
            ] 
    ],
    
    % Case SAY: The error happened in a say instruction. 
    [
    id ==> analyze_error( say(X, _) ),
    type ==> recursive,
    out_arg ==> [Tasks],
    embedded_dm ==> say_error(X, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error				
             ]
    ],
    
    % Case MOVE: The error happened in a move instruction. Note to self: if Golem tried to reach a coordinate, we can check if 
    % he is close enough to his destination. If so, he may continue with the remaining tasks
    [
    id ==> analyze_error( move(X, navigation_error) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> move_error(X, Remaining_tasks, Tasks),    
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ],
    
    % Case FIND: navigation_error in the find behaviour due to a navigation error while moving
    [
    id ==> analyze_error( find(Kind, Entity, Positions, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, navigation_error) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> find_navigation_error(Kind, Entity, Positions, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ],


    % Case FIND: camera_error in a see_object instruction caught within a find task. 
    [
    id ==> analyze_error( find(object, _, _, _, _, object, _, _, _, _, _, camera_error) ),
    type ==> neutral,
    arcs ==> [
             empty : [say('I met with an error in the camera.')] => error
             ]
    ],
    
    
    % Case FIND: empty_scene error in a find instruction caught within a find task. 
    [
    id ==> analyze_error( find(object, [X], Positions, Ori, Tilt, Mode, Found, _, ScanFst, TiltFst, SeeFst, empty_scene) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> find_empty_scene(object, [X], Positions, Ori, Tilt, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ],
    
    % Case FIND: empty_scene error in a find instruction caught within a find task for category. 
    [
    id ==> analyze_error( find(object, Cat, Positions, Ori, Tilt, category, Found, _, ScanFst, TiltFst, SeeFst, empty_scene) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> find_empty_scene_cat(object, Cat, Positions, Ori, Tilt, category, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ],
    
    % Case FIND: not_found error in the find behaviour for objects
    [
    id ==> analyze_error( find(object, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, not_found) ),
    type ==> recursive,
    out_arg ==> [Tasks],
    embedded_dm ==> find_not_found(object, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==>[
             success : empty => success,
             error : empty => error
            ] 
    ],
    
    
    % Case FIND : not_found error when searching for persons
    [
    id ==> analyze_error( find(person, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, not_found) ),
    type ==> recursive,
    out_arg ==> [Tasks],
    embedded_dm ==> find_not_found_prsn(person, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==>[
             success : empty => success,
             error : empty => error
            ] 
    ],
    
    % Case FIND : lost_person error when searching for persons
    [
    id ==> analyze_error( find(person, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, lost_person) ),
    type ==> recursive,
    out_arg ==> [Tasks],
    embedded_dm ==> find_lost_person(person, Entity, Pla, Ori, Til, Mode, Found, _, ScanFst, TiltFst, SeeFst, Remaining_tasks, Tasks),
    arcs ==>[
             success : empty => success,
             error : empty => error
            ] 
    ], 
      
    % Case TAKE: not_grasped error in the take behaviour  
    [
    id ==> analyze_error( take(Obj, Arm, _, not_grasped) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> take_not_grasped(Obj, Arm, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ],  
    
    % Case TAKE: not_found error in the take behaviour  
    [
    id ==> analyze_error( take(Obj, Arm, _, not_found) ),
    type ==> neutral,
    out_arg==> [Tasks],    
    %embedded_dm ==> take_not_found(Obj, Arm, Remaining_tasks, Tasks),
    arcs ==> [
        empty : [
	        apply( daily_life_inference_cicle_demo(_,_,_,_), [Obj,Diagnosis,Decision,ConversationObligations] ),
	         %%% Diagnosis
	         apply(diagnosis_parser(_,_),[Diagnosis,Say_Diagnosis]),
		 say('My diagnosis for the current situation is'),
		 say('The human assistant'),
		 say(Say_Diagnosis),
                 %%% Decision
		 apply(decision_parser(_,_),[Decision,Say_Decision]),
		 say('My decision is to'),
		 say(Say_Decision),
		 %%% Plan
		 apply(plan_parser(_,_),[ConversationObligations,Say_Plan]),
		 say('The plan that I will execute is to'),
		 say(Say_Plan),
		 %%%
		 assign(Tasks,apply(action_reasoner_demo(_),[ConversationObligations]))
		]
		=> success                                     ]
    ], 
    
    % Case TAKE: navigation_error in the take behaviour  
    [
    id ==> analyze_error( take(Obj, Arm, _, navigation_error) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> take_navigation_error(Obj, Arm, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ], 
    
    % Case TAKE: empty_scene error in the take behaviour  
    [
    id ==> analyze_error( take(Obj, Arm, _, empty_scene) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> take_empty_scene(Obj, Arm, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ], 
    
    % Case DELIVER: navigation_error in the deliver behaviour  
    [
    id ==> analyze_error( deliver(Obj, Pos, Mode, navigation_error) ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> deliver_navigation_error(Obj, Pos, Mode, Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ],
    
    % Case ANSWER_QUESTION: error in the 'answer question' behaviour  
    [
    id ==> analyze_error( answer_question ),
    type ==> recursive,
    out_arg==> [Tasks],
    embedded_dm ==> question_error(Remaining_tasks, Tasks),
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ], 
    
    % Case GENDER: error in the 'gender' behaviour  
    [
    id ==> analyze_error( gender(_,_) ),
    type ==> neutral,
    out_arg ==> [New_Tasks],
    arcs ==> [
             empty : [apply( new_tasks_gender(S,T),[Remaining_tasks,New_Tasks] )] => success
             ]
    ], 
    
    % Case POSE: error in the 'pose' behaviour  
    [
    id ==> analyze_error( pose(_,_) ),
    type ==> neutral,
    out_arg ==> [New_Tasks],
    arcs ==> [
             empty : [apply( new_tasks_pose(S,T),[Remaining_tasks,New_Tasks] )] => success
             ]
    ], 
    
    % Case FOLLOW: error in the 'follow' behaviour  
    [
    id ==> analyze_error( follow(learn, gesture_only, _, _) ),
    type ==> recursive,
    embedded_dm ==> follow_manager(learn, gesture_only, Remaining_tasks, Tasks),
    out_arg==> [Tasks],
    arcs ==> [
             success : empty => success,
             error : empty => error
             ]
    ], 
    
    
    % Default action when there is no recovery protocol for an error
    [
    id ==> analyze_error( _ ),
    type ==> neutral,
    arcs ==> [
             empty : empty => error
             ]
    ], 
    
    % Final situation : success
    [
    id ==> success,
    type ==> final,
    in_arg ==> [Tasks],
    diag_mod ==> error_manager_demo(_, _, Tasks)
    ],
    
    % Final situation : error
    [
    id ==> error,
    type ==> final,
    diag_mod ==> error_manager_demo(_, _, [])
    ]
],

% Second argument: list of local variables
[
]

).
