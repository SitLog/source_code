%supermarket main
diag_mod(supermarket_main,
[

   [  
      		id ==> move_origin,
      		type ==> recursive,
			embedded_dm ==> move(start,Status),
		  		arcs ==> [
        			success : empty => is,
        			error : empty => is
			]
    ],

    [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : [robotheight(1.30),set(last_height,1.30),tiltv(0.0),set(last_tilt,0.0),say('Hello. My name is golem and I am an assistant in the supermarket. If you need something tell me'),
                        apply(initialize_KB_supermarket,[])] 
                    => receive_order('.')
                    ]
    ],
    
    [  
      		id ==> receive_order(Question),
      		type ==> recursive,
      		embedded_dm ==> ask(Question,supermarket_command,false,1,Order,Status),
      		arcs ==> [
        			success : [get(count,C)] => verify_order( apply(supermarket_parser(O),[Order]), C ),
        			error : empty => fs				
      			    ]
     ],
     
     [  
      		id ==> verify_order(dispatch,1),
      		type ==> recursive,
      		embedded_dm ==> dispatch_orders,
      		arcs ==> [
        			success : [inc(count,C)] => receive_order('Anything else'),
        			error : empty => fs		
      			    ]
     ],
     
     [  
      		id ==> verify_order(dispatch,2),
      		type ==> recursive,
      		embedded_dm ==> dispatch_orders,
      		arcs ==> [
        			success : empty => fs,
        			error : empty => fs		
      			    ]
     ],
     
     [  
      		id ==> verify_order(Order,_),
      		type ==> recursive,
      		embedded_dm ==> verify_order(Order),
      		arcs ==> [
        			success : empty => receive_order('Anything else'),
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
    count ==> 1
  ]

).	

