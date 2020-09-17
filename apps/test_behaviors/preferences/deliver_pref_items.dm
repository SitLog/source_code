diag_mod(deliver_pref_items(_),
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
                  assign(Pref, apply( consult_preference(_,_),[user,found_in] )),
                  Pref = [Pref_Loc,_],
                  set(user_location,Pref_Loc)
                 ] => apply( when(_,_,_),[Pref_Loc==unknown,
                                          error,
                                          mv(Pref_Loc)] )
           ]
  ],
  

  
  %% Move to 'Loc' and get the list of pairs 'obj_arm(object,held_in_hand)'
  %% store in 'grasped_obj'
  [
  id ==> mv(Loc),
  type ==> recursive,
  embedded_dm ==> move(Loc,_),
  arcs ==> [
           success:[
	            mood(feliz),
	            get(grasped_obj,Grasped)
	           ] => hand_objs(Grasped),
           error  :empty => mv(Loc)
           ]
  ],
  
  %% No more objects to release, we are done
  [
  id ==> hand_objs([]),
  type ==> neutral,
  out_arg ==> [ Return_Location ],
  arcs ==> [
           empty:[get(user_location,Return_Location)] => success
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
           empty:[
	          mood(talk),
	          say(['Here is the', Obj])
	         ] => release(A)
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
           success:[
	            mood(feliz)
	           ] => hand_objs(List),
           error  :empty => release(Arm)
           ]  
  ],
  
  %% Success situation
  [
  id ==> success,
  type ==> final,
  in_arg ==> [User_Loc],
  diag_mod ==> deliver_pref_items(User_Loc)
  ],
  
  %% Error situation
  [
  id ==> error,
  type ==> final
  ]  
],
% Local Variable
[
    grasped_obj ==> [],
    user_location ==> unknown
]
).
