

% Evaluates the If value in case of true returns TrueVal else FalseVal
when(If,TrueVal,FalseVal):-
  (If ->
    print('True '),print(TrueVal),nl,
    Res = TrueVal
  | otherwise ->
    print('False '),print(FalseVal),nl,
    Res = FalseVal
  ),
  assign_func_value(Res)
.

% Verified if a list achieve size
check_size(List,Size,TrueVal,FalseVal) :-
  length(List,Size_),
%  nl,print('Size: '),print(Size_),print(List),read(DD),
  ( Size_ =< Size-> 
    Res = TrueVal
  | otherwise ->
    Res = FalseVal
  ),
  print('list size'),print(List),print(Res),nl,
  assign_func_value(Res)
.

% Verified time
check_time(ATime,ADay) :-
  get_time(TimeStamp),
  stamp_date_time(TimeStamp,date(Year,Month,Day,Hour,Min,Sec,_,_,_), 0),
  print(Year),nl,
  print(Month),nl,
  print(Day),nl,
  print(Hour),nl,
  print(Min),nl,
  print(Sec),nl,
  ATime = [Hour,Min,Sec],
  ADay = [Day,Month,Year],
  assign_func_value(ATime)
.

include(_, [], Acc, Acc).
include(Pred, [X|R], Acc,News):-
  VP =.. [Pred,X],
  VP,
  include(Pred, R, [X|Acc],News).
include(Pred, [_|R], Acc,News):-
  include(Pred, R, Acc,News).


%%%%%%%%%%%%%%%%%%%%%%%%% Specific RoboCup functions %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%******General functions******%%%%%%
% Function to decide which model to execute given in a test mode or from file
model_to_execute(KB,KB2,File):-
  (mode_exe(test) ->
    Res = KB
  |
    file_search_path(projdir,ProjDir),
    seeing(IN),
    absolute_file_name(File,RULES2,[relative_to(ProjDir)]),
    see(RULES2),
    read_clause([],CLAUSE_LIST),
    seen,
    seeing(IN),
    !,
    CLAUSE_LIST=[Fst|_],
    Res =..[KB2,Fst]
  ),
  assign_func_value(Res)
.

% Function to obtain the first member of the list
first_member([H|T],R):-
  print('H: '),print(H),nl,
  print('T: '),print(T),nl,
  R=H,
  print('R: '),print(R),nl,
  assign_func_value(R).

first_member([],R):-
  R=[],
  print('R: '),print(R),nl,
  assign_func_value(R).

%%%%%%******Movement******%%%%%%
% Function to move to different points and execute certain situation after
go_point([Pt|RPt],Sit1,_,Var):-
  var_op(set(Var,RPt)),
  print('Value: '),print(RPt),nl,
  Res =.. [Sit1,Pt],
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.
go_point([],_,Sit2,_):-
  Res = Sit2,
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.

%Function for knowing if another visual analyze is required because of the previous movement
get_closer_ss(R,Sit1,Sit2,X,Y,Z,T):-
  R = [Angle,Distance],
  print("Angle    to compare: "), print(Angle),nl,
  print("Distance to compare: "), print(Distance),nl,
  ( Angle > 8 ->
    Res =.. [Sit1,Angle],
    print('Res: '),print(Res),nl,
    assign_func_value(Res)
  | Angle < -8 ->
    Res =.. [Sit1,Angle],
    print('Res: '),print(Res),nl,
    assign_func_value(Res)
  | otherwise ->
    ( Distance > 0.65 ->
      Res =.. [Sit1,Angle],
      print('Res: '),print(Res),nl,
      assign_func_value(Res)
    | Distance < 0.4 ->
      Res =.. [Sit1,Angle],
      print('Res: '),print(Res),nl,
      assign_func_value(Res)
    | otherwise ->
      Res =.. [Sit2,X,Y,Z,T],
      print('Res: '),print(Res),nl,
      assign_func_value(Res)
    )
  )
.

%Function for knowing how much must be moved the robot for aproaching to an object
get_closer(R,Rth1,Rth2,Rth3):-
  R = [Angle,Distance],
  print('R: '),print(R),nl,
  %print("Angle    from cam2arm: "), print(Angle),nl,
  %print("Distance from cam2arm: "), print(Distance),nl,
  ( Angle > 8 ->
    Y is Angle,
    ( Distance > 0.55 ->
        print('Distance1: '),print(Distance),nl,
        A is Distance - 0.55,
        Rt2 =.. [Rth2,A,Y],  
        print('Rt2: '),print(Rt2),nl,

        Res = [Rth1,Rt2,Rth3],
        print('Res: '),print(Res),nl,
        assign_func_value(Res)
    | Distance < 0.5 ->
        print('Distance2: '),print(Distance),nl,
        A is Distance - 0.5,  
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
        print('Res: '),print(Res),nl,
        assign_func_value(Res)
    | otherwise ->
        print('Distance3: '),print(Distance),nl,
      A is 0,
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
      print('Res: '),print(Res),nl,
      assign_func_value(Res)
    )  
  | Angle < -8 ->
    Y is Angle,
    ( Distance > 0.55 ->
            print('Distance4: '),print(Distance),nl,

        A is Distance - 0.55,  
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
        print('Res: '),print(Res),nl,
        assign_func_value(Res)
    | Distance < 0.5 ->
            print('Distance5: '),print(Distance),nl,

        A is Distance - 0.5,  
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
        print('Res: '),print(Res),nl,
        assign_func_value(Res)
    | otherwise ->
            print('Distance6: '),print(Distance),nl,

      A is 0,
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
      print('Res: '),print(Res),nl,
      assign_func_value(Res)
    )
  | otherwise ->
    Y is 0,
    ( Distance > 0.55 ->
            print('Distance7: '),print(Distance),nl,

        A is Distance - 0.55,  
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
        print('Res: '),print(Res),nl,
        assign_func_value(Res)
    | Distance < 0.5 ->
            print('Distance8: '),print(Distance),nl,

        A is Distance - 0.5,  
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
        print('Res: '),print(Res),nl,
        assign_func_value(Res)
    | otherwise ->
            print('Distance9: '),print(Distance),nl,

      A is 0,
        Rt2 =.. [Rth2,A,Y],  
        Res = [Rth1,Rt2,Rth3],
      print('Res: '),print(Res),nl,
      assign_func_value(Res)
    )
  )
.

%%%%%%******Database consult******%%%%%%
get_cname(A):-
  print('In get_cname'),nl,
  knowledge_base(KB),
  %print('KB: '),print(KB),nl,
  load_file(KB,KBFile),
  create_env(KBFile),
  ( member(complete_name(A,B),KBFile) ->
    print('A: '), print(A), nl
  | otherwise ->
    B = A
  ),
  % delete KB class clauses
  abolish(class/4),  
  print('B: '),print(B),nl,
  var_op(set(c_name,B)),
  assign_func_value(set(c_name,B))
.

include(_, [], Acc, Acc).
include(Pred, [X|R], Acc,News):-
    VP =.. [Pred,X],
    VP,
    include(Pred, R, [X|Acc],News).
include(Pred, [_|R], Acc,News):-
    include(Pred, R, Acc,News).

get_room_points(Rn) :-
  knowledge_base(KB),
  %print('KB: '),print(KB),nl,
  load_file(KB,KBFile),
  create_env(KBFile),
  member(room(Rn,RoPts),KBFile),
  abolish(class/4),  
  var_op(set(room_p,RoPts)),
  assign_func_value(set(room_p,RoPts))
.

%%%%%%******Speech******%%%%%%

getPred(Pred,[A2,A3]) :-
  Pred =.. [Res,Arg],
  Pred2=.. [Res,Arg,A2,A3],
  print('Result: '),print(Pred2),nl,
  assign_func_value(Pred2)
.

getPred(Pred) :-
  Pred =.. [Res,_], 
  print('Result: '),print(Res),nl,
  assign_func_value(Res)
.

getArg(Pred,Arg) :-
  Pred =.. [_,Arg], 
  print('Result: '),print(Arg),nl,
  assign_func_value(Arg)
.

getExp(Pred,Arg2) :-
  Pred =.. [Res,_], 
  Pred2 =.. [Res,Arg2], 
  print('Result: '),print(Pred2),nl,
  assign_func_value(Pred2)
.

joinPred(Pred,Arg) :-
  Res =.. [Pred,Arg], 
  print('Result: '),print(Res),nl,
  assign_func_value(Res)
.

%%%%%%******Arm******%%%%%%
verify_arm(Sit1,Sit2) :-
  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,
  var_op(get(v_objects,_)),

  ( RVal == nothing ->
    Res = Sit2
  
  | LVal == nothing ->
    Res = Sit2
  | otherwise ->
    Res =.. [Sit1,[]]
  
  ),
 
  print('Result verify arm: '),print(Res),nl,
  assign_func_value(Res)
.  

move_a2arm(R,ArmStr,ID):-
  print('R: '),print(R),nl,
  (ArmStr == right ->
    Arm is 1
  | otherwise ->
    Arm is 2
  ),
  print('Using Arm number: '),print(Arm),nl,
  R =[P,A,D],
  D2 is D + 0.05,
  T is round(D2*10000)/10000,
  T2 is round(A*10000)/10000,
  Res = [say(['Attempting to grab the ',ID,' with my ',ArmStr,' arm']),switcharm(Arm),sleep,platform2arm(P,Arm),sleep,grasp(T2,T)],
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.

%%%%%%%%********Clean Up********%%%%%%%%
%List empty
v_take_object(time,Sit,Sit2):-
  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,
  W = [right,RVal],
  U = [left,LVal],

  ( RVal == nothing ->
    ( LVal == nothing ->
      Res = error(nothing_found,[])
    | otherwise ->
      Z = [U],
      Res =.. [Sit2,Z]
    )
  | LVal == nothing -> 
    ( RVal == nothing ->
      Res = error(nothing_found,[])
    | otherwise ->
      Z = [W],
      Res =.. [Sit2,taken_objects]
    )
  | otherwise ->
    Z = [W,U],
    Res =.. [Sit2,taken_objects]
  ),
  var_op(set(result,Z)),
  print('Var result: '),print(Z),nl,
  print('RES: '),print(Res),nl,
  assign_func_value(Res)
.

%List empty
v_take_object([],Sit,Sit2):-
  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,
  W = [right,RVal],
  U = [left,LVal],

  ( RVal == nothing ->
    ( LVal == nothing ->
      var_op(get(point_v,Pts)),
      ( Pts == [] -> 
        Res = error(nothing_found,[])
      | otherwise ->
        Res =.. [rgo,Pts]
      )
    | otherwise ->
      Z = [U],
      Res =.. [Sit2,Z]
    )
  | LVal == nothing -> 
    ( RVal == nothing ->
      var_op(get(point_v,Pts)),
      ( Pts == [] -> 
        Res = error(nothing_found,[])
      | otherwise ->
        Res =.. [rgo,Pts]
      )
    | otherwise ->
      Z = [W],
      Res =.. [Sit2,taken_objects]
    )
  | otherwise ->
    Z = [W,U],
    Res =.. [Sit2,taken_objects]
  ),
  var_op(set(result,Z)),
  print('Var result: '),print(Z),nl,
  print('RES: '),print(Res),nl,
  assign_func_value(Res)
.

v_take_object([X,Y,Z],Sit,Sit2) :-
  Obj = ['unknown object',X,Y,Z,0,0,0,0,0],
  print('Obj: '),print(Obj),nl,
  %To avoid loop between seeing objects
  var_op(set(actual_obj,Obj)),

  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  Tilt = -50,
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,

  ( RVal == nothing ->
    Res =.. [Sit,Obj,Tilt,[-30],[0,-30,30],right,R]
  | LVal == nothing ->
    Res =.. [Sit,Obj,Tilt,[-30],[0,-45,45],left,R]
  | otherwise ->
    Res =.. [n_take,[]]
  ),
  print('Result: '),print(Res),nl,
  assign_func_value(Res)   
.

v_take_object([Obj|RObj],Sit,Sit2) :-
  knowledge_base(KBFILE),
  %print('KB: '),print(KB),nl,
  load_file(KBFILE,KB),
  create_env(KB),
  print('Obj: '),print(Obj),nl,
  %To avoid loop between seeing objects

  [ID_n,X,Y,Z,A,B,C,F,G]=Obj,
  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  var_op(get(a_tilt,Tilt)),
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,
  member(complete_name(ID_n,ID),KB),
  print('A: '),print(ID_n),nl,
  print('B: '),print(ID),nl,
  var_op(set(c_name,ID)),

  ( RVal == nothing ->
    ( member(product_grasp(ID_n,grasp),KB) ->
      Res =.. [Sit,Obj,Tilt,[-30],[0,-30,30],right,R]
    | member(product_grasp(ID_n,n_grasp),KB) ->
      print('No lo puedo agarrar'),nl   
    | otherwise ->
      print('Nada '),nl,
      Res =.. [rfind,[]]
    )
  | LVal == nothing ->
    ( member(product_grasp(ID_n,grasp),KB) ->
      print('Uno '),nl,
      Res =.. [Sit,Obj,Tilt,[-30],[0,-45,45],left,R]
    | member(product_grasp(ID_n,n_grasp),KB) ->
      print('No lo puedo agarrar'),nl
    | otherwise ->
      print('Nada '),nl,
      Res =.. [rfind,[]]
    )
  | otherwise ->
    Res =.. [n_take,[]]
  ),
  abolish(class/4),  
  print('Result: '),print(Res),nl,
  assign_func_value(Res)   
.

v_take_object(Obj,Sit,Sit2) :-
  knowledge_base(KBFILE),
  %print('KB: '),print(KB),nl,
  load_file(KBFILE,KB),
  create_env(KB),
  print('Obj: '),print(Obj),nl,
  %To avoid loop between seeing objects

  [ID_n,X,Y,Z,A,B,C,F,G]=Obj,
  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  var_op(get(a_tilt,Tilt)),
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,
  member(complete_name(ID_n,ID),KB),
  print('A: '),print(ID_n),nl,
  print('B: '),print(ID),nl,
  var_op(set(c_name,ID)),

  ( RVal == nothing ->
    ( member(product_grasp(ID_n,grasp),KB) ->
      Res =.. [Sit,Obj,Tilt,[-30],[0,-30,30],right,R]
    | member(product_grasp(ID_n,n_grasp),KB) ->
      print('No lo puedo agarrar'),nl   
    | otherwise ->
      print('Nada '),nl,
      Res =.. [rfind,[]]
    )
  | LVal == nothing ->
    ( member(product_grasp(ID_n,grasp),KB) ->
      print('Uno '),nl,
      Res =.. [Sit,Obj,Tilt,[-30],[0,-45,45],left,R]
    | member(product_grasp(ID_n,n_grasp),KB) ->
      print('No lo puedo agarrar'),nl
    | otherwise ->
      print('Nada '),nl,
      Res =.. [rfind,[]]
    )
  | otherwise ->
    Res =.. [n_take,[]]
  ),
  abolish(class/4),  
  print('Result: '),print(Res),nl,
  assign_func_value(Res)   
.

