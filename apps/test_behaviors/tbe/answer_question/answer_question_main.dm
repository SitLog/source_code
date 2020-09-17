diag_mod(answer_question_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [apply(initialize_KB,[]),
                 apply(initialize_cognitive_model,[]),
                 say('Hello I am golem')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		embedded_dm ==> answer_question,
      		arcs ==> [
        			success : [say('Success, I am done')] => fs,
        			error : [say('Error, I am done')] => fs
				
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

