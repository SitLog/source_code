% Deliver Task Dialogue Model
%
% 	Description	The robot moves to a certain position and delivers an object to a person or put it on a surface
%	
%	Arguments	Object: label of the object to be delivered (must have a value)
%
%			Position: name of position where the object should be delivered
%
%                       Id: Id of the point where the object is going to be delivered
%
%			Mode: 	handle.- the object is handled to a person
%				    put.- the object is placed on a surface 
%				
%			Status:	
%				    ok .- if the object was correctly delivered
%			       	not_delivered- the object could not be delivered
%				    object_not_in_hands .- the requested object to be delivered is not in hands


diag_mod(deliver(Object, Position, Id, Mode, Status),
[

	    	
	    	% Verify if one of the arms has the object to be delivered
 		    [  
      			id ==> is,
      			type ==> neutral,
			    arcs ==> [
        			empty : assign(Arm, apply(get_hand(Obj), [Object])) => verify(Arm)				
      				]
    		],
    		
    		% If neither hand has the object, finishes
    		[  
      			id ==> verify(none),
      			type ==> neutral,
      			out_arg ==> [object_not_in_hands],
			    arcs ==> [
        			empty : empty => error				
      				]
    		],
    		
	    	
	    	% If the object is in 'right' or 'left' hand  moves to the point
 		    [  
      			id ==> verify(Other),
      			type ==> recursive,
			    out_arg ==> [Move_Status],
			    embedded_dm ==> move(Position,Move_Status),
      			arcs ==> [
        			success : assign(Arm, apply(get_hand(Obj), [Object])) => relieve(Mode,Arm),
        			error : empty => error					
      				]
    		],


		    % If Mode is put, gets the height of the surface to put the object
		    [  
      			id ==> relieve(put,Arm),
      			type ==> neutral,
			    arcs ==> [
        			empty : [
        				apply( height_of_a_delivering_point(P,H) , [Id,Height] ),
        				robotheight(Height),
					    set(last_height,Height),
					    sleep
        				] => relieve(handle,Arm)
        			]
    		],

		    % Relieve the object
 		    [  
      			id ==> relieve(handle,Arm),
      			type ==> recursive,
			    out_arg ==> [Relieve_Status],
		    	embedded_dm ==> relieve(Arm,Relieve_Status),
      			arcs ==> [
        			success : [robotheight(1.20),set(last_height,1.20)] => success,
        			error : [robotheight(1.20),set(last_height,1.20)] => error					
      				]
    		],

		    [
		        id ==> success,
		        type ==> final,
		        diag_mod ==> deliver(_, _, _, _, ok)
         	],

		    [
		        id ==> error,
		        type ==> final,
		        in_arg ==> [DeliverStatus],
		        diag_mod ==> deliver(_, _, _, _, DeliverStatus)
		    ]
	     		

	    ], 

	% List of Local Variables
	[]

   ). 