distance_obtain([Obj|Rts],Sit,Sit2) :-
  print('Obj: '),print(Obj),nl,
  [Pos,Object] = Obj,
  print('Object: '),print(Object),nl,
  knowledge_base(KBFILE),
  %print('KB: '),print(KB),nl,
  load_file(KBFILE,KB),
  create_env(KB),
  %print('Object: '),print(Object),nl, 
  %print('Obj: '),print(Obj),nl, 
  %member(complete_name(Object_an,Object),KB),
  %print('A: '),print(Object_an),nl,
  %print('B: '),print(Object),nl,

  ( member(product_type(Object,C),KB) ->
    ( member(location(Room,C),KB) ->
      ( member(room_deliver(Room,Pt),KB) ->
        Pt = [Pt_],
        Res =.. [Sit,Pt_]
      )
    )
  | otherwise ->
    Res = Sit2 
  ),
  abolish(class/4),  
  var_op(set(recovered,Rts)),
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.
distance_obtain([],Sit,Sit2) :-
  var_op(get(pos,Po)),
  print('Pos: '),print(Po),nl,
  var_op(get(obj_pos,Obl)),
  print('obj_pos: '),print(Obl),nl,
  ( Obl == [] ->
    Res = n5
  | otherwise -> 
    ( Po == null ->
      Res = n5
    | otherwise ->
      length(Po,Po_),
      print('Size: '),print(Po_),nl,
      ( Po_ > 1 ->
         Po = [A,B],
        ( B < A ->
          print('Change'),nl,
          reverse(Obl,Por),
          var_op(set(obj_pos,Por))
        | otherwise ->
          print('No change'),nl
        )
      |  Po_ == 1 -> 
        print('Just one'),nl       
      | otherwise ->
        print('No other'),nl
      ),
      Res = Sit2
    )
  ),
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.

collect_positions(Re):-
  print('Distance: '),print(Re),nl,
  var_op(get(pos,Po)),
  ( Po == null ->
    PO = [Re]
  | otherwise ->
    Po_ = [Re],
    append(Po,Po_,PO)
  ),
  var_op(set(pos,PO)),
  assign_func_value(set(pos,PO))
.


location_obtain([Obj|Rts],R,Sit,Sit2) :-
  print('Obj: '),print(Obj),nl,
  [Pos,Object] = Obj,
  print('Object: '),print(Object),nl,
  knowledge_base(KBFILE),
  %print('KB: '),print(KB),nl,
  load_file(KBFILE,KB),
  create_env(KB),
  print('Object: '),print(Object),nl, 
  %member(complete_name(Object_an,Object),KB),
  %print('A: '),print(Object_an),nl,
  %print('B: '),print(Object),nl,
  %print('Obj: '),print(Obj),nl, 
  ( member(product_type(Object,C),KB) ->
    ( member(location(Room,C),KB) ->
      (Pos == right -> Pos_n = 1 | Pos == left -> Pos_n = 2),
      Res =.. [Sit,Object,Room,Rts,R,Pos]
    )
  | otherwise ->
    print('Outside'),nl,
    Res = Sit2 
  ),
  abolish(class/4),
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.
location_obtain([],R,Sit,Sit2) :-
  Res = Sit2,
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.

%Function for obtainig the points to visit in a given room
obtain_points_deliver(R,Sit,X,Y,LRoom,Arm) :-
  print('Room: '),print(R),nl,
  knowledge_base(KBFILE),
  %print('KB: '),print(KB),nl,
  load_file(KBFILE,KB),
  create_env(KB),
  member(room_deliver(R,Pts),KB),
  print('Points: '),print(Pts),nl, 
  Res =.. [Sit,Pts,X,Y,LRoom,Arm],
  print('Res: '),print(Res),nl,
  abolish(class/4),
  assign_func_value(Res)
.

%%%%%%%%********Cocktail Party********%%%%%%%%
check_order([HOrder|ROrder],Sit1,Sit2):-
  print('First Order: '),print(HOrder),nl,
  HOrder = [Name,Drink],

  var_op(set(order,ROrder)),
  Res =.. [Sit1,Drink],
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.
check_order([],Sit1,Sit2):-
  var_op(get(right, RVal)),
  var_op(get(left, LVal)),
  print('RVal: '),print(RVal),nl,
  print('LVal: '),print(LVal),nl,
  W = [right,RVal],
  U = [left,LVal],

  ( RVal == nothing ->
    ( LVal == nothing ->
      var_op(get(point_v,Pts)),
      ( Pts == [] -> 
        Res = ferr
      | otherwise ->
        Res =.. [ngo,Pts]
      )
    | otherwise ->
      Z = [U],
      Res =.. [fe,Z]
    )
  | LVal == nothing -> 
    ( RVal == nothing ->
      var_op(get(point_v,Pts)),
      ( Pts == [] -> 
        Res = ferr
      | otherwise ->
        Res =.. [ngo,Pts]
      )
    | otherwise ->
      Z = [W],
      Res =.. [fe,Z]
    )
  | otherwise ->
    Z = [W,U],
    Res =.. [fe,Z]
  ),
  abolish(class/4),
  print('RES: '),print(Res),nl,
  assign_func_value(Res)
.

review_order(N,TObject,Order):-
  print('TObject: '),print(TObject),nl,
  print('Order: '),print(Order),nl,
  NN = [N,X],
  print('Name before: '),print(N),nl,
  ( member(NN,Order) ->
    print('Name: '),print(N),nl,
    print('I have order'),nl,
  
    knowledge_base(KBFILE),
    %print('KB: '),print(KB),nl,
    load_file(KBFILE,KB),
    create_env(KB),
    print('Object: '),print(X),nl, 
    ( member(complete_name(X,A),KB),
      print('B: '),print(A),nl
    | otherwise -> 
      A = X
    ),

    NTO = [ArmS,X],

    ( member(NTO,TObject) ->
      Mess = ['Hello',N],
      print('Arm: '),print(ArmS),nl,
      print('Object: '),print(A),nl, 
      DObject = A,
      NSit = rgive(DObject,ArmS)
    | otherwise ->
      Mess = ['I am sorry',N,'I dont have anything for you yet'],
      NSit = ngo
    )
  | otherwise ->
      Mess = ['I will take your order sun'],
      NSit = ridentify_p
  ),
  var_op(set(message,Mess)),
  var_op(set(n_sit,NSit)),
  assign_func_value(set(n_sit,NSit))
.

look_for_people(Sit1,Sit2):-
  print('In look for people'),nl,
  var_op(get(point_v_n,Pts)),
  var_op(get(taken_n,TObject)),
  var_op(get(order_n,Order)),
  ( TObject == [] ->
    Res = fe
  | Pts == [] ->
    Res = fe
  | otherwise ->
    Pts = [TPt|HPt],
    TPt = [Namep,Pt], 
    TOb = [Arm,Or],
    TOr = [Namep,Or],

    print('TPt: '),print(TPt),nl, % Name,Pt

    var_op(set(point_v_n,HPt)),
    ( member(TOr,Order) ->
        print('TOr: '),print(TOr),nl, % Name,Obj
      ( member(TOb,TObject) ->
        print('TOb: '),print(TOb),nl, % Obj,right
        print('Name: '),print(Namep),nl,
        print('Point: '),print(Pt),nl,
        Res =.. [Sit1,Pt]
      | otherwise ->
        print('No point'),nl,
        var_op(set(point_v_n,HPt)),
        var_op(set(taken_n,HOb)),
        Res = ngo
      )
    | otherwise ->
      var_op(set(point_v_n,HPt)),
      Res = ngo
    )
  ),
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.

% Identifies if an object of certain type is close from the origin of the sound
is_close(A,X,Y,Z,Type,Id,Thres) :-
  map_object(Type,Id,X2,Y2,Z2),
  A2    is atan((Y2-Y)/(X2-X)),
  Dist  is sqrt(abs((Y2-Y)*(Y2-Y)+(X2-X)*(X2-X))),
  Ratio is abs((A2-A)),
  T is (-0.4606*log(0.336486*Dist)),
  Ratio < T,!.

% Identifies course
get_source(X,Y,Z,Angle,Type,Thres):-
  correct_angle(Angle,Angle_),
  (is_close(Angle_,X,Y,Z,Type,Id,Thres) ->
  	Angle__ is round(Angle_*10)/10,
    Res  = (Angle__,Id)
  | 
    Res  = false
  ),
  assign_func_value(Res)
.

valid_angle(A):-
    A < 360.

valid_angle2(A):-
	A < 50,
	A > -50.

% Correct angle in to the right segment
correct_angle(A,A_):-
  ( A > 3.1416 ->
    A1 is -2*3.1416+A
  |
    A1 is A
  ),
  ( A1 < -3.1416 ->
    A_ is 2*3.1416+A1
  |
    A_ is A1
  )
.

%%%%%%% GPSR %%%%%%%%

%% se le cambio el nombre para resolver conflicto
actions_reasoner2(Actions_List) :-
  print('Executing actions_reasoner'), nl,
  print('Explicit Action List: '), print(Actions_List), nl,
	
  Next_Situation =.. [dispatch|[Actions_List]],

  print('Next_Situation: '),print(Next_Situation), nl,


  % Assign function value
  assign_func_value(Next_Situation).


parse(In,Out):-
  % Calling the interpreter
|  ( mode_exe(test) -> 
    read(Out)
  | otherwise-> 
    oaa_Solve(gfInterpret(In,Out),[blocking(true)])
  ),
  assign_func_value([Out]).

%%%%%%%% Follow Me %%%%%%%%
% Random message errors function
random_error_message(Rth,Opts) :-
  get_random_element(Opts,Z),
  Capt =.. [Rth,Z],
  Res =.. [caption,Capt],
  assign_func_value(Res).

% Identifies if an object of certain type is close from the origin of the sound
is_close(A,X,Y,Z,Type,Id,Thres) :-
  map_object(Type,Id,X2,Y2,Z2),
  A2    is atan((Y2-Y)/(X2-X)),
  Dist  is sqrt(abs((Y2-Y)*(Y2-Y)+(X2-X)*(X2-X))),
  Ratio is abs((A2-A)),
  T is (-0.4606*log(0.336486*Dist)),
  Ratio < T,!.

% Identifies course
get_source(X,Y,Z,Angle,Type,Thres):-
  correct_angle(Angle,Angle_),
  (is_close(Angle_,X,Y,Z,Type,Id,Thres) ->
  	Angle__ is round(Angle_*10)/10,
    Res  = (Angle__,Id)
  | 
    Res  = false
  ),
  assign_func_value(Res)
.

vete_al_punto(Angle,Dist,Dist2):-
  Dist2 is Dist/100,
  A2 is -Angle,
  Res = get_close(Dist2,A2),
  assign_func_value(Res)
.

filter(Pred,List,List_):-
  print(List),
  include(Pred,List,[],List_),
  print(List_),
  assign_func_value([List_])
.

%%%%%%%%%%%%%%%%%%%%%%%% Function get_location %%%%%%%%%%%%%%%%%%%%%%%%
% Get the list of positions in a place (e.g., kitchen, livingroom, etc.)

% The argument is already a list of points
get_locations([]) :-
  assign_func_value([]).
get_locations(Positions_List) :-
  Positions_List =.. ['.'|_],
  assign_func_value(Positions_List).

get_locations(Place) :-
         
  load_file('$GOLEM_IIMAS_HOME/agents/SitLog/knowledge_base/KB.pl', KB),
  assert(knowledge_base(KB)),

  % create KB environment
  knowledge_base(KB),
  create_env(KB),
	
  consult_KB(Place, Positions),

  print('Positions: '), print(Positions), nl,
  % delete KB class clauses
  abolish(class/4),
  % Assign function value: List of positions in place
  assign_func_value(Positions).

% If the place is concrete (e.g. a specific room or table)
consult_KB(Place, Positions_List) :-
  property_value(Place, entity, positions, Positions_List).

% If the place is generic (i.e., get the first instance object of the class as a default)
consult_KB(Place, Positions_List) :-
  class(Place, _, _, [First|Rest]),
  First =.. [Object|_],
  consult_KB(Object, Positions_List).

consult_KB(Place, location_error) :-
  print('Place not defined in KB: '), print(Place), nl.


%%% Function face_in_scene %%%

face_in_scene(X,Y):-
	var(X),
	assign_func_value([Y]).

face_in_scene(X,X):-
	assign_func_value(ok).

face_in_scene(X,Y):-
	assign_func_value(not_found).

%%%%%%%%%%%%%%%%%%%%%%%% Function objects_in_scene %%%%%%%%%%%%%%%%%%%%%%%%
% format
%
%	objects_in_scene(Objects, Scene)
%
% Objects is a list of objects IDs that are sought in a scene: [Object_1, Object_2, É]
% The Function value is the list of pair [[obj_1, pars_1], [obj_2, pars_2],É] of Objects that appear in Scene
%
% Format List of object in scene [Obj_1, Obj_2,É, Obj_n] where Obj_i is [Object_ID, Pars]
%
% If scene is empty return 'empty_scene'
objects_in_scene(Objects, []) :-
  assign_func_value(empty_scene).

% If Objects is not specified return the full scene: list of all pairs [Object_ID, Pars] in scene
objects_in_scene(Objects, Scene) :-
  var(Objects),
  assign_func_value(Scene).

% Otherwise return all member of Objects that are included in Scene
% Out_Scene is the list of pars [obj, pars] of all objects in Scene
objects_in_scene(Objects, Scene) :-
  analyze_scene(Objects, Scene, [], Out_Scene).

analyze_scene([], _, Out_Scene, Out_Scene) :-
  assign_value_scene(Out_Scene).
analyze_scene([Object_ID|Rest_Objects], Scene, Acc_Objects, Out_Scene) :-
  atom(Object_ID),
  get_object_scene(Object_ID, Scene, Object),
  add_to_scene(Object, Acc_Objects, New_Objects),
  analyze_scene(Rest_Objects, Scene, New_Objects, Out_Scene).
analyze_scene(Oject_ID, _, _, _) :-
  print('Fatal error in objects_in_scene: Object_ID is not an atom! '), termina_diag_manager.

assign_value_scene([]) :-
  assign_func_value(not_found).
assign_value_scene(Out_Scene) :-
  assign_func_value(Out_Scene).

add_to_scene(not_found, Acc_Objects, Acc_Objects).
add_to_scene(Object, Acc_Objects, New_Objects) :-
  append(Acc_Objects, [Object], New_Objects).

% Select object in scene
get_object_scene(Object_ID, [], not_found).

get_object_scene(Object_ID, [object(Object_ID,X,Y,Z,RQ1,RQ2,RQ3,RQ4,Score)|_], object(Object_ID,X,Y,Z,RQ1,RQ2,RQ3,RQ4,Score)).

get_object_scene(Object_ID, [_|Rest], Object) :-
  get_object_scene(Object_ID, Rest, Object).

%%%%%%%%%%%%%%%%%%%%%%%% functions for fine approach %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% functions for fine approach %%%%%%%%%%%%%%%%%%%%%%%%
reachable([Ang, Dist], [Max_Ang, Max_Dist, Min_Dist]) :-
  Dist < Max_Dist,
  Min_Dist < Dist,
  -Max_Ang < Ang,
  Ang < Max_Ang,
  assign_func_value(true).

reachable(_, _) :-
  assign_func_value(false).

% Function that given the parameters of a seen action (i.e., polar coordinates)
% computes the distance increment that the robot needs to move in order to reach the corresponding object
delta_dist(Distance, Max_Dist) :-
  Delta is Distance - Max_Dist,
  fine_delta(Delta, Fine_Delta),
  Final_Delta is (Fine_Delta * 10000) / 10000,
  %Final_Delta is round(Fine_Delta * 10000) / 10000,
  assign_func_value(Final_Delta).

fine_delta(Delta, 0.0) :-
  -0.07 < Delta,
  Delta < 0.07.

fine_delta(Delta, Delta).

delta_angle(DeltaAngle, MaxAngle, LastScan) :-
  D is round(DeltaAngle),
  M is round(MaxAngle),
  L is round(LastScan), 
  Res is D + L,
  -M < Res,
  Res < M,
  assign_func_value(0.0).

delta_angle(DeltaAngle, MaxAngle, LastScan) :-
  Res is DeltaAngle + LastScan,
  assign_func_value(Res).

status_approach(0.0, 0.0, Object) :- 
  assign_func_value(check(Object, _, true)).

status_approach(_,_,_) :- 
  assign_func_value(see).

%%%%%%%%%%%%%%%%%%%%%%% Functions for delivering an object %%%%%%%%%%%%%%%%%%%%%%%
status_move(sucess, Mode) :- 
  assign_func_value(delivering(Mode)).

