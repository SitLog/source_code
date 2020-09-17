diag_mod(wait_instructions,
[

    [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : empty => receive_order('.')
                    ]
    ],
    
    [  
      		id ==> receive_order(Question),
      		type ==> recursive,
      		embedded_dm ==> ask(Question,inference_demo_command,false,1,Order,Status),
      		arcs ==> [
        			success : empty => verify_order( apply(inference_demo_parser(O),[Order]) ),
        			error : empty => fs				
      			    ]
    ],
    
    [  
      		id ==> verify_order(update_inventory(NewObjects)),
      		type ==> neutral,
      		arcs ==> [
        			empty : [ apply(ddp_update_inventory(NO),[NewObjects]) , say('I registered the new products in my knowledge base') ] 
        			        => generate_dialog_new_products(NewObjects)
      			    ]
    ],
    
    [  
      		id ==> generate_dialog_new_products(NewObjects),
      		type ==> neutral,
      		arcs ==> [
        			empty : apply(ddp_generate_dialog_new_products(NOO),[NewObjects]) 
        			        => receive_order('Anything else')
      			    ]
    ],
    
    %%This special case is a direct order in which the restriction checking process is not performed
    [  
      		id ==> verify_order(bring_me_without_verification(List)),
      		type ==> neutral,
      		arcs ==> [
        			empty : apply(ddp_add_list_of_orders_without_verification(L),[List]) => receive_order('Anything else')
      			    ]
    ],        
          
    [  
      		id ==> verify_order(finish),
      		type ==> neutral,
      		arcs ==> [
        			empty : empty => success
      			    ]
    ],
     
     [  
      		id ==> verify_order(Order),
      		type ==> recursive,
      		embedded_dm ==> verify_order(Order),
      		arcs ==> [
        			success : empty  => receive_order('Anything else'),
        			error : empty => fs				
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
