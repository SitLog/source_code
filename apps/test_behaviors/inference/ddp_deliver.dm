diag_mod(ddp_deliver(Object),
[

     [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : [robotheight(1.48),set(last_height,1.48)] => move
                    ]
     ], 
     
     [  
      		id ==> move,
      		type ==> recursive,
		embedded_dm ==> move(displace_precise=>(0.10),Status),
      		arcs ==> [
        			success : empty => relieve(apply(ddp_choose_deliver_arm(Obj),[Object])),
        			error : empty => relieve(apply(ddp_choose_deliver_arm(Obj),[Object]))				
      			]
     ],   
     
     [  
      		id ==> relieve(Arm),
      		type ==> recursive,
		embedded_dm ==> relieve( Arm , Status),
      		arcs ==> [
        			success : [robotheight(1.30),set(last_height,1.30), apply(ddp_actualize_arm_status(X,Y),[Arm,free])  ] => moveback,
        			error : [robotheight(1.30),set(last_height,1.30)] => moveback				
      			]
     ],    
      
     [  
      		id ==> moveback,
      		type ==> recursive,
		embedded_dm ==> move(displace_precise=>(-0.10),Status),
      		arcs ==> [
        			success : empty => success,
        			error : empty => success
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
