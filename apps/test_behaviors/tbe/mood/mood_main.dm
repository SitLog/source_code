diag_mod(mood_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [
		        apply(initialize_KB,[]), say('I am going to test different moods.'), mood(neutral)
        	] => behavior1
      ]
    ],
    
    [  
      		id ==> behavior1,
      		type ==> neutral,
      		arcs ==> [
        			empty : [mood(sorpresa),say('this is happy')] => behavior2
      			]
    ],
    
    [  
      		id ==> behavior2,
      		type ==> neutral,
      		arcs ==> [
        			empty : [mood(enojo),say('this is sad')] => fs
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

