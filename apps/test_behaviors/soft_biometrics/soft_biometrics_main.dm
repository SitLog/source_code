diag_mod(soft_biometrics_main,
  [
        
    [  
      	id ==> is,
      	type ==> recursive,
		embedded_dm ==> test1,
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

