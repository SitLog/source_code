% Consult KB Task Dialogue Model
%
% 	Description	The robot consults the KB to obtain information
%
%	Arguments	Kind: Type of consult requested, and can be:
%				value_object_property
%				value_object_relation
%				change_object_related
%				change_object_property
%				choose_object_from_class
%				value_class_relation
%				value_class_property
%                               get_all_values
%                               object_with_prop_value
%				update_kb_demo
%
%			In_Par: List of input parameters
%				for value_object_property: [Object,Property]
%				for value_object_relation: [Object,Relation]
%				for change_object_related: [Object1,Relation,Object2]
%				for change_object_property: [Object,Property,Value]
%				for choose_object_from_class: [Class]
%				for value_class_relation: [Class,Relation]
%				for value_class_property: [Class,Property]
%                               for get_all_values: [Property]
%                               for object_with_prop_value: [Property,Value]
%				for update_kb_demo: [Location, ListObjects]
%
%			Out_Par: List of output parameters
%				for value_object_property: Property_Value
%				for value_object_relation: Relation_Value
%				for change_object_related: nothing
%				for change_object_property: nothing
%				for choose_object_from_class: Object
%				for value_class_relation: Relation_Value
%				for value_class_property: Property_Value
%                               for get_all_values: Values
%                               for object_with_prop_value: Original_Object
%
%			Status:	
%				ok .- if the consult is succesful
%			       	consult_failed .- otherwise

diag_mod(consult_kb(Kind, In_Par, Out_Par, Status), 
[

		% Verify Kind of consult
		[
		 id ==> verify,
		 type ==> neutral,
		 arcs ==> [		
				% Verify kind of consult
					empty : empty => kind_of_consult(Kind,In_Par)
			  ]
		],

		% Case 1 Get the value of an object property
		
		[
		 id ==> kind_of_consult(value_object_property,[Object,Property]),
		 out_arg ==> [Value],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_value_object_property(O,P,V), [Object,Property,Value] ) => success 
			  ]		  		
		],

		% Case 2 Get the value of an object relation
		
		[
		 id ==> kind_of_consult(value_object_relation,[Object,Relation]),
		 out_arg ==> [Value],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_value_object_relation(O,R,V), [Object,Relation,Value] ) => success 
			  ]		  		
		],

		% Case 3 Choose an object from a class

		[
		 id ==> kind_of_consult(choose_object_from_class,[Class]),
		 out_arg ==> [Object],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_choose_object_from_class(C,O), [Class,Object] ) => success 
			  ]		  		
		],
	
		% Case 4 Change the object related

		[
		 id ==> kind_of_consult(change_object_related,[Object1,Relation,Object2]),
		 out_arg ==> [_],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_change_object_related(O1,R,O2), [Object1,Relation,Object2] ) => success 
			  ]		  		
		],

		% Case 5 Change the value of an object property

		[
		 id ==> kind_of_consult(change_object_property,[Object,Property,Value]),
		 out_arg ==> [_],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_change_object_property(O,P,V), [Object,Property,Value] ) => success 
			  ]		  		
		],
		
		% Case 6 Get the value of a class relation
		
		[
		 id ==> kind_of_consult(value_class_relation,[Class,Relation]),
		 out_arg ==> [Value],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_value_class_relation(C,R,V), [Class,Relation,Value] ) => success 
			  ]		  		
		],

		% Case 7 Get the value of a class property
		
		[
		 id ==> kind_of_consult(value_class_property,[Class,Property]),
		 out_arg ==> [Value],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_value_class_property(C,P,V), [Class,Property,Value] ) => success 
			  ]		  		
		],
		
		% Case 8 Get all values of Property
		
		[
		 id ==> kind_of_consult(get_all_values,[Property]),
		 out_arg ==> [Value],
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( consult_kb_get_all_values(P,V), [Property,Value] ) => success 
			  ]		  		
		],

                % Calse 9 Get the object with the given property value		

		[
		 id ==> kind_of_consult(object_with_prop_value,[Property,Value]),
		 out_arg ==> [Obj],
		 type ==> neutral,
		 arcs ==> [
			         empty : apply( consult_kb_org_obj_prop(P_,V_,O_), [Property,Value,Obj] ) => success 
			  ]
		],
		
		% Case 10 Get the value of an object property
		
		[
		 id ==> kind_of_consult(update_kb_demo,[Location,ListObjects]),		
		 type ==> neutral,
		 arcs ==> [		
				empty : apply( update_kb_demo_dlic(_,_), [Location,ListObjects] ) => success 
			  ]		  		
		],


		% Case n Wrong consult
		[
		 id ==> kind_of_consult(X,Y),
		 type ==> neutral,
		 arcs ==> [		
				empty : empty => error
			  ]		
		],


		% Final Situations
		[
			id ==> success,
			type ==> final,
			in_arg ==> [Res],
			diag_mod ==> consult_kb(_, _, Res, ok)
		],

		[
			id ==> error,
			type ==> final,
			diag_mod ==> consult_kb(_, _, _, consult_failed)
		]

	    ], 

	% List of Local Variables
	[]

   ). 
