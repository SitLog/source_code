diag_mod(object_manipulation_main,
[
     %%  Author: Noe Hdez
     
     %% Initial situation     
     [	
	 id ==> is,
	 type ==> neutral,
	 arcs ==> [
                   empty : [apply(initialize_KB,[]),
                            tiltv(0.0),set(last_tilt,0.0),
                            tilth(0.0),set(last_scan,0.0),
			    assign(Values_ST,get(values_st,_)),
			    Values_ST = [Cupboard,Cupbrd_deliver,ModeTbl,_],
			    set(estante,Cupboard),
			    set(deliver_pos,Cupbrd_deliver),
			    set(tbl_mode,ModeTbl),
                            say('Storing groceries starts now')] => recognize_cupboard(Cupboard)
                  ]
     ],
      
     %% We execute the DM 'detect_cupboard' to go to the cupboard and 
     %% find objects in it (and their categories)
     [
     id ==> recognize_cupboard(Cupboard),
     type ==> recursive,
     embedded_dm ==> detect_cupboard(Cate,Cupboard),
     arcs ==> [
              success : get(tbl_mode,Mode) => recognize_table(Cate,Mode), 
              error   : say('Something wrong happened while detecting categories in the cupboard') => fs
              ]
     ],
     
     %% We then execute the recursive
     %% dialogue model 'detect_table' to locate the table.
     [
     id ==> recognize_table(Cate,Mode),
     type ==> recursive,
     embedded_dm ==> detect_table(Mode),
     arcs ==> [
              success : [get(estante,Cupboard),get(deliver_pos,Deliver)] => fetch_objs(Cate,Cupboard,Deliver),
              error   : say('Something wrong happened while the table') => recognize_table(Cate,Mode)
              ]
     ],
     
     
     %% Golem repeatedly fetches objects from the table to the cupboard
     [
     id ==> fetch_objs(Cate,Cupboard,Deliver),
     type ==> recursive,
     embedded_dm ==> store_obj(Cate,Cupboard,Deliver),
     arcs ==> [
              success : empty => fetch_objs(Cate,Cupboard,Deliver),
              error   : empty => fetch_objs(Cate,Cupboard,Deliver)
              ]
     ],
     
    
     %% Final situation
     [
	 id ==> fs,
	 type ==> final
     ]
		 
 ],

[
    estante ==> _,
    deliver_pos ==> _,
    tbl_mode ==> _
]
).

