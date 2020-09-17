diag_mod(openpose_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        	empty : empty => openpose
         
      ]
    ],
    [
      id ==> openpose,	
      type ==> gesture_op,
      arcs ==> [
        	status(X) : 	empty => fs,
         	person_gesture_op(A,X,Y,Z) : say('Hi') => fs
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

