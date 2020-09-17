diag_mod(manage_failed_orders,
[

     [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : say('I will check my knowledge base') => apply(ddp_check_failed_orders,[])
                    ]
     ], 
     
     [
            id ==> manage([]),	
            type ==> neutral,
            arcs ==> [
                    empty : say('There are no more failed orders to check') => success
                    ]
     ], 
     
     [
            id ==> manage([bring(Object)|T]),	
            type ==> neutral,
            arcs ==> [
                    empty : say(['I will check',Object]) => apply( ddp_verify_existence_of_object(Obj,Tail) , [Object,T] )
                    ]
     ], 
    
     [  
      		id ==> offer(Object,T),
      		type ==> recursive,
      		embedded_dm ==> say(['There are',Object,'in the shelf'],_),
      		arcs ==> [
        			success : empty => offer2(Object,T),
        			error : empty => error		
      			    ]
     ],
           
     [  
      		id ==> offer2(Object,T),
      		type ==> recursive,
      		embedded_dm ==> ask('Do you want it',yesno,false,1,Answer,Status),
      		arcs ==> [
        			success : apply(manage_failed_orders_parser(A,O),[Answer,Object]) => manage(T),
        			error : empty => error			
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
