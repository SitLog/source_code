% Plane recognition dialogue model
%
%                 Description: The robot tries to recognize a plane
%
%                 Arguments: 
%                             Found_Planes: The sorted list of found planes
%
%                 Mode:       moped  - moped is used to recognize any object on the table
%                                      and by approaching it, Golem approaches the table
%                             yolo   - yolo is used
%                             kinect - kinect is used to detect the table
%
%                 Status:
%                             ok: if planes were successfully detected
%                             empty: otherwise
%
% Author: Gibran F and Noe H

diag_mod(plane_detection(Found_Planes, Mode, Status), 
%First argument: list of situations
[
	% Initial situation
        [
           id ==> is,
           type ==> neutral,
           arcs ==> [
                       empty:[
                             assign(M_,get(object_recognition_mode,M)),
                             set(real_mode,M_),
                             set(object_recognition_mode, Mode)
                             ]
                             => see_mode(Mode)
                    ]
        ],
        
        
        % Detect planes by seeing objects on it using moped
        [
           id ==> see_mode(moped),
           type ==> recursive,
           embedded_dm ==> see_object(X, object, Found_Objects, St),
           out_arg ==> [Found_Objects],
           arcs ==> [
                       success:[
                               assign(M_, get(real_mode, M)),
                               set(object_recognition_mode, M_)
                               ] => success,
                       error  :empty => check(St)
                    ]
        ],
        
        
        % Detect planes by seeing objects on it using yolo
        [
           id ==> see_mode(yolo),
           type ==> recursive,
           embedded_dm ==> see_object(X, object, Found_Objects, St),
           out_arg ==> [Found_Objects],
           arcs ==> [
                       success:[
                               assign(M_, get(real_mode, M)),
                               set(object_recognition_mode, M_)
                               ] => success,
                       error  :empty => check(St)
                    ]
        ],
        
        
        % Detect planes by point cloud through kinect
        [
           id ==> see_mode(kinect),
           type ==> neutral,
           arcs ==> [
                       empty:[get(last_tilt, LastTilt),
                              get(x_value, X_Value),
                              get(z_value, Z_Value),
                              assign(Offset, get(offset_height, O)),
                              assign(LastHeight,get(last_height,Height)),
                              Tmp is Offset + LastHeight,
                              Y_Value is Tmp - 0.70
                             ] => see_planes(LastTilt,X_Value,Y_Value,Z_Value)
                    ]
        ],

        % Recognize planes
        % plane_recognition(Last_Tilt,X_max,Y_max,Z_max)
        [
           id ==> see_planes(Last_Tilt,X,Y,Z),
           type ==> plane_recognition(Last_Tilt,X,Y,Z), %see in_communication.pl file
           arcs ==> [
                       status(Status):empty => check(Status),
                       planes(Scene) :empty => sort(Scene)
                    ]
        ],
        
        [
           id ==> sort(Planes),
           type ==> neutral,
           out_arg ==> [Sorted],
           arcs ==> [
                       empty : [
                               assign(Sorted, apply(sort_planes(P),[Planes]) ),
                               assign(M_, get(real_mode, M)),
                               set(object_recognition_mode, M_)
                               ] => success
                    ]
        ],
        
        % Success situation
        [
           id ==> success,
           type ==> final,
           in_arg ==> [Value],
           diag_mod ==> plane_detection(Value, _, ok)
        ],
        
        % Check status
	[
	   id ==> check(Status),
	   type ==> neutral,
           arcs ==> [
                       empty : [
                               assign(M_, get(real_mode, M)),
                               set(object_recognition_mode,M_)
                               ] => error
		    ],
           diag_mod ==> plane_detection(_, _, Status)
        ],

        % Error situation
        [
           id ==> error,
           type ==> final
        ]
],
% List of Local Variables
[
        x_value ==> 1.0,
        offset_height ==> 0.25,
        z_value ==> 1.85,
        real_mode ==> none
]
). % End 
