%verify order
diag_mod(verify_order(Order),
[
           
    [
            id ==> is,
            type ==> neutral,
            arcs ==> [
                    empty : empty => verify_restriction([existence,disponibility,graspability,age_restriction,age_client],Order)
                    ]            
    ],
    
    [
            id ==> verify_restriction([],Input),
            type ==> neutral,
            arcs ==> [
                    empty : empty => success
                    ]            
    ],
    
    [
            id ==> verify_restriction([FirstRestriction|RestRestrictions],Input),
            type ==> neutral,
            arcs ==> [
                    empty : empty => apply(check_restriction(FR,RR,In),[FirstRestriction,RestRestrictions,Input])         
                    ]            
    ],
    
    [  
      		id ==> embedded_sit(EmbeddedBehavior,ActionsSuccess,NextSituationSuccess),
      		type ==> recursive,
      		embedded_dm ==> EmbeddedBehavior,
      		arcs ==> [
        			success : ActionsSuccess => NextSituationSuccess,
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

