diag_mod(answer_question,
[
    [
      id ==> start,
      type ==> neutral,
      arcs ==> [
               empty : [say('Now I will answer your question.')] => asking
               ]
    ],
                           
    [
      id ==> asking,
      type ==> listening(spr),
      arcs ==> [
               said(Ht): [say(apply(sprt_get_answer(Ht),[H]))] => success,
               said(nothing): [say('I did not understand youl')] => asking
               ]
    ],
    
    [
      id ==> success,
      type ==> final
    ],
    
    [
      id ==> error,
      type ==> final
    ]
  
  ],

  % Second argument: list of local variables
  [
  ]

).	

