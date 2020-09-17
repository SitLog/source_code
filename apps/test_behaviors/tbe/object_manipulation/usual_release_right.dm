%% To successfully execute this dialogue model, Golem must hold an object in its
%% right hand

diag_mod(usual_release_right(Pos,Hght),
[
     %% Golem moves forward a bit.
     %% Then, Golem releases the object in its right hand
     [	
     id ==> is,
     type ==> recursive,
     embedded_dm ==> move([displace_precise=>(0.10)], _),
     arcs ==> [
              success : [robotheight(Hght), 
                         set(last_height, Hght)]                       
                      => release_right, 
              error   : empty => is
              ]
     ], 


     %%
     %% Releases object in left hand. 
     [
     id ==> release_right,
     type ==> recursive,
     embedded_dm ==> relieve_arg(-15.0, 0.5, right, _),
     arcs ==> [
              success : empty => success,
              error   : empty => release_right
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