status_move(error(E_d, E_r), _) :- 
  assign_func_value(fs_error(move_error)).

get_hand(Object) :-
  var_op(get(right_arm, In_Right_Hand)),
  var_op(get(left_arm, In_Left_Hand)),
	
  select_hand(Object, In_Right_Hand, In_Left_Hand).
 	
select_hand(Object, Object, _) :-
  % The objet is in the right arm
  assign_func_value(right).

select_hand(Object, _, Object) :-
  % The objet is in the left arm
  assign_func_value(left).

select_hand(_, _, _) :-
  print('Fatal error in get_hand: object is not currently held in neither the right or the left hand. Assign right'),   
  nl, assign_func_value(none).

reset_hand(right) :-
  var_op(set(right_arm, free)),
  assign_func_value(free).

reset_hand(left) :-
  var_op(set(left_arm, free)),
  assign_func_value(free).

reset_hand(_) :-
  print('Fatal error in reset_hand: not valid arm'), nl, 
  end.

arm_update(right,Object) :-
  var_op(set(right_arm, Object)),
  assign_func_value(true).

arm_update(left, Object) :-
  var_op(set(left_arm,Object)),
  assign_func_value(true).

arm_update(Arm, Object) :- 
  print('Fatal error in update_arm_status: not valid arm'), print(Arm), 
  print('for object'), print(Object), nl, 
  end. 

extract_objsid(A):-
  extract_objsid(A,[],B),
  assign_func_value(B).
extract_objsid([],Acc,Acc).
extract_objsid([[Id|_]|Rest],Acc,Res):-
  extract_objsid(Rest,[Id|Acc],Res).

getMissing(A,B):-
    extract_objsid(A,[],A_),
    extract_objsid(B,[],B_),
	getMissing(A_,B_,[],Miss),
	assign_func_value(tell_missing(Miss)).

getMissing([],Objs2,Acc,Acc).
getMissing([Obj|Objs1],Objs2,Acc,Mis):-
	(member(Obj,Objs2) ->
		getMissing(Objs1,Objs2,Acc,Mis)
	 | otherwise ->
		getMissing(Objs1,Objs2,[Obj|Acc],Mis)
	).




%%%%%%%%%%%%%%% Dynamic initialization of the Knowledge Base %%%%%%%%%%%%%%%%%%%%%


%Reset KB (put the KB in its original state)

reset_KB:-
	open_original_kb(KB),
	save_kb(KB).
	
reset_KB_gpsr:-
	open_gpsr_kb(KB),
	save_kb(KB).
	
reset_KB_supermarket:-
	open_supermarket_kb(KB),
	save_kb(KB).
	
reset_KB_inference:-
	open_inference_kb(KB),
	save_kb(KB).
	
reset_KB_preferences:-
	open_preferences_kb(KB),
	save_kb(KB).

%Predicate for reading a text file and retrieve into a list of prolog terms

read_file(Archivo,List):-
	open(Archivo,read,Str),
	read_token(Str,List),
	close(Str).
   
read_token(Stream,[]):-
	at_end_of_stream(Stream).
   
read_token(Stream,[X|L]):-
	\+  at_end_of_stream(Stream),
	read(Stream,X),
	read_token(Stream,L). 



%Load navigation points to KB

load_navigation_points_to_KB:-
	read_file('$GOLEM_IIMAS_HOME/agents/Navigation/puntos.csv',List),
	open_kb(KB),
	add_navigation_point_to_KB(List,KB,NewKB),
	save_kb(NewKB).

add_navigation_point_to_KB([],KB,KB).

add_navigation_point_to_KB([(Name,X,Y,R,D)|T],KB,NewKB):-
	add_object(Name,point,KB,TempKB),
	add_object_property(Name,coordinate,[X,Y,R],TempKB,TempKB2),
	add_navigation_point_to_KB(T,TempKB2,NewKB).



%Initialize the KB: First, reset to the original state and then, add the new information

initialize_KB:-
	reset_KB,
	%load_navigation_points_to_KB,
	assign_func_value(empty).
	
initialize_KB_gpsr:-
	reset_KB_gpsr,
	%load_navigation_points_to_KB,
	assign_func_value(empty).
	
initialize_KB_supermarket:-
	reset_KB_supermarket,
	%load_navigation_points_to_KB,
	assign_func_value(empty).
	
initialize_KB_inference:-
	reset_KB_inference,
	open_kb(KB),
	objects_of_a_class(object,KB,AllObjects),
	initialize_replica_of_original_ids(AllObjects),
	assign_func_value(empty).

initialize_KB_preferences:-
        reset_KB_preferences,
        assign_func_value(empty).

%This procedure makes compatible inference demo with supermarket demo
initialize_replica_of_original_ids([]).

initialize_replica_of_original_ids([H|T]):-
    open_kb(KB),
    add_object_property(H,original_id,H,KB,NewKB),
    save_kb(NewKB),
    initialize_replica_of_original_ids(T).


initialize_parser:-
    initializing_parser,
    assign_func_value(empty).

initialize_parser_general:-
    initializing_parser_general,
    assign_func_value(empty).
    
initialize_cognitive_model:-
    initializing_cognitive_model,
    assign_func_value(empty).


%%%%%%%%%%%%%%%% User functions for Behaviors 2014 %%%%%%%%%%%%%%%%%%%%%%%%

get_objects_in_categories(Category) :-
	open_kb(KB),
	objects_of_a_class(Category,KB,Objects),	
	assign_func_value(Objects).

%Convert from cartesian (x,y,z) to cylindrical (r,o,z)
convert_cartesian_to_cylindrical(X,Y,Z,R,O) :-
	Rtemp is sqrt((X**2)+(Y**2)), %Calculate r
	R is round(Rtemp*100)/100,    %Round r with two decimal positions
	Otemp is atan(Y/X)*57.29,     %Calculate o	
	O is round(Otemp),	      %Round o with two decimal positions	
	assign_func_value([]).
	
%Given the position of a user in polar coordinates (R,O,Z), determine a correct movement
%to approach (Advance and Turn)

%Body

decide_position_to_approach(R,O):-
    Rfloat is R*1.0,
    Ofloat is O*1.0,
    Rfloat<150.0,
    Ofloat>(-10.0),
    Ofloat<(10.0),
    assign_func_value(check_status(ok)).
  	
decide_position_to_approach(R,O):-
    Rfloat is R*1.0,
    Ofloat is O*1.0,
    Rfloat<150.0,
    Turn is  Ofloat,
    Advance  is 0.001,
  	assign_func_value(move_to_body(Advance,Turn)).
  	
decide_position_to_approach(R,O):-
    Rfloat is R*1.0,
    Ofloat is O*1.0,
    Rfloat>=150.0,
    Turn is Ofloat,
    Advance is (Rfloat/100)-1.40,
  	assign_func_value(move_to_body(Advance,Turn)).
  	
  	
%Body with clothes strategy

decide_position_to_approach_clothe_strategy(R,O):-
    Rfloat is R*1.0,
    Ofloat is O*1.0,
    Rfloat<130.0,
    Ofloat>(-10.0),
    Ofloat<(10.0),
    assign_func_value(check_status(ok)).
  	
decide_position_to_approach_clothe_strategy(R,O):-
    Rfloat is R*1.0,
    Ofloat is O*1.0,
    Rfloat<130.0,
    Turn is  Ofloat,
    Advance  is 0.001,
  	assign_func_value(move_to_body(Advance,Turn)).
  	
decide_position_to_approach_clothe_strategy(R,O):-
    Rfloat is R*1.0,
    Ofloat is O*1.0,
    Rfloat>=130.0,
    Turn is Ofloat,
    Advance is (Rfloat/100)-1.20,
  	assign_func_value(move_to_body(Advance,Turn)).

%Head

decide_position_to_approach(R,O,Z,Advance,Turn):-
	R > 1.5,
	Advance is R-1.5+0.01,
	Turn is O+0.01,
	assign_func_value([]).
	
decide_position_to_approach(R,O,Z,Advance,Turn):-
	R > 1.5,
	Advance is 0.01,
	Turn is O+0.01,
	assign_func_value([]).

%decide_position_to_approach(R,O,Z,Advance,Turn):-
%	O > 0,
%	R > 1.5,
%	Advance is R-1.5+0.01,
%	Turn is 90-O+0.01,
%	assign_func_value([]).

%decide_position_to_approach(R,O,Z,Advance,Turn):-
%	O > 0,
%	Advance is 0.01,
%	Turn is 90-O+0.01,
%	assign_func_value([]).

%decide_position_to_approach(R,O,Z,Advance,Turn):-
%	R > 1.5,
%	Advance is R-1.5+0.01,
%	Turn is (90-O)*(-1)+0.01,
%	assign_func_value([]).
	
%decide_position_to_approach(R,O,Z,Advance,Turn):-
%	Advance is 0.01,
%	Turn is (90-O)*(-1)+0.01,
%	assign_func_value([]).
	
%Given the position of a person in cartesian coordinates, verifies if the person is nearer than N meters
verify_if_the_person_is_near(X,Y,Z,N):-
	Distance is sqrt((X**2)+(Y**2)+(Z**2)),
	Distance < N,
	assign_func_value(ok).
	
verify_if_the_person_is_near(X,Y,Z,N):-
	assign_func_value(not_detected).
	
%Convert from centimeters to meters
convert_centimeters_to_meters(Centimeters,Meters) :-
	Centimeters is Meters/100,
	assign_func_value([]).


%Set of predicates to verify the kind of move requested by the move behavior
%It can be:
% coordinate [x,y,z]
% instruction type=>value
% label
% empty list
% and they can be only one, or a list of them
% The predicates has the next format (Input,Kind_of_data,Output)
% If the input contains only one data, the Output put it into a list.

verify_type_of_move(Input,Case,Output):-
	verify_move_requested(Input,Case,Output),
	assign_func_value(empty).

verify_move_requested([[X,Y,Z]|T],coordinate,[[X,Y,Z]|T]).

verify_move_requested([X=>Y|T],instruction,[X=>Y|T]).

verify_move_requested([X,Y,Z],coordinate,[[X,Y,Z]]):-
	number(X),number(Y),number(Z).

verify_move_requested([X|T],label,[X|T]).

verify_move_requested([],empty,[]).

verify_move_requested(X=>Y,instruction,[X=>Y]).

verify_move_requested(X,label,[X]).



%Convert a list of labels to a list of coordinates

from_labels_to_coordinates(Labels):-
	open_kb(KB),
	convert_labels_to_coordinates(Labels,Coordinates,KB),
	assign_func_value(Coordinates).

convert_labels_to_coordinates([],[],KB).

%If label is in KB

%If point is defined in KB and has a value of coordinate property
convert_labels_to_coordinates([L|T],[C|R],KB):-
	there_is_object(L,KB,yes),
	class_of_an_object(L,KB,points),
	object_property_value(L,coordinate,KB,C),
	convert_labels_to_coordinates(T,R,KB).

%If label is not in KB
convert_labels_to_coordinates([L|T],[L|R],KB):-
	convert_labels_to_coordinates(T,R,KB).
	


%Verify if the wanted gesture is specified or not
%For any specific gesture, returns the same name
%For a variable (any gesture you want) retrieves 'any_gesture'

verify_kind_of_gesture(X):-
	var(X),
	assign_func_value(any_gesture).

verify_kind_of_gesture(X):-
	assign_func_value(X).
		
get_number_of_arm(right):-
	assign_func_value(1).
	
get_number_of_arm(left):-
	assign_func_value(2).
	

%Get the height of a delivering location from th KB
height_of_a_delivering_point(Point,Height):-
	open_kb(KB),
	object_property_value(Point,height,KB,H),
	Height is H / 100 + 0.45,
	assign_func_value(empty).
	
%Recover message for follow me

get_follow_recover_message(message1):-
	assign_func_value('Wait a moment. I am tryng to identify you. In a moment I will be ready.').

get_follow_recover_message(message2):-
	assign_func_value('Wait a moment please. Do not come back. I am tryng to identify you.').
	
get_follow_recover_message(message3):-
	assign_func_value('Wait a moment but do not come back. In a few seconds I will be ready to follow you again.').


%Compare follow events (Expected Event and Real Event)

%Case 1 No parameters for the Real Event

%The expected event happened
compare_follow_events(Event,Event):-
	assign_func_value(expected_event(Event)).

%The expected event is not what happened
compare_follow_events(Event,OtherEvent):-
	assign_func_value(unexpected_event(OtherEvent)).

%Case 2 The Real Event has three parameters

%The expected event happened
compare_follow_events_3(elevator,elevator,X,Y,Z):-
	assign_func_value(expected_event(elevator(X,Y,Z))).

%The expected event is not what happened
compare_follow_events_3(Event,elevator,X,Y,Z):-
	assign_func_value(unexpected_event(elevator(X,Y,Z))).

%The expected event happened
compare_follow_events_3(crowd,crowd,X,Y,Z):-
	assign_func_value(expected_event(crowd(X,Y,Z))).

%The expected event is not what happened
compare_follow_events_3(Event,elevator,X,Y,Z):-
	assign_func_value(unexpected_event(crowd(X,Y,Z))).

	
%%%Ask text mode%%%%%
read_text_command:-
	 write('Insert answer:'),
  	 nl,
  	 read(X),
	 assign_func_value(X).


%%%%%%%% consult_kb behavior %%%%%%%%%%

consult_kb_value_object_property(Object,Property,Value):-
	open_kb(KB),
	object_property_value(Object,Property,KB,Value),
	assign_func_value(empty).

consult_kb_value_object_relation(Object,Relation,Value):-
	open_kb(KB),
	object_relation_value(Object,Relation,KB,Value),
	assign_func_value(empty).

consult_kb_change_object_related(Object1,Relation,Object2):-
	open_kb(KB),
	change_value_object_relation(Object1,Relation,Object2,KB,NewKB),
	save_kb(NewKB),
	assign_func_value(empty).
	
consult_kb_choose_object_from_class(Class,Object):-
	open_kb(KB),
	objects_only_in_the_class(Class,KB,[Object|T]),
	assign_func_value(empty).

consult_kb_value_class_relation(Class,Relation,Value):-
	open_kb(KB),
	class_relation_value(Class,Relation,KB,Value),
	assign_func_value(empty).

consult_kb_value_class_property(Class,Property,Value):-
	open_kb(KB),
	class_property_value(Class,Property,KB,Value),
	assign_func_value(empty).

consult_kb_change_object_property(Object,Property,Value):-
	open_kb(KB),
	change_value_object_property(Object,Property,Value,KB,NewKB),
	save_kb(NewKB),
	assign_func_value(empty).
	
consult_kb_get_all_values(Property, Value):-
        open_kb(KB),
        property_extention(Property, KB, V),
        list_parser(V, Value),
        assign_func_value(empty).

consult_kb_org_obj_prop(Propty,Value,Org):-
        open_kb(KB),
	property_extension(Propty,KB,Pairs),
	find_value_propty(Pairs,Value,Org),
	assign_func_value(empty).

find_value_propty([],Value,_).
find_value_propty([Org:Value|_],Value,Org):-!.
find_value_propty([_|Tail],Value,Org):-
        find_value_propty(Tail,Value,Org),!.

%%%%%%%%%%%%%%%%% List parser for property_extention %%%%%%%%%%%%%%%%%%
list_parser([],[]).
list_parser([_:List_Value| Tail], Out):-
        list_parser(Tail, Tmp),
        append(List_Value, Tmp, Out).


%%%%%%%%%%%%%%%%%%%%%% Funtions for Erandu %%%%%%%%%%%%%%%%%%


%Get the location of an object from th KB
location_of_an_object(O,L):-
	open_kb(KB),
	object_relation_value(O,in_location,KB,L),
%	object_property_value(L,position,KB,P),
	assign_func_value(empty).
	
%Get the asnwer to a question
get_answer(q1, 'albert einstein'):-
    assign_func_value(empty).
    
