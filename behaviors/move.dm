% Move Task Dialogue Model
%
% 	Description	The robot performs a movement or a sequence of movements in the scenario
%	
%	Arguments	Movements: Can be specified as
%				A single coordinate [x,y,r] , where x and y are in meters and r is in grades
%				A single label corresponding to a coordinate point in the knowledge base 
%				A single instruction of the form type=>(value) where type corresponds to the kind of movement, and can be 'displace',
%               'turn','displace_precise', 'turn_precise', or 'face_towards' and the value is the magnitud of the movement
%               (in meters for advance, in grades for turn, a label for face_towards).		   
%				A list of coordinates [ [x_1,y_1,r_1] , [x_2,y_2,r_2] , ... , [x_n,y_n,r_n] ] 
%				A list of labels [ label_1, label_2 , ... , label_n ]
%				A list of instructions [type_1=>(value_1), type_2=>(value_2), ..., type_n=>(value_n)]
%				Coordinates and labels corresponds to absolut movements (where the origin corresponds to the topological map)
%				Instructions corresponds to relative movements (where the origin corresponds to the actual position of the robot)
%	
%			Status:	
%				ok .- if the robot completes successfully the sequence of movements
%			       	navigation_error .- otherwise


diag_mod(move(Movements,Status),
[
	
	
	%Initial situation
	[
		id ==> is,
      		type ==> neutral,
      		arcs ==> [
			%Verify the kind of input data. Singles elements are put into a list. There are four Cases: coordinate, label, instruction, empty
        		empty : apply( verify_type_of_move(M,C,L) , [Movements,Case,ListOfMovements] ) => verify_case(Case,ListOfMovements)
      			]
    	],

	% CASE 1
	%If the list of movements is empty
	[
		id ==> verify_case(empty,[]),
      		type ==> neutral,
      		arcs ==> [
			 empty : empty => success
      			]
    	],

	% CASE 2
	%If the list of movements are coordinates
	[
		id ==> verify_case(coordinate,ListOfMovements),
      		type ==> neutral,
      		arcs ==> [
			 empty : [switcharm(0),robotheight(1.25),set(last_height,1.25),switchpose('nav')] => go_to_point(ListOfMovements)
      			]
    	],	

	%Empty list
	[
		id ==> go_to_point([]),
      		type ==> neutral,
      		arcs ==> [
			empty : switchpose('grasp') => success
      			]
    	],

	%Go to first point in list
	[
		id ==> go_to_point([Point|T]),
      		type ==> neutral,
      		arcs ==> [
			empty :  navigate(Point,Result) => verify_result(Result,T)
      			]
    	],

	%If success, move to next point
	[
		id ==> verify_result(ok,T),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => go_to_point(T)
      			]
    	],

	%Otherwise
	[
		id ==> verify_result(Error,T),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => error
      			]
    	],

	% CASE 3
	%If the list of movements are labels
	[
		id ==> verify_case(label,ListOfLabels),
      		type ==> neutral,
      		arcs ==> [
			 %Verify if any of the points is in the KB, and get its coordenates	
			 empty : [switcharm(0),robotheight(1.25),set(last_height,1.25),switchpose('nav')] => go_to_point( apply(from_labels_to_coordinates(L),[ListOfLabels]) )
      			]
    	],	

	% CASE 4
	%If the list of movements are instructions
	[
		id ==> verify_case(instruction,ListOfMovements),
      		type ==> neutral,
      		arcs ==> [
			 empty : empty => choose_movement(ListOfMovements)
      			]
    	],

	%Empty list
	[
		id ==> choose_movement([]),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => success
      			]
    	],

	%Next movement is displace
	[
		id ==> choose_movement([displace=>Distance|T]),
      		type ==> neutral,
      		arcs ==> [
			empty : [NewDist is float(round(Distance*100)/100),
			         advance(NewDist,Result)
			        ] => verify_result_action(Result,T)
      			]
    	],

	%Next movement is turn
	[
		id ==> choose_movement([turn=>Angle|T]),
      		type ==> neutral,
      		arcs ==> [
			empty : [NewAng is float(round(Angle*10)/10),
			         turn(NewAng,Result),
			         assign(Flag,get(flag_angle_storing_groceries, F)),
			         assign(Op,get(angle_operation, O)), 
        			 apply(add_to_angle_sg(V1,V2,V3),[NewAng,Flag,Op])
        			] => verify_result_action(Result,T)
      			]
    	],
    	
    %Next movement is displace_precise
	[
		id ==> choose_movement([displace_precise=>Distance|T]),
      		type ==> neutral,
      		arcs ==> [
			empty : [NewDist is float(round(Distance*100)/100),
			         advance_fine(NewDist,Result)
			        ] => verify_result_action(Result,T)
      			]
    	],


        %Next movement is turn_precise
	[
		id ==> choose_movement([turn_precise=>0.0|T]),
      		type ==> neutral,
      		arcs ==> [
			  empty : empty => choose_movement(T)
      			 ]
    	],
    	
    	
	%Next movement is turn_precise
	[
		id ==> choose_movement([turn_precise=>Angle|T]),
      		type ==> neutral,
      		arcs ==> [
			empty : [NewAng is float(round(Angle*10)/10),
			         turn_fine(NewAng,Result),
			         assign(Flag,get(flag_angle_storing_groceries, F)),
			         assign(Op,get(angle_operation, O)), 
        			 apply(add_to_angle_sg(V1,V2,V3),[NewAng,Flag,Op])
        			] => verify_result_action(Result,T)
      			]
    	],

	%Next movement is face_towards
	[
		id ==> choose_movement([face_towards=>Point|T]),
      		type ==> neutral,
      		arcs ==> [
			empty : face_towards(Point,Result) => verify_result_action(Result,T)
      			]
    	],

	%If the list of movements is other
	[
		id ==> verify_case(Case,ListOfMovements),
      		type ==> neutral,
      		arcs ==> [
			 empty : empty => error
      			]
    	],

	%If success, do next action
	[
		id ==> verify_result_action(ok,T),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => choose_movement(T)
      			]
    	],

	%Otherwise
	[
		id ==> verify_result_action(Error,T),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => error
      			]
    	],

	%Final situations  

    	[
      		id ==> success,
      		type ==> final,
		diag_mod ==> move(_, ok)
    	],

    	[
      		id ==> error,
      		type ==> final,
		diag_mod ==> move(_, navigation_error)
    	]

  ],

  % Second argument: list of local variables
  [
  ]
).	
