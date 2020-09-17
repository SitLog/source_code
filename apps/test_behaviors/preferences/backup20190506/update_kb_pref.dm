diag_mod(update_kb_pref(Items_Locs),
[
  %% Author: Ricardo Cruz
  %%         Noe Hdez
  
  %% Initial situation. 
  %% Update object by object recursively
  [
  id ==> is,
  type ==> neutral,
  arcs ==> [
           empty:empty => update_one(Items_Locs)
           ]
  ],
  
  %% No objects to update. We are finished
  [
  id ==> update_one([]),
  type ==> neutral,
  arcs ==> [
           empty:[assign(Boolean, get(flag_upd,_)),
		  apply( when(I_,T_,F_),[Boolean,
                                      say('The knowledge base is updated'),
                                      empty] )] => success
           ]
  ],
  
  %% Take object 'Obj' and check that the location 'Loc' 
  %% where it was found is different from his preferred location
  [
  id ==> update_one([pair(Obj,Loc)|More]),
  type ==> neutral,
  prog ==> [set(more_items_loc,More)],
  arcs ==> [
           empty:[
                 assign(PL,apply( get_val_pref_propty(Id_,P_),[Obj,loc] ))
                 ] => apply( when(I_,T_,F_),[PL==Loc,
                                             update_one(More),
                                             get_name_locations(Obj,Loc,PL)] )
           ]  
  ],
  
  %% Get the name of locations
  [
  id ==> get_name_locations(Ob,Loc,Pref_Loc),
  type ==> neutral,
  out_arg ==> [Loc,Pref_Loc],
  arcs ==> [
            empty:[
                  assign(NewLoc_N, apply( get_val_pref_propty(L_,P1_),[Loc,name] )),
                  assign(OldLoc_N, apply( get_val_pref_propty(P_,P2_),[Pref_Loc,name] )),
		  mood(talk),
		  say(['I found ',Ob,' in',NewLoc_N,' but its preferred location is ',OldLoc_N])
                  ] => ask_to_update(Ob,NewLoc_N,OldLoc_N)
           ]
  ],
  
  %% Ask whether the user wants to update the KB or not
  [
  id ==> ask_to_update(Object,NewLoc_Name,OldLoc_Name),
  type ==> recursive,
  embedded_dm ==> ask(['Do you want to change the preferred location for ',Object,'?'], yesno, false, 1, Answer, _),
  in_arg ==> [Location,Pref_Loc],
  out_arg ==> [Location,Pref_Loc],
  arcs ==> [
           success:[
	           mood(neutral),
	           get(more_items_loc,More)
	           ] => apply(when(I_,T_,F_),[Answer==yes,
                                              change_kb(Object,Location,Pref_Loc),
                                              update_one(More)]),
           error  :empty => ask_to_update(Object,NewLoc_Name,OldLoc_Name)
           ]  
  ],
  
  %% Change preference value in KB
  [
  id ==> change_kb(Obj,Loc,Pr_L),
  type ==> neutral,
  prog ==> [set(flag_upd,true)],
  arcs ==> [
           empty:[get(more_items_loc,More),
                  apply( upd_kb_pref(O_,L_,P_),[Obj,Loc,Pr_L] )]=>update_one(More)
           ]
  ],  
  
  %% Success situation
  [
  id ==> success,
  type ==> final
  ],
  
  %% Error situation
  [
  id ==> error,
  type ==> final
  ]
],
% Local variables
[
  more_items_loc ==> [],
  flag_upd ==> false
]
).
