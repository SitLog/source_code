diag_mod(preferences_main,
[
  %% Author: Ricardo Cruz
  %%         Noe Hdez
  
  %% Initial situation. 
  [
  id ==> is,	
  type ==> neutral,
  arcs ==> [
           empty : [sleep(5),
                    robotheight(1.25),set(last_height,1.25),
                    tiltv(-30.0),set(last_tilt,-30.0),
                    tilth(0.0),set(last_scan,0.0),
                    apply(initialize_KB_preferences,[])
                   ] => welcome
           ]
  ],
  
  %% Golem goes to a welcome point to meet and greet the user
  [
  id ==> welcome,
  type ==> recursive,
  embedded_dm ==> welcome_user,
  arcs ==> [
           success:[get(ask_for_order,Ask)] => get_order(Ask),
           error  :empty => error
           ]
  ],

  %% Golem obtains a command of preferred items to get for the user
  [
  id ==> get_order(Ask),
  type ==> recursive,
  embedded_dm ==> get_preferences(Ask,preferences_demo_command,to_serve,Final_Order),
  arcs ==> [ 
           success:[apply( upd_kb_user_asked(F_),[Final_Order] )] => get_items(Final_Order),
           error  :[say('There is an error getting the order. Aborting task')] => fs
           ] 
  ],
  
  %% Golem searches in the preferred locations for the items
  %% the user wants, and take them 
  [
  id ==> get_items(Ord),
  type ==> recursive,
  embedded_dm ==> get_pref_items(Ord, Item_Location),
  arcs ==> [
            success:[set(item_loc_list,Item_Location)] => deliver_items,
            error  :[say('There is an error taking the objects. Aborting task')] => fs
           ]
  ],
  
  %% Golem delivers the items to the user by going to the
  %% user's preferred location
  [
  id ==> deliver_items,
  type ==> recursive,
  embedded_dm ==> deliver_pref_items,
  arcs ==> [
            success:[get(item_loc_list,ItemLoc)] => update_kb(ItemLoc),
            error  :[say('There is an error delivering the objects. Aborting task')] => fs
           ]
  ],
  
  %% Situation that asks the user if the locations of 
  %% objects need to be updated
  [
  id ==> update_kb(ItemLoc),
  type ==> recursive,
  embedded_dm ==> update_kb_pref(ItemLoc),
  arcs ==> [
           success:[say('The task is finished')] => fs,
           error  :[say('There is an error updating the knowledge base. Aborting task')] => fs
           ]
  ],
  
  %% Final situation
  [
  id ==> fs,
  type ==> final
  ]
],

%List of local variables
[
  item_loc_list ==> [],
  ask_for_order ==> 'Do you want me to do something for you?'
]
).
