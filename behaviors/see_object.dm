% See Object Task Dialogue Model
%
% 	Description	The robot sees an object in its current field of view
%	
%	Arguments	Sought: List of sought objects or label corresponding to a category of sought objects. 
%			If is a variable, it will search any known objects in the scene. 
%			
%			Mode: 	object .- search objects listed in the argument 'Sought' 
%				category .- search objects belonging to the category indicated in the argument 'Sought'
%	
%			Found_Objects: 	List of objects [ Object_1 , Object_2 , ... , Object_n ] where each object  
%					is a functor which includes the ID and eight parameters about its position and orientation
%					object(id,p1,p2,p3,p4,p5,p6,p7,p8)
%				 
%			Status:	
%				ok .- if at least one of the objects sought was found
%			       	not_found .- no objects sought were found
%				empty_scene .- if the robot is searching for any known objects but nothing was found

diag_mod(see_object(Sought, Mode, Found_Objects, Status),

	    [

		% Check 'Mode'(object or category)
		[
		 id ==> is,
		 type ==> neutral,

		 arcs ==> [		
					%empty:[robotheight(1.30),set(last_height,1.30)] => start_analyzing(Mode)
					empty:empty => start_analyzing(Mode)
				    ]
		 ],

	    	
		[
		 id ==> start_analyzing(object),
		 type ==> neutral,

		 arcs ==> [		% Recognize objects specified directly in 'Sought'
					empty:[get(last_tilt, LastTilt), get(object_recognition_mode, RecognitionMode), get(approaching, Approaching)] => seeing(Sought, LastTilt, RecognitionMode, Approaching)
				    ]
		 ],

		[
		 id ==> start_analyzing(category),
		 type ==> neutral,

		 arcs ==> [		% Recognize objects belonging to the categories listed in 'Sought'
					empty: [get(last_tilt, LastTilt), get(object_recognition_mode, RecognitionMode), get(approaching, Approaching)] => seeing( apply(get_objects_in_categories(S),[Sought] ), LastTilt, RecognitionMode, Approaching)
				    ]
		 ],
		 
		% Case 1: Recognition mode --> yolo
		[
		  id ==> seeing(Objects, LastTilt, yolo, _),
		  type ==> yolo_object_detection(LastTilt,drinks),
		  arcs ==> [
		            objects(Scene) : empty => check(apply(objects_in_scene(O, P), [Objects, Scene])),
                            status(Status) : empty => check(Status)		
		           ]
		],

		% Seeing (wait for scene analysis to be completed)
		[
		 id ==> seeing(Objects, LastTilt, RecognitionMode, Approaching),
		 type ==> object_analyzing(LastTilt, RecognitionMode, Approaching),

		 arcs ==> [ % Recognize Object in current view
					objects(Scene):empty => check(apply(objects_in_scene(O, P), [Objects, Scene])),
			
			        % No objects were recognized, returning status
			        status(Status):empty => check(Status)		
				    ]
		 ],

		% Check status: at least one object is found in scene
		[
		 id ==> check([object(Object_ID,X,Y,Z, RQ1,RQ2,RQ3,RQ4,Score)|Rest]),
		 type ==> neutral,

		 arcs ==> [		empty:empty=> success
				    ],

		 diag_mod ==> see_object(Sought, _, [object(Object_ID,X,Y,Z,RQ1,RQ2,RQ3,RQ4,Score)|Rest], ok)
		 ],


		% Check status: 'not_found' or 'empty_scene'
		[
		 id ==> check(Status),
		 type ==> neutral,

		 arcs ==> [		empty: empty => error
				    ],

		 diag_mod ==> see_object(Sought, _, _, Status)

		 ],

		% Final Situations
		[id ==> error, type ==> final],

		[id ==> success, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
