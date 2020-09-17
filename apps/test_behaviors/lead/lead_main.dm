diag_mod(lead_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : empty => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		embedded_dm ==> lead(jose,kitche,uber,Status),
      		arcs ==> [
        			success : [say('Success')] => fs,
        			error : [say('Fail')] => fs
				
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

