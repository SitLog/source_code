diag_mod(check_item_locations(Order,User_Loc),
[
  %% Author: Noe Hdez
  
  %% Initial situation. 
  %% Get objects for checking their positions
  [
  id ==> is,
  type ==> neutral,
  arcs ==> [
           empty:[
	          assign(Objs,apply(get_objs_then_substract_order(_,_),[comestible,Order]))
		 ] => check(Objs)
           ]
  ],
  
  %% No objects to check their positions
  [
  id ==> check([]),
  type ==> neutral,
  arcs ==> [
           empty:[
	         mood(talk),
	         say(['All objects are placed in their right shelves'])
	         ] => success
           ]
  ],
  
  %% Check the location of Head
  [
  id ==> check([Obj|More]),
  type ==> neutral,
  prog ==> [set(more_items,More)],
  arcs ==> [
               empty:[apply(consult_kb_value_object_property(_,_,_),[Obj,last_seen,Last]),
		      assign(List,apply(consult_preferences_list(_,_),[Obj,loc]))]
	            => apply( is_last_seen_correct(_,_,_,_),[Obj,More,Last,List] )
           ]  
  ],

  %% Add 'misplaced' property, need for the abduction reasoner
  [
  id ==> add_misplaced(Obj,Origin,Dest),
  type ==> neutral,
  arcs ==> [
	   empty : [apply(add_misplaced_property(_),[Obj]),
	   	    mood(talk),
		    say(['I also noticed that the',Obj,'is not in its right place']),
		    apply(consult_kb_abductive_object_property(_,_,_),[Obj,misplaced,Val]),
		    mood(talk),
		    Val=(moved_by=>Ind),
		    say('I think that the explanation for this is that'),
		    say(['the',Obj,'was misplaced there by your',Ind])
		   ] => ask_to_reposition(Obj,Origin,Dest)
           ]
  ],

  %% Ask user to reposition object
  [
  id ==> ask_to_reposition(Obj,Origin,Dest),
  type ==> recursive,
  embedded_dm ==> ask(['Do you want me to take it to its right shelf?'], preferences_demo_command, false, 1, Answer, _),
  arcs ==> [
           success:[get(more_items,More)]
		       => apply(when(_,_,_),[Answer=='yes golem please',
					     fetch_take(Obj,Origin,Dest),
					     check(More)]),
           error  :empty => ask_to_reposition(Obj,Origin,Dest)
           ]
  ],
    
  
  %% Fetch and take the object to the correct position.
  %% At the end, Golem returns to the user location
  [
  id ==> fetch_take(Obj,Ori,Dst),
  type ==> recursive,
  embedded_dm ==> fetch_and_take(Obj,Ori,Dst,User_Loc),
  arcs ==> [
           success: [apply(rm_misplaced_property(_),[Obj]), get(more_items,Rest)] => check(Rest),
	   error  : [say(['I could not position the',Obj,' in its correct position']),get(more_items,Rest)] => error 
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
  more_items ==> []
]
).
