diag_mod(preferences_main,
[
  %% Author: Ricardo Cruz
  %%         Noe Hdez
  
  %% Initial situation. 
  [
  id ==> is,	
  type ==> neutral,
  arcs ==> [
           empty : [robotheight(1.25),set(last_height,1.25),
                    tiltv(-30.0),set(last_tilt,-30.0),
                    tilth(0.0),set(last_scan,0.0),
                    apply(initialize_KB_preferences,[]),
		    mood(neutral),
		    sleep(4)
                   ] => ask_preferences
           ]
  ],
  
  %% Golem asks for the preferences for each drink and food available
  [
  id ==> ask_preferences,
  type ==> recursive,
  embedded_dm ==> ask_user_preferences,
  arcs ==> [
           success:empty => wait_for_user,
           error  :[say(['There is an error getting the initial user preferences','Aborting task'])] => fs
	   ]
  ],

  %% Once Golem got the user preferences, he now waits
  %% for the user to come back after work
  [
  id ==> wait_for_user,
  type ==> neutral,
  arcs ==> [
	   empty:[sleep(2),
		  mood(talk),
		  say('my master went to work'),
		  say('when he comes back I will meet him in the entrance door'),
		  sleep(4)
		 ] => welcome
	   ]
  ],
  
  %% Golem goes to the entrance door to meet and greet the user
  [
  id ==> welcome,
  type ==> recursive,
  embedded_dm ==> welcome_user,
  arcs ==> [
           success:[
	           mood(talk),
	           get(ask_for_order,Ask)
                   ] => get_order(Ask),
           error  :[say(['There is an error welcoming the user','Aborting task'])] => fs
           ]
  ],

  %% Golem obtains a command of preferred items to get for the user
  [
  id ==> get_order(Ask),
  type ==> recursive,
  embedded_dm ==> get_preferences(Ask,preferences_demo_command,to_serve,Final_Order),
  arcs ==> [ 
           success:[apply( upd_kb_user_asked(F_),[Final_Order] ),set(ordered_items,Final_Order)] => get_items(Final_Order),
           error  :[say(['There is an error getting the order','Aborting task'])] => fs
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
            error  :[say(['There is an error taking the objects','Aborting task'])] => fs
           ]
  ],
  
  %% Golem delivers the items to the user by going to the
  %% user's preferred location
  [
  id ==> deliver_items,
  type ==> recursive,
  embedded_dm ==> deliver_pref_items(User_Loc),
  arcs ==> [
            success:[get(item_loc_list,ItemLoc)] => update_kb(ItemLoc,User_Loc),
            error  :[say(['There is an error delivering the objects','Aborting task'])] => fs
           ]
  ],
  
  %% Situation that asks the user if the locations of 
  %% objects need to be updated
  [
  id ==> update_kb(ItemLoc,User_Loc),
  type ==> recursive,
  embedded_dm ==> update_kb_pref(ItemLoc),
  arcs ==> [
           success:[get(ordered_items,Order)] => check_all_item_locs(Order,User_Loc),
           error  :[say(['There is an error updating the knowledge base','Aborting task'])] => fs
           ]
  ],


  %% Check the location of the objects seen during the execution of the task
  [
  id ==> check_all_item_locs(Order,User_Loc),
  type ==> recursive,
  embedded_dm ==> check_item_locations(Order,User_Loc),
  arcs ==> [
	   success : say('The task is finished') => fs,
	   error   : [say(['There is an error checking item locations','Aborting task'])] => fs
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
  ordered_items ==> [],  
  item_loc_list ==> [],
  ask_for_order ==> 'Do you want me to do something for you?'
]
).
