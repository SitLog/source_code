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

	[ % try to see the gesture
		id ==> wait_gesture,
		type ==> recursive,
		embedded_dm ==> see_gesture(hand_up, nearest, 3, GestureParameters, GestureStatus),
		arcs ==> [
			success : empty => get_position(hand_up, GestureParameters),
			error : empty => get_position(not_detected,_)
		]
	],

	[ % register location based on the pointing gesture
		id ==> get_position(hand_up, [person(ID,R,O,P)|_]),
		type ==> neutral,
		arcs ==> [
			empty : [
				assign(Odometry, apply(get_person_odometry(PersonPose,L),[[R,O,P],80])),
				say('Found a customer calling for attention.'),
				say('Do you want me to attend the customer.')
			] => ask_to_attend(Odometry)
		]
	],

	[ % TODO: caught unexpected gesture, trying SSL
		id ==> get_position(not_detected,_),
		type ==> neutral,
		arcs ==> [
			empty : empty => wait_gesture
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
