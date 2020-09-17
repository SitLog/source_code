%%
diag_mod(detect_cupboard(_,Pos),
[
     %% Initial situation. It invokes 'identify_objects' with the neck scan positions empty,
     %% so Golem will immediately move to the initial position in the list of positions
     [	
	 id ==> is,
	 type ==> neutral,
	 arcs ==> [
                  empty : empty => identify_objects([],_,[Pos])
	          ]
     ],
     

     %% Since Golem carries out a neck horizontal (scan) move at the end, when we reach an empty list for
     %% the scan positions and the list of search positions is empty too, then we are done examining the cupboard.
     [
	 id ==> identify_objects([], _, []),
	 type ==> neutral,	 
	 out_arg ==> [Cat],
	 arcs ==> [
		  empty : [get(categorias,Cat)] => apply( when(_,_,_),[Cat==[],error,success] )
                  ]
     ],

     
     %% If the scan positions are finished, Golem moves to the next position in the list
     %% of points to visit. In the next position Golem performs a new search with the initial scan and tilt values     
     [
         id ==> identify_objects([], _, [Pt|Rest]),
         type ==> recursive,
         embedded_dm ==> move(Pt,_),
         arcs ==> [
                  success : [
                             say('Searching for categories'),
                             get(scan_st,Scan),
                             get(tilt_st,Tilt)                           
                            ] => identify_objects(Scan,Tilt,Rest),
	          error   : empty => error
                  ]
     ],


     %% When the tilt positions are finished we reset their values since more horizontal positions
     %% might be left     
     [
 	 id ==> identify_objects(Scan,[],Pts),
	 type ==> neutral,
	 arcs ==> [
		  empty : [get(last_scan, SVal),
                           get(tilt_st,Tilt)] => identify_objects( apply( list_fil(_,_),[Scan,SVal] ),Tilt,Pts)
                  ]    
     ],     
     
     
     %% Using the behaviour 'scan' Golem detects objects 
     %% Once objects are found the conduct stops, so we need to continue searching for objects with the remaining neck positions.
     %% If an error ocurrs, Golem moves to the next position given by 'Pts'
     [
	 id ==> identify_objects(HFull, VFull, Pts),
	 type ==> recursive,
         embedded_dm ==> scan(object, X, HFull, VFull, object, Found_Obj, false, false, _),
	 arcs ==> [
	          success :
	     	      [get(categorias, Current_Cate),
                       get(last_height,LastHeight),                       
                       get(last_scan, LastSc),
                       get(last_tilt, LastTi)] 
	     	      => set_object_list(HFull,VFull,Pts,apply(  remove_repeated(_,_,_,_,_), [Found_Obj, Current_Cate, LastSc, LastTi, LastHeight]  )),
  	     	  error : empty => identify_objects([], VFull, Pts) %% <-- Golem moves to next searching position
                  ]    
     ],
     
     	     
     %% We set the objects Golem has seen so far without repetition in the variable 'categorias'
     %% We also change the vertical neck value to the next one, while keeping the last horizontal position used
     [
	 id ==> set_object_list(HFull, VFull, Pts, Cat),
	 type ==> neutral,
	 arcs ==> [
 	      	  empty : [set(categorias, Cat), get(last_scan, HVal), get(last_tilt, VVal)] 
			    => identify_objects( apply( list_hor(_,_), [HFull,HVal] ),  apply( list_fil(_,_), [VFull,VVal] ), Pts )
                  ]
     ],
     

     %% Final situation. Success case.
     %% We set the lists of found objects to 
     [
     id ==> success,
     type ==> final,
     in_arg ==> [Final_List],
     diag_mod ==> detect_cupboard(Final_List,_)
     ],
     
     
     %% Final situation. Error case.
     [
     id ==> error,
     type ==> final,
     diag_mod ==> detect_cupboard([],_)
     ]   
     
],

% Second argument: list of local variables
[
     categorias ==> [],
     tilt_st ==> [-30.0,0.0], %% <--- Attention! Tilt in cupboard
     scan_st ==> [0.0]        %% <--- Attention! Scan in cupboard
]
).	
