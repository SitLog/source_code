%% Author: Noe Hdez
%%
diag_mod(release_category(Position,DeliverPos,Categories),
[
     %% Initial situation.
     %% Golem doesn't keep track of the 
     %% returnig turn (flag is set to false)
     [	
     id ==> is,
     type ==> neutral,
     arcs ==> [
              empty : empty => find_category(1)
              ]
     ],
     
     
     %% This situation invokes 'check_category' to find the object's category
     %% is in the cupboard. When the argument 2 is passed, it means that the grasp 
     %% will be attempted with the left arm
     [	
	 id ==> find_category(1),
	 type ==> recursive,
	 embedded_dm ==> move(Position, _),
	 arcs ==> [
                  success : [get(right_arm, Name),
			     assign(Ang_St,get(angle_storing_groceries,_)),
		             set(tmp_ang_st,Ang_St)
                            ]=> check_category(apply( get_class_of_obj(N_),[Name] ), 1),
                  error   : empty => find_category(1)
	          ]
     ],
     
 
     %% This situation invokes 'check_category' to find the object's category
     %% is in the cupboard. When the argument 2 is passed, it means that the grasp 
     %% will be attempted with the left arm
     [	
	 id ==> find_category(2),
	 type ==> recursive,
	 embedded_dm ==> move(Position, _),
	 arcs ==> [
                  success : [get(left_arm, Name),
			     assign(Ang_St,get(tmp_ang_st,_)),
		             set(angle_storing_groceries,Ang_St)
			    ] => check_category(apply( get_class_of_obj(N),[Name] ), 2),
                  error   : empty => find_category(2)
	          ]
     ],
     
     
     %% This situation consider when Golem has an unknown object in his right hand.
     %% So, Golem releases it
     [	
	 id ==> check_category(unknown, 1),
	 type ==> neutral,
	 arcs ==> [
                    empty : empty => release_right
	          ]
     ],
     
     
     %% This situation consider when Golem has an unknown object in his left hand.
     %% So, Golem releases it
     [	
	 id ==> check_category(unknown, 2),
	 type ==> neutral,
	 arcs ==> [
                    empty : empty => release_left
	          ]
     ],
     
     
     %% This situation checks if the category corresponding to the object to be put
     %% is in the cupboard. If so, 'search_height' is invoked. Otherwise, a normal
     %% release takes place
     [	
	 id ==> check_category(Obj_Cat, Arm),
	 type ==> neutral,
	 arcs ==> [
                    empty : empty 
                          => apply( extract_categories(X, Y, Z), [Obj_Cat, Categories, Arm] )  
	          ]
     ],
     
     
     %% This situations finds a list of objects that have the same category as the respective 
     %% argument. We know that objects in that category are positioned in a shelf
     %% reachable by Golem
     [
	 id ==> search_height(Category, Arm, S_Val, T_Val),
	 type ==> recursive,
         embedded_dm ==> scan(object, Category, S_Val, T_Val, category, FndObjs, false, false, _), 
	 arcs ==> [
	           success : [set(flag_angle_storing_groceries,true),
                              set(angle_operation,substraction),
			      set(turn_flag_approach, 0.0)] 
                           => approach( apply(get_head(H), [FndObjs]), Arm),
  	     	   error   : empty => apply( when(I_,T_,F_),[Arm==1,release_right,release_left] )
                  ]    
     ],
     
      
     %% Golem approaches Objecto, after that he will release the object he has in his right hand
     [
	 id ==> approach(Objeto, 1),
	 type ==> recursive,
	 embedded_dm ==> approach_object(Objeto, object(Id,X1,Y1,Z1,A,B,C,D,E), _),
	 arcs ==> [
 	      	  success : [ set(flag_angle_storing_groceries,false),
			      get(last_tilt,GolemT),
			      get(last_height,RobotHeight),
    			      cam2arm(right,RobotHeight,[X1,Y1,Z1],[GolemT,0.11,0.10],[0.21,0.22,0.2248],[Height,Angle,Distance]),%%<--Attention!! Change calibration values
    			      robotheight(Height),
			      set(last_height,Height),
			      get(turn_flag_approach, Flag_Value),
                              assign(Offset,apply(when(I_,T_,F_),[Flag_Value>0.0,-4.0,4.0])),
                              NewAng is Offset + Angle
                             ]
                           => release_arg(NewAng,Distance,right),
                  error  : [set(flag_angle_storing_groceries,false)]
			   => release_right
                  ]
     ],


     %% Golem approaches Object, after that he will release the object he has in his left hand
     [
	 id ==> approach(Objeto, 2),
	 type ==> recursive,
	 embedded_dm ==> approach_object(Objeto, object(Id,X1,Y1,Z1,A,B,C,D,E), _),
	 arcs ==> [
 	      	  success : [set(flag_angle_storing_groceries,false),
			     get(last_tilt,GolemT),
    			     get(last_height,RobotHeight),
    			     cam2arm(left,RobotHeight,[X1,Y1,Z1],[GolemT,0.11,0.10],[-0.05,0.22,0.2248],[Height,Angle,Distance]),%%<--Attention!! Change calibration values
    			     robotheight(Height),
			     set(last_height,Height),
			     get(turn_flag_approach, Flag_Value),
                             assign(Offset,apply(when(I_,T_,F_),[Flag_Value>0.0,-4.0,4.0])),
                             NewAng is Offset + Angle
                            ]
			   => release_arg(NewAng,Distance,left),
		  error : [set(flag_angle_storing_groceries,false)]
			   => release_left
                  ]
     ],
     
     
     %% Release object with an angle and distance
     [
	 id ==> release_arg(Ang, Dist, H),
	 type ==> recursive,
	 embedded_dm ==> relieve_arg(Ang, Dist, H, _),
	 arcs ==> [
 	      	  success : [robotheight(1.20),
                             set(last_height,1.20),
                             advance_fine(-0.20,_),
                             get(left_arm, Obj_left)]
                          => apply( when(I_,T_,F_),[Obj_left == free,success,find_category(2)] ),
		  error : empty => release_arg(Ang, Dist, H)
                  ]
     ],     
     
     
     %% Release object in right hand to default releasing position
     [
	 id ==> release_right,
	 type ==> recursive,
	 embedded_dm ==> usual_release(right,DeliverPos),
	 arcs ==> [
 	      	  success : [robotheight(1.20),
                             set(last_height,1.20),
                             advance_fine(-0.25,_),
                             get(left_arm, Obj_left)] 
                          => apply( when(I_,T_,F_),[Obj_left == free,success,find_category(2)] ),
		  error : empty => release_right
                  ]
     ], 
     
     
     %% Release object in left hand to default releasing position
     [
	 id ==> release_left,
	 type ==> recursive,
	 embedded_dm ==> usual_release(left,DeliverPos),
	 arcs ==> [
 	      	  success : [robotheight(1.20),
                             set(last_height,1.20)] 
                          => success,
		  error : empty => release_left
                  ]
     ], 
     
     
     %% Final situation. Success case.
     [
     id ==> success,
     type ==> final
     ],	
     
     
     %% Final situation. Error case.
     [
     id ==> error,
     type ==> final
     ]     
     
],

% Second argument: list of local variables
[
    tmp_ang_st ==> 0.0
]
).	

