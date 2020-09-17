diag_mod(answer_question_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [apply(initialize_KB,[]),
                 apply(initialize_cognitive_model,[]),
                 say('Nothing')] => question1
      ]
    ],
    
  
   [  
    id ==> question1,
       type ==> recursive,
     embedded_dm ==> ask('Please, ask me a question',spr,false,20,Res,Status),
     arcs ==> [
        success : [say('You said'),say(Res)] => question2,
        error : [say('I did not hear you. Ask me again.'), reset_soundloc] => question1
         ]
         ],
         
   [ 
      id ==> question2,
      type ==> recursive,
      embedded_dm ==> ask('Please, ask me another question',spr,false,20,Res,Status),
      arcs ==> [
         success : [say('You said'),say(Res)] => question3,
          error : [say('I did not hear you. Ask me again.'), reset_soundloc] => question2
           ]
           ],
           
   [
         id ==> question3,
         type ==> recursive,
         embedded_dm ==> ask('One more question please',spr,false,20,Res,Status),
         arcs ==> [
           success : [say('You said'),say(Res)] =>agrad,
            error : [say('I did not hear you. Ask me again.'), reset_soundloc] => question3
             ]
             ],
             
             [
                id ==> agrad
                  type ==> neutral,
                    arcs ==> [
                      empty : [say('Thanks for your help. Goodbye')] => fs]
             ],

  % Second argument: list of local variables
  [
  ]

).	

