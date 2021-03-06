% Find Task Dialogue Model
%
% 	Description	The robot search a person, an object or a gesture in a set of places. In each place, the robot performs a set of 
%			observations changing the horizontal angle of its neck. Each horizontal orientation includes a set 
%			of tilts (changing the vertical angle of its neck). The robot finishes if in a specific observation 
%			the sought person or object is found.
%			
%	
%	Arguments	Kind: 	person
%				object
%				gesture		
%
%			Sought:  
%				for persons: Label which will be used as an identificator for the learned/sought person. If is a variable in %					mode 'recognize' or 'recognize_with_approach', it will search for any person in the scene and retrieve %					its label if the person is known, or 'unknown' if the person is not in the database. 		
%				for objects: List of sought objects or label corresponding to a category of sought objects. If is a variable, %					it will search any known objects in the scene.
%				for gesture: Label of the sought gesture, which can be: 
%					waving .- the person is waving both hands over his/her head 
%					pointing .- the person is pointing with one of his/her hands
%					hand_up .- the person is handing up one of his/her hands
%					If is a variable, it will search for any known gesture 
%
%			Places: List of positions of the topological map [ Point_1, Point_2, ... , Point_n ]
%
%
%			Orientations: List of horizontal angles [ Angle_h1, Angle_h2, ... , Angle_hn ]
%
%
%			Tilts: List of vertical angles [ Angle_v1 , Angle_v2 , ... , Angle_vn ] 
%
%			Modes:  
%				for persons can be:
%					detect .- the robot detects a head
%					memorize .- the robot detects a head and memorize the face
%					recognize .- the robot detects a head and recognize the face
%					detect_with_approach.- the robot detects a head, approach to it and detects the face to verify 
%					memorize_with_approach.-  the robot detects a head, approach to it, detects the face to verify and %						memorize the face
%					recognize_with_approach.-  the robot detects a head, approach to it, detects the face to verify and %						recognize the face
%				for objects can be:
%					object .- search objects listed in the argument 'Sought' 
%					category .- search objects belonging to the category indicated in the argument 'Sought'
%				for gesture can be:
%					an integer number which corresponds to the duration of the observation (in seconds)
%
%			Found_Objects: 	
%				for objects: List of objects [ Object_1 , Object_2 , ... , Object_n ] where each object  
%					is a functor which includes the ID and eight parameters about its position and orientation
%					object(id,p1,p2,p3,p4,p5,p6,p7,p8)
%				for gestures: A list [x,y,z,v] where x,y and z are the cartesian coordinates of the nearest person doing the %					gesture (in meters), and v is a value used for some gestures (for pointing gives the direction angle %					in grades in which the user is pointing)
%
%			Remaining_Positions: List of the positions not explored because the object or face was found
%					[ Point_1, Point_2, ... , Point_n ]
%
%			Scan_First: Boolean flag. When is 'true', the robot will perform an initial set of observations in the current %					position and then will proceed with the observations listed in 'Places'. When is 'false', the first %					set of observation is in the first point of 'Places'. 
%
%			Tilt_First: Boolean flag for controlling the set of horizontal observations. When is 'true', the robot will perform an %					initial set of vertical observations in the current horizontal orientation of the neck and then will %					proceed with the set of horizontal observations listed in 'Tilts'. When is 'false', the first set of %					vertical observation is the one listed in 'Tilts'. 
%
%			See_First: Boolean flag for controlling the set of vertical observations. When is 'true', the robot will perform an %					initial observation in the current vertical orientation of the neck and then will proceed with the %					list of observations listed in 'Orientations'.When is 'false', the first observation is the one listed %					in 'Orientations'. 
%				 
%			Status:	
%				ok .- if a face was correctly detected/memorized/recognized, someone has found when searching for anybody, at %					least one of the objects sought was found or a person doing the gesture was found
%				not_detected .- if the detection of a face or a gesture failed
%				lost_user .- if the face dissapears during the learning/recognition process
%				not_found .- the sought person wasn't found or the sought objects weren't found
%			       	camera_error .- if there is a problem with the camera
%				empty_scene .- if the robot is searching for any known objects but nothing was found


