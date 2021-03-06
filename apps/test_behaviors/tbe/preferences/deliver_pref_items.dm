diag_mod(deliver_pref_items,
[
  %% Author: Ricardo Cruz
  %%         Noe Hdez
  
  %% Initial situation
  %% We formed a list of pairs 'obj_arm(object,held_in_hand)'
  %% so we can deliver such objects to the user
  %% Furthermore, the KB is consulted to determine user's preferred
  %% locations. It returns a list of location, so we get its head
  [
  id ==> is,
  type ==> neutral,
  prog ==> [assign(R,get(right_arm,_)),assign(I,get(left_arm,_)),
            set(grasped_obj,[obj_arm(R,right),obj_arm(I,left)])],
  arcs ==> [
           empty:[
                  assign(Pref, apply( consult_preference(E_,P_),[user,found_in] )),
                  Pref = [Pref_Loc,_]                  
                 ] => apply( when(I_,T_,F_),[Pref_Loc==unknown,
                                             error,
                                             say_destination(Pref_Loc)] )
           ]
  ],
  
  %% Golem says where he is heading to
  [
  id ==> say_destination(Loc),
  type ==> neutral,
  arcs ==> [
           empty : [
                    assign(Loc_Name,apply( get_val_pref_propty(L_,P_),[Loc,name] )),
                    say(['I will go to the ',Loc_Name]),
                    say('It is the preferred location where the user can be found')
                   ] => mv(Loc)
           ]
  ],
  
  %% Move to 'Loc' and get the list of pairs 'obj_arm(object,held_in_hand)'
  %% store in 'grasped_obj'
  [
  id ==> mv(Loc),
  type ==> recursive,
  embedded_dm ==> move(Loc,_),
  arcs ==> [
           success:[get(grasped_obj,Grasped)] => hand_objs(Grasped),
           error  :empty => mv([Loc|More])
           ]
  ],
  
  %% No more objects to grasp, we are done
  [
  id ==> hand_objs([]),
  type ==> neutral,
  arcs ==> [
           empty:empty => success
           ]
  ],
  
  %% The hand is free, no need to reelease anything
  %% Procceed with the rest of list 'grasped_obj'
  [
  id ==> hand_objs([obj_arm(free,_)|More]),
  type ==> neutral,
  arcs ==> [
           empty:empty => hand_objs(More)
           ]
  ],
  
  %% Hand 'A' is holding 'Obj'
  [
  id ==> hand_objs([obj_arm(Obj,A)|More]),
  type ==> neutral,
  out_arg ==> [ More ],
  arcs ==> [
           empty:[say(['Here is the ', Obj])] => release(A)
           ]
  ],
  
  %% Release object held by 'Arm'
  %% Then procceed with the rest of list 'grasped_obj'
  [
  id ==> release(Arm),
  type ==> recursive,
  embedded_dm ==> relieve(Arm,_),
  in_arg ==> [List],
  arcs ==> [
           success:empty => hand_objs(List),
           error  :empty => release(Arm)
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
% Local Variable
[
  grasped_obj ==> []
]
).