get_answer(q2, 'mexico'):-
    assign_func_value(empty).

get_answer(q3, 'tokyo'):-
    assign_func_value(empty).
    
get_answer(q4, 'eindhoven holland'):-
    assign_func_value(empty).
    
get_answer(q5, 'canberra'):-
    assign_func_value(empty).
    
get_answer(q6, 'a service robot'):-
    assign_func_value(empty).

get_answer(q7, 'february twenty fourth'):-
    assign_func_value(empty).
    
get_answer(q8, 'golem'):-
    assign_func_value(empty).
    
get_answer(q9, 'basic functionalities'):-
    assign_func_value(empty).
    
get_answer(q10, 'cuidad del carmen'):-
    assign_func_value(empty).
    
%Get the question from the label.
get_question(q1, 'who discovered the theory of relativity'):- 
    assign_func_value(empty).
    
get_question(q2, 'where are you from'):-
    assign_func_value(empty).
    
get_question(q3, 'what is the capital of japan'):-
    assign_func_value(empty).
    
get_question(q4, 'where did robocup twenty thirteen took place'):-
    assign_func_value(empty).
    
get_question(q5, 'what is the capital of australia'):-
    assign_func_value(empty).
    
get_question(q6, 'what are you'):-
    assign_func_value(empty).
    
get_question(q7, 'when is the flags day in mexico'):-
    assign_func_value(empty).
    
get_question(q8, 'what is your name'):-
    assign_func_value(empty).
    
get_question(q9, 'in what test do you compete'):-
    assign_func_value(empty).
    
get_question(q10, 'in which city are we'):-
    assign_func_value(empty).

timeOver(X,false):-
    statistics(walltime, [CurrentTime | _]),
    N is CurrentTime - X,
    N >= 180000,
    assign_func_value(empty).
    
timeOver(X,true):- 
    assign_func_value(empty).	

concat(L,Acc):-
    concat(L,'',Acc),
	assign_func_value(Acc).


concat([A],Acc,Res):-
  atom_concat(A,Tmp,Res).

concat([P1|Rest],Acc,Res):-
  atom_concat(P1,' ',Tmp),
  atom_concat(Acc,Tmp,Net),
  paste_command(Rest,Net,Res).


%%%%%%%%%%%%%%%%%% GPSR Action Reasoner %%%%%%%%%%%%%%%%%%%%%%%%

:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/test_behaviors/gpsr/action_reasoner.pl').

get_logic_form(In):-
    gpsr_command_2015(In,Out),
	assign_func_value(Out).	

register_waiting_position(X,Y,Z) :-
	open_kb(KB),
	change_value_object_property(waiting_position,coordinate,[X,Y,Z],KB,NewKB),
	save_kb(NewKB),
	assign_func_value(empty).

consult_waiting_position:-
	open_kb(KB),
	object_property_value(waiting_position,coordinate,KB,Position),
	assign_func_value(Position).

%%% Start restaurant %%%%%%%
convert_string_to_atom(String) :-
    term_to_atom(Atom,String),
    assign_func_value(Atom).

get_odometry :-
    % predicate_property(rosswipl_call_service,visible),
    ( mode_exe(test) -> 
      print('Input the position of the robot (format: [x,y,r])'),
      nl,
      read(Position), 
      print(Position)
    | otherwise-> 
      rosswipl_call_service('/pose_sender_service','',JsonRes),
      rosswipl_to_ioca(JsonRes,Position)
    ),
    nl, print('Odometry value [x,y,tetha] is: '), print(Position),nl,
    assign_func_value(Position).
    
get_amcl :-
    % predicate_property(rosswipl_call_service,visible),
    ( mode_exe(test) -> 
      print('Input the position of the robot (format: [x,y,r])'),
      nl,
      read(PositionAMCL), 
      print(PositionAMCL)
    | otherwise-> 
      rosswipl_call_service('/pose_amcl_sender_service','',JsonRes),
      rosswipl_to_ioca(JsonRes,PositionAMCL)
    ),
    nl, print('AMCL value [x,y,tetha] is: '), print(PositionAMCL),nl,
    assign_func_value(PositionAMCL).

%get_odometry :-
%    print('Input the position of the robot (format: [x,y,r])'),
%    nl,
%    read(Position), 
%    print(Position),
%    assign_func_value(Position).

get_person_odometry([R,O,P]) :-
    ( mode_exe(test) -> 
      read(Position)
    | otherwise-> 
      % predicate_property(rosswipl_call_service,visible),
      ioca_to_rosswipl(person_pose(R,O,P),ReqJsonString),
      print(ReqJsonString),nl,
      rosswipl_call_service('/get_person_pose',ReqJsonString,JsonRes),
      rosswipl_to_ioca(JsonRes,Position)
    ),
    assign_func_value(Position).

get_person_odometry([R,O,P],D) :-
    ( mode_exe(test) -> 
      read(Position)
    | otherwise-> 
      % predicate_property(rosswipl_call_service,visible),
      Rf is R-D,
      ioca_to_rosswipl(person_pose(Rf,O,P),ReqJsonString),
      print(ReqJsonString),nl,
      rosswipl_call_service('/get_person_pose',ReqJsonString,JsonRes),
      rosswipl_to_ioca(JsonRes,Position)
    ),
    assign_func_value(Position).

fix_points(Dir,[X1,Y1,A11],[X2,Y2,A2]) :-
  A111 is A11*3.1416/180,
  ( A111 > 3.1416 ->
    A1 is -2*3.1416+A111
  | otherwise ->
    A1 is A111
  ),
  ( A1 < -3.1416 ->
    A1_ is 2*3.1416+A1
  | otherwise ->
    A1_ is A1
  ),
  X2_ is X1+1.0*cos(A1_),
  Y2_ is Y1+1.0*sin(A1_),
  ( Dir == left ->
    A_tmp is A1_-1.5708
  | otherwise ->
    A_tmp is A1_+1.5708
  ),
  ( A_tmp > 3.1416 ->
    A2__ is -2*3.1416+A_tmp
  | otherwise ->
    A2__ is A_tmp
  ),
  ( A2__ < -3.1416 ->
    A2_ is 2*3.1416+A2__
  | otherwise ->
    A2_ is A2__
  ),
  X2 is X2_,
  Y2 is Y2_,
  A2 is A2_*180/3.1416,
  Res = [X2,Y2,A2],
  print('Real address: '),
  print(X2),print(', '),print(X1),
  print(Y2),print(', '),print(Y1),
  print(A2),print(', '),print(A1), nl,
  assign_func_value(Res).

% Guided tour part
missing_orders(T,O) :-
	T > O,
	assign_func_value(true).

missing_orders(_,_) :-
	assign_func_value(false).

add_location_kb(Name,Position) :-
	open_kb(KB),
        add_object(Name,points,KB,NewLocKB),
	add_object_property(Name,coordinate,Position,NewLocKB,NewPropLocKB),
	save_kb(NewPropLocKB),
	assign_func_value(true).

add_location_kb(_,_) :- assign_func_value(true).

spot_side(AngleGesture) :-
	AngleGesture >= 0,
	assign_func_value(right).	

spot_side(_) :-
	assign_func_value(left).	
	
% fetch part	
fetch_take_recovery(Entity,ObjectList,MaxTries, MaxTries, UnexploredPos,object) :- 
	var(Entity),
	var_op(get(left_arm, LeftArm)),
	var_op(get(right_arm, RightArm)),
	assign_func_value(fetch(Entity, UnexploredPos, LeftArm,RightArm)).

fetch_take_recovery(Entity, ObjectList, MaxTries, MaxTries, UnexploredPos,object) :- 
	var_op(get(left_arm, LeftArm)),
	var_op(get(right_arm, RightArm)),
	assign_func_value(fetch(ObjectList, UnexploredPos, LeftArm,RightArm)).


fetch_take_recovery(Entity, ObjectList, MaxTries, Tries, UnexploredPos,object) :- 
	var(Entity),
	var_op(get(left_arm, LeftArm)),
	var_op(get(right_arm, RightArm)),
	var_op(get(find_currpos, CurrPos)),
	append([CurrPos],UnexploredPos,Positions),
	assign_func_value(fetch(Entity, Positions, LeftArm,RightArm)).

fetch_take_recovery(Entity, ObjectList, MaxTries, Tries, UnexploredPos,object) :- 
	var_op(get(left_arm, LeftArm)),
	var_op(get(right_arm, RightArm)),
	var_op(get(find_currpos, CurrPos)),
	append([CurrPos],UnexploredPos,Positions),
	assign_func_value(fetch(ObjectList, Positions, LeftArm,RightArm)).

fetch_take_recovery(Entity, ObjectList, MaxTries, MaxTries, UnexploredPos,category) :- 
	var_op(get(left_arm, LeftArm)),
	var_op(get(right_arm, RightArm)),
	assign_func_value(fetch(Entity, UnexploredPos, LeftArm,RightArm)).

fetch_take_recovery(Entity, ObjectList, MaxTries, Tries, UnexploredPos,category) :- 
	var_op(get(left_arm, LeftArm)),
	var_op(get(right_arm, RightArm)),
	var_op(get(find_currpos, CurrPos)),
	append([CurrPos],UnexploredPos,Positions),
	assign_func_value(fetch(ObjectList, Positions, LeftArm,RightArm)).

% Search locations
object_locations([HObj|TObj],Places,object) :-
	var(Places),
	object_locations_kb([HObj|TObj],SearchLocs),
	remove_duplicates(SearchLocs,SearchPath),
	assign_func_value(SearchPath).

object_locations(_,Places,object) :- 	
	atom(Places),
	assign_func_value([Places]).

object_locations(_,[HPlaces|TPlaces],_) :- 
	assign_func_value([HPlaces|TPlaces]).

object_locations(Objects,Places,object) :-
	atom(Object),
	print('Fatal error in object_locations: Object can not be an atom: '), 
	print(Objects), nl, 
   termina_diag_manager.

object_locations(Objects,Places,object) :- 	
	 print('Fatal error in object_locations: not possible to get locations in object mode for '), 
    print(Objects), print(' and '), print(Places), nl, 
 	 termina_diag_manager.

object_locations(Objects,Places,category) :- 	
	var(Places),
	atom(Objects),
	object_locations_kb(Objects,SearchPath),
	assign_func_value(SearchPath).

object_locations(Objects,Places,category) :- 	
	print('Fatal error in object_locations: not possible to get locations in category mode for'), 
	print(Objects), print(' and '), print(Places), nl, 
    	termina_diag_manager.

object_locations_kb([],[]). 

object_locations_kb([H|T],SearchPath) :-	
	consult_locations_kb(H,HeadLoc),
	object_locations_kb(T,TailLocs),
	append(HeadLoc, TailLocs, SearchPath).
			
consult_locations_kb(ObjectID,SearchPath) :-	
	open_kb(KB),
	print('consulting '), print(ObjectID),nl,
	there_is_object(ObjectID,KB,yes),
	object_relation_value(ObjectID,in_location,KB,Location),
	append([Location], [], SearchPath).

% Eliminates duplicated information in lists
remove_duplicates([], NL) :-
	append([], [], NL).

remove_duplicates([H|T], NL) :-
	not_member(H,T),
	remove_duplicates(T,TD),
	append([H], TD, NL).
	
remove_duplicates([_|T],NL) :-
	remove_duplicates(T,TD),
	append([], TD, NL).

there_is_property(FindProperty,[]) :- 
	false.

there_is_property(P,[P=>ValList|_]).

there_is_property(P,[H|T]) :- 
	there_is_property(P,T).

consult_object_location([], LocationList) :-	
	append([],[],LocationList).

% Get the list of positions in a place (e.g., kitchen, livingroom, etc.)
consult_object_location([FirstObj|RestObj], LocationList) :- 	
	consult_object_location(RestObj, Locs),
	class_of(FirstObj, ingestible, [Class|_], PropList),
	add_to_locs(Class,Locs,LocationList).

add_to_locs(E,I,L) :- 	
	not_member(E,I),     
	append([E],I,L).

add_to_locs(E,I,L) :-	
	append([],I,L). 

% Destinations
find_destination(free,_) :-	
	assign_func_value(_).

find_destination(Obj,[]) :-	
	print('Fatal error: could not find destination for'), 
	print(Obj), nl, 
	termina_diag_manager.

find_destination(Obj,[order(Obj,Dest)|Tail]) :- assign_func_value(Dest).

find_destination(Obj,[_|Tail]) :-
	find_destination(Obj,Tail).

% Extract orders
extract_orders([],O) :-	
	assign_func_value(O).

extract_orders(_,[]) :-	
	assign_func_value([]).

extract_orders(C,O) :-	
	remove_order_list(C,O,L),
	assign_func_value(L).

remove_order_list([],O,O).

remove_order_list([H|T], Orders,LeftOrders) :-
	remove_order(H,Orders,LeftHead),
	remove_order_list(T,LeftHead,LeftOrders).

remove_order(_,[],L) :-	
	append([], [], L).

remove_order(O,[O|T],L):-
	append([],T,L).

remove_order(O,[H|T], L) :-	
	remove_order(O,T, R),
	append([H], R, L).

% Fetch and carry part
choose_search_path(ObjectsLeft, Seen,UnexploredPos) :-
	var_op(get(find_currpos, CurrLoc)),
	current_location(ObjectsLeft,Seen,CurrLoc,UnexploredPos,SearchPath),
	assign_func_value(SearchPath). 

current_location([], _, _, _,[]). 

current_location(_, [], _, RestLocs,RestLocs). 

current_location(ObjectsLeft, _, CurrLoc, RestLocs, [CurrLoc,RestLocs]) :- 
	var(ObjectsLeft).
 
current_location(ObjectsLeft, [[Object_ID, X, Y, Z, O1, O2, O3, O4, Conf]|RestObjs], CurrLoc, RestLocs,SearchPath) :- 
	member(Object_ID, ObjectsLeft),
	append([CurrLoc],RestLocs,SearchPath).

current_location(ObjectsLeft, [[Object_ID, X, Y, Z, O1, O2, O3, O4, Conf]|RestObjs], CurrLoc, RestLocs,SearchPath) :- 	
	current_location(ObjectsLeft, RestObjs, CurrLoc, RestLocs,SearchPath).

% Extract objects from orders
extract_objects(Orders) :-	
	extract_element(Orders, Objects),
	assign_func_value(Objects).
    
extract_element([],ObjList) :- 	
	append([], [], ObjList).

extract_element([order(Obj,Dest)|Tail], ObjList) :-	
	extract_element(Tail, Z),
	append([Obj], Z, ObjList).

%  Remove objets from list
remove_object(E, L,category) :-
	print('Element is a category. Result'), print(E), nl,
	assign_func_value(E).	

remove_object(E, L, object) :-	
	var(E),
	print('Element is a variable. Result'), print(E), nl,
	assign_func_value(E).

remove_object(E, L, object) :-	
	atom(E),
	remove_element([E],L,R),
	print('Element is an atom. Result '), print(R), nl,
	assign_func_value(R).

remove_object([H|T],L,object) :-
	remove_element([H|T],L, R),
	print('Element is a list. Result '), print(L), print([H|T]), print(R), nl,
	assign_func_value(R).

remove_object(_,_,_) :- 	
	print('Fatal error in remove_object: can not remove entity!'),		
	termina_diag_manager.

remove_element(_,[],[]).

remove_element([],L,L).

remove_element(E,L,L) :- 
	var(E).

remove_element(E,L,[]) :- 
	var(L).

remove_element([E|_],[E|T],LIST) :-
	append([],T,LIST).

remove_element(E,[E|T],LIST) :-
	append([],T,LIST).

remove_element(E,[H|T],LIST) :-	
	remove_element(E,T,R),
	append([H],R,LIST).
%%%%%%%%%%%%%% ENDS RESTAURANT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calcular_estrategia(R,D1,D2) :-
	D1 is (R/2000)+1.2,
	D2 is (R/2000)+0.6,
	assign_func_value(rodear_crowd1(D1,D2)).



