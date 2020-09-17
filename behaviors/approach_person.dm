% Approach Person Task Dialogue Model
%
% 	Description	The robot approachs to a person. When the robot is near the person, verifies if the person is still in the same position.
%	
%	Arguments	
%           Mode: 
%               face
%               head
%               body
%
%           Initial position: A list [x,y,z] with the position of the person in relation with the initial position of the robot 
%               (in meters)	
%
%			Final position: A list [x,y,z] with the position of the person in relation with the final position of the robot (in meters)	
%
%			Status:	
%				ok .- if the robot is near the person
%			    not_detected .- if after approaching there is nobody near
%				navigation_error.- if the robot could not approach correctly to the user

diag_mod(approach_person(Mode, Final_Position, Status), 
[

        % Verify mode
		[
		    id ==> is,
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => mode(Mode)
			         ]
		],

        % Mode BODY
        [  
      		id ==> mode(body),
      		type ==> recursive,
		    embedded_dm ==> detect_body(nearest,3,Body_Positions,Detect_Status),
		    out_arg ==> [Body_Positions],
      		arcs ==> [
        			success : empty => decide_point_to_move(Body_Positions),
        			%error : empty => check_status(lost_person)
        			error : empty => error			
      			]
        ],
    	
    	% Given the position of the person in cylindrical coordinates, decides the correct point to approach
		[
		 id ==> decide_point_to_move([person(ID,R,O,W)|Rest]),
		 type ==> neutral,
		 arcs ==> [		
					empty : empty => apply( decide_position_to_approach(Rval,Oval) , [R,O] ) 
			  ]
		],  
		
		% Turn and advance in direction to the detected person
		[  
      		 id ==> move_to_body(Distance,Angle),
      		 type ==> recursive,
      		 embedded_dm ==> move([turn=>(Angle),displace=>(Distance)],Status_move),
      		 arcs ==> [
        			success : empty => mode(body),
        			error : empty => check_status(Status_move)				
      			  ]
    	],      
		
		%Mode HEAD
		
		% Convert from cartesian coordinates to cylindrical coordinates the position of the person
		[
		 id ==> mode(head),
		 type ==> neutral,
		 arcs ==> [		
					empty : [ 
						apply( convert_cartesian_to_cylindrical(Xval,Yval,Zval,Rval,Oval) , [X,Y,Z,R,O] )
						] => decide_point(R,O,Z)
			  ]

		],
		 
		% Given the position of the person in cylindrical coordinates, decides the correct point to approach
		[
		 id ==> decide_point(R,O,Z),
		 type ==> neutral,
		 arcs ==> [		
					empty : [ 
						apply( decide_position_to_approach(Rval,Oval,Zval,Aval,Tval) , [R,O,Z,Distance,Angle] )
						] => move(Distance,Angle)
			  ]
		],
		
		% Turn and advance in direction to the detected person
		[  
      		 id ==> move(Distance,Angle),
      		 type ==> recursive,
      		 embedded_dm ==> move([turn=>(Angle),displace=>(Distance)],Status_move),
      		 arcs ==> [
        			success : empty => detect_again(Mode),
        			error : empty => check_status(Status_move)				
      			  ]
    	],
    	
    	% Verify again the position of the person in the mode HEAD
        [  
      		 id ==> detect_again(head),
      		 type ==> recursive,
	         out_arg ==> [NewPosition],
      		 embedded_dm ==> detect_head(NewPosition,Status_detect_head),
      		 arcs ==> [
        			success : empty => verify_new_position(NewPosition),
        			error : empty => check_status(Status_detect_head)				
      			  ]
    	],
    		
    	%Verify if the detected person is still near the position where was originally detected
    	[
		    id ==> verify_new_position([NewX,NewY,NewZ]),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => check_status( apply(verify_if_the_person_is_near(Xval,Yval,Zval,Nval),[NewX,NewY,NewZ,2]) )
			        ]

		],
       
		% Check status 
		[
		 id ==> check_status(ok),
		 type ==> neutral,
		 in_arg ==> [NewPosition],
		 arcs ==> [		
					empty : empty => success
			  ],

		 diag_mod ==> approach_person(_, NewPosition, ok)

		 ],
		 
		[
		 id ==> check_status(Error),
		 type ==> neutral,
		 arcs ==> [		
					empty : empty => error
				    ],
		 diag_mod ==> approach_person(_, _, Error)
		 ],


		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
