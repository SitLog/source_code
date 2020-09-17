diag_mod(fetch_and_take(Obj,Org,Dst,User),
[
  %% Author: Noe Hdez
  
  %% Initial situation. 
  [
  id ==> is,
  type ==> neutral,
  arcs ==> [
           empty:[
	         assign(Dst_Name, apply( get_val_pref_propty(_,_),[Dst,name] )),
	         mood(talk),
	         say(['Ok, I will take it to', Dst_Name])
	         ] => mv(Org)
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
           success:[
                   mood(neutral), 
                   assign(NewHeight,apply( when(_,_,_), 
                          [Place==Org,
                           get(height_obj,_), 
                           get(height_tbl,_) 
                          ])),
                   robotheight(NewHeight),
		   set(last_height,NewHeight)            
                   ] =>apply( when(_,_,_),[Place==Org,see,deliver] ),
	   error  :[say(['Error moving to the',Place])]=>error
           ]
  ],
  
  %% See the Obj given as a DM argument 
  [
  id ==> see,
  type ==> recursive,
  embedded_dm ==> scan(object, [Obj], [0.0], [-30.0], object, [Found], false, false, _),
  arcs ==> [
           success:[
	           mood(neutral)
	           ] => take(Found),
	   error  :[advance_fine(-0.15,_),inc(see_cnt,Cnt)] => apply(when(_,_,_),[Cnt<3,see,error])
           ]  
  ],


  %% Take Obj
  [
  id ==> take(Seen_Object),
  type ==> recursive,
  embedded_dm ==> take(Seen_Object,right,_,_),
  arcs ==> [
           success:[
	           mood(feliz)
	           ] => mv(Dst),
           error  :[
	           mood(triste),
	           advance_fine(-0.15,_)
	           ] => take(Seen_Object) 
           ]
  ],


  %% Deliver Obj
  [
  id ==> deliver,
  type ==> recursive,
  embedded_dm ==> relieve_arg(-15.0, 0.7, right, _),
  arcs ==> [
           success:[
                   mood(talk),
	           say(['I put the',Obj,'in its right shelf']),
		   mood(feliz)
	           ] => mv_user,
	   error  :[say(['Error delivering the object','Trying again'])] => deliver
           ]
  ],


  %% Move to the user
  [
  id ==> mv_user,
  type ==> recursive,
  embedded_dm ==> move(User,_),
  arcs ==> [
           success:[
	           mood(alegre)
	           ]=>success,
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
    height_tbl ==> 1.41,
    height_obj ==> 1.15,
    see_cnt ==> 0
]
).
