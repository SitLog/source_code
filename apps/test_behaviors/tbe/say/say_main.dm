diag_mod(say_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : empty => behavior 
        %[ robotheight(1.50),set(last_height,1.50), tiltv(-15.0),set(last_tilt,-15.0),say('Hello, my name is Golem.'), say('I am a service robot.'), robotheight(1.35),set(last_height,1.35), tiltv(-25.0),set(last_tilt,-25.0), tilth(0.0),set(last_scan,0.0) ] => move_hand
      ]
    ],
    
    [  
      id ==> move_hand,
      type ==> recursive,
      embedded_dm ==> relieve(right, Status),
        arcs ==> [
                success : [say('Shalala')] => move_hand_other,
                error   : [say('I can not move my hand')] => move_hand_other
               ]
    ],
    
     [  
      id ==> move_hand_other,
      type ==> recursive,
      embedded_dm ==> relieve(left, Status),
        arcs ==> [
                success : [say('Shalala')] => is,
                error   : [say('I can not move my hand')] => is
               ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		%embedded_dm ==> say('I can see die people',Status),
		embedded_dm ==> say('7',Status),
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

