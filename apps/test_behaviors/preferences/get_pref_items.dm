diag_mod(get_pref_items(Objs_to_fetch, _),
[
  %% Author: Ricardo Cruz
  %%         Noe Hdez
  
  %% Initial situation
  [
  id ==> is,
  type ==> neutral,
  arcs ==> [
           empty:empty=>fetch_one(Objs_to_fetch)
           ]
  ],
  
  %% No more objects to get. The situation 'almost_success'
  %% allows us to set the 'out_arg' component 
  [
  id ==> fetch_one([]),
  type ==> neutral,
  arcs ==> [ empty:empty => almost_success ]
  ],

  %% Get object 'Item' according to the preferred locations for it
  [
  id ==> fetch_one([Item|More]),
  type ==> neutral,
  prog ==> [ set(more_items,More) ],
  arcs ==> [
           empty:[mood(talk),
		  say(['I will get the', Item]),
		  mood(neutral),
                  assign(Pref_List, apply( consult_preferences_list(I_,P_),[Item,loc] ))
                 ] => find_obj(Item,Pref_List)
           ] 
  ],
  
  %% Base case when the list of preferred locations in empty
  [
  id ==> find_obj(ObjName,[]),
  type ==> neutral,
  arcs ==> [
           empty : empty => error
           ]
  ],
  
  %% Using the find behaviour we search for 'ObjName'. We update the 
  %% location of whatever is found visiting the different 'Locations'
  %% until 'ObjName' is found. Then save the location where 'ObjName' was found
  [
  id ==> find_obj(ObjName,Locations),
  type ==> recursive,
  embedded_dm ==> find(object,X,Locations,[0.0],[-30.0],object,Found_objs,Remaining_Locs,false,false,false,_),
  arcs ==> [
            success:[
                     assign(Current_Loc,apply(get_current_position(_,_),[Locations,Remaining_Locs])),
                     apply( update_locations(_,_),[Found_objs,Current_Loc] ),
                     assign(Obj_to_take,apply( object_present_scene(_,_),[ObjName,Found_objs] )),
		     apply(consult_kb_value_object_property(_,_,_),[Current_Loc,name,Loc_Name]),
		     apply(when(_,_,_),[Obj_to_take==not_found,
			                mood(sorpresa),
				        mood(feliz)
				       ]),
		     apply(when(_,_,_),[Obj_to_take==not_found,
			                say(['The', ObjName ,'is not in', Loc_Name]),
				        empty
				       ]),
                     mood(neutral)
                    ] => apply( when(If_,True_,False_),
                                  [Obj_to_take==not_found,
                                   find_obj(ObjName,Remaining_Locs),
                                   add_to_item_loc(Obj_to_take,ObjName,Current_Loc)
                                  ]
                                ),
            eror   :empty => error
           ]
  ],
  
  %% The location where 'ObjName' was found is saved in 
  %% the list 'item_location'. We used this later in the demo
  %% when asking the user to update the locations of objects
  [
  id ==> add_to_item_loc(FullObj,ObjName,CurrentPos),
  type ==> neutral,
  arcs ==> [
           empty:[
                   get(arm_id,Arm),
                   assign(ItemLoc,get(item_location,_)),
                   set(item_location,[pair(ObjName,CurrentPos)|ItemLoc])
                  ] => get_obj(FullObj,ObjName,Arm)
           ]
  ],
  
  %% 'Obj' is taken with left hand.
  %% If successful, we get another item now with right hand
  %% If not, we try to see the object again
  %% If 'Obj_NAme' is taken, delete its property
  %% 'last_seen'
  [
  id ==> get_obj(Obj,Obj_Name,0),
  type ==> recursive,
  embedded_dm ==> take(Obj,left,_,_),
  arcs ==> [
           success:[
	            mood(feliz),
	            get(more_items,Items),inc(arm_id,_),
                    apply( reset_obj_loc(O_),[Obj_Name] )
		   ] => fetch_one(Items),
           error  :[
                    mood(triste),
	            robotheight(1.20),
                    set(last_height,1.20),
                    advance_fine(-0.15, _)
                   ] => see_again(Obj_Name)
	      ]     
  ],

  %% 'Obj' is taken with right hand.
  %% If successful, are almost done
  %% If not, we try to see the object again
  [
  id ==> get_obj(Obj,Obj_Name,1),
  type ==> recursive,
  embedded_dm ==> take(Obj,right,_,_),
  arcs ==> [
           success:[
	           mood(feliz),
	           apply( reset_obj_loc(O_),[Obj_Name] )
	           ] => almost_success,
           error  :[robotheight(1.20),
		    mood(triste),
                    set(last_height,1.20),
                    advance_fine(-0.15, _)
                   ] => see_again(Obj_Name)
	      ]     
  ],
       
  %% In the current location, Golem tries to detect an 'Obj_Name'.
  %% This is why we use a 'scan' behaviour
  [
  id ==> see_again(Obj_Name),
  type ==> recursive,
  embedded_dm ==> scan(object, [Obj_Name], [0.0], [-30.0], object, [Obj_to_take|_], false, false, _), 
  arcs ==> [
           success:[
	           mood(feliz),
	           get(arm_id,Arm)
	           ] => get_obj(Obj_to_take,Obj_Name,Arm) , 
            error : empty => error
           ]
  ],
  
  %% Almost finish. Here we pass 'Item_Loc' through 'out_arg'
  %% so the 'success' situation can get it
  [
  id ==> almost_success,
  type ==> neutral,
  out_arg ==> [Item_Loc],
  arcs ==> [
           empty:[
	          mood(neutral),
	          get(item_location,Item_Loc)
	         ] => success
           ]
  ],

  %% Success situation
  [
  id ==> success,
  type ==> final,
  in_arg ==> [Item_Loc],
  diag_mod ==> get_pref_items(_, Item_Loc)
  ],
  
  %% Error situation
  [
  id ==> error,
  type ==> final
  ]
],
%List of local variables
[
  more_items ==> [],
  item_location ==> [],
  arm_id ==> 0
]
).

