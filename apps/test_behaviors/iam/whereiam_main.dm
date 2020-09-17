diag_mod(whereiam_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will know where I am')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> whereiam,
      		arcs ==> [
        			text(X) : [say(['I am in',X])] => fs,
        			text(outside) : [say('I am outside the arena')] => fs
				
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

