  %% Author: Ricardo Cruz
  %%         Noe Hdez
  %% get_preferences Dialogue Model
  %% Its arguments are:
  %%   Order        -> The text Golem says when asking the user for an order
  %%   Grammar      -> The grammar that is used to understand the user's order
  %%   PreferenceId -> The preference id Golem will look up in the KB
  %%   Final_List   -> The list that contains the preferred items after
  %%                   Golem reasons about preferences. This will be returned by the DM

diag_mod(get_preferences(Order,Grammar,PreferenceId,Final_List),
[
  %% Initial situation. Golem gets a command from the user
  [
  id ==> ask_order,
  type ==> recursive,
  embedded_dm ==> ask(Order,Grammar,false,1,Output,_),
  arcs ==> [
           success:[assign(User_val,apply( preferences_demo_parser(_),[Output]) )] 
                         => preference( User_val ),
           error  :empty => error
           ]
  ],
  
  %% No more items to processed
  [
  id ==> preference([]),
  type ==> neutral,
  out_arg ==> [Reversed_lst],
  arcs ==> [ 
           empty:[get(lst,Lst),
                  reverse(Lst,Reversed_lst),
                  Reversed_lst = [Obj1,Obj2],
		  mood(talk),
		  say(['ok, I will bring you the ',Obj1,' and the ',Obj2])
                 ] => %% The function 'when' is represented by 'g' in the diagram of 'get_preferences'
                      apply( when(_,_,_),[Lst==[],
                                             error,
                                             success] )
           ]
  ],
  
  %% We find the preferences for item 'E'. If its preference does not
  %% contradict any order given by the user, add it to the final order;
  %% otherwise, asks the users which item to add.
  [
  id ==> preference([Element_Asked|T]),
  type ==> neutral,
  out_arg ==> [Q_ask_choice],
  arcs ==> [
           empty:[set(user_val,T),
                  assign(Pref, apply( consult_preference(_,_),[Element_Asked,PreferenceId] )),
		  Pref = [Pref_elem,Elem],
                  assign(Q_ask_choice, apply( prompt_user_to_decide(_,_),[Element_Asked,Pref_elem] )),
		  mood(talk)
		 ] => %% The function 'when' is represented by 'f' in the diagram of 'get_preferences'
                      apply(when(_,_,_),
		            [(Element_Asked=='drink';Element_Asked=='food'),
			     ask_choice(Pref_elem,Pref_elem),
			     ask_choice(Element_Asked,Pref_elem)
			    ])
           ]
  ],
  
  %% 'Elem' is add to the final order
  [
  id ==> add(Elem),
  type ==> neutral,
  arcs ==> [
           empty:[
                  get(lst,Current_lst),
                  set(lst,[Elem|Current_lst]),
                  get(user_val,User_val)
                 ] 
                 => preference(User_val)
           ]
  ],

  %% An error situation
  [
  id ==> ask_choice(_, unknown),
  type ==> neutral,
  arcs ==> [
           empty:empty => error
           ]
  ],
  
  %% The users is prompted to decide between 'Obj1' and 'Obj2'
  [
  id ==> ask_choice(Obj1, Obj2),
  type ==> recursive,
  in_arg ==> [Q],
  embedded_dm ==> ask(Q,preferences_demo_command,false,1,Answer,_),
  arcs ==> [
           success:empty => apply(when(_,_,_),[Answer=='yes',
                                               add(Obj1),
                                               add(Obj2)]),
           error  :empty => add(Obj1)%% The user doesn't choose any object. So the robot considers Obj1 for the 
                                     %% rest of the interaction
           ]
  ],
  
  %% Success situation
  [
  id ==> success,
  type ==> final,
  in_arg ==> [Preferred_elements],
  diag_mod ==> get_preferences(_,_,_,Preferred_elements)
  ],
  
  %% Error situation
  [
  id ==> error,
  type ==> final
  ]
],
%List of local variables
[
  lst ==> [],
  user_val ==> []
]
).

