/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional AutÃ³noma de MÃ©xico)
    Copyright (C) 2012  Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*********************************************************************************/

% not_definedFind the set of classes of an object (botton to top) and its list of prop. (from specific to general) using a TOP-DOWN depth-first strategy
% Initial cal: class = top node
class_of(Object, Class, [Class], Prop_List) :-
  print('Object: '),print(Object),nl,
  member_of_class(Object, Class, _, Prop_List).

class_of(Object, Class, Class_List, Props_List) :-
  print('Object: '),print(Object),nl,
  % Search the tree depth-firts
  sons_of(Class, Sons_of_Class),
  explore_tree(Object, Class, Sons_of_Class, Classes_Son, Props_Son),
  class(Class, _, Class_Props, _),
  append(Classes_Son, [Class], Class_List),
  append(Props_Son, Class_Props, Props_List).

sons_of(Class, Sons_List) :- 
  setof(Sons, class(Sons, Class, _, _), Sons_List). 

% No more sons in this branch
explore_tree(_, [], _, _) :- 
  fail.

% Expand current son
explore_tree(Object, Class, [Current_Son|_], Class_List, Props_List) :-
  class_of(Object, Current_Son, Class_List, Props_List).

% Explore next son
explore_tree(Object, Class, [_|Rest_Sons], Class_List, Props_List) :-
  explore_tree(Object, Class, Rest_Sons, Class_List, Props_List).

% Most specific class of an object with its list of props (from specific to class prop).
member_of_class(Object, Class, Is_a, Prop_List) :- 
  class(Class, Is_a, Class_Props, Instances), 
  check_object(Object, Instances, Object_Props),
  append(Object_Props, Class_Props, Prop_List). 

% Args: Object_ID, Instances, In_Props, Out_Props.
check_object(Object, [], []) :- 
  fail.
check_object(Object, [Instance|_], Local_Props) :- 
  get_feature_kb(id, Instance, Object),
  get_feature_kb(props, Instance, Props),
  check_empty_props(Props, Local_Props).
check_object(Object, [_|Rest], Local_Props) :- 
  check_object(Object, Rest, Local_Props).
check_empty_props(not_defined, []).
check_empty_props(Props, Props).

% Find classes and proerties: strategy BOTTOM-UP

class_of_BU(Object, Top, Class_List, Props_List) :-
  member_of_class(Object, Class, Type, Props),
  collect_upwards(Type, Top, [Class], Props, Class_List,  Props_List).

collect_upwards(Top, Top, Class_List, Props_List, Class_List, Props_List).

collect_upwards(Class, Top, In_Classes, In_Props, Class_List, Props_List) :-
  class(Class, Type, Props, _),
  append(In_Classes, [Class], Next_Classes),
  append(In_Props, Props, Next_Props),
  collect_upwards(Type, Top, Next_Classes, Next_Props, Class_List, Props_List).

% Procedure to ask for whether an arbitrary object has an arbitrary property
% If the property is not defined Val = not_defined
property_value(Object, Top_Class, Property, Val) :- 
  class_of(Object, Top_Class, _, Object_Props),
  get_feature_kb(Property, Object_Props, Val).

%Get Feature Value
get_feature_kb(Feature, [], not_defined).
get_feature_kb(Feature, [Feature => Value|Rest], Value).
get_feature_kb(Feature, [_|Rest], Value) :- 
  get_feature_kb(Feature, Rest, Value), !.