diag_mod(find_nonblock(Kind, Entity, Places, Orientations, Tilts, Mode, Found_Objects, Remaining_Positions, Scan_First, Tilt_First, See_First, Status),
	    
	   
	    [
		

		[
		 id ==> is,
		 type ==> neutral,
		 arcs ==> [		% Verify Scan_First and get values for the list of positions
					empty:empty => scan_first(Tilt_First,Places)
			  ]
		],

		[
		 id ==> scan_first(true,Positions),
		 type ==> recursive,
		 out_arg ==> [Entity, Found_Objects, Positions, Scan_Status],
		 embedded_dm ==> scan(Kind, Entity, Orientations, Tilts, Mode, Found_Objects, Tilt_First, See_First, Scan_Status),
		 arcs ==> [		% Scan task result
					success:empty => success,
					error:empty => scan_first(false,Positions)
			  ]

		], 
	
		[  
      		 id ==> scan_first(false,[FirstPosition|RestPositions]),
      		 type ==> recursive,
		 out_arg ==> [Entity, _, RestPositions, Status_Move],
		 embedded_dm ==> move_nonblock(FirstPosition,Status_Move),
      		 arcs ==> [
				% keep this [set(find_currpos, FirstPosition)]
        			success : [set(moving_pos, FirstPosition)] => check_for_call(RestPositions),
        			error : empty => error
				
      			]
    		],
				
		% Checks whether a customer calls at a distance
		[
		 id ==> check_for_call(Positions),
		 type ==> recursive,		 
		 embedded_dm ==> doas(all,DOAS,StatusDOAS),			 
		 arcs ==> [	
				empty:empty => there_are_calls(DOAS, StatusDOAS, Positions)
			  ]
		],
	
		% Checks whether a customer calls at a distance
		[
		 id ==> there_are_calls([],_,Positions),
		
		 type ==> neutral,		 
		
		 arcs ==> [	
				empty:empty => nav_status(Positions)
			  ]
		],
	
		% Checks whether a customer calls at a distance
		[
		 id ==> there_are_calls(_,error,Positions),
		
		 type ==> neutral,		 
		
		 arcs ==> [	
				empty:empty => nav_status(Positions)
			  ]
		],
		
		% Checks whether a customer calls at a distance
		[
		 id ==> there_are_calls(DOAS,StatusDOAS,Positions),
		
		 type ==> neutral,		 
		
		 arcs ==> [	
				empty: empty => confirm_customers(apply(valid_customer_angles(D), [DOAS]), Positions)
			  ]
		],

                [
		 id ==> confirm_customers([], Positions),
		
		 type ==> neutral,		 
		
		 arcs ==> [	
				empty: empty => nav_status(Positions)
			  ]

		],

                [
		 id ==> confirm_customers(CustomerAngle, Positions),
		
		 type ==> neutral,		 
		
		 arcs ==> [	
				empty: [navigate_abort, turn(CustomerAngle, Result)] => check_gesture(Positions)
			  ]

		],

		[  
      		 id ==> check_gesture(Positions),

      		 type ==> recursive,


		 embedded_dm ==> see_gesture(hand_up,nearest, 5, BodyParams, Status_Move),

      		 arcs ==> [
        			success : [say('Ill be there in a minute'), get(moving_pos,MovingPos), apply(add_location_to_visit())] => continue_moving(Positions, MovingPos),
        			error : get(moving_pos,MovingPos) => continue_moving(Positions, MovingPos)
			  ]
    		],

		[  
      		 id ==> continue_moving(Positions, MovingPos),

      		 type ==> recursive,

		 out_arg ==> [Entity, _, Positions, Status_Move],

		 embedded_dm ==> move_nonblock(MovingPos,Status_Move),

      		 arcs ==> [
        			success : empty => check_for_call(Positions),
        			error : empty => error
			  ]
    		],

        	[
                 id ==> nav_status(Positions),
                 type ==> navigate_status,
                 arcs ==> [
                                active: empty => there_are_calls(Positions),
                                ok: [switchpose('grasp'),say('i arrived')] => scan(Positions,ok),
                                inactive: [switchpose('grasp'),say('i am inactive')] => scan(Positions,navigation_error),
                                error: [switchpose('grasp'),say('something went wrong')] => scan(Positions,navigation_error)
                          ]
                ],			  

		% Error when moving to current position (when the move_brak has been implemented, for GPSR questions type 3)
		[
		 id ==> scan(Positions, navigation_error),
		 type ==> neutral,		 
		 out_arg ==> [_, _, Positions, navigation_error],		 
		 arcs ==> [	
				empty:empty => error
			  ]
		],
		

		% scan situation: already in the scan position
		[
		 id ==> scan(Positions,ok),
		 type ==> recursive,
		 out_arg ==> [Entity, Scan_Parameters, Positions, Scan_Status],
		 embedded_dm ==> scan(Kind, Entity, Orientations, Tilts, Mode, Scan_Parameters, Tilt_First, See_First, Scan_Status),
		 arcs ==> [		% Scan task result
					success:empty => success,
					error:empty => search(Positions)
			  ]

		], 

		% Search situation: no more search points
		[
		 id ==> search([]),
		 type ==> neutral,

		 arcs ==> [		% Select list of positions of place
					empty:empty => error
			  ]

		], 

		% Search situation: move to search point and scan
		[  
      		 id ==> search([Next_Position|Rest_Positions]),
      		 type ==> recursive,
		 out_arg ==> [Entity, _, Rest_Positions, Status_Move],
		 embedded_dm ==> move(Next_Position,Status_Move),
      		 arcs ==> [
        			success : [set(find_currpos, Next_Position)] => scan(Rest_Positions,Status_Move),
        			error : empty => error
				
      			]
    		],

		% Final Situation (Success)
		[
		 	id ==> success, 
			type ==> final,
		 	in_arg ==> [Entity, Found_Objects, Positions, Final_Status],
		 	diag_mod ==> find(_, Entity, _, _, _, _, Found_Objects, Positions, _, _, _, Final_Status)
		],

	         % Final Situation (Error)
		[
		 	id ==> error, 
			type ==> final,
		 	in_arg ==> [Entity, Found_Objects, Positions, Final_Status],
		 	diag_mod ==> find(_, _, _, _, _, _, _, Positions, _, _, _, Final_Status)
		]
	   
	    
	    ], 

	% List of Local Variables
	[
	moving_pos ==> _
	]

   ). 
