% Pose Task Dialogue Model
%
% 	Description	The robot recognizes the pose of a person 
%	
%	Arguments	Pos: The pose of the person Golem is seeing
%				
%			St:	
%				    ok .- if the gender was recognized
%			       	    fail .- otherwise

diag_mod(pose(Pos, St),
[
   [
   id ==> is,
   type ==> neutral,
   arcs ==> [
            empty : [say('I will recognize your pose')] => hnd_up
            ]
   ],
   
   [  
   id ==> hnd_up,
   type ==> recursive,
   embedded_dm ==> see_gesture(hand_up,nearest,1,Body_Positions,_),
   out_arg ==> ['with hand up'],
   arcs ==> [
            success : [say('Got it')] => success,
            error   : [say('Wait')] => wave				
            ]
   ],
    
   [  
   id ==> wave,
   type ==> recursive,
   embedded_dm ==> see_gesture(waving,nearest,1,Body_Positions,_),
   out_arg ==> [waving],
   arcs ==> [
            success : [say('Got it')] => success,
            error   : [say('Wait')] => sit				
            ]
   ],
    
   [  
   id ==> sit,
   type ==> recursive,
   embedded_dm ==> see_gesture(sitting,nearest,1,Body_Positions,_),
   out_arg ==> [sitting],
   arcs ==> [
            success : [say('Got it')] => success,
            error   : empty => stand				
            ]
   ],
   
   [  
   id ==> stand,
   type ==> neutral,
   out_arg ==> [standing],
   arcs ==> [
            empty : [say('Got it')] => success			
            ]
   ],
           
   [
   id ==> success,
   type ==> final,
   in_arg ==> [Pose],
   diag_mod ==> pose(Pose, ok) 
   ],
	
   [
   id ==> error,
   type ==> final,
   diag_mod ==> pose(unknown, fail)
   ]

],

  % Second argument: list of local variables
  [
  ]

).
