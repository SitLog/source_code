%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%							%
%	Receptionist, Robocup@home 2020			%
%							%
%-------------------------------------------------------%
%							%
%	Dennis Mendoza, Arturo Rodriguez		%
%							%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diag_mod(receptionist_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [  apply(initialize_KB,[]),
        	get(count,Count)
        	] => move_to_door(Count)
      ]
    ],
    [ % All guests have a seat, task finished
      		id ==> move_to_door(2),
      		type ==> recursive,
		embedded_dm ==> move(welcome_point,Status),
      		arcs ==> [
        			success : [say('Finished task')] => fs,
        			error : [say('I could not arrive to the door')] => move_to_door(2) 
      			]
    ],
    [ % Some guests do not have a seat yet
      		id ==> move_to_door(Count),
      		type ==> recursive,
		embedded_dm ==> move(welcome_point,Status),
      		arcs ==> [
        			success : [tiltv(-10.0), set(last_tilt,-10.0)] => is_door_opened,
        			error : [say('I could not arrive to the door')] => move_to_door(Count) 
      			]
    ],
    [ % Check if the door is opened 
      		id ==> is_door_opened,
      		type ==> recursive,
      		embedded_dm ==> detect_door(Status),
      		arcs ==> [
        			success : [say('Please stand in front of me')] => detect_new_guest,
        			error : [say('The door is closed, open the door please')] => is_door_opened
        		]
    ],
    [ % Detect if there is a person in front of the robot
		id ==> detect_new_guest,
		type ==> detect_face_cognitive(detect),
			arcs ==> [		
				faceId(X) : [say(['Welcome to our party']) ] => ask_name,
				faceId('no detected') : say('I cannot see you, please stand in front of me') => detect_new_guest
		  ]
    ],
    [ % Ask name
      		id ==> ask_name,
      		type ==> recursive,
      	        embedded_dm ==> ask('Please, tell me your name',human,true,2,Name,Status),      		
      		arcs ==> [
        			success : [ say('Wait a moment, let me see your face') , apply(recepcionist_name_new_guest(N),[Name]) ] => memorize_new_guest(Name),
        			error : [say('I did not understood. Could you repeat it')] => ask_name
				
      			]
    ],
    [ % Memorize face
		id ==> memorize_new_guest(Name),
		type ==> detect_face_cognitive(detect),
		arcs ==> [		
				faceId(X) : apply(recepcionist_save_id_new_guest(N1,X1),[Name,X]) => ask_favorite_drink,
				faceId('no detected') : say('I cannot see you, please stand in front of me') => detect_new_guest
		  ]
    ],
    [ % Ask favorite drink
      		id ==> ask_favorite_drink,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, tell me your favorite drink',drinks,true,2,Drink,Status),      		
      		arcs ==> [
        			success : [ apply(recepcionist_drink_new_guest(D),[Drink]), say('Please follow me to introduce you with the other guests in the living room') ] => move_to_living_room,
        			error : [say('I did not understood. Could you repeat it')] => ask_favorite_drink
				
      			]
    ],
    [ % Go to the living room
		id ==> move_to_living_room,
		type ==> recursive,
		embedded_dm ==> move(lv2,Status),
		arcs ==> [		
				success : [say('This is the living room. Please stand on my right.'),sleep,turn(90.0,Result)] => find_new_guest( apply(recepcionist_get_name_new_guest,[])),
				error : empty => move_to_living_room
		  ]
    ],
    [ % Detect new guest
		 id ==> find_new_guest([NewGuest,NewGuestId]),
		 type ==> identify_face_cognitive(identify,NewGuestId),
		 arcs ==> [		
					identified_face(A,B,C,D,E) : 
						[
						say(['I identified ', NewGuest]), 
						apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[C,D,E,R,O])] 
						=> point(NewGuest),
					status(Status) : [say('I did not see you. Please stand in front of me.')] => find_new_guest([NewGuest,NewGuestId])
    			]
    ],
    [ % Point new guest
      		id ==> point(NewGuest),
      		type ==> recursive,
		embedded_dm ==> point(right, Status),
		arcs ==> [
        			success : [ get(chair_list,ChairList),apply(recepcionist_introduce_guest(X1),[NewGuest])] 
        				=> verify_chair(ChairList),
        			error : [say('I did not point it')] => point(NewGuest)				
      			]
    ],
    [% move to a chair 
      		id ==> verify_chair([Chair|Rest]),
      		type ==> recursive,
      		embedded_dm ==> move(Chair,Status),
		arcs ==> [
        			success : empty => search_free_seats([Chair|Rest]),
        			error : empty => verify_chair([Chair|Rest]) 				
      			]
    ],
    [% if all the chairs are occupied
		id ==> search_free_seats([]),	
		type ==> neutral,
	        arcs ==> [
			 empty   :	say('I am sorry we do not have seats left. Make yourself at home.') => move_to_door
		         ]
    ],
    [% verify if the chair is empty
		id ==> search_free_seats([Chair|Rest]),	
		type ==> recursive,
	        embedded_dm ==> detect_body(nearest,3,Body_Positions,Detect_Status),
		arcs ==> [
			 success : 	empty => verify_chair(Rest),
			 error   :	[say('Looks like the seat in front of me is empty, please take a seat'),inc(count,Count1)
			 ] => move_to_door(Count1)
		         ]
    ],
    
    [ % final situation
      id ==> fs,
      type ==> final
    ]
  ],

  % Second argument: list of local variables
  [
  ]

).	

