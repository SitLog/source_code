% Approach Plane Dialogue Model
%
% 	Description	The robot detects a plane (e.g. table) and approaches it
%	
%	Arguments	Input: The coordinates of the plane
%
%                       Mode: moped - moped is used to recognize any object on the table
%                                     and by approaching it, Golem approaches the table
%                             kinect - kinect is used to detect the table
%
%                       Status:	
%				ok .- if the robot detects a plane and approach to it
%			       	plane_not_found .- the plane was not detected


diag_mod(approach_plane(Input, Mode, Status),
%List of situations
[
   [
   id ==> is,
   type ==> neutral,
   arcs ==> [
            empty : tilth(0.0) => apply(when(If,True,False),[Mode==moped,compare_O(Input),compare_P(Input)])
            ]
   ],
   
   % Get the polar coordinates of the object and check if the object is close enough
   [
   id ==> compare_O(object(Object_ID, X, Y, Z, O1, O2, O3, O4, Conf)),
   type ==> neutral,
   prog ==> [set(approaching, true)],
   arcs ==> [		
               empty : [ get(last_tilt, LastTilt), cam2nav([X,Y,Z],[LastTilt,0.1,-0.06], Polar_Coord) ] => 				
                         check(object(Object_ID, X, Y, Z, O1, O2, O3, O4, Conf), Polar_Coord, apply(reachable(A, D), [Polar_Coord, get(in_range, Range)]))
            ]
   ],
  
   % Get the polar coordinates of the plane and check if it is close enough
   [
   id ==> compare_P(plane(X,Y,Z,_)),
   type ==> neutral,
   arcs ==> [
               empty : [get(last_tilt, LastTilt), cam2nav([X,Y,Z],[LastTilt,0.1,-0.06], Polar_Coord)] 
                     => check(plane(X,Y,Z,_), Polar_Coord, apply(reachable(A, D), [Polar_Coord, get(in_range, Range)]))
            ]
   ],
   
   % Plane is already in grasping or delivery distance
   [ 
   id ==> check(_,_, true),
   type ==> neutral,
   prog ==> [set(approaching, false)],
   arcs ==> [		
            empty:empty => success
            ],
   diag_mod ==> approach_plane(_, _, ok)
   ],
   
   % Plane is not within grasping or delivery distance: fine movement in direction to the object
   [
   id ==> check(Plane,[Angle,Distance], false),
   type ==> neutral,
   arcs ==> [
            empty:[assign(In_Range,get(in_range, Range)),
                   In_Range = [MaxAngle, MaxDist, MinDist],
                   assign(Delta_Dist, apply(delta_dist(D, MD),[Distance, MaxDist])), 
                   assign(Delta_Angle, apply(delta_angle(A, MA, LS),[Angle, MaxAngle, get(last_scan,LastScan)])),
                   tilth(0.0), set(last_scan,0.0)
                  ] => apply(when(If, True, False), [Delta_Dist>0,move(Plane,Delta_Dist,Delta_Angle),move(Plane,Delta_Dist,0.0)]) 
            ]
   ],
   
   % Golem is close enough to the object
   [  
   id ==> move(Plane,0.0,0.0),
   type ==> neutral,
   arcs ==> [
   		empty : empty => check(Plane, _, true)
            ]
   ],
   
   % Approach to the object
   [  
   id ==> move(Plane,Delta_Dist,Delta_Angle),
   type ==> recursive,
   out_arg ==> [Status_Move],
   embedded_dm ==> move([turn_precise=>(Delta_Angle),displace_precise=>(Delta_Dist)],Status_Move),
   arcs ==> [
            success : empty => apply(when(If,True,False),[Mode==moped,see_obj(Plane),check(_, true)]),
            error   : empty => error
            ]
   ],
   
   % See object again
   [
   id ==> see_obj(object(Object_ID, X, Y, Z, O1, O2, O3, O4, Conf)),
   type ==> recursive,
   embedded_dm ==> see_object([Object_ID], object, [ObjectInfo], See_Status),
   arcs ==> [		
            % See objects and compare again
            success:empty => compare_O(ObjectInfo),
            % The object is lost from scene: try to recover it
            error:empty => scan(Object_ID)
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
            success:empty => compare_O(ObjectInfo),
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
   in_arg ==> [Approach_Status],
   diag_mod ==> approach_plane(_, _, Approach_Status)
   ]
   
],
% List of Local Variables
[
in_range ==> [15.0, 0.60, 0.53], 
delta ==> 0
]

).


