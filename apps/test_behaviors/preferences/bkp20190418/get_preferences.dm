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
  %% Initial situation. Golem gest a command from the user
  [
  id ==> ask_order,
  type ==> recursive,
  embedded_dm ==> ask(Order,Grammar,false,1,Output,Status),
  arcs ==> [
           success:[assign(User_val,apply( preferences_demo_parser(O_),[Output]) )] 
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
           empty:[assign(Lst,get(lst,_)),
                  reverse(Lst,Reversed_lst)                  
                 ] => %% The function 'when' is represented by 'g' in the diagram of 'get_preferences'
                      apply( when(I_,T_,F_),[Lst==[],
                                             error,
                                             success] )
           ]
  ],
  
  %% We find the preferences for item 'E'. If its preference does not
  %% contradict any order given by the user, add it to the final order;
  %% otherwise, asks the users which item to add.
  [
  id ==> preference([E|T]),
  type ==> neutral,
  out_arg ==> [Q_ask_choice],
  arcs ==> [
           empty:[set(user_val,T),
                  assign(Pref, apply( consult_preference(I_,P_),[E,PreferenceId] )),Pref = [Pref_elem,Elem],
                  assign(Q_ask_choice, apply( prompt_user_to_decide(E_,PE_),[E,Pref_elem] ))
                 ] => %% The function 'when' is represented by 'f' in the diagram of 'get_preferences'
                      apply(when(I_,T_,F_),[(Elem==no_object;E==Pref_elem),
                                            add(Pref_elem),
                                            ask_choice(E,Pref_elem)])
           ]
  ],
  
  %% 'Elem' is add to the final order
  [
  id ==> add(Elem),
  type ==> neutral,
  arcs ==> [
           empty:[
                  assign(Current_lst, get(lst,Var)),
                  set(lst,[Elem|Current_lst]),
                  assign(Add_text, apply(add_elem_text(E_),[Elem] )),
		  say(Add_text),
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
  embedded_dm ==> ask(Q,yesno,false,1,Answer,St),
  arcs ==> [
           success:[
                    assign(Choice_obj1, apply(choice_text(O1_,O2_),  [Obj1,Obj2] )),
                    assign(Choice_obj2, apply(choice_text(OO2_,OO1_),[Obj2,Obj1] )),
		    apply( when(I1_,T1_,F1_),
                           [Answer==yes,
                            say(Choice_obj2),
                            say(Choice_obj1) ])
                   ] => apply(when(I2_,T2_,F2_),[Answer==yes,
                                                 add(Obj2),
                                                 add(Obj1)]),
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

