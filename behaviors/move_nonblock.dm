% Move Task Dialogue Model with NonBlocking
%
% 	Description	The robot performs a movement in the scenario with nonblock
%	
%	Arguments	Movements: Can be specified as
%				A single coordinate [x,y,r] , where x and y are in meters and r is in grades
%				A single label corresponding to a coordinate point in the knowledge base 
%				Coordinates and labels corresponds to absolut movements (where the origin corresponds to the topological map)
%	
%			Status:	
%				ok .- if the robot completes successfully the sequence of movements
%			       	navigation_error .- otherwise


diag_mod(move_nonblock(Movements,Status),
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
			 empty : [robotheight(1.42),set(last_height,1.42),switchpose('nav')] => go_to_point(ListOfMovements)
      			]
    	],	

	%Empty list
	[
		id ==> go_to_point([]),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => success
      			]
    	],

	%Go to first point in list and get out
	[
		id ==> go_to_point([Point|T]),
      		type ==> neutral,
      		arcs ==> [
			empty :  navigate_nonblock(Point,Result) => verify_result(Result,T)
      			]
    	],

	%If success, get out
	[
		id ==> verify_result(ok,T),
      		type ==> neutral,
      		arcs ==> [
			empty : empty => success
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
			 empty : [robotheight(1.42),set(last_height,1.42),switchpose('nav')] => go_to_point( apply(from_labels_to_coordinates(L),[ListOfLabels]) )
      			]
    	],	

	% CASE 4
	%If the list of movements is other, ignore them
	[
		id ==> verify_case(Case,ListOfMovements),
      		type ==> neutral,
      		arcs ==> [
			 empty : empty => error
      			]
    	],

	%Final situations  

    	[
      		id ==> success,
      		type ==> final,
		diag_mod ==> move_nonblock(_, ok)
    	],

    	[
      		id ==> error,
      		type ==> final,
		diag_mod ==> move_nonblock(_, navigation_error)
    	]

  ],

  % Second argument: list of local variables
  [
  ]
).	
