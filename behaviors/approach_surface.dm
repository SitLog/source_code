% Approach Surface Dialogue Model
%
% 	Description	The robot detects a surface (e.g. table) and approaches it
%	
%	Arguments	Input: The coordinates of the surface
%
%                       Status:	
%				ok .- if the robot detects a surface and approach to it
%			       	not_reable .- the surface was not detected


diag_mod(approach_plane(Input, Output, Status),
%List of situations
[
   [
   id ==> is,
   type ==> neutral,
   arcs ==> [
            empty : tilth(0.0) => compare(Input)
            ]
   ],
   
   % Get the polar coordinates of the surface and check if it is close enough
   [
   id ==> compare(plane(X,Y,Z,A)),
   type ==> neutral,
   arcs ==> [
               empty : [ get(last_tilt, LastTilt), cam2nav([X,Y,Z],[LastTilt,0.1,-0.06], Polar_Coord) ] => 				
                              check(plane(X,Y,Z,A), Polar_Coord, apply(reachable(A, D), [Polar_Coord, get(in_range, Range)]))
            ]
   ],
   
   % Surface is already in grasping or delivery distance
   [ 
   id ==> check(Output, _, true),
   type ==> neutral,
   arcs ==> [		
            empty:empty => success
            ],
   diag_mod ==> approach_plane(_, Output, ok)
   ],
   
   % Surface is not within grasping or delivery distance: fine movement in direction to the object and see again
   [
   id ==> check(Surface, [Angle,Distance], false),
   type ==> neutral,
   arcs ==> [
            empty:[assign(In_Range,get(in_range, Range)),
                   In_Range = [MaxAngle, MaxDist, MinDist],
                   assign(Delta_Dist, apply(delta_dist(D, MD),[Distance, MaxDist])), 
                   assign(Delta_Angle, apply(delta_angle(A, MA, LS),[Angle, MaxAngle, get(last_scan,LastScan)])),
                   tilth(0.0), set(last_scan,0.0)
                  ] => move(Surface,Delta_Dist,Delta_Angle)
            ]
   ],
   
   % Approach to the object
   % User function status_approach can retrieve 'see' or 'check(Object, _, true)'
   [  
   id ==> move(Surface, Delta_Dist, Delta_Angle),
   type ==> recursive,
   out_arg ==> [Status_Move],
   embedded_dm ==> move([turn_precise=>(Delta_Angle),displace_precise=>(Delta_Dist)],Status_Move),
   arcs ==> [
            success : empty => apply(status_approach(DD, DA, O),[Delta_Dist, Delta_Angle, Surface]),
            error   : empty => error
            ]
   ],
   
   % See plane again
   [
   id ==> see,
   type ==> recursive,
   out_arg ==> [plane_not_found],
   embedded_dm ==> plane_detection(P, St),
   arcs ==> [
            % See plane and compare again
            success : empty => prior_compare(P),
            error   : empty => error
            ]
   ],
   
   [
   id ==> prior_compare([Plane|_]),
   type ==> neutral,
   arcs ==> [
             empty : empty => compare(Plane)
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
   in_arg ==> [Approach_Status],
   diag_mod ==> approach_plane(_, _, Approach_Status)
   ]
   
],
% List of Local Variables
[
in_range ==> [20.0, 0.70, 0.55], 
delta ==> 0
]

).

%
%		[
%	      	  	id ==> approach_surface(Height, [DX, DY, DZ]),
%	      	 	type ==> neutral,
%	      	 	arcs ==> [	% Approach to plane
%	      				% Set platform height	      						
%	      				empty:[
%	      				       get_closer(DZ - 30, 0),
%	      				       platform(Height)
%	      				      ] => success
%	      			]
%	      	],
%
%		[
%		 	id ==> success,
%		 	type ==> final,
%		 	diag_mod ==> relieve(_, _, ok)
%        	],
%
%		[
%		 	id ==> error,
%		 	type ==> final,
%		 	diag_mod ==> relieve(_, _, not_deliver)
%		]     
%		
%
%	    ], 
%
%	% List of Local Variables
%	[]
%
%  ). 

% OLD DIALOGUE MODEL
%diag_mod(approach_surface(Status),
%[
%
%	        % See the surface (e.g. table)
%	     	[
%	     	  	 id ==> is,
%	     	  	 type ==> recursive,
%    	 	 	 embedded_dm ==> plan_detect(Height, Location), 
%	     	  	 arcs ==> [
%	    	  		        success(_):empty => approach_surface(Height, Location),
%	    	  			error(_, _):empty => is
%	     	  		  ]
%	     	],
%
%		[
%	      	  	id ==> approach_surface(Height, [DX, DY, DZ]),
%	      	 	type ==> neutral,
%	      	 	arcs ==> [	% Approach to plane
%	      				% Set platform height	      						
%	      				empty:[
%	      				       get_closer(DZ - 30, 0),
%	      				       platform(Height)
%	      				      ] => success
%	      			]
%	      	],
%
%		[
%		 	id ==> success,
%		 	type ==> final,
%		 	diag_mod ==> relieve(_, _, ok)
%        	],
%
%		[
%		 	id ==> error,
%		 	type ==> final,
%		 	diag_mod ==> relieve(_, _, not_deliver)
%		]     
%		
%
%	    ], 
%
%	% List of Local Variables
%	[]
%
%  ). 
