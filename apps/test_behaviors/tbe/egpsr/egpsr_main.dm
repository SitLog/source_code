% GPSR Main Dialogue Model
diag_mod(egpsr_main, 
[
    [
    id ==> is,	
    type ==> neutral,
    arcs ==> [
             empty : [
                      robotheight(1.25),set(last_height,1.25),
                      tiltv(-30.0),set(last_tilt,-30.0),
                      tilth(0.0),set(last_scan,0.0),
                      apply(initialize_KB,[]),
                      apply(initialize_cognitive_model,[]),
                      %apply(initialize_parser,[]),
                      screen('Initialization complete, input ok. to start the test ')
                      %say('Open the door please')
                     ] 
                     % => add_to_kb_actual_position
                   => k1
             ]
    ],

    [
            id   ==> k1,
            type ==> keyboard,
            arcs ==> [
                     ok : empty => start2
                    ]
    ],

    [
            id ==> start2,
            type ==> neutral,
            arcs ==> [
                    empty : [
                    say('Open the door please')                           
                ] => detect_door
                    ]
    ],
    	
    %%
    [  
    id ==> detect_door,
    type ==> recursive,
    embedded_dm ==> detect_door(_),
    arcs ==> [
             success : empty => move_waiting_pos,
             error   : empty => detect_door				
             ]
    ],
        
    %%    
    [  
    id ==> move_waiting_pos,
    type ==> recursive,
    embedded_dm ==> move(waiting_position, _),
    arcs ==> [
             success : empty => solve,
             error   : empty => move_waiting_pos
             ]
    ],
    	
       
    %The actual position is stored as the 'waiting position'in the kb
    [
    id ==> add_to_kb_actual_position,
    type ==> positionxyz,
    arcs ==> [
             pos(X,Y,Z): apply(register_waiting_position(Xpos,Ypos,Zpos),[X,Y,Z]) => solve
             ]
    ],


    %%
    [  
    id ==> solve,
    type ==> recursive,
    embedded_dm ==> egpsr_solve_command,
    arcs ==> [
             success : empty => fs,
             error   : empty => fs
             ]
    ],
    
    
    %%
    [
    id ==> fs,
    type ==> final
    ]
],

  % Second argument: list of local variables
  [
  ]

).
