% Set a table and clean it up
% Author: Noe Hernandez
diag_mod(set_table_up_main, 
[

    [
    id ==> is,	 
    type ==> neutral,
    arcs ==> [
             empty : [
                     tiltv(-30.0),set(last_tilt,-30.0),
                     tilth(0.0),set(last_scan,0.0),
		     apply(initialize_KB,[]),
		     set(object_recognition_mode, moped)
		     ]
                   => start2
             ]
    ],
    
    
    [
            id ==> start2,
            type ==> neutral,
            arcs ==> [
                     empty : [say('Open the door please')] => detect_door
                     ]
    ],

    
    %%	
    [  
       id ==> detect_door,
       type ==> recursive,
       embedded_dm ==> detect_door(_),
       arcs ==> [
                success : empty => move_table,
                error   : empty => detect_door				
                ]
    ],
    	
    %%
    %% Golem moves to the table
    [
    id ==> move_table,
    type ==> recursive,
    embedded_dm ==> move(kitchentable,_),%% Attention!! Change to the right point (table) in the map and right height in KB
    arcs ==> [
             success : empty => meal_order,
             error   : empty => move_table				
      	     ]
    ],
        
    %%
    %% Golem retrieves the order from the operator
    [  
    id ==> meal_order,
    type ==> recursive,
    embedded_dm ==> ask('Please, tell me what has to be served. Say, bring me heineken and noodles, or bring me coke and kellogs', gpsr2015, true, 4, Res, _),
    arcs ==> [
             success : empty => apply( kind_order(X), [Res] ),
             error   : empty => meal_order
             ]
    ],
    	
    %%
    %% Here Golem runs the dialogue model fetch_objects,
    %% which needs to be provided with the List of objects to be fetched
    %% and the place of Source (cupboard) and Destination (table)   
    [
    id ==> get_order(List),
    type ==> recursive,
    embedded_dm ==> fetch_objects(List, diningtable, kitchentable),%% From diningtable to kintchentable. Attention!! Change to the right point in the map and right height in KB
    arcs ==> [
             success : [set(objs_list, List), say('The meal is served')] => cleaning_order,
             error   : [say('There was a problem fetching objects. Terminating task')] => fs
             ]
    ],

    %%
    %% Golem waits until the operator ask him to clean the table
    [  
    id ==> cleaning_order,
    type ==> recursive,
    embedded_dm ==> ask('Please, say start when you want me to clean the table', wakeup, true, 3, _, _),
    arcs ==> [
             success : [get(objs_list, Lista)] => clean_table(Lista),
             error   : empty => cleaning_order
             ]
    ],
    
    %%
    %% Golem takes the objects in the table back to the cupboard.
    %% Here Golem runs the dialogue model fetch_objects,
    %% which needs to be provided with the List of objects to be fetched
    %% and the place of Source (table) and Destination (cupboard) 
    [
    id ==> clean_table(Lista),
    type ==> recursive,
    embedded_dm ==> fetch_objects(Lista, kitchentable, diningtable),%% From table to cupboard. Attention!! Change to the right point in the map and right height in KB
    arcs ==> [
             success : [say('The table is clean. I am finished with this task')] => fs,
             error   : [say('There was a problem placing back the objects. Terminating task')] => fs
             ]
    ],
    
    %%
    %% Final situation
    [
    id ==> fs,
    type ==> final
    ]
    
  ],

% Second argument: list of local variables
  [
     objs_list ==> []
  ]

).
