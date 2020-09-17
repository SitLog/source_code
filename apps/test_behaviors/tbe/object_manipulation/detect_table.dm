%%
diag_mod(detect_table,
[
     %% Initial situation. Golem keeps track (set flag true) 
     %% of the rotation angle (by adding the values to the corresponding
     %% global variables)
     [	
     id ==> is,
     type ==> neutral,
     arcs ==> [
               empty : [set(flag_angle_storing_groceries,true),
                        set(angle_operation,addition),
                        get(scan_st,Scan),
                        get(tilt_st,Tilt),
                        get(tbl_pts,Tbl_Pts) ] => find_tbl(Scan,Tilt,Tbl_Pts)
	      ]
     ],
     
     
     %%
     %% Find table
     [
     id ==> find_tbl(Scan,Tilt,Pts),
     type ==> recursive,
     embedded_dm ==> find(plane,X,Pts,Scan,Tilt,yolo,FndObjs,_,false,false,false,_), %% Attention!!
     arcs ==> [
               success : empty => approach_tbl( apply(get_head(H),[FndObjs]) ),
               error   : [say('I found no table')] => error
              ]
     ],
     

     %% Approach table. Case 1: No table
     [
     id ==> approach_tbl(empty_list),
     type ==> neutral,
     arcs ==> [
               empty : [say('I found no table')] => error
	      ]     
     ],
     
     
     %% Approach table. The list of objects is not a list
     [
     id ==> approach_tbl(non_list),
     type ==> neutral,
     arcs ==> [
               empty : [say('I found no table')] => error
	      ]     
     ],

   
     % Approach table. Get close to an object on the table
     [
     id ==> approach_tbl(Object),
     type ==> recursive,
     embedded_dm ==> approach_object(Object,_,_),
     arcs ==> [
               success : [set(flag_angle_storing_groceries,false)] => success,
               error   : [say('Problem approaching the table')] => error
              ]
     ],


     %% Success situation
     [
     id ==> success,
     type ==> final
     ],


      %%  Error situation
     [
     id ==> error,
     type ==> final
     ]
],

% Second argument: list of local variables
[
     scan_st ==> [0.0],                                    %% <--- Attention!!
     tilt_st ==> [-30.0],                                  %% <--- Attention!!
     tbl_pts ==> [turn=>(90.0),turn=>(90.0),turn=>(90.0)]  %% <--- Attention!!
     %tbl_pts ==> [turn=>(90.0),turn=>(90.0),turn=>(90.0)]
]

).	
	
