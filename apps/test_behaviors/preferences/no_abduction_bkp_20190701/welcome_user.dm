diag_mod(welcome_user,
[
  %% Author: Ricardo Cruz
  %%         Noe Hdez
  
  %% Initial situation. 
  [
  id ==> is,
  type ==> neutral,
  arcs ==> [
           empty:empty => go_meeting_pt(welcome_point)
           ]
  ],
  
  %% Golem moves to the door where he meets the user 
  [
  id ==> go_meeting_pt(Pt),
  type ==> recursive,
  embedded_dm ==> move(Pt,_),
  arcs ==> [
           success:empty => ask_day,
           error  :empty => error
           ]
  ],
  
  %% Golem asks how the user is going
  [
  id ==> ask_day,
  type ==> recursive,
  embedded_dm ==> ask(['Welcome',' how was you day, master?'], preferences_demo_command, false, 1, Output, Status),
  arcs ==> [
           success:[apply( upd_KB_back_from_work,[] )] => day_reply( apply(preferences_demo_parser(O_),[Output]) ),
           error  :empty => error
           ]
  ],
  
  %% Golem shows empathy to the user and updates the KB with the user's
  %% perception of the day 
  [
  id ==> day_reply(Day),
  type ==> neutral,
  arcs ==> [
           empty : [ apply( update_KB_users_day(D_), [Day] ), 
                     apply(when(I_,T_,F_),[Day=='good_day',
                                           say('I am glad to hear that'), 
					   say('I am sorry to hear that')] )
		   ] => success	
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
[]
).
