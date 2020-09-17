diag_mod(eduardo_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ initSpeech,say('Hello I am Golem and this is the dialogue model for eduardo')] => behavior(john,pepsi)
      ]
    ],
    
    [  
      		id ==> behavior(X,Y),
      		type ==> recursive,
		%embedded_dm ==> say('I can see die people',Status),
		%embedded_dm ==> say(['I can say','different','things'],Status),
		embedded_dm ==> say(['I think',X,'wants',Y,'to drink'],Status),
      		arcs ==> [
        			success : [say('I finish')] => fs
				
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

