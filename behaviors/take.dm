% Take Task Dialogue Model
%
% 	Description	The robot approach to an object and grasp it 
%	
%	Arguments	Object: a functor object(id, x, y, z, o1, o2, o3, o4, c) with information about the position of the object.
%
%			    Arm: 	left
%				        right
%			
%			    ObjTaken: name of the taken object 
%				
%			    Status:	
%				        ok .- if the object was taken
%				        not_grasped .- the object can not be taken
%			           	not_found .- the desired object is not found 
%				        empty_scene .- if not object is seen in the scene 
%                       navigation_error .- if there is a problem while approaching the object


diag_mod(take(Object, Arm, ObjTaken, Status),
	   
[
		
		[
		 id ==> approach,
		 type ==> recursive,
		 out_arg ==> [_, Approach_Status],
		 embedded_dm ==> approach_object(Object, Approach_Parameters, Approach_Status),		 
		 arcs ==> [		
					success : sleep => grasp(Approach_Parameters),
			        error : empty => error
			  ]
		],
		
		[
		 id ==> grasp(object(ObjectGrasp, GX, GY, GZ, GO1, GO2, GO3, GO4, GConf)),
		 type ==> recursive,
		 out_arg ==> [ObjectGrasp, Grasp_Status],
		 embedded_dm ==> grasp(object(ObjectGrasp, GX, GY, GZ, GO1, GO2, GO3, GO4, GConf), Arm, Grasp_Status),		 
		 arcs ==> [		
					success: assign(Status, apply(arm_update(A,O),[Arm, ObjectGrasp])) => success,
			        error: empty => error
			  ]
		 ],

		 % Final Situations
		 [
		  id ==> success,
		  type ==> final,
		  in_arg ==> [ObjectGrasped, _],
		  diag_mod ==> take(_, _, ObjectGrasped, ok)
		 ],

         [
	  	  id ==> error,
		  type ==> final,
		  in_arg ==> [_, Final_Status],
		  diag_mod ==> take(_, _, _, Final_Status)
		 ]
 
	    ], 

	% List of Local Variables
	[]

   ). 
