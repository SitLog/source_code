% Recognize Body Task Dialogue Model
%
% 	Description	The robot detects and recognizes a body in its current field of view. 
%	
%	Arguments	
%
%               Mode:  (preference in identification is given to first in list)
%                   nearest.- retrieves the bodies in the scene arranging them from the nearest to the farthest
%                   innermost.- retrieves the bodies in the scene arranging them from the most central to the less central
%                   leftright.- retrieves the bodies in the scene arranging them from left to right
%                   rightleft.- retrieves the bodies in the scene arranging them from right to left
%
%               Time_observation: time of an observation in seconds. When the time finishes, the robot determines if there are 
%                   bodies in the scene
%
%               Name: Name of the searched person (must be declared in the knowledge base). If is a variable it will identify the first
%                   in the list of detected persons, with the label unknown in case the person is not in the database.
%
%               Body_position: A functor of the form person(id,r,o,w), where id is the kinect id of the person, (r,o) is the polar %                   coordinate in the XY plane, and w is the orientation angle of the person, with information of the recognized person
%	
%			    Status:	
%				    ok .- if the person was detected and recognized
%			       	not_detected .- if no person was detected
%                   not_found.- if the persons in scene are not the searched person
%                   invalid_name.- the requested name is not declared in the knowledge base

diag_mod(recognize_body(Mode,Time_observation,Name,Body_position,Status), 
[

        %Detect bodies
        [  
      		id ==> detect_body,
      		type ==> recursive,
		    embedded_dm ==> detect_body(Mode,Time_observation,Detected_Bodies,Detect_Status),
      		arcs ==> [
        			success : empty => recognize(Detected_Bodies , apply(get_name_numerical_id(N),[Name]) ),
        			error : empty => not_detected				
      			]
        ],
        
        %In case no body is detected
        [
		    id ==> not_detected,
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => error
			  ],
			diag_mod ==> recognize_body(_,_,_,_,not_detected)
		],
        
        %Case 1, The name received is a variable, so it will recognize the first person in list of detected persons 
        [
		    id ==> recognize([person(ID,R,O,W)|T],is_variable),
		    type ==> recognize_body(ID,W),
		    arcs ==> [
                                recognized(NumID):empty => check_result( apply( get_name_from_numerical_id(X),[NumID] ) )	  	
		             ],
		    out_arg ==> [person(ID,R,O,W)]
        ],
        
        [
		    id ==> check_result(RecognizedPerson),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => success
			  ],
			in_arg ==> [person(ID,R,O,W)],
			diag_mod ==> recognize_body(_,_,RecognizedPerson,person(ID,R,O,W),success)
		],
       
        %Case 2, The name received has not a numerical id in the database 
        [
		    id ==> recognize(X,unknown),
		    type ==> neutral,
		    arcs ==> [
                                empty: empty => error  	
		             ],
		    diag_mod ==> recognize_body(_,_,_,_,invalid_name)
        ],
        
        %Case 3, The name received has a numerical id in the database, so it will search detected persons 
        
        [
		    id ==> recognize([],Name_num),
		    type ==> neutral,
		    arcs ==> [
                                empty:empty => error 	
		             ],
		     diag_mod ==> recognize_body(_,_,_,_,not_found)
		             
        ],
        
        %Check identity of first person in list, if Name_num is NumID then the person has been found and goes to success, 
        %else goes to recognize with the rest of persons
        [
		    id ==> recognize([person(ID,R,O,W)|T],Name_num),
		    type ==> recognize_body(ID,W),
		    arcs ==> [
                                recognized(NumID):empty => apply( compare_body_id(X1,X2,List), [Name_num,NumID,T] )	  	
		             ],
		    out_arg ==> [person(ID,R,O,W)]
        ],
        
        [
		    id ==> retrieve_data,
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => success
			  ],
			in_arg ==> [person(ID,R,O,W)],
			diag_mod ==> recognize_body(_,_,_,person(ID,R,O,W),success)
		],      
        
			
		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[
	    
	]

   ). 
