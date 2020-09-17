diag_mod(answer_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ apply(initialize_KB,[]),  apply(initialize_cognitive_model,[]),
                  say('Hello I am golem')] => asking
      ]
    ],
    
    [  
      		id ==> asking,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, ask me a question',spr,false,20,Res,Status),
      		arcs ==> [
        			success : [say('You said'),say(Res)] => answer( apply(sprt_get_answer(R),[Res]) ),
        			error : [say('I did not understood')] => fs				
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
      		id ==> getdoas(H),
      		type ==> recursive,
		    embedded_dm ==> doas(one,doa(Angle),Status),
      		arcs ==> [
        			success : [turn_fine(Angle,Res), say(H), say('Ask me another question.'), reset_soundloc] => asking,
        			error : [say(H), say('Ask me another question.'), reset_soundloc] => asking
				
      			]
    ],
    
    [
      id ==> answer(X),	
      type ==> neutral,
      arcs ==> [
        empty : [say(X)] => fs
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

