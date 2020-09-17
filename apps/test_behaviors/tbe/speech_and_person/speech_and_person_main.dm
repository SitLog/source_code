diag_mod(speech_and_person_main,
[

    [
            id ==> start,
            type ==> neutral,
            arcs ==> [
                    empty : [   apply(initialize_KB,[]), apply(initialize_cognitive_model,[]),
                                %tiltv(-18.0),set(last_tilt,-18.0),
				%tilth(0.0),set(last_scan,0.0),
		                %robotheight(1.38),set(last_height,1.38),set_ang_speed(25.0),
		                screen('Initialization complete, input ok. to start the test ')
		            ] => k1
                    ]
    ],
    
    [
            id   ==> k1,
            type ==> keyboard,
            arcs ==> [
                     ok : empty => start2
                    ]
    ],
    
    [
            id ==> start2,
            type ==> neutral,
            arcs ==> [
                    empty : [
		                say('Hello, my name is Golem and I want to play riddles. I will wait ten seconds before turning')		                        
		            ] => wait
                    ]
    ],
    
    [  
      		id ==> wait,
      		type ==> neutral,
      	        arcs ==> [
        			empty : [sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep] => turn			
      		     ]
    ],
    
    [  
      		id ==> turn,
      		type ==> recursive,
  		embedded_dm ==> move([displace=>(0.4),turn_precise=>(179.0)],Status),
		arcs ==> [
        			success : empty => take_photo_of_crowd,
        			error : empty => turn
      			]
    ],
    
    [  
      		id ==> take_photo_of_crowd,
      		type ==> recursive,
		embedded_dm ==> memorize_body(nearest,10,james,Body_Positions,Status),
      		arcs ==> [
        			success : [say('I see a crowd')] => analyzing_crowd,
        			error : [say('I did not see a crowd'),say('I will continue with the task.')] => message				
      			]
    ],
    
    [
	        id ==> analyzing_crowd,
		type ==> analyzing_crowd(1),
		arcs ==> [
                            detected(X): say('I am counting the persons in the crowd') => crowd_description	  	
		         ]
    ],
    
    [
	        id ==> crowd_description,
		type ==> detect_crowd(1),
		arcs ==> [
                            detected(X): apply(sprtDescribeCrowd(Xs),[X]) => message	  	
		         ]
    ],
    
    [  
      		id ==> message,
      		type ==> neutral,
      	        arcs ==> [
        			empty : say('Now I will answer your questions. Please tell to go the the exit after you finish. Remember to ask me after the beep.') => asking1		
      		     ]
    ],     
    	
    	
    	% First question for the front position
    	[
	      id ==> asking1,
	      type ==> listening(spr),
	      arcs ==> [
		       said(Ht): [say('The answer is '), say(apply(sprt_get_answer(Ht),[H])), say('Ask me another question.')] => asking2,
		       said(nothing): [say('I did not hear you. Ask me again.')] => asking2
		       ]
	],
    	
    	
    	% Second question for the front position
    	
    	[
	      id ==> asking2,
	      type ==> listening(spr),
	      arcs ==> [
		       said(Ht): [say('The answer is '), say(apply(sprt_get_answer(Ht),[H])), say('Ask me another question.')] => asking3,
		       said(nothing): [say('I did not hear you. Ask me again.')] => asking3
		       ]
	],
    	
    	
    	% Third question for the front position
    	[
	      id ==> asking3,
	      type ==> listening(spr),
	      arcs ==> [
		       said(Ht): [say('The answer is '), say(apply(sprt_get_answer(Ht),[H])), say('Ask me another question.')] => asking4,
		       said(nothing): [say('I did not hear you. Ask me again.')] => asking4
		       ]
	],
    	
    	
    	% Fourth question for the front position
        [
	      id ==> asking4,
	      type ==> listening(spr),
	      arcs ==> [
		       %said(Ht): [say(apply(sprt_get_answer(Ht),[H]))] => asking,
		       said(Ht): [say('The answer is '), say(apply(sprt_get_answer(Ht),[H])), say('Ask me another question.')] => asking_simple,
		       %said(nothing): empty => asking
		       said(nothing): [say('I did not hear you. Ask me again.')] => asking_simple
		       ]
	],
        
        
        
        % Question rotating
        
                       
	[
		 id ==> asking_simple,
		 type ==> listening(spr),
		 arcs ==> [
                                said(Ht): [say('The answer is '), say(apply(sprt_get_answer(Ht),[H])), say('Ask me another question.')] => asking_simple,
                                said(nothing): [say('I did not hear you. Ask me again.')] => asking_simple
		          ]
        ],

	[
		 id ==> asking,
		 type ==> listening(spr),
		 arcs ==> [
                                said(Ht): empty => getdoas(apply(sprt_get_answer(Ht),[H])),
                                said(nothing): empty => getdoas(nothing)
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
      		id ==> getdoas('move exit'),
      		type ==> recursive,
		    embedded_dm ==> move(exit,_),
      		arcs ==> [
        			success : [say('I finish the speech and person recognition test')] => fs,
        			error : [say('I could not reach the exit, I finish the speech and person recognition test')] => fs
				
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

