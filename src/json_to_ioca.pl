% load JSON convertion module
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

% basic object definitions
:- json_object object(name:atom, x:float, y:float, z:float, rq1:float, rq2:float, rq3:float, rq4:float, score:float).
:- json_object neckcoord(angle:float, direction:integer).
:- json_object identified_face(isIdentical:atom, confidence:float, distanciaX:float, distanciaY:float, distanciaZ:float).
:- json_object graspcoord(angle:float, distance:float).
:- json_object arm(arm:integer).
%:- json_object distance(distance:integer).
:- json_object distance(distance:float).
:- json_object pose(pose:atom).
:- json_object person_pose(r:integer,o:integer,p:integer).
:- json_object height(height:float).
:- json_object coord2(x:float, y:float).
:- json_object coord3(x:float, y:float, z:float).
:- json_object navpoint(x:float, y:float, angle:float).
:- json_object navigate(navigate:navpoint/3).
:- json_object navigate(navigate:atom).
:- json_object navigate_nonblock(navigate_nonblock:navpoint/3).
:- json_object navigate_nonblock(navigate_nonblock:atom).
:- json_object navigate_abort(navigate_abort:atom).
:- json_object navigate_status(navigate_status:atom).
:- json_object turn(turn:float).			
:- json_object tilt_angle(tilt:float).
:- json_object advance(advance:float).
:- json_object advance_nonblock(advance_nonblock:float).
:- json_object turn_fine(turn_fine:float).
:- json_object advance_fine(advance_fine:float).
:- json_object set_lin_vel(set_lin_vel:float).
:- json_object set_ang_vel(set_ang_vel:float).
:- json_object face_towards(face_towards:atom).
:- json_object doa(doa:float).
:- json_object confidence(confidence:atom).
:- json_object text(text:atom).
:- json_object command(command:atom).
:- json_object faceId(faceId:atom).
:- json_object detect_request(command:atom).
:- json_object identify_request(command:atom,faceId:atom).
:- json_object name(name:atom).
:- json_object status(status:atom).
:- json_object door_status(door_status:atom).
:- json_object method(method:atom).
:- json_object memorize_face(x:float, y:float, z:float, name:atom).
:- json_object person_gesture_op(angle:float, pointX:integer, pointY:integer, pointZ:integer).
:- json_object object_recognition_request(tilt:float, recognition_mode:atom, approaching:boolean).
:- json_object yolo_object_recognition_request(tilt:float,objects:atom, recognition_mode:atom, approaching:boolean).
:- json_object plane_recognition_request(tilt:float,x_max:float,y_max:float,z_max:float).
:- json_object plane(x:float, y:float, z:float, angle:float).
:- json_object person_pose_op(angle:float, pointX:float, pointY:float, pointZ:float).
			
array_to_list([], []).

array_to_list([HeadTerm|RestTerms], List) :-
    json_to_prolog(HeadTerm, HeadList),
    array_to_list(RestTerms, RestList),
    append([HeadList], RestList, List).
    

json_to_ioca(json([]), []).

json_to_ioca([], []).

json_to_ioca(json([_=[HeadArray|RestArray]|RestPairs]), IOCAInter) :-
    array_to_list([HeadArray|RestArray], HeadIOCAInter),
    json_to_ioca(json(RestPairs), RestIOCAInter),
    append(HeadIOCAInter, RestIOCAInter, IOCAInter).

json_to_ioca(json([X=Value|RestPairs]), IOCAInter) :-
    json_to_prolog(json([X=Value]), HeadIOCAInter),
    json_to_ioca(json(RestPairs), RestIOCAInter),
    append([HeadIOCAInter], RestIOCAInter, IOCAInter).

rosswipl_to_ioca(JsonString, IOCAInter) :-
    atom_json_term(JsonString, JsonTerms, []),
    json_to_ioca(JsonTerms, IOCAInter). 
   
ioca_to_rosswipl(IOCAInter, JsonString) :-
	prolog_to_json(IOCAInter,InputJson),
	with_output_to(atom(JsonString), json_write(current_output, InputJson)).

	
remove_bracket_left(S, NoSpaces) :-
    atomic_list_concat(L, '[', S),
    atomic_list_concat(L, NoSpaces).
remove_bracket_right(S, NoSpaces) :-
    atomic_list_concat(L, ']', S),
    atomic_list_concat(L, NoSpaces).
remove_spaces(S, NoSpaces) :-
    atomic_list_concat(L, ' ', S),
    atomic_list_concat(L, NoSpaces).
remove_keys(S, NoSpaces) :-
    atomic_list_concat(L, '},\n{', S),
    atomic_list_concat(L, NoSpaces).

replace_atom_so(Original,Pattern,NewPattern,Result):-
	atomic_list_concat(Words, Pattern, Original), 
	atomic_list_concat(Words, NewPattern, Result).
    
ioca_list_to_rosswipl(IOCAInter, Final) :-
    ioca_to_rosswipl(IOCAInter, JsonString),
    remove_bracket_left(JsonString, NoBracketsL),
    remove_bracket_right(NoBracketsL, NoBrackets),
    remove_spaces(NoBrackets, NoSpaces),
    remove_keys(NoSpaces, NoKeys),
    replace_atom_so(NoKeys,'""','","',Final).
    
    
    
