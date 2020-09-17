diag_mod(prompt_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ say('Hello I am Golem and I will receive a command in the keyboard') ] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		embedded_dm ==> prompt('Text something here:', ReadText, Status),
      		arcs ==> [
        			success : [say('I finish')] => fs,
        			error : [say('Something is wrong')] => fs				
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

