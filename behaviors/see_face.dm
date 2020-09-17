% See Face Task Dialogue Model
%
% 	Description	The robot sees a face in its current field of view
%	
%	Arguments	
%           Name:	Label which will be used as an identificator for the learned/sought person. If is a variable in mode 'recognize',
%               it will search for any person in the scene and retrieve its label if the person is known, or 'unknown' if the person is %               not in the database. 
%
%			Modes: 	
%               detect .- the robot detects a face
%				memorize .- the robot detects and memorize a face
%				recognize .- the robot detects and recognize a face
%
%           Face_position: A list [h_1,h_2,...,h_n] where each h_i is a functor coord3(x,z,y) with the cartesian coordinate
%               of the detected face (in meters) arranged from the nearest to the farthest
%				
%			Status:	
%				ok .- if a face was correctly detected/memorized/recognized or someone has found when searching for anybody
%				not_detected .- if the detection of a face failed
%				lost_user .- if the face dissapears during the learning/recognition process
%				not_found .- the sought person wasn't found
%		       	camera_error .- if there is a problem with the camera 


diag_mod(see_face(Name, Mode, Face_position, Status), 

[
		
		%Detect Face in all cases
		[
		 id ==> is,
		 type ==> recursive,
		 out_arg ==> [_, Face_Pos, Face_Status],
	 	 embedded_dm ==> detect_face(Face_Pos, Face_Status),
		 arcs ==> [		
					success:empty => see_face(Mode, Face_Pos),
					error:empty => error
			  	    ]
		],		

		[
		 id ==> see_face(detect, Face_Pos),
		 type ==> neutral,
		 arcs ==> [		
					empty:empty => success
				  ]
		],

		[
		 id ==> see_face(memorize, [Face_Pos]),
		 type ==> recursive,
	 	 out_arg ==> [Name, Face_Pos, Face_Status],
		 embedded_dm ==> memorize_face(Face_Pos,Name,Face_Status),
		 arcs ==> [		
					success:empty => success,
					error:empty => error
				    ]
		 ],

		[
		 id ==> see_face(recognize, [Face_Pos]),
		 type ==> recursive,
	 	 out_arg ==> [Name, Face_Pos, Face_Status],
		 embedded_dm ==> recognize_face(Face_Pos,Name,Face_Status),
		 arcs ==> [		
					success:empty => success,
					error:empty => error
				    ]
		 ],

	
		% Final Situations

		[
		 id ==> success, 
		 type ==> final,
		 in_arg ==> [Name, Face_Pos, Face_Status],
		 diag_mod ==> see_face(Name, _, Face_Pos, Face_Status)
		],

		[
         id ==> error, 
		 type ==> final,
		 in_arg ==> [Name, Face_Pos, Face_Status],
		 diag_mod ==> see_face(Name, _, Face_Pos, Face_Status)
		]

	    ], 

	% List of Local Variables
	[]

   ). 



























