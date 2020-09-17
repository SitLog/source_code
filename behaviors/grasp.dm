% Grasp Task Dialogue Model
%
% 	Description	The robot grasps an object (assuming is already reachable)  
%	
%	Arguments	Object: a functor object(id, x, y, z, o1, o2, o3, o4, c) with information about the position of the object.
%
%			Arm: 	left
%				    right
%				
%			Status:	
%				    ok .- if the object was grasped
%			       	not_grasped .- otherwise

diag_mod(grasp(object(ID,X,Y,Z,O1,O2,O3,O4,Conf), Arm, Status),
[


	[
  		id ==> is,	
  		type ==> neutral, 
  		arcs ==> [
	    			empty : empty => decidearmpos(Arm)
	   ]
	],
	[
  		id ==> decidearmpos(left),	
  		type ==> neutral, 
  		arcs ==> [
	    			empty : empty => is_act([-0.05,0.22,0.2248])
	   ]
	],
	[
  		id ==> decidearmpos(right),	
  		type ==> neutral, 
  		arcs ==> [
	    			empty : empty => is_act([0.21,0.22,0.2248])
	   ]
	],

	[
  		id ==> is_act(ArmPos),	
  		type ==> neutral, 
  		arcs ==> [
	    			empty : [
	    			            get(last_tilt,Tilt),
	    			            get(last_height,RobotHeight),
	    			            % cam2arm(Arm,RobotHeight,[X,Y,Z],[Tilt,0.04,-0.06],ArmPos,[Height,Angle,Distance]),
	    			            cam2arm(Arm,RobotHeight,[X,Y,Z],[Tilt,0.11,0.10],ArmPos,[Height,Angle,Distance]),
	    			            %say(['Height: ',Height,', Angle: ',Angle,', Distance: ',Distance]),
	    			            %cam2arm(Arm,RobotHeight,[X,Y,Z],[Tilt,0.045,-0.06],[0,0.70,0.154],[Height,Angle,Distance]),	
					    say(['Attempting to grab the ',ID,' with my ', Arm,' arm']),
					    switcharm( apply(get_number_of_arm(A), [Arm])  ),
					    robotheight(Height),
					    set(last_height,Height),
					    assign(Offset_leftarm,apply(when(_,_,_),[Arm==left,0.019,-0.025])),
					    NewDistance is Distance+Offset_leftarm,
					    assign(Offset_angle,apply(when(_,_,_),[Arm==left,5.5,1.0])),
					    NewAngle is Angle + Offset_angle,
					    grasp(NewAngle,NewDistance,Result),
					    switcharm(0)
					        ] => check_grasped(Result)
	   ]
	],

    	[
     		id ==> check_grasped(success),	
      		type ==> neutral,
      		arcs ==> [
        		empty : say(['I took the ',ID])=> success
      		]
    	],

        [
     		id ==> check_grasped(error),	
      		type ==> neutral,
      		arcs ==> [
        		empty : say(['Sorry, I didnt take the ',ID]) => error
      		]
    	],

    	[
	      	id ==> success,
      		type ==> final,
      		diag_mod ==> grasp(_, _, ok) 
    	],
	
	    [
      		id ==> error,
      		type ==> final,
      		diag_mod ==> grasp(_, _, not_grasped)
    	]

  ],

  % Second argument: list of local variables
  [
  ]

).