%Ask: checking not empty hypothesys

check_not_empty_hypothesys(nothing,Conf):-
        sleep(1),
	assign_func_value(listen_command).

check_not_empty_hypothesys(Hyp,Conf):-
	assign_func_value(confirm_hypothesis(Hyp,Conf)).	
	
	
	
%Detect body 

detect_body_mode(nearest):-
    assign_func_value(1).

detect_body_mode(innermost):-
    assign_func_value(2).
    
detect_body_mode(leftright):-
    assign_func_value(3).
    
detect_body_mode(rightleft):-
    assign_func_value(4).
    
%Detect gesture

detect_gesture_mode(X):-
    var(X),
    assign_func_value(0).
    
detect_gesture_mode(hand_up):-
    assign_func_value(1).
    
detect_gesture_mode(waving):-
    assign_func_value(2).
    
detect_gesture_mode(pointing):-
    assign_func_value(3).


get_name_of_gesture(1):-
    assign_func_value(hand_up).
    
get_name_of_gesture(2):-
    assign_func_value(waving).

get_name_of_gesture(3):-
    assign_func_value(pointing).
    
get_name_of_gesture(4):-
    assign_func_value(sitting).
    
    
%Memorize body

get_name_numerical_id(Name):-
    var(Name),
    assign_func_value(is_variable).

get_name_numerical_id(Name):-
    open_kb(KB),
	object_property_value(Name,num_id,KB,NumericalID),
    assign_func_value(NumericalID).
    

%Recognize body

get_name_from_numerical_id(ID):-
    open_kb(KB),
    property_extension(num_id,KB,List),
    print('List with num_id:'),nl,print(List),nl,
    find_human_with_ID(List,ID,Name),
    assign_func_value(Name).
    
find_human_with_ID([],ID,'unknown').

find_human_with_ID([N:ID|T],ID,N).
    
find_human_with_ID([_|T],ID,Name):-
    find_human_with_ID(T,ID,Name).
    

compare_body_id(X,X,L):-
    assign_func_value(retrieve_data).
    
compare_body_id(X,Y,L):-
    assign_func_value(recognize(L,X)).


% Check if object is graspable
is_graspable([W,Z,Y,X],Res):-
	print('W : '), print(W), nl,
	print('Z : '), print(Z), nl,
	print('Y : '), print(Y), nl,
	print('X : '), print(X), nl,
    P is atan2(2*Y*Z + 2*W*X, W*W - X*X - Y*Y + Z*Z), 
    R is atan2(2*X*Y + 2*W*Z, W*W + X*X - Y*Y - Z*Z),
    Prea is (2*W*Y - 2*X*Z),
	%print('Prea : '), print(Prea), nl,
    (Prea > 1 ->
       A is asin(1)
    | otherwise ->
        (Prea < -1 ->
            A is asin(-1)
        | otherwise ->
            A is asin(2*W*Y - 2*X*Z)
        )
    ),
	print('Roll : '), print(R), nl,
	print('Pitch: '), print(P), nl,
	print('Yaw  : '), print(A), nl,
    (abs(R) > 0.7854 ->
       Res = not_graspable
    | otherwise ->
       (abs(P) > 0.7854 ->
          Res = not_graspable
       | otherwise ->
          Res = graspable
       ) %ignoring yaw for now
    ),
	print('Result : '), print(Res), nl.
	%assign_func_value(Res).
    


%SUPERMARKET

%Parser

supermarket_parser('do you have a bread product on sale'):-
    assign_func_value(bring_me(bread,on_discount=>yes)).
    
supermarket_parser('do you have toilet paper'):-
    assign_func_value(bring_me('toilet paper')).

supermarket_parser('do you have beer'):-
    assign_func_value(bring_me(beer)).

supermarket_parser('do you have a drink for all ages'):-
    assign_func_value(bring_me(drink,age=>all)).
    
supermarket_parser('do you have cereal'):-
    assign_func_value(bring_me(cereal)).
    
supermarket_parser('no'):-
    assign_func_value(dispatch).


%Existence

check_restriction(existence,RestRestrictions,Input):-
    consult_existence_of_an_object(Input,there_is(Object)),
    open_kb(KB),
    object_property_value(Object,brand,KB,Brand),
    change_object_name(Object,Brand,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(embedded_sit(say(['Yes.',Brand],Status),empty,verify_restriction(RestRestrictions,Brand))).

check_restriction(existence,RestRestrictions,Input):-
    consult_existence_of_an_object(Input,unknown_object(Object)),
    assign_func_value(embedded_sit(say(['I dont have information in my knowledge base about that product'],Status),empty,success)).
    
check_object_is_from_class([],Value,Class,KB,[]).

check_object_is_from_class([Object:Value|T],Value,Class,KB,Object):-
    objects_of_a_class(Class,KB,AllObjects),
    isElement(Object,AllObjects).
    
check_object_is_from_class([Object:_|T],Value,Class,KB,Object):-
    check_object_is_from_class(T,Value,Class,KB,Object).
    
consult_existence_of_an_object(bring_me(Class,Property=>Value),there_is(Object)):-
    open_kb(KB),
    property_extension(Property,KB,List),
    check_object_is_from_class(List,Value,Class,KB,Object).

consult_existence_of_an_object(bring_me(Class),there_is(Object)):-
    open_kb(KB),
    there_is_class(Class,KB,yes),
    objects_of_a_class(Class,KB,[Object|Rest]).
    
consult_existence_of_an_object(bring_me(Class),unknown_object(Object)):-
    open_kb(KB),
    there_is_class(Class,KB,unknown).
    

%Disponibility

check_restriction(disponibility,RestRestrictions,Input):-
    check_inventory_of_an_object(Input,EmbeddedModel,RestRestrictions,Input),
    assign_func_value(EmbeddedModel).

check_inventory_of_an_object(Object,EmbeddedModel,RestRestrictions,Input):-
    open_kb(KB),
    object_property_value(Object,inv,KB,Number),
    verify_value_in_inventory(Number,Object,EmbeddedModel,RestRestrictions,Input).

verify_value_in_inventory(Number,Object,Embedded,RestRestrictions,Input):-
    ( Number == 0 ->
      Embedded=embedded_sit(say(['But we dont have',Object,'in inventory'],Status),empty,success),
      register_failed_order(Object,not_disponible)
     | otherwise ->
       Embedded = embedded_sit(say('.',Status),verify_value_in_inventory(Number,Object,empty),verify_restriction(RestRestrictions,Input))
    ).

register_failed_order(Object,Reason):-
    open_kb(KB),
    add_object(bring(Object),failed_orders,KB,NewKB),
    add_object_property(bring(Object),reason,Reason,NewKB,NewKB2),
    save_kb(NewKB2).


%Graspability

check_restriction(graspability,RestRestrictions,Input):-
    check_object_graspable(Input,Value),
    object_graspable_next_sit(Value,NextSit,RestRestrictions,Input),
    assign_func_value(NextSit).

check_object_graspable(Object,Value):-
    open_kb(KB),
    object_property_value(Object,graspable,KB,Value).
    
object_graspable_next_sit(yes,NextSit,RestRestrictions,Input):-
    NextSit = embedded_sit(say('.',Status),empty,verify_restriction(RestRestrictions,Input)).

object_graspable_next_sit(no,NextSit,RestRestrictions,Input):-
    NextSit = embedded_sit(say('But I can not grasp it',Status),empty,success).
    

%Age restriction

check_restriction(age_restriction,RestRestrictions,Input):-
    check_object_age_restriction(Input,Value),
    age_restriction_next_sit(Value,NextSit,RestRestrictions,Input),
    assign_func_value(NextSit).

check_object_age_restriction(Object,Value):-
    open_kb(KB),
    object_property_value(Object,age,KB,Value).
    
age_restriction_next_sit(all,NextSit,RestRestrictions,Input):-
    NextSit = embedded_sit(say('I will bring it to you',Status),empty,success),
    register_order(Input).

age_restriction_next_sit(18,NextSit,RestRestrictions,Object):-
    NextSit = embedded_sit(ask('Are you over eighteen',yesno,false,1,Answer,Status),empty,verify_restriction(RestRestrictions,[Object,Answer])).


%Age of client

check_restriction(age_client,RestRestrictions,[Object,Answer]):-
    age_client_next_sit(Answer,NextSit,RestRestrictions,Object),
    assign_func_value(NextSit).

age_client_next_sit(yes,NextSit,RestRestrictions,Input):-
    NextSit = embedded_sit(say('I will bring it to you',Status),empty,success),
    register_order(Input).

age_client_next_sit(no,NextSit,RestRestrictions,Input):-
    NextSit = embedded_sit(say(['I cant give you',Input,'because you are very young'],Status),empty,verify_restriction(RestRestrictions,Input)).

%Shelves

get_shelf_of_an_object(Object):-
    open_kb(KB),
    object_property_value(Object,shelf,KB,Shelf),
    assign_func_value(Shelf).


%Register order

register_order(Object):-
    open_kb(KB),
    add_object(bring(Object),orders,KB,NewKB),
    save_kb(NewKB).


%Other restriction
    
check_restriction(FirstRestriction,RestRestrictions,Input):-
    assign_func_value(embedded_sit(say('Checking new restriction',Status),say('Ready'),verify_restriction(RestRestrictions,Input))).
   
%Remove order
remove_order(Object):-
    open_kb(KB),
    rm_object(bring(Object),KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).


%Remove customer
remove_customer(Customer):-
    open_kb(KB),
    rm_object(Customer,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).

%Get list of orders

get_list_of_orders:-
    open_kb(KB),
    objects_of_a_class(orders,KB,Orders),    
    assign_func_value(Orders).

get_list_of_failed_orders:-
    open_kb(KB),
    objects_of_a_class(failed_orders,KB,Orders),
    check_failed_order(Orders,[],PossibleOrders),
    assign_func_value(PossibleOrders).

check_failed_order([],[],PossibleOrders):-
    PossibleOrders = [].

check_failed_order([],PossibleOrdersLast,PossibleOrders):-
    PossibleOrders = PossibleOrdersLast.

check_failed_order([bring(Object)|RestOrders],PossibleOrdersLast,PossibleOrders):-
    open_kb(KB),
    object_property_value(bring(Object),reason,KB,Reason),
    ( Reason == not_disponible ->
      object_property_value(Object,inv,KB,Inventory),
      ( Inventory == 1 ->
        append(PossibleOrdersLast,[bring(Object)],PossibleOrdersNext)
        | otherwise ->
        PossibleOrdersNext = PossibleOrdersLast
      )
      | otherwise ->
      PossibleOrdersNext = PossibleOrdersLast
    ),
    check_failed_order(RestOrders,PossibleOrdersNext,PossibleOrders).

%Actualiza supermarket KB

update_object_inv_in_KB(Object,Inventory):-
	print('Updating inventory for : '), print(Object), nl,
    open_kb(KB),
    class_of_an_object(Object,KB,Class),
    change_value_class_property(Class,inv,Inventory,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).
    
get_object_by_property(Property,Value,Object):-
    open_kb(KB),
	print('1 : '), print(Property), print(Value), nl,
    property_extension(Property,KB,List),
	print('2 : '), print(List), nl,
    check_list_by_property(Value,List,Object).

check_list_by_property(Value,[Name:TestValue|Rest],Object):-
	print('3 : '), print(Name), print(TestValue), nl,
    ( Value == TestValue ->
      Object = Name
    | otherwise ->
      check_list_by_property(Value,Rest,Object)
    ).

check_list_by_property(Value,[],Object):-
    Object = empty.

update_object_graspable_in_KB(Object,[Q1,Q2,Q3,Q4]):-
	print('Updating graspable for : '), print(Object), nl,
	is_graspable([Q1,Q2,Q3,Q4],ResGrasp),
    ( ResGrasp == not_graspable ->
         get_object_by_property(brand,Object,ObjectName),
         open_kb(KB),
         change_value_object_property(ObjectName,graspable,no,KB,NewKB),
         save_kb(NewKB)
    | otherwise ->
         print('It is graspable.'), nl
    ),
    assign_func_value(empty).
    
actualize_supermarket_kb:-
    open_kb(KB),
    change_value_class_property(dairy,inv,0,KB,NewKB),
    add_object_property(cereal,graspable,no,NewKB,NewKB2),    
    save_kb(NewKB2),
    assign_func_value(empty).  
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Inference demo  :)  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arturo Rodríguez 

inference_module_without_explication:-
    open_kb(KB),
    diagnostician(KB,Diagnostic,NewKB),
	save_kb(NewKB),
	decision_maker(NewKB,Decision,Result),
	dfs_planner(Result,500,NewKB,Plan),	
    assign_func_value(solve_plan(Plan,empty)).  
   
inference_module:-
    open_kb(KB),
    diagnostician(KB,Diagnostic,NewKB),
	save_kb(NewKB),
	decision_maker(NewKB,Decision,Result),
	dfs_planner(Result,500,NewKB,Plan),
	ddp_generate_explication_dialog(Diagnostic,Decision,Plan,Dialog),
    assign_func_value(solve_plan(Plan,Dialog)).  
    
%%%%%%%%%%%%%%%%%%%%
%Copiar desde aqui
%%%%%%%%%%%%%%%%%%%%



   
inference_modules3:-
    open_kb(KB),
        save_kb_temp(KB),
            nl,nl,print('Antes del diagnostico'),nl,nl,
	        statistics(walltime, _),
	%diagnostician(KB,Diagnostic,NewKB),
	etr_dlv_link(KB,Diagnostic,NewKB),
	        statistics(walltime,[_, ExecutionTime]),
	    save_exec_time(diagnostic, ExecutionTime),
	        nl,nl,print('Despues del diagnostico'),nl,nl,
        save_diagnostic_temp(Diagnostic),
    %save_kb(NewKB),	
	etr_save_kb(NewKB),
	    save_new_kb_temp(NewKB),
	open_kb(KB2), %Esto se hace para asegurar que la base le llega al decision maker de Arturo en la forma correcta
	decision_maker(KB2,Decision,Result),
	dfs_planner(Result,500,KB2,Plan),
	ddp_generate_explication_dialog(Diagnostic,Decision,Plan,Dialog),
    assign_func_value(solve_plan(Plan,Dialog)).  

etr_save_kb(KB):-
    open('knowledge_base/golem_KB.txt',write,Stream),
    write(Stream,KB),
    close(Stream).




inference_modules:-
    open_kb(KB),
        save_kb_temp(KB),
        nl,nl,print('Antes del diagnostico'),nl,nl,
	    statistics(walltime, _),
	etr_dlv_link(KB,Diagnostic,NewKB),
	    statistics(walltime,[_, ExecutionTime]),
	    save_exec_time(diagnostic, ExecutionTime),
	    nl,nl,print('Despues del diagnostico'),nl,nl,
	    %nl,nl,print('Diagnostic: '),print(Diagnostic),nl,nl,
	    %nl,nl,print('NewKB: '),print(NewKB),nl,nl,
        save_diagnostic_temp(Diagnostic),	
	    save_new_kb_temp(NewKB),
	    nl,print('Save_kb de eduardo'),  
	etr_save_kb(NewKB),
	nl, print('Despues de save_kb de eduardo'),nl,
	%create_file_for_aspdlv,
	etr_DataBase_To_ASP(NewKB),
	    statistics(walltime, _),
	decision_maker_ASP(Decision),
	    print('Saliendo de razonador\n\n'),
	    statistics(walltime,[_, ExecutionTime2]),
	    save_exec_time(decision, ExecutionTime2),
	    save_decision_temp(Decision),
	    statistics(walltime, _),
	dfs_planner_ASP(Plan),
	    statistics(walltime,[_, ExecutionTime3]),
	    save_exec_time(planning, ExecutionTime3),
	    save_plan_temp(Plan),
	    print('Saliendo de planeador\n\n'),
	    print('Aqui estoy\n\n'),
	ddp_generate_explication_dialog(Diagnostic,Decision,Plan,Dialog),
	    print('Saliendo de diagnostician\n\n'),
    assign_func_value(solve_plan(Plan,Dialog)).  







