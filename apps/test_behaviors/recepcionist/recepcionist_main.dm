diag_mod(recepcionist_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [  apply(initialize_KB,[]),say('Please stand in front of me') ] => detect_new_guest
      ]
    ],
    
    [
		id ==> detect_new_guest,
		type ==> detect_face_cognitive(detect),
		arcs ==> [		
				faceId(X) : [say(['Hello. Welcome to our party']) ] => ask_name,
				faceId('Please stand in front of me') : empty => detect_new_guest
		  ]
    ],
    
    [  
      		id ==> ask_name,
      		type ==> recursive,
      	        embedded_dm ==> ask('Tell me your name after the beep',human,true,2,Name,Status),      		
      		arcs ==> [
        			success : [ say('Wait a moment, let me see your face') , apply(recepcionist_name_new_guest(N),[Name]) ] => memorize_new_guest(Name),
        			error : [say('I did not understood. Could you repeat it')] => fs
				
      			]
     ],

         [
		id ==> memorize_new_guest(Name),
		type ==> detect_face_cognitive(detect),
		arcs ==> [		
				faceId(X) : apply(recepcionist_save_id_new_guest(N1,X1),[Name,X]) => ask_favorite_drink,
				faceId('Please stand in front of me') : empty => detect_new_guest
		  ]
    ],
    

     [  
      		id ==> ask_favorite_drink,
      		type ==> recursive,
      		embedded_dm ==> ask('Tell me your favorite drink after the beep',drinks,true,2,Drink,Status),      		
      		arcs ==> [
        			success : [ apply(recepcionist_drink_new_guest(D),[Drink]), say('Please follow me to introduce you with the other guests') ] => move_to_party_room,
        			error : [say('I did not understood. Could you repeat it')] => fs
				
      			]
     ],
 
     [  
      		id ==> move_to_party_room,
      		type ==> recursive,
		%embedded_dm ==> move(party_room,Status),
		embedded_dm ==> say('I am moving to the party room',Status),
      		arcs ==> [
        			success : [ say('Here is the party') ] => find_new_guest( apply(recepcionist_get_name_new_guest,[]) ),
        			error : [say('I could not arrive to the room. I will try again')] => move_to_party_room				
      			]
    ],
   
    [  
      		id ==> find_new_guest(NewGuest),
      		type ==> recursive,  
      		%embedded_dm ==> find(person, NewGuest, [turn=>(-45.0),turn=>(0.0),turn(45.0)], [0.0], [0.0,-15.0], memorize_face, Found_Persons, Remaining_Positions, false, false, false, Status),
      		embedded_dm ==> say(['I am searching to',NewGuest],Status),
     		arcs ==> [
        			success : [say('I found him')] => point(NewGuest),
        			error : [say('Is not here')] => fs				
      			 ]
    ],

    [  
      		id ==> point(NewGuest),
      		type ==> recursive,
		%embedded_dm ==> point(right, Status),
		embedded_dm ==> say('I am pointing the new guest', Status),
		arcs ==> [
        			success : [ apply(recepcionist_introduce_guest(X1),[NewGuest]) ] 
        				=> verify_chair( apply(recepcionist_reset_chairs,[]) ),
        			error : [say('I did not point it')] => fs				
      			]
    ],
    
    [  
      		id ==> verify_chair([Chair|RestChairs]),
      		type ==> recursive,
		%embedded_dm ==> move(Chair,Status),
		embedded_dm ==> say(['I am moving to the',Chair],Status),
      		arcs ==> [
        			success : empty => verify_chair(RestChairs),
        			error : [say('I could not arrive to the chair')] => verify_chair(RestChairs) 				
      			]
    ],

    [  
      		id ==> verify_chair([]),
      		type ==> recursive,
		embedded_dm ==> say(['I finished exploring all the chairs',Chair],Status),
      		arcs ==> [
        			success : empty => fs,
        			error : empty => fs 				
      			]
    ],
     
    [
      id ==> fs,
      type ==> final
    ]
  ],

  % Second argument: list of local variables
  [
  ]

).	

