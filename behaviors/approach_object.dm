% Approach Object Task Dialogue Model
%
% 	Description	The robot approaches to a place to be close enough to grasp an object  
%	
%	Arguments	In_Parameters: a functor object(id, x, y, z, o1, o2, o3, o4, c) with information about the position of the object in %                   relation to the robot when the task is started.
%
%			    Out_Parameters: a functor object(id, x, y, z, o1, o2, o3, o4, c) with information about the position of the object in 
%                   relation to the robot when the task is accomplished successfully.  
%				
%			    Status:	
%				    ok .- if the/an object was found 
%			        not found .- if object is not in the scene (whether specified or not) 
%				    empty_scene .- if not object is seen in the scene 

diag_mod(approach_object(In_Parameters, Out_Parameters, Status),

% Situation's list
[

		[
		 id ==> is,
		 type ==> neutral,
		 prog ==> [set(approaching, true)],
		 arcs ==> [
		          	empty : tilth(0.0) => compare(In_Parameters)
			  ]
		],

		% Get the polar coordinates of the object and check if the object is close enough
		[
		 id ==> compare(object(Object_ID, X, Y, Z, O1, O2, O3, O4, Conf)),
		 type ==> neutral,
		 arcs ==> [		
				empty : [ get(last_tilt, LastTilt), cam2nav([X,Y,Z],[LastTilt,0.1,-0.06], Polar_Coord) ] => 				
				check(object(Object_ID, X, Y, Z, O1, O2, O3, O4, Conf), Polar_Coord, apply(reachable(A, D), [Polar_Coord, get(in_range, Range)]))
			  ]
		],

		% Particular case of compare when only the object's name is given
		[
		 id ==> compare(ObjectName),
		type ==> recursive,
		out_arg ==> [See_Status],
		embedded_dm ==> see_object([ObjectName], object, [ObjectInfo], See_Status),
		arcs ==> [		
				% See objects and compare again
				success:empty => compare(ObjectInfo),
				% The object is lost from scene: try to recover it
				error:empty => error
			  ]
		],
	    	
		% Object already in grasping or delivery distance
		[ 
		 id ==> check(Out_Parameters, _, true),
		 type ==> neutral,
		 prog ==> [set(approaching, false)],
		 arcs ==> [		
					empty:empty => success
		          ],
		 diag_mod ==> approach_object(_, Out_Parameters, ok)
		],

 		% Object is not within grasping or delivery distance: fine movement in direction to the object and see again
		[
		  id ==> check(Object, [Angle,Distance], false),
		  type ==> neutral,
		  arcs ==> [		
					empty:[
						assign(In_Range,get(in_range, Range)),
						In_Range = [MaxAngle,MaxDist,MinDist],
						assign(Delta_Dist, apply(delta_dist(D, MD),[Distance,MaxDist])), 
						assign(Delta_Angle, apply(delta_angle(A, MA,LS),[Angle,MaxAngle, get(last_scan,LastScan)])),
						tilth(0.0),set(last_scan,0.0),
						Delta_D is float(round(Delta_Dist*100)/100),
						Delta_A is float(round(Delta_Angle*10)/10)
					      ] => move(Object,Delta_D,Delta_A)
			   ]
		],
		
		% Golem is close enough to the object
		[  
      		 id ==> move(Object,0.0,0.0),
      		 type ==> neutral,
      		 arcs ==> [
        			empty : empty => check(Object, _, true)
			  ]
    		],

		% Approach to the object
		[  
      		 id ==> move(Object, Delta_Dist, Delta_Angle),
      		 type ==> recursive,
		 out_arg ==> [Status_Move],
		 embedded_dm ==> move([turn_precise=>(Delta_Angle),displace_precise=>(Delta_Dist)],Status_Move),
      		 arcs ==> [
        			success : [apply(set_turn_flag(X),[Delta_Angle]),sleep(3)] => see, %apply(status_approach(DD,DA,O),[Delta_Dist,Delta_Angle,Object]), %% The sleep action is to wait for the robot to stabilize after moving
        			error   : empty => error
			  ]
    		],

		% See object again
		[
		 id ==> see,
		 type ==> neutral,
		 arcs ==> [
				empty: empty => see_object(In_Parameters)		
		          ]
		],


		% See object again
		[
		 id ==> see_object(object(Object_ID, X, Y, Z, O1, O2, O3, O4, Conf)),
		 type ==> recursive,
		 embedded_dm ==> see_object([Object_ID], object, [ObjectInfo], See_Status),
		 arcs ==> [		
				% See objects and compare again
				success:empty => compare(ObjectInfo),
				% The object is lost from scene: try to recover it
				error:empty => scan(Object_ID)
			  ]
		],
		
		
		%% Particular case of see when only the object's name is given
		
		[
		 id ==> see_object(ObjectName),
		 type ==> recursive,
		 embedded_dm ==> see_object([ObjectName], object, [ObjectInfo], See_Status),
		 arcs ==> [		
				% See objects and compare again
				success:empty => compare(ObjectInfo),
				% The object is lost from scene: try to recover it
				error:empty => scan(ObjectName)
			  ]
		],
		

		% Tilt to recover the object again
		[
		 id ==> scan(Object_ID),
		 type ==> recursive,
		 out_arg ==> [Scan_Status],
		 % Scan around the object -5 and -5 degrees attempting to recover an object that was found but lost during approaching
		 embedded_dm ==> scan(object, [Object_ID], [0.0,-5.0,5.0], [-30.0,-20.0], object, [ObjectInfo], false, false, Scan_Status),
		 arcs ==> [ % Find object again and compare proximity
					success:empty => compare(ObjectInfo),					
					% Fatal error: object lost and cannot be recovered from scene again
					error:empty => error
		          ]
		],

	 	% Final Situations
	    [
		  id ==> success,
		  type ==> final
	    ],
	    
	    [
		  id ==> error, 
		  type ==> final,
		  prog ==> [set(approaching, false)],
		  in_arg ==> [Approach_Status],
 		  diag_mod ==> approach_object(_, _, Approach_Status)
		]


],

	% List of Local Variables
	[in_range ==> [20.0, 0.58, 0.45], delta ==> 0]

   ).
