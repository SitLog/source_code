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
			    Values_ST = [Cupboard,Cupbrd_deliver,ModeTbl,Vuelta,_],
			    set(vuelta,Vuelta),
			    set(estante,Cupboard),
			    set(deliver_pos,Cupbrd_deliver),
			    set(tbl_mode,ModeTbl)]
			    => recognize_cupboard(Cupboard)
                  ]
     ],
     
     %% We execute the DM 'detect_cupboard' to go to the cupboard and 
     %% find objects in it (and their categories)
     [
     id ==> recognize_cupboard(Cupboard),
     type ==> recursive,
     embedded_dm ==> detect_cupboard(Cate,Cupboard),
     arcs ==> [
              success : [get(vuelta,Vuelta)] => go_to_sidetable(Cate,Vuelta), 
              error   : [assign(Error_Cnt,inc(counter_rc,_)),
                         apply( when(_,_,_), 
                                [Error_Cnt > 2,
                                 say('Something wrong happened while detecting categories in the cupboard'),
                                 advance_fine(-0.10, _) 
                                ]
                                )
                        ]
                          => apply( when(_,_,_),[Error_Cnt > 2,fs,recognize_cupboard(Cupboard)])
              ]
     ],
     
       
     [
     id ==> go_to_sidetable(Cate,Vuelta),
     type ==> recursive,
     embedded_dm ==> move(turn=>(Vuelta),_),
     arcs ==> [
              success : [get(estante,Cupboard),get(deliver_pos,Deliver)] => fetch_objs(Cate,Vuelta,Cupboard,Deliver),
              error   : [assign(Error_Cnt,inc(counter_gts,_)),
                         apply( when(_,_,_), 
                                [Error_Cnt > 2,
                                 say('Something wrong happened while moving to the sideboard'),
                                 empty 
                                ]
                                )
                        ] => apply( when(_,_,_),[Error_Cnt > 2,fs,go_to_sidetable(Cate,Vuelta)])
              ]
     ],
     
     
     %% Golem repeatedly fetches objects from the table to the cupboard
     [
     id ==> fetch_objs(Cate,Vuelta,Cupboard,Deliver),
     type ==> recursive,
     embedded_dm ==> store_obj(Cate,Vuelta,Cupboard,Deliver),
     arcs ==> [
              success:empty => fs,
              error  :[assign(Error_Cnt,inc(counter_fo,_)),
                         apply( when(_,_,_), 
                                [Error_Cnt > 2,
                                 say('Error occurred, aborting task'),
                                 empty 
                                ]
                                )
                        ] => apply( when(_,_,_),[Error_Cnt > 2,fetch_objs(Cate,Vuelta,Cupboard,Deliver)])
              ]
     ],
     
    
     %% Final situation
     [
	 id ==> fs,
	 type ==> final
     ]
		 
 ],

[
    counter_rc ==> 0,
    counter_gts ==> 0,
    counter_fo ==> 0,
    estante ==> _,
    deliver_pos ==> _,
    tbl_mode ==> _,
    vuelta ==> _
]
).

