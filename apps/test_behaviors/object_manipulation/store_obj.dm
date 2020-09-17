%%
diag_mod(store_obj(Cate,Vuelta,Cupboard,Cupbrd_deliver),
[
     %% Initial situation. 
     [	
     id ==> is,
     type ==> neutral,
     arcs ==> [
               empty : [get(scan_st,Sc),
                        get(tilt_st,Ti),
                        get(tbl_list,Table_Ang),
			assign(Cat_Lst,apply(extract_all_cat_st(_),[Cate])),
		        assign(C,apply(head_of_list(_),[Cat_Lst])),
			set(cat,C),
			assign(Rest,apply(list_fil(L_,V_),[Cat_Lst,C])),
			set(rest_cat,Rest)
		       ] => scan_tbl(Sc,Ti,Table_Ang,C)
	      ]
     ],
     
     
     %% Base case 1
     [
     id ==>  scan_tbl(_,_,_,empty_list),
     type ==> neutral,
     arcs ==> [
	      empty : [get(right_arm, Obj_right)] 
                       => apply(when(_,_,_), [Obj_right == free,error,release])
	      ]
     ],


     %% Base case 2
     [
     id ==>  scan_tbl(_,_,_,non_list),
     type ==> neutral,
     arcs ==> [
	      empty : [get(right_arm, Obj_right)] 
                       => apply(when(_,_,_), [Obj_right == free,error,release])
	      ]
     ],

     

     %%
     %% This is the case when there are at least one position  where to look for objects.
     [
     id ==>  scan_tbl(Scan,Tilt,Pts,Cat),
     type ==> recursive,
     embedded_dm ==> find(object,Cat,Pts,Scan,Tilt,category,[Obj|_],RemainigPos,true,false,false,_),
     arcs ==> [
               success : [get(brazo,A),
                          set(more_pos,RemainigPos)
                         ] => take_obj(Obj,A),
               error   : [assign(CatLst,get(rest_cat,_)),
			  assign(C,apply(head_of_list(_),[CatLst])),
			  set(cat,C),
			  assign(Rest,apply(list_fil(_,_),[CatLst,C])),
			  set(rest_cat,Rest),
			  get(tbl_list,Puntos)
			 ] => scan_tbl(Scan,Tilt,Puntos,C) %% Search for another category
              ]    
     ],
   
   
     %% After an object is found, this situation makes Golem take such an object
     %% with its right hand
     [
     id ==> take_obj(Obj,1),
     type ==> recursive,
     embedded_dm ==> take(Obj,right,_,_),
     arcs ==> [
               success : [set(brazo, 2),
                          get(scan_st,Scan),
                          get(tilt_st,Tilt),
                          get(more_pos,Pos),
			  get(cat,C),
		          set(last_height,1.10)] 
                       => scan_tbl(Scan,Tilt,Pos,C), 
               error   : [get(scan_st,Scan),
                          get(tilt_st,Tilt),
                          get(more_pos,Pos),
			  get(cat,C),
		          set(last_height,1.10)]
                       => scan_tbl(Scan,Tilt,Pos,C)
	      ]     
     ],
     
     %% After an object is found, this situation makes Golem take such an object
     %% with its left hand
     [
     id ==> take_obj(Obj,2),
     type ==> recursive,
     embedded_dm ==> take(Obj,left,_,_),
     arcs ==> [
               success : empty => release,
               error   : empty => release
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
                         set(brazo, 1)] => mv_table,
              error   : empty => release
              ]
     ],


     %%
     %% Golem turns Angle, and then keeps track of the rotation angle by adding 
     %% it to the global variable
     [	
     id ==> mv_table,
     type ==> recursive,
     embedded_dm ==> move(turn=>(Vuelta), _),
     arcs ==> [
              success : [get(scan_st,Sc),
                         get(tilt_st,Ti),
                         get(tbl_list,Table_Ang),
                         get(cat,C),
			 robotheight(1.10),
		         set(last_height,1.10)] => scan_tbl(Sc,Ti,Table_Ang,C), 
              error   : empty => mv_table(Angle)
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
    cat ==> none,
    rest_cat ==> [],
    more_pos ==> [],
    brazo ==> 1,
    scan_st ==> [0.0],                          %% <--- Attention! Scan in table
    tilt_st ==> [-40.0],                        %% <--- Attention! Tilt in table
    tbl_list ==> [displace_precise=>(-0.10)]    %% <--- Attention!
]

).	
	
