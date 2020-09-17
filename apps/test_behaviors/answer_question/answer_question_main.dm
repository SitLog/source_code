diag_mod(answer_question_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [apply(initialize_KB,[]),
                 apply(initialize_cognitive_model,[]),
                 say('Hello I am Golem')] => behavior
      ]
    ],
    
  
   [
   id ==> behavior,
   type ==> recursive,
   embedded_dm ==> answer_question,
   arcs ==> [
             success : [
                        inc(c,Ctr)] => apply(when(_,_,_),[Ctr<3,behavior,agrad]),
   error : say('Error, I failed ') => fs
            ]
   ],
   
    [
                id ==> agrad,
                  type ==> neutral,
                    arcs ==> [
                      empty : [say('Thanks for your help. Goodbye')] => fs]
             ],

    [
      id ==> fs,
      type ==> final
    ]
  ],

  % Second argument: list of local variables
  [
  c ==> 0
  ]

).	

