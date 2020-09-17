%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preference demo functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parser
preferences_demo_parser('i had a bad day'):-
    assign_func_value(bad_day).

preferences_demo_parser('i had a good day'):-
    assign_func_value(good_day).

preferences_demo_parser('bring me a coke and something to eat'):-
    assign_func_value([coke,food]).

    
    
%% Update KB with user's property 'back_from_work'
upd_KB_back_from_work:-
   open_kb(KB),
   add_object_property(user,back_from_work,yes,KB,NewKB),
   save_kb(NewKB),
   assign_func_value(empty).



%% Update KB with user's property 'day'
update_KB_users_day(Day):-
   open_kb(KB),
   (Day==good_day ->
      add_object_property(user,good_day,yes,KB,NewKB)
   |otherwise ->
      add_object_property(user,bad_day,yes,KB,NewKB)
   ),
   save_kb(NewKB),
   assign_func_value(empty).
   
   

%% Gets the object and class corresponding to 'Element'
get_obj_class(Element,KB,Object,Class):-
    there_is_object(Element,KB,Val1),
    (Val1==yes ->
	 Object = Element,	 
         class_of_an_object(Element,KB,Class)
     | otherwise ->
         Object = no_object,
         there_is_class(Element,KB,Val2),
         (Val2==yes ->
	      Class = Element
          | otherwise ->
              Class = no_class
         )
     ).



%% Update KB given the list of comestibles asked by the user
upd_kb_user_asked([]):-
    assign_func_value(empty).

upd_kb_user_asked([Item|More]):-
    aux_upd_kb_user_0(Item),
    upd_kb_user_asked(More).

aux_upd_kb_user_0(Element):-
    open_kb(OriKB),
    get_obj_class(Element,OriKB,Object,Class),
    aux_upd_kb_user_1(OriKB,NewKB,Object,Class),
    save_kb(NewKB).

aux_upd_kb_user_1(KB,KB,_,no_class).
      
aux_upd_kb_user_1(KB_0,KB_1,no_object,_) :-
   object_property_value(user,asked_comestible,KB_0,Val),%% Get in Val the value of propty asked_comestible of user
   aux_upd_kb_user_2(Val,KB_0,KB_1).
      
aux_upd_kb_user_1(KB_0,KB_1,Obj,Class) :-
   object_property_value(user,asked_comestible,KB_0,Val),
   aux_upd_kb_user_2(Val,KB_0,Tmp_KB),
   add_class_property(Class,asked,Obj,Tmp_KB,KB_1).
   
aux_upd_kb_user_2(unknown,KB,KB1):-
   add_object_property(user,asked_comestible,yes,KB,KB1). %% Add propty asked_comestible to user 

aux_upd_kb_user_2(_,KB,KB).



%% This function consults the preferences in the KB for
%% 'Object' (or 'Class' if 'Object' is not defined) with
%% respect to the property 'Pref_Name.'
%% RETURN THE PREFERRED ELEMENT AND ITS ARGUMENT 'ELEMENT' IN A LIST
consult_preference(Element,Pref_Name):-
   open_kb(KB),
   get_obj_class(Element,KB,Object,Class), 
   (Object==no_object ->
      (Class==no_class ->
         Pref_elem = unknown
       | otherwise ->
         class_property_value(Class,Pref_Name,KB,Pref_elem)
      )
    | otherwise ->
      object_property_value(Object,Pref_Name,KB,Pref_elem)
   ),
   assign_func_value([Pref_elem,Object]).


   
%% This function consults the preferences in the KB for
%% 'Object' (or 'Class' if 'Object' is not defined) with
%% respect to the property 'Pref_Name'.
%% RETURNS A LIST OF PREFERENCES 
consult_preferences_list(Element,Pref_Name):-
   open_kb(KB),
   get_obj_class(Element,KB,Object,Class), 
   (Object==no_object ->
      (Class==no_class ->
         PrefList = []
       | otherwise ->
         class_property_list(Class,Pref_Name,KB,PrefList)
      )
    | otherwise ->
      object_property_list(Object,Pref_Name,KB,PrefList)
   ),
   assign_func_value(PrefList).



