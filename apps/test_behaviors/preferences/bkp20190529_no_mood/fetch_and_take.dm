diag_mod(fetch_and_take(Obj,Org,Dst,User),
[
  %% Author: Noe Hdez
  
  %% Initial situation. 
  [
  id ==> is,
  type ==> neutral,
  arcs ==> [
           empty:[say(['I will get the',Obj])] => mv(Org)
           ]
  ],
  
  %% Move to Place. The place could be Org or Dst. Once Golem moves
  %% to Dst, it changes its height to the proper delivery height according to
  %% the table or shelf
  [
  id ==> mv(Place),
  type ==> recursive,
  embedded_dm ==> move(Place,_),
  arcs ==> [
           success:empty=>apply( when(_,_,_),[Place==Org,see,change_height] ),
	   error  :[say(['Error moving to the',Place])]=>error
           ]
  ],
  
  %% See the Obj given as a DM argument 
  [
  id ==> see,
  type ==> recursive,
  embedded_dm ==> scan(object, [Obj], [0.0], [-30.0], object, [Found], false, false, _),
  arcs ==> [
           success:empty => take(Found),
	   error  :[advance_fine(-0.15,_)] => see
           ]  
  ],


  %% Take Obj
  [
  id ==> take(Seen_Object),
  type ==> recursive,
  embedded_dm ==> take(Seen_Object,right,_,_),
  arcs ==> [
           success:empty => mv(Dst),
           error  :[advance_fine(-0.15,_)] => take(Seen_Object) 
           ]
  ],


  %% Change height to the make a successful deliver
  [
  id ==> change_height,
  type ==> neutral,
  arcs ==> [
	   empty : [assign(NewHeight,get(height_tbl,_)),
		    robotheight(NewHeight),
		    set(last_height,NewHeight)] => deliver
           ]
  ],
      
  
  %% Deliver Obj
  [
  id ==> deliver,
  type ==> recursive,
  embedded_dm ==> relieve_arg(-15.0, 0.7, right, _),
  arcs ==> [
           success:[say(['I positioned the',Obj,'in the correct shelf'])] => mv_user,
	   error  :[say(['Error delivering the object','Trying again'])] => deliver
           ]
  ],


  %% Move to the user
  [
  id ==> mv_user,
  type ==> recursive,
  embedded_dm ==> move(User,_),
  arcs ==> [
           success:empty=>success,
           error  :[say('Error moving to the user')]=>mv_user
           ]
  ],

  
  %% Success situation
  [
  id ==> success,
  type ==> final
  ],

  
  %% Error situation
  [
  id ==> error,
  type ==> final
  ]
      
],
% Local variables
[
    height_tbl ==> 1.45
]
).