inference_modules2:-
    open_kb(KB),
    save_kb_temp(KB),
    %statistics(walltime, _),
    diagnostician(KB,Diagnostic,NewKB),
    %etr_dlv_link(Diagnostic,NewKB),
    %statistics(walltime,[_, ExecutionTime]),
    %save_exec_time(diagnostic, ExecutionTime),
    save_diagnostic_temp(Diagnostic),
	%save_new_kb_temp(NewKB),
	save_kb(NewKB),
	create_file_for_aspdlv,
	statistics(walltime, _),
	%decision_maker(NewKB,Decision,Result),
	decision_maker_ASP(Decision),
	print('Saliendo de razonador\n\n'),
	statistics(walltime,[_, ExecutionTime2]),
	save_exec_time(decision, ExecutionTime2),
	save_decision_temp(Decision),
	statistics(walltime, _),
	dfs_planner_ASP(Plan),
	statistics(walltime,[_, ExecutionTime3]),
	save_exec_time(planning, ExecutionTime3),
	save_plan_temp(Plan),
	print('Saliendo de planeador\n\n'),
	%decision_maker(NewKB,Decision,Result),
	print('Aqui estoy\n\n'),
	ddp_generate_explication_dialog(Diagnostic,Decision,Plan,Dialog),
	print('Saliendo de diagnostician\n\n'),
    assign_func_value(solve_plan(Plan,Dialog)).  
    
save_new_kb_temp(KB):-
    open('apps/robocup_2015/ricardo/pruebas/nueva_base_revision.txt',append,Stream),
    write(Stream,KB),nl(Stream),nl(Stream),nl(Stream),nl(Stream),
    close(Stream).
    
save_kb_temp(KB):-
    open('apps/robocup_2015/ricardo/pruebas/base_revision.txt',append,Stream),
    write(Stream,KB),nl(Stream),nl(Stream),nl(Stream),nl(Stream),
    close(Stream).
    
save_diagnostic_temp(Diagnostic):-
    open('apps/robocup_2015/ricardo/pruebas/diagnostic_revision.txt',append,Stream),
    write(Stream,Diagnostic),nl(Stream),nl(Stream),nl(Stream),nl(Stream),
    close(Stream).

save_decision_temp(Decision):-
    open('apps/robocup_2015/ricardo/pruebas/decision_revision.txt',append,Stream),
    write(Stream,Decision),nl(Stream),nl(Stream),nl(Stream),nl(Stream),
    close(Stream).

save_plan_temp(Plan):-
    open('apps/robocup_2015/ricardo/pruebas/plan_revision.txt',append,Stream),
    write(Stream,Plan),nl(Stream),nl(Stream),nl(Stream),nl(Stream),
    close(Stream).
    
save_exec_time(Module,Time):-
    open('apps/robocup_2015/ricardo/pruebas/times.txt',append,Stream),
    write(Stream,Module), write(Stream, ': '), write(Stream,Time), write(Stream,' ms.'), nl(Stream), nl(Stream),
    close(Stream).
    
    
    
    
    
    
    
    
    
    
    
ddp_explain_assistant_actions([],[]).

ddp_explain_assistant_actions([move(X),take(Y),take(Z)|T],[say(['He went to',NameOfShelf,'and took the',Y,'and the',Z])|NewT]):-
    %open_kb(KB),
    NameOfShelf = 'storage',
    %object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_assistant_actions(T,NewT).

ddp_explain_assistant_actions([move(X),take(Y)|T],[say(['He went to',NameOfShelf,'and took the',Y])|NewT]):-
    %open_kb(KB),
    NameOfShelf = 'storage',
    %object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_assistant_actions(T,NewT).
    
ddp_explain_assistant_actions([take(X)|T],[say(['the assistant took the',X])|NewT]):-
    ddp_explain_assistant_actions(T,NewT).
    
ddp_explain_assistant_actions([move('storage')|T],[say(['the assistant went to',NameOfShelf])|NewT]):-
    %open_kb(KB),
    NameOfShelf = 'storage',
    %object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_assistant_actions(T,NewT).

    
    
    
    
    
    
    
    
    
    

%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/test_behaviors/gpsr/action_reasoner.pl').

%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/ETR_P_User_Functions.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/ETR_P_Transform_DB_To_ASP.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/ETR_P_Preparation_For_Diagnosis.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/ETR_P_Diagnosis.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/ETR_P_Return.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/RAFV_planner.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/user_functions_b.pl').
%:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/apps/robocup_2015/ricardo/RAFV_create_asp_from_prolog.pl').

%%%%%%%%%%%%%%%%%%%%
%Copiar hasta aqui
%%%%%%%%%%%%%%%%%%%%
    
  
%ID fix procedure (to get compatible with supermarket demo)

ddp_fix_id:-
    open_kb(KB),
    objects_of_a_class(object,KB,AllObjects),
    ddp_fix_id(AllObjects,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).

ddp_fix_id([],X,X).

ddp_fix_id([H|T],KB,NewKB):-
    object_property_value(H,original_id,KB,OriginalID),
    change_object_name(H,OriginalID,KB,KB2),
    ddp_fix_id(T,KB2,NewKB).    

    

%Parser

inference_demo_parser('i will put a coke a heineken noodles and bisquits'):-
    assign_func_value(update_inventory([coke,heineken,noodles,bisquits])).

inference_demo_parser('do you have a bread product on sale'):-
    assign_func_value(bring_me(bread,on_discount=>yes)).
    
inference_demo_parser('do you have mexican fritters'):-
    assign_func_value(bring_me('mexican fritters')).

inference_demo_parser('do you have beer'):-
    assign_func_value(bring_me(beer)).

inference_demo_parser('do you have a drink for all ages'):-
    assign_func_value(bring_me(drink,age=>all)).
    
inference_demo_parser('do you have cereal'):-
    assign_func_value(bring_me(cereal)).
    
inference_demo_parser('bring me kellogs'):-
    assign_func_value(bring_me_without_verification([kellogs])).

inference_demo_parser('bring me noodles'):-
    assign_func_value(bring_me_without_verification([noodles])).

inference_demo_parser('bring me a heineken'):-
    assign_func_value(bring_me_without_verification([heineken])).
    
inference_demo_parser('bring me bisquits'):-
    assign_func_value(bring_me_without_verification([bisquits])).
    
inference_demo_parser('bring me a coke'):-
    assign_func_value(bring_me_without_verification([coke])).

inference_demo_parser('golem bring me kellogs and a coke'):-
    assign_func_value(bring_me_without_verification([coke,kellogs])).
    
inference_demo_parser('golem bring me bisquits and a coke'):-
    assign_func_value(bring_me_without_verification([coke,bisquits])).
    
inference_demo_parser('no'):-
    assign_func_value(finish).


ddp_update_inventory(NewObjects):-
    ddp_update_element(NewObjects),
    ddp_register_dialog(NewObjects),
    assign_func_value(empty).


ddp_update_element([]).

ddp_update_element([Brand|T]):-
    open_kb(KB),
    dg_get_object_of_the_brand(Brand,KB,ID),
    object_property_value(ID,shelf,KB,Shelf),
    class_of_an_object(ID,KB,ClassofID),
    class_property_value(ClassofID,inv,KB,Inv),
    NewInv is Inv + 1,
    change_value_object_property(ID,in,Shelf,KB,NewKB),
    change_value_class_property(ClassofID,inv,NewInv,NewKB,FinalKB),
    save_kb(FinalKB),
    ddp_update_element(T).
    
ddp_register_dialog(NewObjects):-
    open_kb(KB),
    ddp_tranform_new_objects_into_dialog(NewObjects,Dialog),
    change_value_object_property(dialog1,content,Dialog,KB,NewKB),
    save_kb(NewKB).
    
ddp_tranform_new_objects_into_dialog([],[]).

ddp_tranform_new_objects_into_dialog([Brand|T],[bring(Brand,Shelf)|NewT]):-
    open_kb(KB),
    dg_get_object_of_the_brand(Brand,KB,ID),
    object_property_value(ID,shelf,KB,Shelf),
    ddp_tranform_new_objects_into_dialog(T,NewT).


%Inference demo dispatcher

from_plan_to_dialog_model(Plan):-
    convert_plan_to_commands(Plan,DialogModels),
    assign_func_value(DialogModels).

convert_plan_to_commands([],[]).

convert_plan_to_commands([H|T],Final):-
    construct_commands_from_plan(H,NewH),
	convert_plan_to_commands(T,NewT),
	append(NewH,NewT,Final).


construct_commands_from_plan(move(_,start),[
	say(['I will go to the start position'],_),
	move(start,_)
	]).

construct_commands_from_plan(move(X,Y),[
	ddp_move(Y)
	]).
	
construct_commands_from_plan(search(X),[
    consult_kb(value_object_property, [X,brand], Brand, _),
	ddp_search(Brand)
	]).
	
construct_commands_from_plan(grasp(X),[
    consult_kb(value_object_property, [X,brand], Brand, _),
	ddp_grasp(Brand)
	]).
	
construct_commands_from_plan(deliver(X),[
	ddp_deliver(X),
	consult_kb(value_object_property, [golem,position], Position, _),
	consult_kb(change_object_property, [X,in,Position], _, _)
	]).
	
construct_commands_from_plan(X,[
	say(['I dont know this instruction'],_)
	]).


%%Updating observation

convert_found_objects_in_dialog(FO):-
    ddp_get_dialog_seen_objects(FO,Dialog),
    assign_func_value(Dialog).

ddp_get_dialog_seen_objects([],[]).

ddp_get_dialog_seen_objects([object(ID,_,_,_,_,_,_,_,_)|T],['I see',ID,'.'|NewT]):-
    ddp_get_dialog_seen_objects(T,NewT).
    

update_kb_with_seen_objects(FoundObj,Loc):-
    ddp_extract_ids_of_seen_objects(FoundObj,IDFoundObj),
    ddp_store_observation(Loc,IDFoundObj),
    assign_func_value(success).
    
ddp_extract_ids_of_seen_objects([],[]).

ddp_extract_ids_of_seen_objects([object(ID,_,_,_,_,_,_,_,_)|T],[ID|NewT]):-
    ddp_extract_ids_of_seen_objects(T,NewT).
    

ddp_store_observation(Loc,IDFoundObj):-
    open_kb(KB),
    add_object(observation(Loc),observation,KB,KB2),
    add_object_property(observation(Loc),seen_by,robot,KB2,KB3),
    add_object_property(observation(Loc),observed_objects,IDFoundObj,KB3,NewKB),
    save_kb(NewKB).
    
    
ddp_describe_location(L):-
    open_kb(KB),
    object_property_value(L,name,KB,Name),
    assign_func_value(['I will move to',Name]).
    
    
ddp_check_if_robot_is_in_place(Loc):-
    open_kb(KB),
    object_property_value(golem,position,KB,Pos), 
    ddp_check_if_robot_is_in_place_next_situation(Loc,Pos,NextSit), 
    assign_func_value(NextSit).
    
ddp_check_if_robot_is_in_place_next_situation(L1,L1,in_place).

ddp_check_if_robot_is_in_place_next_situation(L1,L2,not_in_place).
 

ddp_actualize_robot_position(NewP):-
    open_kb(KB),
    change_value_object_property(golem,position,NewP,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).
    
ddp_actualize_grasp_event(Object):-
    open_kb(KB),
    add_object(grasp(Object),'grasp object',KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).


ddp_check_failed_orders:-
     open_kb(KB),
     objects_of_a_class(failed_orders,KB,FailedOrders),
     assign_func_value(manage(FailedOrders)).
     
ddp_remove_orders:-
    open_kb(KB),
    rm_class(orders,KB,KB2),
    add_class(orders,top,KB2,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).
    
ddp_verify_existence_of_object(Object,T):-
    open_kb(KB),
    object_property_value(Object,inv,KB,0),
    assign_func_value(manage(T)).
    
ddp_verify_existence_of_object(Object,T):-
    assign_func_value(offer(Object,T)).
    
manage_failed_orders_parser(no,_):-
    assign_func_value(empty).

manage_failed_orders_parser(yes,Object):-
    open_kb(KB),
    rm_object(bring(Object),KB,KB2),
    add_object(bring(Object),orders,KB2,NewKB),    
    save_kb(NewKB),
    assign_func_value(empty).
    
%%Generation of dialogs when adding new product in knowledge base
ddp_generate_dialog_new_products(NOO):-
    ddp_create_dialog_new_products(NOO,Dialog),
    assign_func_value(Dialog).
    
ddp_create_dialog_new_products([],[]).

ddp_create_dialog_new_products([H|T],[say([H,'in',NameOfShelf])|NewT]):-
    ddp_create_dialog_new_products(T,NewT),
    open_kb(KB),
    dg_get_object_of_the_brand(H,KB,ID),
    object_property_value(ID,shelf,KB,Shelf),  
    object_property_value(Shelf,name,KB,NameOfShelf).
    

    
%%Generation of dialogs to explain diagnostic, decision and planning
ddp_generate_explication_dialog(Diagnostic,Decision,Plan,Dialog):-
    nl,
    print('**************************************************'),nl,
    print('Diagnostic: '),print(Diagnostic),nl,
    print('Decision: '),print(Decision),nl,
    print('Plan: '),print(Plan),nl,
    print('**************************************************'),nl,
    ddp_create_dialog_explanation(Diagnostic,Decision,Plan,Dialog).

%%If there is no plan there is no dialog
ddp_create_dialog_explanation(_,_,[],empty).

%In other case
ddp_create_dialog_explanation(Diagnostic,Decision,Plan,Dialog):-
    ddp_create_diagnostic_explanation(Diagnostic,E1),
    ddp_create_decision_explanation(Decision,E2),
    ddp_create_plan_explanation(Plan,E3),
    append(E1,E2,Aux),
    append(Aux,E3,Dialog).
    
%Diagnostic dialog
ddp_create_diagnostic_explanation(Diagnostic,Dialog):-
    ddp_explain_assistant_actions(Diagnostic,AssistantActions),
    append([say('This is my diagnosis about the actions of the assistant')],AssistantActions,Dialog).    
    
ddp_explain_assistant_actions([],[]).

ddp_explain_assistant_actions([move(X),deliver(Y),deliver(Z)|T],[say(['He went to',NameOfShelf,'and put the',Y,'and the',Z])|NewT]):-
    open_kb(KB),
    object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_assistant_actions(T,NewT).

ddp_explain_assistant_actions([move(X),deliver(Y)|T],[say(['He went to',NameOfShelf,'and put the',Y])|NewT]):-
    open_kb(KB),
    object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_assistant_actions(T,NewT).

ddp_explain_assistant_actions([move(X)|T],[say(['the assistant went to',NameOfShelf])|NewT]):-
    open_kb(KB),
    object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_assistant_actions(T,NewT).
    
ddp_explain_assistant_actions([deliver(X)|T],[say(['the assistant put the',X])|NewT]):-
    ddp_explain_assistant_actions(T,NewT).

%Decision dialog
ddp_create_decision_explanation(Decision,FinalDialog):-
    print(Decision),
    ddp_explain_robot_decision(Decision,Dialog),
    append([say('My decision is')],Dialog,FinalDialog). 
 
ddp_explain_robot_decision([],[]).

ddp_explain_robot_decision([realign(X,Y),bring(Z,client),bring(W,client)|T],[say(['I will realign the',X,'in',NameOfShelf,'and bring the',Z,'and the',W,'to the client'])|NewT]):-
    open_kb(KB),
    object_property_value(Y,name,KB,NameOfShelf),
    ddp_explain_robot_decision(T,NewT).

