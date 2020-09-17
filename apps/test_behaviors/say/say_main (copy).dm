diag_mod(say_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ say('Hello I am Golem and I will say something') ] => behavior(john,pepsi)
      ]
    ],
    
    [  
      		id ==> behavior(X,Y),
      		type ==> recursive,
		%embedded_dm ==> say('I can see die people',Status),
		embedded_dm ==> say(['I can say','different','things'],Status),
		%embedded_dm ==> say(['I think',X,'wants',Y,'to drink'],Status),
      		arcs ==> [
        			success : [say('I finish'), robotheight(1.25),set(last_height,1.25)] => fs
				
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

