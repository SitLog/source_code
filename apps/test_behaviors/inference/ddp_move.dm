diag_mod(ddp_move(Location),
[

     [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : empty => apply( ddp_check_if_robot_is_in_place(Loc),[Location] )
                    ]
     ], 


     %Case 1 the robot must move to a place, and when arrives, it search objects in the shelf
     [
            id ==> not_in_place,	
            type ==> neutral,
            arcs ==> [
                    empty : say( apply(ddp_describe_location(L),[Location]) ) => move
                    ]
     ], 
     
     [  
      		id ==> move,
      		type ==> recursive,
			embedded_dm ==> move(Location,Status),
			arcs ==> [
        			success : [say('I arrive'), apply(ddp_actualize_robot_position(NewP),[Location]),  
        			robotheight(1.10),set(last_height,1.10),tiltv(-35.0),set(last_tilt,-35.0) ] => see_shelf,
        			error : [say('I could not arrive')] => move				
      			]
    ],
    
 
     [  
      		id ==> see_shelf,
      		type ==> recursive,
	        embedded_dm ==> see_object(X,object,Found_Objects,_),
       		arcs ==> [
        			success : [say( apply(convert_found_objects_in_dialog(FO),[Found_Objects])  )] 
        			    => apply(update_kb_with_seen_objects(FoundObj,Loc),[Found_Objects,Location]),
        			error : [say('There are not objects in this shelf')] 
        			    => apply(update_kb_with_seen_objects(FoundObj,Loc),[[],Location])
      			]
     ],
     
     %The robot is in the place, so it don't need to move
     [
            id ==> in_place,	
            type ==> neutral,
            arcs ==> [
                    empty : empty => success
                    ]
     ], 
           
     [
            id ==> success,
            type ==> final
     ],
     
     [
            id ==> error,
            type ==> final
     ]
     
  ],

  % Second argument: list of local variables
  [
  
  ]

).	
