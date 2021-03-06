diag_mod(deliver_clean_up,
[
    [
	id ==> is,
	type ==> neutral,
	arcs ==> [
		 empty : [get(right_arm,Obj_R)] => get_place(Obj_R)
		 ]
    ],


    [
	id ==> get_place(Obj),
	type ==> neutral,
	arcs ==> [
		 empty : [assign(Class,apply(get_class_of_obj(O_),[Obj])),
			  apply(consult_kb_value_class_relation(C_,P_,L_),[Class,in_location,NewLoc]),
			  get(last_location,LastLoc),
			  get(brazo,Arm)			  
			 ] => apply(when(I_,T_,F_),[LastLoc==NewLoc,release(Arm),move_place(NewLoc)])
	         ]	     
    ],
    

    [
	id ==> move_place(Place),
	type ==> recursive,
	embedded_dm ==> move(Place,_),
	arcs ==> [
		 success : [set(last_location,Place),
			    advance_fine(0.25,_),
			    apply(consult_kb_org_obj_prop(P_,V_,N_),[position,Place,Place_Name]),
			    apply(consult_kb_value_object_property(NN_,PP_,H_),[Place_Name,height,H]),
			    Height is (H + 50)/100,
			    robotheight(Height),
			    set(last_height,Height),
			    get(brazo,Arm)
		           ] => release(Arm),
		 error   : empty => move_place(Place)
		 ]
    ],

    [
	id ==> release(1),
	type ==> recursive,
	embedded_dm ==> relieve_arg(-15.0,0.5,right,_),
	arcs ==> [
		 success : [get(left_arm,Obj_L),
			    set(brazo,2)
			   ] => apply( when(I_,T_,F_),[Obj_L == free,success,get_place(Obj_L)] ),
		 error   : empty => release(1)
	         ] 
    ],


    [
	id ==> release(2),
	type ==> recursive,
	embedded_dm ==> relieve_arg(15.0,0.5,left,_),
	arcs ==> [
		 success : empty => success,
		 error   : empty => release(2)
	         ] 
    ],

    [
	id ==> success,
	type ==> final
    ],

    [
	id ==> error,
	type ==> final
    ]
],
[
    brazo ==> 1,
    last_location ==> none
]
).
