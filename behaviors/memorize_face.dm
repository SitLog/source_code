% Memorize Face Task Dialogue Model
%
% 	Description	The robot memorizes a face in its current field of view
%	
%	Arguments	
%           
%           Face_position: A functor coord3(x,z,y) with the cartesian coordinate of the detected face (in meters) 	
%
%           Name:	Label which will be used as an identificator for the learned person 
%				
%			Status:	
%				ok .- if a person was memorized 
%			    camera_error .- if there is a problem with the camera
%				lost_user .- if the user dissapears during the learning process

diag_mod(memorize_face(Face_position,Name,Status), 
[
		% Detect face
		[
		 id ==> memorize,
		 type ==> neutral,
		 arcs ==> [	
					% action memorize face can return as Status: ok, camera_error and lost_user
					empty : memorize_face(Face_position,Name,Status) => check_status(Status)
			  ]
		 ],


		% Check status memorize
		[
		 id ==> check_status(memorized),
		 type ==> neutral,
		 arcs ==> [		
					empty : empty => success
			  ],

		 diag_mod ==> memorize_face(Face_position,Name,ok)

		 ],

		[
		 id ==> check_status(Error_Status),
		 type ==> neutral,

		 arcs ==> [		
					empty : empty => error
		          ],

		 diag_mod ==> memorize_face(Face_position,Name,Error_Status)

		 ],

		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
