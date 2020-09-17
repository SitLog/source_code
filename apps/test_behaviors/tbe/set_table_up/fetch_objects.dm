% Set a table and clean it up
% Author: Noe Hernandez
diag_mod(fetch_objects(List, Source, Dst), 
[
    %% Initial situation
    [
    id ==> is,	
    type ==> neutral,
    arcs ==> [
             empty : [say(['I will take objects from the', Source, 'to the', Dst])] => find_objs(List) 
             ]
    ],
    
    %%
    %% If there are no more objects to fetch, we examine Golem's right hand to see if he got something.
    %% If so, Golem releases such an object. But if he has nothing, we run a check to exit with success
    %% or error
    [
    id ==> find_objs([]),	
    type ==> neutral,
    arcs ==> [
             empty : [get(right_arm, Obj_right),
                      apply( height_of_a_delivering_point(P,H),[Dst, Value] )] 
                     => apply( when(If, True, False), [Obj_right == free,check_flag,release(Value)] )
             ]
    ],
    
    %%
    %% We check the task_flag to determine if Golem fetched at least one object, in that case
    %% we return success. If no object was fetched, we return error. Also, Golem moves to Dst.
    [
    id ==> check_flag,	
    type ==> recursive,
    embedded_dm ==> move(Dst, _),
    arcs ==> [
             success : [get(task_flag, Flag_Val)] 
                     => apply( when(If, True, False), [Flag_Val,success,error] ),
             error   : empty => check_flag
             ]
    ],	 

    %%
    %% Golem finds the first object in List, then he takes it if such an object is within Golem's reach
    [
    id ==> find_objs([Obj_Name|More_Objs]),	
    type ==> recursive,
    embedded_dm ==> find(object, [Obj_Name], [Source], [0.0], [-5.0, -30.0], object, [Object|Rest], _, false, false, false, _),
    arcs ==> [
             success : [set(objects, More_Objs),
                        get(brazo, Arm)
                       ] 
                     => take_obj(Object, Arm, Obj_Name, More_Objs),
             error   : [set(objects, More_Objs)] => find_objs(More_Objs)
             ]
    ],
    
    %%
    %% Golem takes an object with right hand. If successful, it finds an object to
    %% take it with left hand. If not, it tries to take such an object again
    [
    id ==> take_obj(FndObj, right, Objeto_Nombre, More),
    type ==> recursive,
    embedded_dm ==> take(FndObj, right, _, _),
    arcs ==> [
             success : [robotheight(1.35),
                        set(last_height,1.35),
                        advance_fine(-0.15, _),
                        set(brazo, left)] 
                     => find_objs(More),
             error   : [robotheight(1.35),
                        set(last_height,1.35),
                        advance_fine(-0.15, _)]
                     => find_objs([Objeto_Nombre|More])
             ]
    ],
    
    %%
    %% Golem takes an object with left hand. If successful, Golem releases the objects
    %% he may have. If unsuccessful, Golem tries again to find the object and 
    %% take it with his left hand
    [
    id ==> take_obj(FndObj, left, Objeto_Nombre, More),
    type ==> recursive,
    embedded_dm ==> take(FndObj, left, _, _),
    arcs ==> [
             success : [robotheight(1.35),
                        set(last_height,1.35),
                        set(brazo,right),
                        apply( height_of_a_delivering_point(P,H),[Dst, Value] )]
                     => release( Value ),  
             error   : [robotheight(1.35),
                        set(last_height,1.35),
                        advance_fine(-0.15, _)] 
                     => find_objs([Objeto_Nombre|More]) 
             ]
    ],
    
    %%
    %% Golem releases the objects he may have in Dst, 
    %% with the proper Height for Dst        
    [  
    id ==> release(Height),
    type ==> recursive,
    embedded_dm ==> usual_release(Dst, Height, true),
    arcs ==> [
             success : [set(task_flag, true), 
                        get(objects, More_Objs)] 
                     => find_objs(More_Objs),
             error   : [get(objects, More_Objs)] => find_objs(More_Objs)
             ]
    ],
    	
    %% Success      
    [
    id ==> success,
    type ==> final
    ],
    
    %% Error
    [
    id ==> error,
    type ==> final
    ]
  ],

% Second argument: list of local variables
  [
     brazo ==> right,
     objects ==> [],
     task_flag ==> false
  ]

).
