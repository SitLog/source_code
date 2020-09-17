%%
diag_mod(store_obj(Cate,Cupboard,Cupbrd_deliver),
[
     %% Initial situation. 
     [	
     id ==> is,
     type ==> neutral,
     arcs ==> [
               empty : [get(scan_st,Sc),
                        get(tilt_st,Ti),
                        get(tbl_list,Table_Ang) ] => scan_tbl(Sc,Ti,Table_Ang,true)
	      ]
     ],
     
     
     %%
     %% This is the case there are at least one position  where to look for objects.
     [
     id ==> scan_tbl(Scan,Tilt,Pts,InSitu),
     type ==> recursive,
     embedded_dm ==> find(object,X,Pts,Scan,Tilt,object,Objs,RemainigPos,InSitu,false,false,_),
     arcs ==> [
               success : [get(brazo,A),
                          set(more_pos,RemainigPos),
                          set(flag_angle_storing_groceries,false)
                         ] => get_obj( apply(get_head_cat(O_,C_), [Objs,Cate]), A),
               error   : [get(right_arm, Obj_right)] 
                       => apply(when(I_,T_,F_), [Obj_right == free,error,release])
              ]    
     ],
   

     %% If no object was to be taken since there was not object within range
     [
     id ==> get_obj(empty_list,_),
     type ==> neutral,
     arcs ==> [
               empty : [get(scan_st,Sc),
                        get(tilt_st,Ti),
                        get(more_pos,Pos)] => scan_tbl(Sc,Ti,Pos,false)
	      ]     
     ],
     
     
     %% FndObjs is not a list
     [
     id ==> get_obj(non_list,_),
     type ==> neutral,
     arcs ==> [
               empty : [get(scan_st,Sc),
                        get(tilt_st,Ti),
                        get(more_pos,Pos)] => scan_tbl(Sc,Ti,Pos,false)
	      ]     
     ],

   
     %% After an object is found, this situation makes Golem take such an object
     %% with its right hand
     [
     id ==> get_obj(Object,1),
     type ==> recursive,
     embedded_dm ==> take(Object, right, _, _),
     arcs ==> [
               success : [robotheight(1.20),
                          set(last_height,1.20),
                          advance_fine(-0.15, _),
                          set(brazo, 2),
                          get(scan_st,Scan),
                          get(tilt_st,Tilt),
                          get(more_pos,Pos)] 
                       => scan_tbl(Scan,Tilt,Pos,true),
               error   : [robotheight(1.20),
                          set(last_height,1.20),
                          advance_fine(-0.15, _),
                          get(scan_st,Scan),
                          get(tilt_st,Tilt),
                          get(more_pos,Pos)]
                       => scan_tbl(Scan,Tilt,Pos,true)
	      ]     
     ],
 

     %% After an object is found, this situation makes Golem take such an object
     %% with its left hand
     [
     id ==> get_obj(Object,2),
     type ==> recursive,
     embedded_dm ==> take(Object, left, _, _),
     arcs ==> [
               success : [set(brazo,1)] => release,
               error   : [set(brazo,1)] => release
    	      ]
     ],
    
     
     %%
     %% This situation performs a release based on the category
     %% of the objects Golem currently holds
     [
     id ==> release,
     type ==> recursive,
     embedded_dm ==> release_category(Cupboard,Cupbrd_deliver,Cate), 
     arcs ==> [
              success : [advance_fine(-0.10, _),
                         get(angle_storing_groceries,Angle),
			 set(brazo, 1)] => rotate(Angle),
              error   : empty => release
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
              success : [get(scan_st,Sc),
                         get(tilt_st,Ti),
                         get(tbl_list,Table_Ang),
                         set(flag_angle_storing_groceries,true),
                         set(angle_operation,addition)] => scan_tbl(Sc,Ti,Table_Ang,true), 
              error   : empty => rotate(Angle)
              ]
     ],

     
     %% Final situation. Success case.
     [
     id ==> success,
     type ==> final
     ],
     

     %% Final situation. Error case.
     [
     id ==> error,
     type ==> final
     ]     
     
],

% Second argument: list of local variables
[
     more_pos ==> [],
     brazo ==> 1,
     scan_st ==> [0.0, -25.0, 25.0],             %% <--- Attention!!
     tilt_st ==> [-30.0],                        %% <--- Attention!!
     tbl_list ==> [displace_precise=>(-0.10)]     %% <--- Attention!!
]

).	
	