ddp_explain_robot_decision([realign(X,Y),bring(Z,client)|T],[say(['I will realign the',X,'in',NameOfShelf,'and bring the',Z,'to the client'])|NewT]):-
    open_kb(KB),
    object_property_value(Y,name,KB,NameOfShelf),
    ddp_explain_robot_decision(T,NewT).

ddp_explain_robot_decision([bring(X,client),bring(Y,client)|T],[say(['I will bring the',X,'and the',Y,'to the client'])|NewT]):-
    ddp_explain_robot_decision(T,NewT).

ddp_explain_robot_decision([bring(X,client)|T],[say(['I will bring the',X,'to the client'])|NewT]):-
    ddp_explain_robot_decision(T,NewT).

ddp_explain_robot_decision([realign(X,Y)|T],[say(['I will realign the',X,'in',NameOfShelf])|NewT]):-
    open_kb(KB),
    object_property_value(Y,name,KB,NameOfShelf),
    ddp_explain_robot_decision(T,NewT).
       
ddp_explain_robot_decision([bring(X,Y)|T],[say(['I will bring the',X,'to',NameOfShelf])|NewT]):-
    open_kb(KB),
    object_property_value(Y,name,KB,NameOfShelf),
    ddp_explain_robot_decision(T,NewT).
    

%Plan dialog

ddp_create_plan_explanation(Plan,FinalDialog):-
    ddp_explain_robot_plan(Plan,Dialog),
    append([say('My plan is')],Dialog,FinalDialog). 

ddp_explain_robot_plan([],[say(['Now I will proceed with the execution of my plan'])]).

ddp_explain_robot_plan([move(_,X),deliver(Y),search(Z),grasp(Z)|T],[say(['I will move to',NameOfShelf,',','deliver the',NameOfObject1,',','find the',NameOfObject2,'and grasp it'])|NewT]):-
    open_kb(KB),
    object_property_value(X,name,KB,NameOfShelf),
    object_property_value(Y,brand,KB,NameOfObject1),
    object_property_value(Z,brand,KB,NameOfObject2),
    ddp_explain_robot_plan(T,NewT).

ddp_explain_robot_plan([move(_,X),search(Y),grasp(Y)|T],[say(['I will move to',NameOfShelf,',','find the',NameOfObject,'and grasp it'])|NewT]):-
    open_kb(KB),
    object_property_value(X,name,KB,NameOfShelf),
    object_property_value(Y,brand,KB,NameOfObject),
    ddp_explain_robot_plan(T,NewT).

ddp_explain_robot_plan([move(_,start),deliver(X)|T],[say(['I will move to the client and deliver the',NameOfObject])|NewT]):-
    open_kb(KB),
    object_property_value(X,brand,KB,NameOfObject),
    ddp_explain_robot_plan(T,NewT).

ddp_explain_robot_plan([move(_,start)|T],[say(['I will move to the client'])|NewT]):-
    ddp_explain_robot_plan(T,NewT).

ddp_explain_robot_plan([move(_,X)|T],[say(['I will move to',NameOfShelf])|NewT]):-
    open_kb(KB),
    object_property_value(X,name,KB,NameOfShelf),
    ddp_explain_robot_plan(T,NewT).

ddp_explain_robot_plan([search(X)|T],[say(['I will find the',NameOfObject])|NewT]):-
    open_kb(KB),
    object_property_value(X,brand,KB,NameOfObject),
    ddp_explain_robot_plan(T,NewT).
    
ddp_explain_robot_plan([grasp(X)|T],[say(['I will grasp the',NameOfObject])|NewT]):-
    open_kb(KB),
    object_property_value(X,brand,KB,NameOfObject),
    ddp_explain_robot_plan(T,NewT).
    
ddp_explain_robot_plan([deliver(X)|T],[say(['I will deliver the',NameOfObject])|NewT]):-
    open_kb(KB),
    object_property_value(X,brand,KB,NameOfObject),
    ddp_explain_robot_plan(T,NewT).
    
ddp_explain_robot_plan([X|T],[say(['I cant explain this action'])|NewT]):-
    ddp_explain_robot_plan(T,NewT).
    

%In this case the objects are directly added in the order list without checking restrictions. 

