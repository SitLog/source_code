% Competition, Rulebook 2017
%
% Copyright (C) 2017 UNAM (Universidad Nacional Autónoma de México)
% Caleb Rascon (http://calebrascon.info)
% Based on the 2016 work of:
%       Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)

% THIS DM IS NAMED guided_tour FOR COMPATBILITY REASONS
% 1.- Find the waving person via vision
% 2.- If didn't found it, use SSL to turn in the direction and try again
% 3.- When found, tell that a person is found and store location

diag_mod(guided_tour(Status),
[% situations for following a person and registering points and products

	[% initial situation
		id ==> is,
		type ==> neutral,
		arcs ==> [
			empty : [
				tiltv(-15.0),
				set(last_tilt,-15.0),
				say('I will wait here for the customer signal.')
			] => wait_gesture
		]
	],

	[ % Gesture OpenPose
		id ==> wait_gesture,
		type ==> gesture_op,
		arcs ==> [
		   	person_gesture_op(A,X,Y,Z) : 	[
		   					apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[X,Y,Z,R,O]),
			     				assign(Odometry, apply(get_person_odometry_yolo(P_,L_),[[R,O,1],0]))
							] => ask_to_attend(Odometry),
		   	person_gesture_op(A,0,0,0) : 	empty => wait_gesture,
		   	status(X) : 			empty => wait_gesture
     	 ]
	],

	[% found person
		id ==> ask_to_attend(Odometry),
		type ==> listening(yesno),
		arcs ==> [
			said(yes):[
				apply(add_location_kb(L,P),[customer,Odometry]),
				say('Good.')
			] => success,
			said(no):[
				say('Ok. I will stay here for the next customer.')
			] => wait_gesture,
			said(nothing):[
				say('Could not understand you.'),
				say('Do you want me to attend the customer.')
			]=> ask_to_attend(Odometry)
		]
	],

	% final situations
	[
		id ==> success,
		type ==> final,
		diag_mod ==> guided_tour(ok)
	],	

	[
		id ==> error,
		type ==> final,
		in_arg ==> [FinalSatus],
		diag_mod ==> guided_tour(FinalSatus)
	]
	],

% local variables
[
]
).
