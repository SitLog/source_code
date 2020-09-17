diag_mod(clean_up_main,
[
    [
	id ==> is,
	type ==> recursive,
	embedded_dm ==> ask('Please tell me the room to clean up',gpsr2015,true,3,Room,_),
	arcs ==> [
		 success : [apply(initialize_KB,[]),
			    say(['I will search for misplaced objects in the',Room]),
		            apply( consult_kb_value_object_property(R_,P_,V_),[Room,object_path,Obj_Path] )
		           ] => get_misplaced(Obj_Path),
		 error   : [say('I could not recognize the room')] =>fs
		 ]
    ],

    [
	id ==> get_misplaced([]),
	type ==> neutral,
	arcs ==> [
		 empty : [say('No more places to search for objects'),say('The task is finished')] => fs
		 ]
    ],
    
    [
	id ==> get_misplaced(Obj_Path),
	type ==> recursive,
	embedded_dm ==> find(object,X,Obj_Path,[-25.0,25.0],[-30.0,0.0],object,Found,Remaining,false,false,false,_),
	arcs ==> [
		 success : [assign(Path2,apply( clean_up_f2(O_,R_),[Obj_Path,Remaining] )),
			    set(obj_path,Path2),
			    Path2 = [Pos|_],
			    set(current_loc,Pos)
			   ] => check_height(Found,Remaining),
		 error   : [say('I could not find any object')] => fs
	     ]
    ],

    [
	id ==> check_height([],Remaining),
	type ==> neutral,
	arcs ==> [
		 empty : empty => get_misplaced(Remaining)
	         ]
    ],

    [
	id ==> check_height([Obj|Rest],Remaining),
	type ==> neutral,
	arcs ==> [
		 empty : [Obj = object(_,X,Y,Z,_,_,_,_,_),
			  get(last_height,RobotHeight),
			  get(last_tilt,Tilt),
			  cam2arm(right,RobotHeight,[X,Y,Z],[Tilt,0.11,0.10],[0.21,0.22,0.2248],[Height,_,_])
			 ] => apply(clean_up_f1(H_,O_,T_,R_),[Height,Obj,Rest,Remaining])
	     ]
    ],

    [
	id ==> check_loc(Obj,Rest_Obj,Remaining),
	type ==> neutral,
	arcs ==> [
		 empty : [Obj = object(ID,_,_,_,_,_,_,_,_),
			  assign(C,apply(get_class_of_obj(_),[ID])),
			  apply(consult_kb_value_class_relation(_,_,_),[C,in_location,LocKB]),
			  get(current_loc,Loc),
			  get(brazo,Arm)
			 ] => apply( when(_,_,_),[LocKB==Loc,check_height(Rest_Obj,Remaining),get_obj(Obj,Arm)])
	     ]
    ],

    [
	id ==> get_obj(Object,1),
	type ==> recursive,
	embedded_dm ==> take(Object, right, _, _),
	arcs ==> [
		 success : [robotheight(1.20),
                            set(last_height,1.20),
                            set(brazo,2),
                            get(obj_path,Obj_P)
			   ] => get_misplaced(Obj_P),
		 error   : [robotheight(1.20),
                            set(last_height,1.20),
                            advance_fine(-0.20, _),
                            get(obj_path,Obj_P)
			   ] => get_misplaced(Obj_P)
	         ] 
    ],

    [
	id ==> get_obj(Object,2),
	type ==> recursive,
	embedded_dm ==> take(Object, left, _, _),
	arcs ==> [
		 success : [set(brazo,1)] => deliver,
		 error   : [set(brazo,1)] => deliver
    	         ]
    ],


    [
	id ==> deliver,
	type ==> recursive,
	embedded_dm ==> deliver_clean_up,
	arcs ==> [
		 success : [get(obj_path,Obj_P)] => get_misplaced(Obj_P),
		 error   : empty => fs
		 ]
    ],


    [
	id ==> fs,
	type ==> final
    ]
],
[
    current_loc ==> none,
    obj_path ==> [],
    brazo ==> 1
]
).
