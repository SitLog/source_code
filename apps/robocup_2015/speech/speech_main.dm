diag_mod(speech_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [tiltv(-30.0),set(last_tilt,-30.0),robotheight(1.35),set(last_height,1.35),set_ang_speed(25.0),
	         say('Starting Speech Recognition test.'),say('Please talk loud and clear, and start talking only after you hear a beep.'),say('Ask me something.'), reset_soundloc] => asking
      ]
    ],
    
	[
		 id ==> asking,
		 type ==> listening(questions),
		 arcs ==> [
                                said(Ht): empty => getdoas(apply(sprt_get_answer(Ht),[H]))
		          ]
        ],

    [  
      		id ==> getdoas(nothing),
      		type ==> recursive,
		    embedded_dm ==> doas(one,doa(Angle),Status),
      		arcs ==> [
        			success : [turn_fine(Angle,Res), say('Please ask me again.'), reset_soundloc] => asking,
        			error : [say('I did not hear you. Ask me again.'), reset_soundloc] => asking
				
      			]
    ],

    [  
      		id ==> getdoas(H),
      		type ==> recursive,
		    embedded_dm ==> doas(one,doa(Angle),Status),
      		arcs ==> [
        			success : [turn_fine(Angle,Res), say('The answer is '), say(H), say('Ask me another question.'), reset_soundloc] => asking,
        			error : [say('The answer is '), say(H), say('Ask me another question.'), reset_soundloc] => asking
				
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

