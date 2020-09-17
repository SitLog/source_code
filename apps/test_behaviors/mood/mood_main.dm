diag_mod(mood_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [
		        sleep(5),%say('I am going to test different moods'), 
		        say('this is talking'),mood(talk),
		        say('this is neutral'),mood(neutral), 
		        say('this is surprised'),mood(sorpresa),
		        say('this is happy'), mood(feliz) 
        	] => fs
      ]
    ],
    
    [  
      		id ==> behavior1,
      		type ==> neutral,
      		arcs ==> [
        			empty : [say('this is happy'), mood(feliz), 
        			         say('this is sad'),mood(triste),
        			         say('this is glad'),mood(alegre)] => behavior2
      			]
    ],
    
    [  
      		id ==> behavior2,
      		type ==> neutral,
      		arcs ==> [
        			empty : [say('this is angry'),mood(enojo),
        			         say('this is upset'),mood(disgusto),
        			         say('this is afraid'),mood(miedo),
        			         %say('this is preoccupied'),
        			         mood(preocupado),say(['no more gestures','goodbye'])] => fs
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

