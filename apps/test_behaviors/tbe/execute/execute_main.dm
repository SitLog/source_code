diag_mod(execute_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ initSpeech,say('Hello I will execute a script') ] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		embedded_dm ==> execute('scripts/upfollow.sh',Status),
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

