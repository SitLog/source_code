% Scan Task Dialogue Model
%
% 	Description	In its current position, the robot search a person, an object or a gesture, performing a set of observations
%			changing the horizontal angle of its neck. Each horizontal orientation, includes a set of tilts
%                       (changing the vertical angle of its neck). The robot finishes if in a specific observation the 
%			sought person or object is found.
%			
%	
%	Arguments	Kind: 	person
%				object
%				gesture
%                               plane
%
%			Sought:  
%				for persons: Label which will be used as an identificator for the learned/sought person. If is a variable in %					mode 'recognize' or 'recognize_with_approach', it will search for any person in the scene and retrieve %					its label if the person is known, or 'unknown' if the person is not in the %					database
%				for objects: List of sought objects or label corresponding to a category of sought objects. If is a variable, %					it will search any known objects in the scene. 
%				for gesture: Label of the sought gesture, which can be: 
%					waving .- the person is waving both hands over his/her head 
%					pointing .- the person is pointing with one of his/her hands
%					hand_up .- the person is handing up one of his/her hands
%					If is a variable, it will search for any known gesture
%                               for plane: not applicable
%
%			Orientations: List of horizontal angles [ Angle_h1, Angle_h2, ... , Angle_hn ]
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
%                               for plane: 
%                                       moped: moped is used to recognize any object on the table, thus the table is detected
%                                       kinect: kinect is used to detect the table
%
%			Found_Objects: 	
%				for objects:  List of objects [ Object_1 , Object_2 , ... , Object_n ] where each object  
%					is a functor which includes the ID and eight parameters about its position and orientation
%					object(id,p1,p2,p3,p4,p5,p6,p7,p8)
%				for gestures: A list [x,y,z,v] where x,y and z are the cartesian coordinates of the nearest person doing the %					gesture (in meters), and v is a value used for some gestures (for pointing gives the direction angle %					in grades in which the user is pointing)
%                               for plane: Lists of planes [Plane_1, Plane_2, ..., Plane_n] where each plane is of the form plane(X,Y,Z,Angle)
%
%			Tilt_First: Boolean flag. When is 'true', the robot will perform an initial set of vertical observations in the %					current horizontal orientation of the neck and	then will proceed with the set of horizontal %					observations listed in 'Tilts'. When is 'false', the first set of vertical observation is the one %					listed in 'Tilts'. 
%
%			See_First: Boolean flag for controlling the set of vertical observations. When is 'true', the robot will perform an %					initial observation in the current vertical orientation of the neck and then will proceed with the %					list of observations listed in 'Orientations'.
%					When is 'false', the first observation is the one listed in 'Orientations'. 
%				 
%			Status:	
%				ok .- if a face was correctly detected/memorized/recognized, someone has found when searching for anybody, at %				      least one of the objects sought was found or a person doing the gesture was found
%				not_detected .- if the detection of a face or a gesture failed
%				lost_user .- if the face dissapears during the learning/recognition process
%				not_found .- the sought person wasn't found or the sought objects weren't found
%			       	camera_error .- if there is a problem with the camera
%				empty_scene .- if the robot is searching for any known objects or plane but nothing was found



diag_mod(scan(Kind, Sought, [First_Scan|Rest_Scans], Tilts, Mode, Found_Objects, Tilt_First, See_First, Status), 
[
  
		[
		 id ==> is,
		 type ==> neutral,
		 arcs ==> [		% Verify Tilt_First 
			   empty:empty => tilt_first(Tilt_First)
                          ]
		],
		
                % Before a scan move, Golem makes a search
   		[
      	         id ==> tilt_first(true),
      	         type ==> recursive,
      	         out_arg ==> [Sought, Found_Objects, Tilt_Status],
		 embedded_dm ==> tilt(Kind, Sought, Tilts, Mode, Found_Objects, See_First, Tilt_Status),
      	         arcs ==> [		
            	           success:empty => success,
       			   error:empty => tilt_first(false)
      		          ]
                ],

                % Golem makes a scan (horizontal) move
		[
		 id ==> tilt_first(false),
		 type ==> neutral,
		 arcs ==> [		
			   empty:[tilth(First_Scan), set(last_scan,First_Scan)] => tilt(Rest_Scans)
			  ]
		],

   
                % see situation: already in the scan orientation
                [
                 id ==> tilt(Rest_Scans),
                 type ==> recursive,
                 out_arg ==> [Sought, Found_Objects, Tilt_Status],
                 embedded_dm ==> tilt(Kind, Sought, Tilts, Mode, Found_Objects, See_First, Tilt_Status),
                 arcs ==> [		
                           success:empty => success,
                           error:empty => search(Rest_Scans)
                          ]
                ],
   
                % Search situation: no more search orientations
                [
                 id ==> search([]),
                 type ==> neutral,
                 arcs ==> [		
                           % No more orientation to scan
                           empty:[get(basev, Basev), tiltv(Basev), set(last_tilt, Basev), get(baseh, Baseh), tilth(Baseh), set(last_scan,Baseh)] 
                                => error
                          ]
                ],
   
                % Search situation: move to next scan position and see again
                [
                 id ==> search([Next_Orientation|Rest_Orientations]),
                 type ==> neutral,
                 arcs ==> [		
                           % rotate neck and see again!
                           empty:[tilth(Next_Orientation), set(last_scan,Next_Orientation)] 
                                => tilt(Rest_Orientations)
                          ]
                ],
   
                % Final situations
                [
                 id ==> success, 
                 type ==> final,
                 in_arg ==> [Sought, Found_Objects, Tilt_Status],
                 diag_mod ==> scan(_, Sought, _, _, _, Found_Objects, _, _, Tilt_Status)	
                ],
   
                [
                 id ==> error, 
                 type ==> final,
                 in_arg ==> [Sought, Found_Objects, Tilt_Status],
                 diag_mod ==> scan(_, Sought, _, _, _, Found_Objects, _, _, Tilt_Status)
                ]
  ], 
	 
  % List of Local Variables
  [baseh ==> 0.0, basev ==> 0.0]
). 















