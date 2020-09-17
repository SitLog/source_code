diag_mod(consult_kb_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ say('Hello I am Golem and I will consult my knowledge base'), apply(initialize_KB,[]) ] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		embedded_dm ==> consult_kb(value_object_property, [waiting_position,coordinate], Out_Par, Status),
		%embedded_dm ==> consult_kb(change_object_related, [bed,in,bathroom], Out_Par, Status),
		%embedded_dm ==> consult_kb(change_object_property, [bed,name,sofa], Out_Par, Status),		
		%embedded_dm ==> consult_kb(choose_object_from_class, [drink], Out_Par, Status),
		%embedded_dm ==> consult_kb(value_object_relation, [bed,in], Out_Par, Status),
		%embedded_dm ==> consult_kb(value_class_relation, [drink,in], Out_Par, Status),
		%embedded_dm ==> consult_kb(value_class_property, [points,coordinate], Out_Par, Status),
      		arcs ==> [
        			success : [say('I finish')] => result(Out_Par),
        			error : [say('Something is wrong')] => fs
				
      			]
    ],
    
    [
      id ==> result(X),	
      type ==> neutral,
      arcs ==> [
        	empty : empty => fs
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

