diag_mod(ask_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [initSpeech] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		%embedded_dm ==> ask('Please, tell me a command',gpsr2015,true,2,Res,Status), 
      		%embedded_dm ==> ask('Please, tell me a command',inference_demo_command,true,2,Res,Status), 
      		%embedded_dm ==> ask('tell me a drink',drink,true,2,Res,Status),
                %embedded_dm ==> ask('tell me a command',gpsrI,true,1,Res,Status),
      		%embedded_dm ==> ask('Please, tell me a command',gpsr2015,true,100,Res,Status), 
      		embedded_dm ==> ask('Please, tell me your name',human,true,100,Res,Status), 
      		
      		arcs ==> [
        			success : [say('you said '),say(Res)] => fs,
        			error : [say('I did not understood')] => fs
				
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

