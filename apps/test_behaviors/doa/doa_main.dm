diag_mod(doa_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        %empty : [ say('Talk so I can hear you'), reset_soundloc, sleep,sleep,sleep] => behavior
        empty : [ reset_soundloc, sleep,sleep,sleep] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		embedded_dm ==> doas(all,Angles,Status),
      		arcs ==> [
        			success : [say('I heard you')] => fs,
        			error : [say('I did not hear you')] => fs
				
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

