diag_mod(find_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
                empty : [say('Hello I am Golem and I will search something'),apply(initialize_KB,[])] => behavior
               ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,  
      		%embedded_dm ==> find(person, _, [[0.0,0.0,0.0],[1.0,0.0,45.0],[0.0,0.5,45.0]], [-30.0,0.0,30.0], [-15.0,0.0,15.0], detect_body, Found_Persons, Remaining_Positions, false, false, false, Status),
      		%embedded_dm ==> find(person, james, [displace=>(0.32),turn=>(-36.0),displace=>(0.20)], [-30.0,30.0], [0.0,-15.0], memorize_body, Found_Persons, Remaining_Positions, false, false, false, Status),
      		%embedded_dm ==> find(person, X, [displace=>(0.32),turn=>(-36.0),displace=>(0.20)], [-30.0,30.0], [0.0,-15.0], recognize_body, Found_Persons, Remaining_Positions, false, false, false, Status),
                
                %embedded_dm ==> find(object, X, [], [0.0], [-30.0], object, FndObj, Remaining_Positions, true, false, false, Status),
                %embedded_dm ==> find(person, X, [displace=>(0.01)], [0.0], [-15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
                embedded_dm ==> find(plane, X, [[1.0,0.0,-135.0],[0.0,0.0,90.0]], [0.0], [-25.0,-15.0], kinect, Found_Planes, Remaining_Pos, false, false, false, _),
                %embedded_dm ==> find(object, X, [living,bedroom,living], [-30.0,0.0,30.0], [-15.0,0.0,15.0], object, Found_Objects, Remaining_Positions, false, false, false, Status),
      		%embedded_dm ==> find(object, [cereal], [stove], [0.0], [-30.0,-20.0], object, Found_Objects, Remaining_Positions, false, false, false, Status),
      		%embedded_dm ==> find(object, drinks, [waiting_position],[0.0],[-5.0,-30.0],category, [Object|More], Rem_Pos, false, false, false, St), 
		%embedded_dm ==> find(object, drink, [p1,p2,p3], [-20,20], [-30,0,30], category, [[Name,P1,P2,P3,P4,P5,P6,P7,P8]|T], Remaining_Positions, false, false, false, Status),
      		%embedded_dm ==> find(person,X, [p1], [-20,20], [-30,0,30],detect, Found_Objects, Remaining_Positions, false, false, false, Status),
		%embedded_dm ==> find(gesture, X, [p1,p2,p3], [-20,20], [-30,0,30], 20, Found_Objects, Remaining_Positions, false, false, false, Status),
		%embedded_dm ==> find(gesture, X, [p1,turn=>(-90),[4.4,-1.84,-45],displace=>(0.3),p3], [-20,20], [-30,0,30], 1, Found_Objects, Remaining_Positions, false, false, false, Status),
		arcs ==> [
        			success : [say('I found it')] => temp(Found_Persons),
        			error : [say('Is not here')] => fs
				
      			 ]
    ],
    
    [
      id ==> temp([Head|Tail]),	
      type ==> neutral,
      arcs ==> [
                empty : [display(Head)] => fs
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

