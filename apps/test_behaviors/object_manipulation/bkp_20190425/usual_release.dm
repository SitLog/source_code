%% To successfully execute this dialogue model, Golem must hold an object in its
%% right hand

diag_mod(usual_release(Arm,Point),
[
     %% Initial situation
     [	
     id ==> is,
     type ==> neutral,
     arcs ==>[
	      empty : [assign(Values_ST,get(values_st,_)),
		       Values_ST = [_,_,_,Height],
		       get(release_height,Height)] => move_shelf(Height)
	     ]
     ],


     %%
     %% Golem moves to the releasing position
     [
     id ==> move_shelf(Hght),
     type ==> recursive,	 
     embedded_dm ==> move(Point, _),
     arcs ==> [
              success : [robotheight(Hght), 
                         set(last_height, Hght)]                       
                      => release(Arm), 
              error   : empty => move_shelf(Hght)
              ]
     ], 


     %%
     %% Releases object in left hand. 
     [
     id ==> release(right),
     type ==> recursive,
     embedded_dm ==> relieve_arg(-15.0, 0.5, right, _),
     arcs ==> [
              success : empty => success,
              error   : empty => release(right)
              ]
     ],


     %%
     %% Releases object in left hand. 
     [
     id ==> release(left),
     type ==> recursive,
     embedded_dm ==> relieve_arg(15.0, 0.5, left, _),
     arcs ==> [
              success : empty => success,
              error   : empty => release(left)
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