ddp_add_list_of_orders_without_verification([X]):-
    open_kb(KB),
    add_object(bring(X),orders,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(say('OK, I will bring it to you')).
    
ddp_add_list_of_orders_without_verification([X,Y]):-
    open_kb(KB),
    add_object(bring(X),orders,KB,KB2),
    add_object(bring(Y),orders,KB2,NewKB),
    save_kb(NewKB),
    assign_func_value(say('OK, I will bring them to you')).
    
    
%%Choose arm to grasp or deliver

ddp_choose_free_arm:-
	open_kb(KB),
    	object_property_value(golem,right_arm,KB,X),
    	ddp_choose_free_arm(X,Arm),
    	print('***********************************************************************************'),
    	print('I choose this arm: '),print(Arm),
    	print('***********************************************************************************'),
	assign_func_value(Arm).

ddp_choose_free_arm(free,right).
ddp_choose_free_arm(_,left).

ddp_actualize_arm_status(right,Y):-
    open_kb(KB),
    change_value_object_property(golem,right_arm,Y,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).
    
ddp_actualize_arm_status(left,Y):-
    open_kb(KB),
    change_value_object_property(golem,left_arm,Y,KB,NewKB),
    save_kb(NewKB),
    assign_func_value(empty).
	
	
ddp_choose_deliver_arm(Obj):-
    open_kb(KB),
    object_property_value(Obj,brand,KB,B),
    object_property_value(golem,right_arm,KB,R),
    object_property_value(golem,left_arm,KB,L),
    ddp_verify_in_which_hand_is_the_object(B,R,L,Arm),    
    print('**********************************************************************************************'),
    print('I will deliver this'),print(B),print(','),print(R),print(','),print(L),print(','),print(Arm),
    print('**********************************************************************************************'),
    assign_func_value(Arm). 
    
ddp_verify_in_which_hand_is_the_object(X,X,_,right).
    
ddp_verify_in_which_hand_is_the_object(_,_,_,left).


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
    %object_property_weight(Obj,Loc1,KB,Value)
    %%change_weight_preference_object_property(Obj,KB,NewKB)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preference demo ends here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Speech and person recognition test
%%% Author
%%% Ivette Velez
%%% Arturo Rodriguez


sprt_get_answer(Question_NL):-
	cognitive_command(Question_NL, Answer_NL), 
	assign_func_value(Answer_NL).
	
sprtDescribeCrowd(crowd(A,B,C)):-
	print('**************************************'),
	print(A),print(B),print(C),
	open_kb(KB),
	change_value_object_property(crowd,persons,A,KB,KB2),
	change_value_object_property(crowd,men,B,KB2,KB3),
	change_value_object_property(crowd,women,C,KB3,NewKB),
	save_kb(NewKB),
	print('**************************************'),
	assign_func_value([ say(['There are',A,'persons in the crowd']), say([B,'of them are men']), say([C,'of them are women']) ]).


%%%
%%% Object Manipulation
%%%
%%% Author: Noe Hdez
min_robot_height(1.12). %Minimun height
max_robot_height(1.77). %Maximum height

%% Author: Noe Hdez
%% This function determines if obj is within Golem's reach with respect to the height
calculate_height(Obj, Tilt, RobotHeight, 1) :-
    calc_height_aux(Obj, Tilt, RobotHeight, 1, [0.21,0.22,0.2248], Res),
    assign_func_value(Res).
    
calculate_height(Obj, Tilt, RobotHeight, 2) :-
    calc_height_aux(Obj, Tilt, RobotHeight, 2, [-0.05,0.22,0.2248], Res),
    assign_func_value(Res).
    
calc_height_aux(object(ID,X,Y,Z,O1,O2,O3,O4,C), Tilt, RobotHeight, Arm, ArmPos, approach(object(ID,X,Y,Z,O1,O2,O3,O4,C), Arm) ) :-   
    min_robot_height(MinH),
    max_robot_height(MaxH),
    nl, nl, print('* * * * * * * * * * * * * * * * *'), print('Calculating height'), print('* * * * * * * * * * * * * * * * *'), nl, nl,
    cam2arm(Arm, RobotHeight, [X,Y,Z], [Tilt,0.04,-0.06], ArmPos, [Height, _, _]),
    MinH < Height, Height < MaxH.
    
calc_height_aux(_, _, _, _, _, error). 
        

%% Author: Noe  Hdez
%% We get the class of object N with this function
get_class_of_obj(unknown) :-
    assign_func_value(unknown).
    
get_class_of_obj(N) :-
    print('Getting class of object: '), print(N), nl,
    open_kb(KB),
    class_of_an_object(N, KB, Res),
    assign_func_value(Res).
    
%% Author: Noe Hdez
%% We get the head of a list
get_head([]):-
    assign_func_value(empty_list).

get_head([H|_]):-
    assign_func_value(H).
    
get_head(_):-
    assign_func_value(non_list).

%% Get the first object whose category is in Cate
get_head_cat([],_):-
    assign_func_value(empty_list).

get_head_cat(L,Cate):-
    is_list(L),
    open_kb(KB),
    aux_get_cat(L,Cate,KB,Obj),
    atom(Obj),
    assign_func_value(Obj).

get_head_cat(_,_):-
    assign_func_value(non_list).

%%
aux_get_cat([],_,_,_).

aux_get_cat([O|_],Cat,KB,O):-
     class_of_an_object(O,KB,Class),  
     aux_get_cat2(Class,Cat).

aux_get_cat([_|T],Cat,KB,O):-
     aux_get_cat(T,Cat,KB,O).

%%
aux_get_cat2(Class,[categval(Class,_,_)|_]).     

aux_get_cat2(Class,[_|T]):-
     aux_get_cat2(Class,T).
    
%% This function determines depending on Height wheteher to take an object or to keep
%% searching for one. Main task: set a table and clean it up
take_find(Height, Obj, Arm, Obj_Name, More_Objs):-
    min_robot_height(MinH),
    max_robot_height(MaxH),
    MinH =< Height, Height =< MaxH,
    assign_func_value( take_obj(Obj, Arm, Obj_Name, More_Objs) ).
    
take_find(_, _, _, _, More_Objs):-
    assign_func_value( find_objs(More_Objs) ).    

%%% Author: Noe Hdez
%%% This function, with the aid of aux_fun, adds new elements in the list 'New' to the ones present is list 'Old'
remove_repeated(New, Old_Cat, Scan, Tilt, RobotHeight):-
    aux_func(New, Old_Cat, Scan, Tilt, RobotHeight, Return),
    assign_func_value(Return)
.
 
aux_func([], Old_Cat, _, _, _, Old_Cat).

aux_func([object(unknown,_,_,_,_,_,_,_,_)|More_New], Old_Cat, Scan, Tilt, RobotHeight, R1):-
    aux_func(More_New, Old_Cat, Scan, Tilt, RobotHeight, R1)
.
aux_func([object(Name,X,Y,Z,_,_,_,_,_)|More_New], Old_Cat, Scan, Tilt, RobotHeight, R1):-
    open_kb(KB),
    class_of_an_object(Name, KB, Category),
    is_new(Category, Old_Cat),
    min_robot_height(MinH),
    max_robot_height(MaxH),
    cam2arm(1, RobotHeight, [X,Y,Z], [Tilt,0.04,-0.06], [-0.05,0.22,0.2248], [Height, _, _]),
    MinH =< Height, Height =< MaxH,     
    aux_func(More_New, [categval(Category, Scan, Tilt)|Old_Cat], Scan, Tilt, RobotHeight, R1)
.
aux_func([_|More_New], Old_Cat, Scan, Tilt, RobotHeight, R1):-
    aux_func(More_New, Old_Cat, Scan, Tilt, RobotHeight, R1)
.

%% Author: Noe Hernandez
%% Determines if the first argument is not present in the list given as the second argument
is_new(_, []).
    
is_new(Cat1, [categval(Cat2, _, _)|More]):-
    Cat1 \== Cat2, !,
    is_new(Cat1, More)
.

%% Author: Noe Hernandez
%% This function selects the right task when trying to determine
%% whether Golem searches for objects in a category or simply
%% executes the default task
extract_categories(Obj_Cat, List_Cat, Arm):-
    extract_cat_aux(Obj_Cat, List_Cat, Scan, Tilt),    
    assign_func_value( search_height(Obj_Cat, Arm, [Scan], [Tilt]) ).
    
extract_categories(_, _, 1):-
    assign_func_value( release_right ).
    
extract_categories(_, _, 2):-
    assign_func_value( release_left ).

    
extract_cat_aux(Category, [categval(Category, Scan, Tilt)|_], Scan, Tilt).
extract_cat_aux(Category, [_|More_Cat], Scan, Tilt):-
    extract_cat_aux(Category, More_Cat, Scan, Tilt),!.
    
%% Author: Noe Hernandez
list_fil(List, Val):-
    print('Excluding list filtering.'), nl,
	aux_list_fil(List, Val, Ans), assign_func_value(Ans)
.

aux_list_fil([], _, []).
aux_list_fil([Val | More], Val, More).
aux_list_fil( [_ | More], Val, L):-
	aux_list_fil(More, Val, L)
.

list_hor(List, Val):-
    print('Including list filtering.'), nl,
	aux_hor(List, Val, Ans), assign_func_value(Ans)
.

aux_hor([], _, []).
aux_hor([V | Mas], V, [V | Mas]).
aux_hor([_| Mas], V, L):-
	aux_hor(Mas, V, L)
.

%% This function sets the value of the flag that determines whether Golem 
%% first turned right or left when approaching an object
set_turn_flag(Angle):-
    var_op(get(turn_flag_approach, Flag_Value)),
    check_flag_value(Flag_Value, Angle),
    assign_func_value(empty)
.  

check_flag_value(0.0, Angle):-
    ( Angle > 0.0 ->
         print('Positive: '), print(Angle), nl,
         var_op(set(turn_flag_approach, -5.0))
     | otherwise -> 
         print('Negative: '), print(Angle), nl,
         var_op(set(turn_flag_approach, 5.0))
    )
.

check_flag_value(_, _).


%%% GPSR task
%%% check_tasks_gpsr -> checks that the list of tasks doesn't start with take(object(X))
check_acts_gpsr([take(object(X))|More]):-
    assign_func_value([take(object(X),unknown)|More]).

check_acts_gpsr(Acts):-
    assign_func_value(Acts).

%%% GPSR task
%%% Author: Noe Hdez
%%% This function generates a string (Atom) with the current date
hoy :-
    consult_date_hour(_, _, _, _, _, _, _, _, Day_Week, _),
    assign_func_value(['today is', Day_Week])
.

%%% Author: Noe Hdez
%%% This function generates a string (Atom) with the current date
manana :-
    consult_date_hour(_, _, _, _, _, _, _, _, _, Tomorrow_Week),
    assign_func_value(['tomorrow is', Tomorrow_Week])
.

%%% Author: Noe Hdez
%%% This function generates a string (Atom) with the current date
fecha :-
    consult_date_hour(_, _, _, _, Day, _, _, _, _, _),
    atom_number(X,Day),
    assign_func_value(['the day of the month is', X])
.


%%% Author: Noe Hdez
%%% This function generates a string (Atom) with the current time
hora :-
    consult_date_hour(_, Time, _, _, _, _, _, _, _, _),
    assign_func_value(Time)
.

%%% Author: Ivette
%%% day_of_week --> says the day of the week
day_of_week(1, 'monday'):-!.
day_of_week(2, 'tuesday'):-!.
day_of_week(3, 'wednesday'):-!.
day_of_week(4, 'thursday'):-!.
day_of_week(5, 'friday'):-!.
day_of_week(6, 'saturday'):-!.
day_of_week(0, 'sunday'):-!.


%%% Author: Ivette
%%% consult about the dates and hours
consult_date_hour(Date, Time, Year, Month, Day, Hour, Min, Sec, Day_Week, Tomorrow_Week):-
	get_time(X),
	% Organizando la hora a la zona horaria correcta, en méxico -5 horas, para japón +9 horas
	%Y is X + (3600*(-5)),
	Y is X + (3600*(-5)),
	stamp_date_time(Y, date(Year, Month, Day, Hour, Min, Sec, _, _, _), 'UTC'),
	day_of_the_week(date(Year, Month, Day), Day_W),
	T_W is Day_W + 1,
	Tomorrow_W is T_W mod 7,
	day_of_week(Day_W, Day_Week),
	day_of_week(Tomorrow_W, Tomorrow_Week),
	Date = ['the year is', Year, 'the month is', Month, 'the day is', Day],
	Time = ['the time is',Hour,'hours and', Min, 'minutes'].

%%% Author: Noe Hdez
%%% This function returns the path to search for object Obj
get_path_obj(Obj) :-
    print('Getting path for searching object: '), print(Obj), nl,
    open_kb(KB),
    class_of_an_object(Obj, KB, Class),
    print('Class '),  print(Class), nl, nl,
    class_relation_value(Class, in_room, KB, Room),
    print('Room '),  print(Room), nl, nl,
    object_property_value(Room, object_path, KB, Path),
    print('Path '),  print(Path), nl, nl,
    assign_func_value(Path).


%%% Authors: Noe Hdez and Ivette Vélez
%%% This function returns the path to search for class
get_path_class(Class) :-
    print('Getting path for searching objects in class: '), print(Class), nl,
    open_kb(KB),
    class_relation_value(Class, in_room, KB, Room),
    print('Room '),  print(Room), nl, nl,
    object_property_value(Room, object_path, KB, Path),
    print('Path '),  print(Path), nl, nl,
    assign_func_value(Path).
    

%%% Author: Noe Hdez
%%% This function replaces the object to be taken by a take behaviour
%%% within the list of actions for the GPSR task. If we encounter a second 'find',
%%% we do not replace the object to be taken any further since such an object
%%% is out of scope
replace_take(List):-
    nl, nl, print('Entre a replace_take'), nl, nl,
    print('Lista: '), nl, print(List), nl,
    replace_take_aux(List, New_List),
    assign_func_value(New_List).
    
%% This function leaves the first find it faces, and takes the object such a find returns to perform the
%% substitution in the remaining actions by the replace_take_aux2
replace_take_aux([], []).
replace_take_aux([find(Kind, Sought, Place, Ori, Tilt, Modes, [New_Obj|More], Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T1], [find(Kind, Sought, Place, Ori, Tilt, Modes, [New_Obj|More], Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T2]):-
    nl, print('Primer find'), nl, 
    replace_take_aux2(New_Obj, T1, T2),!.
replace_take_aux([H|T1], [H|T2]):-replace_take_aux(T1, T2).

%% Replaces the object the take task will get 
replace_take_aux2(_, [], []).
replace_take_aux2(_, [find(Kind, Sought, Place, Ori, Tilt, Modes, Found, Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T], [find(Kind, Sought, Place, Ori, Tilt, Modes, Found, Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T]):-!.
replace_take_aux2(New, [take(_, Arm, N, St)|T], [take(New, Arm, N, St)|T]):-print('Acabo. El valor es '), print(New), nl, nl, print([take(New, Arm, N, St)|T]), nl, nl, nl, !.
replace_take_aux2(New, [H|T1], [H|T2]) :- nl, print('El valor es '), print(New), nl, replace_take_aux2(New, T1, T2).


%%%
%%% This function replaces the object to be taken by the take behavior
%%% within the list of action produced by the GPSR task. This is the case 
%%% for the 'category' mode
replace_task_obj_cat(List):-
    nl, nl, print('Entre a replace_task_obj_cat'), nl, nl,
    print('Lista: '), nl, print(List), nl,
    replace_take_aux(List, Tmp1),
    replace_obj_name(Tmp1, New_List),
    assign_func_value(New_List).

%%%
%%% This function replaces the object to be taken by the take behavior
%%% within the list of action produced by the GPSR task. Since we are possible
%%% going to take another objcts, we also  have to change any reference to that object 
replace_taks_obj(List):-
    nl, nl, print('Entre a replace_taks_obj'), nl, nl,
    print('Lista: '), nl, print(List), nl,
    replace_taks_obj_aux(List, New_List),
    assign_func_value(New_List).
    
%%%  This functions performs the work done by replace_task
%%%  and then changes the object the GPRS tasks refers to
replace_taks_obj_aux(List, New_List):-
    replace_take_aux(List, Tmp1),
    replace_obj_name(Tmp1, Tmp2),
    add_apology_class(Tmp2, New_List).
    
%%%  We change the name of the object we find
%%%  thanks to the function replace_obj_name_aux
replace_obj_name([],[]).
replace_obj_name([find(Kind, Sought, Place, Ori, Tilt, Modes, [object(Name, U, V, W, O1, O2, O3, O4, Conf)|More], Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T1], [find(Kind, Sought, Place, Ori, Tilt, Modes, [object(Name, U, V, W, O1, O2, O3, O4, Conf)|More], Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T2]):-
    replace_obj_name_aux(Name, T1, T2),!.
replace_obj_name([H|T1],[H|T2]):-replace_obj_name(T1,T2).

replace_obj_name_aux(_, [], []).
replace_obj_name_aux(_, [find(Kind, Sought, Place, Ori, Tilt, Modes, Found, Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T], [find(Kind, Sought, Place, Ori, Tilt, Modes, Found, Rem_Pos, ScanFst, TiltFst, SeeFst, St)|T]):-!.
replace_obj_name_aux(Name, [consult_kb(change_object_property, [golem,found,_], Out, St)|T], [consult_kb(change_object_property, [golem,found,Name], Out, St)|T]):-!.
replace_obj_name_aux(New, [H|T1], [H|T2]):-replace_obj_name_aux(New, T1, T2).

add_apology_class([], []).
add_apology_class([say(['I delivered the'|Say],_)|More], [say(['Apologies, I delivered the'|New_Say],_)|More]):-
    append(Say, ['This might be not the object you asked for', 'However, it is one belonging to the same class'], New_Say).
add_apology_class([H|T1], [H|T2]):-add_apology_class(T1, T2).

%%%
%%% Reset the error counter for all recovery protocols
reset_error_counters :-
    var_op(set(gpsr_error, 0)),
    var_op(set(deliver_nav_error, 0)),
    var_op(set(find_empty_scn_error, 0)),
    var_op(set(find_nav_error, 0)),
    var_op(set(find_not_fnd_error, 0)),
    var_op(set(find_not_fnd_prsn_error, 0)),
    var_op(set(find_lost_user_error, 0)),
    var_op(set(mv_error, 0)),
    var_op(set(question_error, 0)),
    var_op(set(say_error, 0)),
    var_op(set(tk_empty_scn_error, 0)),
    var_op(set(tk_nav_error, 0)),
    var_op(set(tk_not_fnd_error, 0)),
    var_op(set(tk_not_grasped_error, 0)),
    var_op(set(follow_error, 0)),
    assign_func_value(empty).

%%%
%%%
find_pos([Head|_]):-
    open_kb(KB),
    objects_of_a_class(location,KB,Locations),
    aux_find_pos(Locations, Head, KB, Loc),
    object_relation_value(Loc, in_room, KB, Room),
    object_property_value(Room,human_path,KB,Value),
    assign_func_value(Value).

find_pos(Positions):-
    assign_func_value(Positions).
    
aux_find_pos([Loc|_], Head, KB, Loc):-
    object_property_value(Loc,position,KB,Head).
    
aux_find_pos([_|More], Head, KB, Loc):-
    aux_find_pos(More, Head, KB, Loc).


%%%
%%% This function gives the list of actions
%%% that Golem can safely resume doing after
%%% a FIND error
new_tasks_find(Remaining_tasks, New_Tasks) :-
    aux_new_tasks_find(Remaining_tasks, New_Tasks),
    assign_func_value(empty).
    
aux_new_tasks_find([], []).
aux_new_tasks_find([say(['I see'| _],_)|MoreTasks], [say('Apologies, I did not find the person I was looking for', _)|MoreTasks]).
aux_new_tasks_find([_|MoreTasks], New_Tasks) :-
    aux_new_tasks_find(MoreTasks, New_Tasks).


%%%
%%% This function gives the list of actions
%%% that Golem can safely resume doing after
%%% a FOLLOW error
new_tasks_follow(Remaining_tasks, New_Tasks) :-
    aux_new_tasks_follow(Remaining_tasks, New_Tasks),
    assign_func_value(empty).
    
aux_new_tasks_follow([], []).
aux_new_tasks_follow([say(['I am finished following this person'],_)|MoreTasks], [say('Apologies, I cannot follow this person', _)|MoreTasks]).
aux_new_tasks_follow([_|MoreTasks], New_Tasks) :-
    aux_new_tasks_follow(MoreTasks, New_Tasks).


%%%
%%% This function gives the list of actions
%%% that Golem can safely resume doing after
%%% a GENDER error
new_tasks_gender(Remaining_tasks, New_Tasks) :-
    aux_new_tasks_gender(Remaining_tasks, New_Tasks),
    assign_func_value(empty).
    
aux_new_tasks_gender([], []).
aux_new_tasks_gender([say(['The gender of the person is'|_],_)|MoreTasks], [move(waiting_position,_), say('Apologies, I am unable to get the gender of this person', _)|MoreTasks]).
aux_new_tasks_gender([_|MoreTasks], New_Tasks) :-
    aux_new_tasks_gender(MoreTasks, New_Tasks).


%%% This function gives the list of actions
%%% that Golem can safely resume doing after
%%% a POSE error
new_tasks_pose(Remaining_tasks, New_Tasks) :-
    aux_new_tasks_pose(Remaining_tasks, New_Tasks),
    assign_func_value(empty).
    
aux_new_tasks_pose([], []).
aux_new_tasks_pose([say(['The person is'|_],_)|MoreTasks], [move(waiting_position,_), say('Apologies, I am unable to get the pose of this person', _)|MoreTasks]).
aux_new_tasks_pose([_|MoreTasks], New_Tasks) :-
    aux_new_tasks_pose(MoreTasks, New_Tasks).


%%%
%%% This function determines whether 'cereal' is 
%%% present in Sentence. If so, the next dialogue
%%% model is given the list with [cereal, juice]. 
%%% Otherwise, the list is [soup, coke]
kind_order(Sentence) :-
    atomic_list_concat(List, ' ', Sentence),	
    ( member(kellogs,List) ->
       assign_func_value( get_order([kellogs, coke]) )
     | otherwise ->
       assign_func_value( get_order([noodles, heineken]) )
    )
.

    
%%%
%%% QR Codes
%%% Author: Noe Hdez
%%% This function takes a string and removes any upper case letter, comma, and other symbols that hinders
%%% the correct work of the parse for the GPSR task
parse_string_gpsr(Str_In) :- 
    downcase_atom(Str_In, Tmp1),
    my_str_split(Tmp1, [' ', ',', '.', '-', '_'], Tmp2),
    remove_null_str(Tmp2, Tmp3),
    atomic_list_concat(Tmp3, ' ', Str_Out),
    assign_func_value(Str_Out)
.

my_str_split(Original, [], Original).
my_str_split(Original, [H|T], Final):-
    atomic_list_concat(List, H, Original),
    aux_str_split(List, T, Final)
.

aux_str_split(List, [], List).
aux_str_split(List, [X|Xs], Final):-
    parse_tmp(List, X, Sol),
    aux_str_split(Sol, Xs, Final)
.

parse_tmp([],_,[]).
parse_tmp([H|T], X, Sol):-
    atomic_list_concat(S1, X, H),
    parse_tmp(T, X, S2),
    append(S1, S2, Sol)
.

remove_null_str([], []).
remove_null_str([""|More], Res):-
    remove_null_str(More,Res).
remove_null_str([''|More], Res):-
    remove_null_str(More,Res).
remove_null_str([Str|More],[Str|Res]):-
    remove_null_str(More,Res).
    
    
%%
%%
%% Author Noe Hernandez
add_interleaved_vals(L):-
 interleaved_tmp(L,NewL),
 assign_func_value(NewL)
.

interleaved_tmp([],[]).
interleaved_tmp([Val|Tail1],[Val,turn=>(-36.0),turn=>(72.0)|Tail2]):-
  interleaved_tmp(Tail1,Tail2)
.

    
%%
%%
%% Author Noe Hernandez
to_radians(D,R):-
  print('Degree to radians. Degree: '),print(D),nl,
  Rad is D*3.14159/180,
  mod_pi(Rad,R),
  print('Radians: '),print(R),nl.
  
mod_pi(Radians, Result):-
  ( Radians > 3.14159 ->
    Rad is -2*3.14159+Radians
  | otherwise ->
    Rad is Radians
  ),
  ( Rad < -3.14159 ->
    Rad_ is 2*3.14159+Rad
  | otherwise ->
    Rad_ is Rad
  ),
  ( Rad_ > 3.14159 ->
    mod_pi(Rad_, Result)
  | Rad_ < -3.14159 ->
    mod_pi(Rad_, Result)
  | otherwise ->
    Result = Rad_
  ).
  
% This predicate sorts the list of planes
sort_planes(Planes):-
  compute_dist(Planes, PlanesDist),
  sort(PlanesDist, SortedDist),
  remove_dist(SortedDist, Res),
  assign_func_value(Res).
  
% The distance to each plane is computed and added as a fist element of
% an ordered pair. The second element of such an ordered pair is the plane itself  
compute_dist([],[]).
compute_dist([plane(X,Y,Z,A)|More],[(Dist,plane(X,Y,Z,A))|MoreDist]):-
  XBase is X - 0.10,
  ZBase is Z,
  Dist is round(sqrt(XBase * XBase + ZBase * ZBase) * 10000) / 10000,
  compute_dist(More, MoreDist).
  
% The distance that was previously added as the first element of an ordered
% pair is removed, obtaining so the list of bare planes  
remove_dist([],[]).
remove_dist([(_,plane(X,Y,Z,A))|More],[plane(X,Y,Z,A)|Mas]):-
  remove_dist(More,Mas).

%%
angle_modulo(Angle, Result):-
   (Angle > 180.0 ->
      NewAngle is Angle - 360.0
   |  otherwise ->
      NewAngle is Angle
   ),
   (NewAngle < -180.0 ->
      Result is NewAngle + 360.0
   |  otherwise -> 
      Result is NewAngle
   ).
   
add_to_angle_sg(DeltaAngle,true,addition):-
     var_op(get(angle_storing_groceries, Angle)),
     Tmp0 is Angle + DeltaAngle,
     angle_modulo(Tmp0, Tmp),
     var_op(set(angle_storing_groceries, Tmp)),
     Neg is -Tmp,
     var_op(set(neg_angle_storing_groceries, Neg)),
     assign_func_value(empty).   

add_to_angle_sg(DeltaAngle,true,substraction):-
     var_op(get(angle_storing_groceries, Angle)),
     Tmp0 is Angle - DeltaAngle,
     angle_modulo(Tmp0, Tmp),
     var_op(set(angle_storing_groceries, Tmp)),
     Neg is -Tmp,
     var_op(set(neg_angle_storing_groceries, Neg)),
     assign_func_value(empty).   
    
add_to_angle_sg(_,_,_):-
     assign_func_value(empty).   
   

%%
%% For new demo paper
%Example of user functions structure
f(X) :- var_op(get(day, Day)),
	nl,print('X is:'),print(X),nl,
	(X == Day -> Y = ok
	|otherwise -> Y = 'not ok'),
	% Assign function value
	assign_func_value(Y).
% Example of function consulting
% the history
g(_) :- get_history(History),
        print(History), nl,
	get_last_transition(History,Last),
	% Assign function value
	assign_func_value(Last).
% Example of next state selection
% function
h(X, Y) :- (X == Y -> Next_Sit = is
           |otherwise -> Next_Sit = rs),
	   % Assign function value
	   assign_func_value(Next_Sit).
