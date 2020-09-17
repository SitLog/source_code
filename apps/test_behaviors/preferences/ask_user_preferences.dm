diag_mod(ask_user_preferences,
[
    %% Author: Noe Hernandez

    %% Initial situation
    %% Golem addesses the user to get his preferences
    [
    id ==> is,
    type ==> neutral,
    arcs ==> [
             empty : [
		     mood(talk),
		     say('Hi Luis'),
		     say('Please tell me'),
		     get(ctr,Ctr)
	             ]
		    => retrieve_lst(Ctr)
             ]
    ],

    %% Golem gets the preferences for drinks
    [
    id ==> retrieve_lst(0),
    type ==> neutral,
    arcs ==> [
	     empty : [
		     mood(talk),
		     assign(Bev_lst,apply(get_objects_in_categories(_),[drink]))
	             ] => ask_item_pref(Bev_lst)
	     ]
    ],

    %% Golem gets the preferences for food
    [
    id ==> retrieve_lst(1),
    type ==> neutral,
    arcs ==> [
	     empty : [
		     mood(talk),
		     assign(Food_lst,apply(get_objects_in_categories(_),[food]))
	             ] => ask_item_pref(Food_lst)
	     ]
    ],

    %% No more preferences to know
    [
    id ==> retrieve_lst(_),
    type ==> recursive,
    embedded_dm ==> ask(['do you have any more preferences?'],preferences_demo_command,false,1,Answer,_),
    arcs ==> [
	     success : [apply(when(_,_,_),
		        [Answer=='no thanks golem that is ok',
			 say('thank you Luis'),
                         empty])
		       ] => apply(when(_,_,_),
				  [Answer=='no thanks golem that is ok',
				   success,
		   		   retrieve_lst(2)
		    		  ]),
	     error  : empty => success
	     ]
	
    ],

    
    %% For the classes Golem wants to know the user preference there are
    %% exactly two objects. Golem asks for the preference of the two objects
    [
    id ==> ask_item_pref([Item1,Item2]),
    type ==> recursive,
    embedded_dm ==> ask(['what do you like best',Item1,'or',Item2,'?'],preferences_demo_command,false,1,Answer,_),
    arcs ==> [
	     success : [assign(Speech,apply(dialogue_conceptual_inference(_), [Answer])),
		        say(Speech)
		       ] => apply(when(_,_,_),
				  [(Answer=='hi golem i like malz';Answer=='i like noodles best'),
				   save_pref_kb(Item1,Item2),
		   		   save_pref_kb(Item2,Item1)
		    		  ]),
	     error  : empty => error
	     ]
	
    ],

    %% Here the preferences for the two items is set in the KB
    [
    id ==> save_pref_kb(It1,It2),
    type ==> neutral,
    arcs ==> [
	     empty : [
		     apply(save_new_pref(_,_),[It1,1]),
		     apply(save_new_pref(_,_),[It2,2]),
		     inc(ctr,Ctr)
		     ] => retrieve_lst(Ctr)
	     ]
    ],

    %% Final situation: success
    [
    id ==> success,
    type ==> final
    ],

    %% Final situation: error
    [
    id ==> error,
    type ==> final
    ]    
],

[
    ctr ==> 0
]
).
