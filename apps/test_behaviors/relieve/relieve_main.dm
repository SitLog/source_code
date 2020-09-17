diag_mod(relieve_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
                empty : [
                         robotheight(1.20), 
                         set(last_height, 1.20),
                         say('Hello I am Golem and I will release an object') 
                        ] => behavior
               ]
    ],
    
    [  
      id ==> behavior,
      type ==> recursive,
      %embedded_dm ==> relieve(right, Status),
      %embedded_dm ==> relieve_arg(-22.0,0.5,right, Status),
      embedded_dm ==> release_plane(right, [-30.0,-10.0,0.0], _),
      arcs ==> [
                success : [say('I released it')] => fs,
                error   : [say('I did not release it')] => fs
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

