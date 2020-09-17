%Dispatch orders and failed orders
diag_mod(dispatch_orders,
[
           
    %Get list of orders from KB           
    [
            id ==> get_list_of_orders,	
            type ==> neutral,
            arcs ==> [
                    empty : say('okey') => dispatch(  apply(get_list_of_orders,[])  )
                    ]
    ],   
    
    %Dispatching orders one by one
    [
            id ==> dispatch([]),	
            type ==> neutral,
            arcs ==> [
                    %empty : [say('I finish delivering. My knowledge base is updated.')] => verify_failed_orders
                    empty : empty => verify_failed_orders
                    ]
    ],   
    
    [
            id ==> dispatch([bring(Object)|T]),	
            type ==> neutral,
            arcs ==> [
                    empty : [say(['I will deliver ', Object])] => nav_shelf(Object,T)
%                    empty : [say(['I will deliver ', Object])] => observe_scene(Object,T)
                    ]
    ],   
              
    %Going to shelf where the object is
    [
            id ==> nav_shelf(Object,T),
            type ==> recursive,
            embedded_dm ==> move(apply( get_shelf_of_an_object(O),[Object] ),Status),
            arcs ==> [
            	    success : [say('Reached shelf.'),tiltv(-30.0),set(last_tilt,-30.0)] => observe_scene(Object,T),
                    error : [say('I could not reach shelf. Trying again.')] => nav_shelf(Object,T)
                    ]
    ],   

    %Observing the visual scene to update knowledge base
    [
            id ==> observe_scene(Object,T),
            type ==> recursive,
            embedded_dm ==> see_object(X,object,Found_Objects,Status),
            arcs ==> [
            	    success : [say('I am seeing some objects. Updating knowledge base.')] => update_object_in_kb(Found_Objects,Object,T),
                    error : [say('I did not see any objects. Trying again.')] => observe_scene(Object,T)
                    ]
    ],   

    %For every object seen, update knowledge base
    [
            id ==> update_object_in_kb([],Object,T),	
            type ==> neutral,
            arcs ==> [
                    empty : [say(['Finished updating knowledge base. Delivering ', Object])] => nav_order(Object,T)
%                    empty : [say(['Finished updating knowledge base. Delivering ', Object])] => hand(Object,T)
                    ]
    ],   

    [
            id ==> update_object_in_kb([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|TFull],Object,T),	
            type ==> neutral,
            arcs ==> [
                    empty : empty => apply(when(If,TrueVal,FalseVal),[Object==Name,object_asked_for([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|TFull],Object,T),not_object_asked_for([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|TFull],Object,T)] )
                    ]
    ],   

    %If the object seen is the one asked for, pick it up and update KB
    [
            id ==> object_asked_for([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|TFull],Object,T),
            type ==> neutral,
            arcs ==> [
                    empty : [say(['Grabbing the ', Name]),apply( update_object_inv_in_KB(O,I),[Object,0] )] => grab(object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score),TFull,Object,T)
                    ]
    ],   

    [  
            id ==> grab(ObjectFull,TFull,Object,T),
            type ==> recursive,
            embedded_dm ==> take(ObjectFull, right, ObjTaken, Status),
            arcs ==> [
                    success : [say(['I finished grasping the ', Object]),apply( remove_order(X),[Object] ),robotheight(1.30),set(last_height,1.30),tiltv(0.0),set(last_tilt,0.0)] => update_object_in_kb(TFull,Object,T),
                    error : [say('I did not grasp it. Trying again.')] => grab(ObjectFull,TFull,Object,T)				
                    ]
    ],

    %If the object seen is NOT the one asked for, just update KB
    [
            id ==> not_object_asked_for([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|TFull],Object,T),
            type ==> neutral,
            arcs ==> [
                    empty : [say(['Updating ', Name]),apply( update_object_inv_in_KB(O,I),[Name,1] ), apply( update_object_graspable_in_KB(O,Q),[Name,[Q1,Q2,Q3,Q4]] )] => update_object_in_kb(TFull,Object,T)
                    ]
    ],   

    %When finished observing scene and picking up object,
    %return to starting position to hand over object
    [
            id ==> nav_order(Object,T),
            type ==> recursive,
            embedded_dm ==> move(start,Status),
            arcs ==> [
            	    success : [say(['Reached starting position. Handing ', Object])] => hand(Object,T),
                    error : [say('I could not reach starting position. Trying again.')] => nav_order(Object,T)
                    ]
    ],   

    [  
            id ==> hand(Object,T),
            type ==> recursive,
            embedded_dm ==> relieve(right, Status),
            arcs ==> [
                    success : [get(which_orders_checking, Dispatch)] => Dispatch,
                    error : empty => hand(Object,T)
                    ]
    ],

    %When finished dispatching orders, check for failed orders
    [
            id ==> verify_failed_orders,	
            type ==> neutral,
            arcs ==> [
                    empty : [set(which_orders_checking, dispatch_failed(T))] => dispatch_failed(  apply(get_list_of_failed_orders,[])  )
                    ]
    ],   
    
    [
            id ==> dispatch_failed([]),	
            type ==> neutral,
            arcs ==> [
                    empty : empty => success
                    ]
    ],   
    
    [  
      		id ==> dispatch_failed([bring(Object)|T]),
      		type ==> recursive,
      		embedded_dm ==> ask(['There was ', Object, ' in the shelf. Do you want me to bring it?'],yesno,false,2,ResOut,Status),
      		arcs ==> [
        			success : empty => dispatch_failed_bring(ResOut,[bring(Object)|T]),
        			error : [say('I did not understood')] => fs
				
      			]
     ],

    [
            id ==> dispatch_failed_bring(yes,[bring(Object)|T]),	
            type ==> neutral,
            arcs ==> [
                    empty : [say(['I will deliver ', Object])] => nav_shelf(Object,T)
%                    empty : [say(['I will deliver ', Object])] => observe_scene(Object,T)
                    ]
    ],   

    [
            id ==> dispatch_failed_bring(no,[bring(Object)|T]),	
            type ==> neutral,
            arcs ==> [
                    empty : empty => dispatch_failed(T)
                    ]
    ],   

    [
            id ==> success,
            type ==> final
    ],
     
    [
            id ==> error,
            type ==> final
    ]     
     
  ],

  % Second argument: list of local variables
  [
    which_orders_checking ==> dispatch(T)
  ]

).	

