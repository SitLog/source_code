diag_mod(ddp_grasp(Object),
[

     [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : [say(['I will grasp the',Object])] => see
                    ]
     ], 
     
     [  
      		id ==> see,
      		type ==> recursive,
		    embedded_dm ==> see_object([Object],object,[SeenObject],Status),
      		arcs ==> [
        			success : empty => grasp(SeenObject,apply(ddp_choose_free_arm,[])),
        			error : empty => see
				
      			]
     ],
    
     [  
      		id ==> grasp(SeenObject,Arm),
      		type ==> recursive,
      		embedded_dm ==> take(SeenObject, Arm, ObjTaken, Status),
      		arcs ==> [
        			success : [apply(ddp_actualize_grasp_event(Obj),[Object]),apply(ddp_actualize_arm_status(X,Y),[Arm,Object])] => success,
        			error : [say('I did not take it. I will try again'),advance_fine(-0.20,TempRes),robotheight(1.10),set(last_height,1.10),tiltv(-35.0),set(last_tilt,-35.0)] => grasp(SeenObject,Arm)				
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
