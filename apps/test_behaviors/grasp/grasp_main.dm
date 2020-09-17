diag_mod(grasp_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        
         empty : [tilth(0.0),set(last_scan,0.0),tiltv(-30.0),set(last_tilt,-30.0),robotheight(1.20),set(last_height,1.20)] => behavior

%         empty : [tilth(0.0),set(last_scan,0.0),tiltv(-35.0),set(last_tilt,-35.0),robotheight(1.20),set(last_height,1.20),say('Hello I am Golem and I will grasp an object')] => behavior

%        empty : [say('Hello I am Golem and I will grasp an object'),switcharm(2),grasp(90.0,0.0,X)] => fs
      
%        empty : [say('Hello I am Golem and I will grasp an object'),switcharm(2),grasp(10.0,0.5),
%               tiltv(10.0),offer,open_grip,close_grip,robotheight(1.25)] => fs
%        empty : [robotheight(1.20),say('Hello I am Golem and I will grasp an object'),tiltv(0.0),tilth(0.0),switcharm(2),grasp(10.0,0.5)]
%=> fs
        
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
	        embedded_dm ==> see_object(X,object,[FirstObject|Rest],Status),
      		arcs ==> [
        			%success : [say('I found something')] => behavior2(FirstObject),
        			%error : [say('I did not find objects')] => fs				
        			success : [empty] => behavior2(FirstObject),
        			error : [empty] => fs				
      			]
    ],    
    
    [  
      		id ==> behavior2(Object),
      		type ==> recursive,
      		%embedded_dm ==> grasp(Object, right, Status),
      		embedded_dm ==> grasp(Object, left, Status),
      		arcs ==> [
        			%success : [say('I grasped it')] => fs,
        			%error : [say('I did not grasp it')] => fs				
        			success : [empty] => fs,
        			error : [empty] => fs				
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