%% This function returns the question to be asked to the user
%% to decide between E or Pref_elem 
prompt_user_to_decide(E,Pref_elem):-
    assign_func_value(['You asked for ',E, ' but ',Pref_elem, ' is preferred ', 'do you want ',Pref_elem,'?']).
     
     
     
%% The text Golem says when an element is added to the order
add_elem_text(Elem):-
    assign_func_value(['The preferred item ',Elem,' was added to the order']).



%% The text Golem says when choosing 'Obj1' over 'Obj2'
choice_text(Obj1,Obj2):-
    assign_func_value(['You chose ',Obj1, ' over ',Obj2]).

 

%% Returns the head of a list, or 'empty_list' if the list
%% is empty, or 'non_list' if the argument is not a list
head_of_list([]):-
    assign_func_value(empty_list).
    
head_of_list([H|_]):-
    assign_func_value(H).
    
head_of_list(_):-
    assign_func_value(non_list).
    
    
    
%% Given the list of 'Locations' and 'Remaining_Locs'
%% this function determines the last location visited where
%% objects were seen
get_current_position([],_):-
   assign_func_value(empty).
     
get_current_position([Loc|MoreLocs],MoreLocs):-
    assign_func_value(Loc).
    
get_current_position([_|MoreLocs],Remaining_Locs):-
    get_current_position(MoreLocs,Remaining_Locs).
     


%% We update the KB such that the objects in 'List'
%% are 'last_seen' in 'NewLoc'      
update_locations([],_):-
    assign_func_value(empty).
    
update_locations(List,NewLoc):-
    open_kb(KB),
    aux_update_loc(List,NewLoc,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).
    
aux_update_loc([],_,NewKB,NewKB).

aux_update_loc([object(Obj,_,_,_,_,_,_,_,_)|More],NewLoc,KB,FinalKB):-
    add_object_property(Obj,last_seen,NewLoc,KB,NewKB),
    aux_update_loc(More,NewLoc,NewKB,FinalKB).
         


%% This function determines whether 'Obj' is part of 
%% the list of objects given in the second argument          
object_present_scene(_,[]):-
    assign_func_value(not_found).

object_present_scene(Obj,[object(Obj,X,Y,Z,O1,O2,O3,O4,C)|_]):-
    assign_func_value(object(Obj,X,Y,Z,O1,O2,O3,O4,C)).

object_present_scene(Obj,[_|Tail]):-
    object_present_scene(Obj,Tail).
  
      

%% Reset 'Object' last_seen location once it is taken
reset_obj_loc(Object):-
   open_kb(KB),
   rm_object_property(Object,last_seen,KB,NewKB),
   save_kb(NewKB),
   assign_func_value(empty).   


    
%% Get the value of 'Propty' from 'Obj'
get_val_pref_propty(Obj,Propty):-
    open_kb(KB),
    object_property_value(Obj,Propty,KB,Value),
    assign_func_value(Value).
    
    

%% Swap the values of preferences for 'Loc1' and 'Loc2' in 'Obj'
upd_kb_pref(Obj,Loc1,Loc2):-
    open_kb(KB),
    object_property_preference_value(Obj,'-'=>>loc=>Loc1,KB,W1),
    object_property_preference_value(Obj,'-'=>>loc=>Loc2,KB,W2),
    change_weight_object_property_preference(Obj,'-'=>>loc=>Loc1,W2,KB,KB_Tmp),
    change_weight_object_property_preference(Obj,'-'=>>loc=>Loc2,W1,KB_Tmp,New_KB),
    save_kb(New_KB),
    assign_func_value(empty).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preference demo ends here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
