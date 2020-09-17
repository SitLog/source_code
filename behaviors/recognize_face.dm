% Recognize Face Task Dialogue Model
%
% 	Description	The robot recognize a face in its current field of view
%	
%	Arguments	
%            
%           Face_position: A functor coord3(x,z,y) with the cartesian coordinate of the detected face (in meters) 
%	
%           Name:	Label which will be used as an identificator for the sought person. If is a variable, it will search for any person in %                the scene and retrieve its label if the person is known, or 'unknown' if the person is not in the database.   
%				
%			Status:	
%				ok .- the sought person was found or someone has found when searching for anybody
%				not_found .- the sought person wasn't found
%				lost_user .- if the user dissapears during the recognition process
%			       	camera_error .- if there is a problem with the camera


diag_mod(recognize_face(Face_position,Name,Status), 
[
		
		% Recognize face
		[
		 id ==> recognize,
		 type ==> recognize_face,

		 arcs ==> [		
					% User function face_in_scene retrieves three possible status: 'ok', 'not found' or a list including the name of the found person
					name(X) : empty => check_status(ok,X),
					name(unknown): empty =>check_status(not_found),
					status(Status) : empty => check_status(Status)
			  ]
		 ],

		% When is searching for any person in the scene, retrieves the name of the person recognized
		[
		 id ==> check_status([X]),
		 type ==> neutral,

		 arcs ==> [		
					empty : empty => success
			  ],

		 diag_mod ==> recognize_face(Face_position,X,ok)

		 ],

		% Check status detect and recognize
		[
		 id ==> check_status(ok,Name),
		 type ==> neutral,

		 arcs ==> [		
					empty : empty => success
			  ],

		 diag_mod ==> recognize_face(Face_position,Name,ok)

		 ],

		[
		 id ==> check_status(Status),
		 type ==> neutral,

		 arcs ==> [		
					empty : empty => error
				    ],

		 diag_mod ==> recognize_face(Face_position,Name,Status)

		 ],

		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
