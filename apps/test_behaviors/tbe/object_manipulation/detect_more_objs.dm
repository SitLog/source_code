%%
diag_mod(detect_more_objs(Hor_Pos, Ver_Pos, Categories),
[
     %% Initial situation. Golem he  doesn't keep track (set flag false) 
     %% of the rotation angle and turns the angle it has stored in
     %% angle_storing_groceries
     [	
     id ==> is,
     type ==> neutral,
     arcs ==> [
               empty : [advance_fine(-0.14, _),
                        set(flag_angle_storing_groceries,false),
                        get(angle_storing_groceries,Angle)
                       ] => rotate(Angle)
              ]
     ],
     
     
     %%
     %% Golem turns Angle, and then keeps track of the rotation angle by adding 
     %% it to the global variable
     [	
     id ==> rotate(Angle),
     type ==> recursive,
     embedded_dm ==> move([turn=>(Angle)], _),
     arcs ==> [
              success : [get(table_list, Table_List),
                         set(flag_angle_storing_groceries,true),
                         set(angle_operation,addition)] => detect_objs(Table_List), 
              error   : empty => rotate(Angle)
              ]
     ], 
     
     %%
     %% This is the case there are at least one position where to look for objects.
     [
     id ==> detect_objs(Pts_List),
     type ==> recursive,
     embedded_dm ==> find(object, X, Pts_List, Hor_Pos, Ver_Pos, object, FndObjs, _, true, false, false, _),
     arcs ==> [
               success : [get(brazo,A) ] => get_arm_obj( apply(get_head(H), [FndObjs]), A),
               error   : [get(right_arm, Obj_right)] 
                       => apply(when(If, True, False), [Obj_right == free,error,release(Categories,false)])
              ]    
     ],
     
     
     %% If no object was to be taken since there was not moped object within range
     [
     id ==> get_arm_obj(empty_list,_),
     type ==> neutral,
     arcs ==> [
               empty : [say('No objects to take'), get(right_arm, Obj_right)] 
                     => apply(when(If, True, False), [Obj_right == free,error,release(Categories,false)])
	      ]     
     ],
     
     
     %% If no object was to be taken since there was not moped object within range
     [
     id ==> get_arm_obj(non_list,_),
     type ==> neutral,
     arcs ==> [
               empty : [say('No objects detected with moped'), get(right_arm, Obj_right)] 
                     => apply(when(If, True, False), [Obj_right == free,error,release(Categories,false)])
	      ]     
     ],
	
	     
     %% After an object is found, this situation makes Golem take such an object
     %% with its right hand
     [
     id ==> get_arm_obj(Object,1),
     type ==> recursive,
     embedded_dm ==> take(Object, right, _, _),
     arcs ==> [
               success : [robotheight(1.20),
                          set(last_height,1.20),
                          advance_fine(-0.15, _),
                          set(brazo, 2),
                          set(turn_flag_approach, 0.0)] 
                       => see_again,
               error   : [robotheight(1.20),
                          set(last_height,1.20),
                          advance_fine(-0.15, _),
                          set(turn_flag_approach, 0.0)]
                       => see_again
	      ]     
     ],
     
     
     %% After an object is found, this situation makes Golem take such an object
     %% with its left hand
     [
     id ==> get_arm_obj(Object, 2),
     type ==> recursive,
     embedded_dm ==> take(Object, left, _, _),
     arcs ==> [
               success : [set(brazo,1),
                          set(turn_flag_approach, 0.0)]
                       => release(Categories,true),
               error   : [set(brazo,1),
                          set(turn_flag_approach, 0.0)] 
                       => release(Categories,true)
    	      ]
     ],
     
     
     %%
     %% In the current location, Golem detects an object not
     %% moving to some other point. This is why we use a 'scan' behaviuor
     [
     id ==> see_again,
     type ==> recursive,
     embedded_dm ==> scan(object, X, Hor_Pos, Ver_Pos, object, FndObjs, false, false, _), 
     arcs ==> [
               success : [get(brazo,A)] => get_arm_obj(apply(get_head(H), [FndObjs]), A),
               error   : [get(right_arm, Obj_right)] => apply(when(If, True, False), [Obj_right == free,error,release(Categories,false)])
              ]
     ],
     
     
     %%
     %% This situation performs an usual release, i.e., the objects are left
     %% in the default position in the cupboard
     [
     id ==> release([],GoBack),
     type ==> recursive,
     embedded_dm ==> usual_release([estante1],1.16,GoBack), %%Attention!!
     arcs ==> [
              success : empty => success,
              error   : empty => release([],GoBack)
              ]
     ],
     
     
     %%
     %% This situation performs a release based on the category
     %% of the objects Golem currently holds
     [
     id ==> release(Cat,GoBack),
     type ==> recursive,
     embedded_dm ==> release_category([estante1],Cat,GoBack),  %%Attention!!
     arcs ==> [
              success : empty => success,
              error   : empty => release([],GoBack)
              ]
     ],
     

     %% Final situation. Success case.
     [
     id ==> success,
     type ==> final,
     diag_mod ==> detect_more_objs(_, _, _)
     ],
     

     %% Final situation. Error case.
     [
     id ==> error,
     type ==> final,
     diag_mod ==> detect_more_objs(_, _, _)
     ]     
     
],

% Second argument: list of local variables
[
     brazo ==> 1,
     table_list ==> [turn=>(-10.0),turn=>(20.0)]
]

).	

