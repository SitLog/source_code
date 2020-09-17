% See Task Dialogue Model
%
% 	Description	The robot sees a person, an object or a gesture in its current field of view
%	
%	Arguments	Kind: 	person
%				object
%				gesture
%                               plane
%
%			Sought:  
%				for persons: Label which will be used as an identificator for the learned/sought person. If is a variable in
%					mode 'recognize' or 'recognize_with_approach', it will search for any person in the scene and 
%					retrieve its label if the person is known, or 'unknown' if the person is not in the database.
%				for objects: List of sought objects or label corresponding to a category of sought objects. If is a variable, %					it will search any known objects in the scene.
%				for gesture: Label of the sought gesture, which can be: 
%					waving .- the person is waving both hands over his/her head 
%					pointing .- the person is pointing with one of his/her hands
%					hand_up .- the person is handing up one of his/her hands
%					If is a variable, it will search for any known gesture %
%                               for plane: not applicable
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
%                               for plane: 
%                                       moped: moped is used to recognize any object on the table, thus the table is detected
%                                       kinect: kinect is used to detect the table
%
%			Found_Objects: 	
%				for objects: List of objects [ Object_1 , Object_2 , ... , Object_n ] where each object  
%					is a functor which includes the ID and eight parameters about its position and orientation
%					object(id,p1,p2,p3,p4,p5,p6,p7,p8)
%				for gestures: A list [x,y,z,v] where x,y and z are the cartesian coordinates of the nearest person doing the %					gesture (in meters), and v is a value used for some gestures (for pointing gives the direction angle %					in grades in which the user is pointing)
%                               for plane: Lists of planes [Plane_1, Plane_2, ..., Plane_n] where each plane is of the form plane(X,Y,Z,Angle)
%				 
%			Status:	
%				ok .- if a face was correctly detected/memorized/recognized, someone has found when searching for anybody, at %					least one of the objects sought was found, a person doing the gesture was found or at least one plane 
%                                       was detected
%				not_detected .- if the detection of a face or a gesture failed
%				lost_user .- if the face dissapears during the learning/recognition process
%				not_found .- the sought person wasn't found or the sought objects weren't found
%			       	camera_error .- if there is a problem with the camera
%				empty_scene .- if the robot is searching for any known objects or planes but nothing was found
%                               


diag_mod(see(Kind, Sought, Mode, Found_Objects, Status), 
	    
	  
	    [
		
		[
		 id ==> is,
		 type ==> neutral,

		 arcs ==> [		% Check Kind (object, person or gesture)
					empty:empy => see(Kind)
				    ]
		 ],


		[
		 id ==> see(person),
		 type ==> recursive,
	 	 out_arg ==> [Sought, Found_Persons, See_Status],
		 embedded_dm ==> see_person(Sought, Mode, Found_Persons, See_Status),
		 arcs ==> [		
					success:empty => success,
					error:empty => error
				    ]
		],
				
		[
		 id ==> see(object),
		 type ==> recursive,
 		 out_arg ==> [Sought, Found_Objects, See_Status],
		 embedded_dm ==> see_object(Sought, Mode, Found_Objects, See_Status),
		 arcs ==> [		
					success:empty => success,
					error:empty => error
				    ]
		],

		[
		 id ==> see(gesture),
		 type ==> recursive,
 		 out_arg ==> [Sought, Gesture_Value, See_Status],
		 embedded_dm ==> see_gesture(Sought, Mode, Gesture_Value, See_Status),
		 arcs ==> [		
                           success:empty => success,
                           error:empty => error
                          ]
		 
		 ],
		 
		 [
		  id ==> see(plane),
		  type ==> recursive,
		  out_arg ==> [_, Found_Planes, Plane_Status],
		  embedded_dm ==> plane_detection(Found_Planes, Mode, Plane_Status),
		  arcs ==> [
		            success:empty => success,
		            error  :empty => error
		           ]
		 ],


		% Final Situations

		[
		 id ==> success, 
		 type ==> final,
		 in_arg ==> [Sought, Found_Objects, See_Status],
		 diag_mod ==> see(_, Sought, _, Found_Objects, See_Status)
		],

		[
		 id ==> error, 
		 type ==> final,
		 in_arg ==> [Sought, Found_Objects, See_Status],
		 diag_mod ==> see(_, Sought, _, Found_Objects, See_Status)
		]

	    ], 

	% List of Local Variables
	[]

   ).















