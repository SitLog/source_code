diag_mod(pose_main,
[
   [
   id ==> is,	
   type ==> neutral,
   arcs ==> [
            empty : [tiltv(-10.0), set(last_tilt, -10.0), tilth(0.0), set(last_scan, 0.0), say('I will detect your pose')] => behavior
            ]
   ],
    
   [  
   id ==> behavior,
   type ==> recursive,  
   embedded_dm ==> pose(Pose,_),
   arcs ==> [
            success : [say(['You are ', Pose]), say('I finished')] =>fs,
            error : [say('I am sorry')] => fs
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

