diag_mod(approach_plane_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
                empty : [
                         say('Hello I am Golem and I will approach to a plane'),
                         tiltv(-30.0),set(last_tilt,-30.0),
                         tilth(0.0),set(last_scan,0.0),
                         robotheight(1.20),set(last_height,1.20)
                        ] => behavior
               ]
    ],
    
    [  
      id ==> behavior,
      type ==> recursive,
      embedded_dm ==> plane_detection(P, moped, _),
      %embedded_dm ==> plane_detection(P, kinect, _),
      arcs ==> [
        	success : [say('I found a plane')] => behavior2(P),
        	error   : [say('I did not find any plane')] => fs
	       ]
    ],
    
    [  
      id ==> behavior2([Plane|_]),
      type ==> recursive,
      embedded_dm ==> approach_plane(Plane, _, _),
      arcs ==> [
      		success : [say('I am near of it')] => fs,
      		error   : [say('I could not approach the plane')] => fs				
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
