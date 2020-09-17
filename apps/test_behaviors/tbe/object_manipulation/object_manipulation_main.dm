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
                            say('Storing groceries starts now')] => recognize_cupboard
                  ]
     ],
      
     %% We execute the DM 'detect_cupboard' to go to the cupboard and 
     %% find objects in it (and their categories)
     [
     id ==> recognize_cupboard,
     type ==> recursive,
     embedded_dm ==> detect_cupboard(Cate),
     arcs ==> [
              success : empty => recognize_table(Cate), 
              error   : say('Something wrong happened while detecting categories in the cupboard') => fs
              ]
     ],
     
     %% We then execute the recursive
     %% dialogue model 'detect_table' to locate the table.
     [
     id ==> recognize_table(Cate),
     type ==> recursive,
     embedded_dm ==> detect_table,
     arcs ==> [
              success : empty => fetch_objs(Cate),
              error   : say('Something wrong happened while the table') => recognize_table(Cate)
              ]
     ],
     
     
     %% Golem repeatedly fetches objects from the table to the cupboard
     [
     id ==> fetch_objs(Cate),
     type ==> recursive,
     embedded_dm ==> store_obj(Cate),
     arcs ==> [
              success : empty => fetch_objs(Cate),
              error   : empty => fetch_objs(Cate)
              ]
     ],
     
    
     %% Final situation
     [
	 id ==> fs,
	 type ==> final
     ]
		 
 ],

 [
 ]
).

