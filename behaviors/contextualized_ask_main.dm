diag_mod(contextualized_ask_main(Mode), 
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [initSpeech,apply(initialize_KB,[]),
                 apply(initialize_cognitive_model,[])]  => behavior(Mode) 
               ]
    ],
    [
		 id ==> behavior(reg), 
		 type ==> neutral,
		 arcs ==> [
	              empty : [mood(triste), say('Please stand in front of me') ] => ask1
		 	  ]
	],
		      	
	[
		id ==> ask1,
		type ==> recursive,
		embedded_dm ==> contextualized_ask('Please, tell me your question',spr,true,2,regular,Res,Status),   
		arcs ==> [
        			success : [say(apply(sprt_get_answer(Res),[H])), say('Thanks for your help')] => fs,
        			error : [say('I did not understood')] => ask1
				
      			 ]
      	],		
      	
      	[
		 id ==> behavior(inte),
		 type ==> neutral,
		 arcs ==> [
	              empty : [say('Please, go to the kitchen and wait until i call you'), sleep(5),say('Comeback')
	              ] => ask21 
	              
		          ]
	],

	[
		id ==> ask21,
		type ==> recursive,
		embedded_dm ==> contextualized_ask('Please, tell me your question',spr,true,2,intermediate,Res,Status),      
		arcs ==> [
        			success : [say(apply(sprt_get_answer(Res),[H])), say('Thanks for your help')] => fs,
        			error : [say('I did not understood')] => ask31
				
      			 ]
	],

     [
		 id ==> behavior(adv),
		 type ==> neutral,
		 arcs ==> [
	              empty : [say('Please, go to the kitchen and read the questions to make me one of them'),sleep(5)
	            ] => ask31 
	              
		          ]
	],

	[
		id ==> ask31,
		type ==> recursive,
		embedded_dm ==> contextualized_ask('Please, tell me your question ',spr,true,2,advanced,Res,Status),      
		arcs ==> [
        			success : [say(apply(sprt_get_answer(Res),[H])), say('Thanks for your help')] => fs,
        			error : [say('I did not understood')] => ask31
				
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
