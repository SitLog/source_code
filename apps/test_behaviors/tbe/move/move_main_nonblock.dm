diag_mod(move_main_nonblock,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [
		        say('Hello I am Golem and I will perform a non blocking movement'),apply(initialize_KB,[])
        	] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		%embedded_dm ==> move_nonblock([],Status),
		%embedded_dm ==> move_nonblock([0.0,0.75,0.0],Status),
		embedded_dm ==> move_nonblock([0.0,0.0,0.0],Status),		
		%embedded_dm ==> move_nonblock([[0.0,0.0,0.0],[1.0,0.0,45.0],[0.0,0.5,45.0]],Status),
		%embedded_dm ==> move_nonblock(living,Status),
		%embedded_dm ==> move_nonblock([waiting_position],Status),
		%embedded_dm ==> move_nonblock(point1,Status),
		%embedded_dm ==> move_nonblock([shelf,kitchen_table,exit],Status),
      		arcs ==> [
        			%success : [say('started to move')] => nav_status,
        			success : [say('started to move')] => nav_status_cancel1,
        			error : [say('could not start to move')] => fs
				
      			]
    ],
    
	[
		 id ==> nav_status,
		 type ==> navigate_status,
		 arcs ==> [
                                active: empty => nav_status,
                                ok: [switchpose('grasp'),say('i arrived')] => fs,
                                inactive: [switchpose('grasp'),say('i am inactive')] => fs,
                                error: [switchpose('grasp'),say('something went wrong')] => fs
		          ]
    ],

	[
		 id ==> nav_status_cancel1,
		 type ==> navigate_status,
		 arcs ==> [
                                active: empty => nav_status_cancel2,
                                ok: [switchpose('grasp'),say('i arrived')] => fs,
                                inactive: [switchpose('grasp'),say('i am inactive')] => fs,
                                error: [switchpose('grasp'),say('something went wrong')] => fs
		          ]
    ],

	[
		 id ==> nav_status_cancel2,
		 type ==> navigate_status,
		 arcs ==> [
                                active: empty => nav_status_cancel3,
                                ok: [switchpose('grasp'),say('i arrived')] => fs,
                                inactive: [switchpose('grasp'),say('i am inactive')] => fs,
                                error: [switchpose('grasp'),say('something went wrong')] => fs
		          ]
    ],

	[
		 id ==> nav_status_cancel3,
		 type ==> navigate_status,
		 arcs ==> [
                                active: [navigate_abort, switchpose('grasp'),say('took to long, aborted')] => fs,
                                ok: [switchpose('grasp'),say('i arrived')] => fs,
                                inactive: [switchpose('grasp'),say('i am inactive')] => fs,
                                error: [switchpose('grasp'),say('something went wrong')] => fs
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

