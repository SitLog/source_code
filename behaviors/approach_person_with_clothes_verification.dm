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

diag_mod(approach_person_with_clothes_verification(Mode, Final_Position, Status), 
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
		    embedded_dm ==> detect_body(nearest,0,Body_Positions,Detect_Status),
		    out_arg ==> [Body_Positions],
      		arcs ==> [
        			success : empty => decide_point_to_move(Body_Positions),
        			error : empty => check_status(lost_person)			
      			]
        ],
        
%       [  
%      		id ==> mode(body),
%      		type ==> recursive,
%		    embedded_dm ==> recognize_body(nearest,0,james,Body_Positions,Detect_Status),
%      		arcs ==> [
%        			success : empty => decide_point_to_move(Body_Positions),
%        			error : empty => mode(body)				
%      			]
%       ],
        
   	
    	% Given the position of the person in cylindrical coordinates, decides the correct point to approach
		[
		 id ==> decide_point_to_move([person(ID,R,O,W)|Rest]),
		 type ==> neutral,
		 arcs ==> [		
					empty : empty => apply( decide_position_to_approach_clothe_strategy(Rval,Oval) , [R,O] ) 
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
