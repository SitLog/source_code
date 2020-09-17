%% To successfully execute this dialogue model, Golem must hold an object in its
%% right hand

diag_mod(usual_release(Pos, Hght, GoBack),
[
     %% Initial situation.
     %% Golem goes to the releasing position (stored in Pos) and 
     %% changes its height to the default one for releasing. Golem doesn't keep track of this 
     %% returnig turn (flag is set to false)
     [	
     id ==> is,
     type ==> neutral,
     arcs ==> [
              empty : [set(flag_angle_storing_groceries,false)] => go_back(GoBack)
              ]
     ],
     
     
     %%
     %% Golem moves back before turning
     [	
     id ==> go_back(true),
     type ==> neutral,
     arcs ==> [
              empty : [advance_fine(-0.15, _)] => mv(Pos)
              ]
     ], 
     
     
     %%
     %% Golem doesn't move back before turning 
     [	
     id ==> go_back(_),
     type ==> neutral,
     arcs ==> [
              empty : empty => mv(Pos)
              ]
     ],


     %%
     %% Golem turns and keeps track (set flag true) 
     %% of the rotation angle (by substracting the values to the corresponding
     %% global variables)
     [	
     id ==> mv(Pos),
     type ==> recursive,
     embedded_dm ==> move(Pos, _),
     arcs ==> [
              success : empty => move_forward, 
              error   : empty => mv(Pos)
              ]
     ], 

     %%
     %% Move forward a bit
     [	
     id ==> move_forward,
     type ==> recursive,
     embedded_dm ==> move([displace_precise=>(0.10)], _),
     arcs ==> [
              success : [robotheight(Hght), 
                         set(last_height, Hght)]                       
                      => release_obj(1), 
              error   : empty => move_forward
              ]
     ], 


     %%
     %% Releases object in right hand. Once the object in the right hand is released
     %% Golem checks if there is one in his left hand to release
     [
     id ==> release_obj(1),
     type ==> recursive,
     embedded_dm ==> relieve_arg(-15.0, 0.5, right, _),
     arcs ==> [
               success : [get(left_arm, Obj_left)] 
                        => apply( when(If,True,False),[Obj_left == free,success,release_obj(2)] ),
               error   : empty => release_obj(1)
             ]
     ],


     %%
     %% Releases object in left hand. 
     [
     id ==> release_obj(2),
     type ==> recursive,
     embedded_dm ==> relieve_arg(15.0, 0.5, left, _),
     arcs ==> [
               success : [robotheight(1.25),
                          set(last_height,1.25)] 
                       => success,
              error    : empty => release_obj(2)
              ]
     ],


     %%
     %% Final situation. Success case.
     [
     id ==> success,
     type ==> final
     ],
     

     %%
     %% Final situation. Error case.
     [
     id ==> error,
     type ==> final
     ]
],

% Second argument: list of local variables
[
]

).	

