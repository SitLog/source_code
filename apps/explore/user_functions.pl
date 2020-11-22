

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
  ( Size == Size_-> 
    Res = TrueVal
  | otherwise ->
    Res = FalseVal
  ),
  print(aaaaa),print(List),print(Res),nl,
  assign_func_value(Res)
.

% Verified time
check_time(ATime,ADay) :-
  datime(datime(Year,Month,Day,Hour,Min,Sec)),
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

include(Pred, [], Acc, Acc).
include(Pred, [X|R], Acc,News):-
  VP =.. [Pred,X],
  VP,
  include(Pred, R, [X|Acc],News).
include(Pred, [X|R], Acc,News):-
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
go_point([Pt|RPt],Sit1,Sit2,Var):-
  var_op(set(Var,RPt)),
  print('Value: '),print(RPt),nl,
  Res =.. [Sit1,Pt],
  print('Res: '),print(Res),nl,
  assign_func_value(Res)
.
go_point([],Sit1,Sit2,Var):-
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

include(Pred, [], Acc, Acc).
include(Pred, [X|R], Acc,News):-
    VP =.. [Pred,X],
    VP,
    include(Pred, R, [X|Acc],News).
include(Pred, [X|R], Acc,News):-
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
  Pred =.. [Res,Arg], 
  print('Result: '),print(Res),nl,
  assign_func_value(Res)
.

getArg(Pred,Arg) :-
  Pred =.. [Res,Arg], 
  print('Result: '),print(Arg),nl,
  assign_func_value(Arg)
.

getExp(Pred,Arg2) :-
  Pred =.. [Res,Arg], 
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
  var_op(get(v_objects,Obj)),

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

actions_reasoner(Actions_List) :-
  print('Executing actions_reasoner'), nl,
  print('Explicit Action List: '), print(Actions_List), nl,
	
  Next_Situation =.. [dispatch|[Actions_List]],

  print('Next_Situation: '),print(Next_Situation), nl,


  % Assign function value
  assign_func_value(Next_Situation).


parse(In,Out):-
  % Calling the interpreter
  ( mode_exe(test) -> 
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



%%% Restaurant %%%%%%%
fix_points(Dir,pos(X1,Y1,A11),pos(X2,Y2,A2)) :-
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
  X2_ is X1+1.50*cos(A1_),
  Y2_ is Y1+1.50*sin(A1_),
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
  Res = pos(X2,Y2,A2),
  print('Real address: '),
  print(X2),print(', '),print(X1),
  print(Y2),print(', '),print(Y1),
  print(A2),print(', '),print(A1), nl,
  assign_func_value(Res).

paste_command([],Acc,Acc).
paste_command([P1|Rest],C1,Res):-
  atom_concat(C1,' ',C2),
  atom_concat(C2,P1,C3),
  paste_command(Rest,C3,Res).

collect_points([],[]).
collect_points([Point|Rest],[Block|Rest2]):-
  Point =.. [Pred,Name,pos(X,Y,Z)],
  atom_concat('',Name,Name1),
  atom_concat(Name1,',',F1),
  number_codes(X,XC),
  atom_codes(XA,XC),
  atom_concat(F1,XA,F2),
  atom_concat(F2,',',F3),
  number_codes(Y,YC),
  atom_codes(YA,YC),
  atom_concat(F3,YA,F4),
  atom_concat(F4,',',F5),
  number_codes(Z,ZC),
  atom_codes(ZA,ZC),
  atom_concat(F5,ZA,F6),
  atom_concat(F6,'',Block),
  collect_points(Rest,Rest2).

generate_nav_files(Points) :-
  print('in'),
  collect_points(Points,Points2),
  print(Points2), nl,
  paste_command(Points2,'./scripts/generate_points ',Command),
  print(Command), nl,
%  exec(Command,[std,std,std],H),
  assign_func_value(Command).

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
  Delta is Distance - (Max_Dist - 0.10),
  fine_delta(Delta, Fine_Delta),
  Final_Delta is (Fine_Delta * 10000) / 10000,
  %Final_Delta is round(Fine_Delta * 10000) / 10000,
  assign_func_value(Final_Delta).

fine_delta(Delta, 0.0) :-
  -0.1 < Delta,
  Delta < 0.1.

fine_delta(Delta, Delta).

delta_angle(DeltaAngle, MaxAngle, LastScan) :-
  D is round(DeltaAngle),
  M is round(MaxAngle),
  L is round(LastScan), 
  -M < (D + L),
  (D + L) < M,
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

initialize_parser:-
    initializing_parser,
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
decide_position_to_approach(R,O,Z,Advance,Turn):-
	O > 0,
	R > 1.5,
	Advance is R-1.5+0.01,
	Turn is 90-O+0.01,
	assign_func_value([]).

decide_position_to_approach(R,O,Z,Advance,Turn):-
	O > 0,
	Advance is 0.01,
	Turn is 90-O+0.01,
	assign_func_value([]).

decide_position_to_approach(R,O,Z,Advance,Turn):-
	R > 1.5,
	Advance is R-1.5+0.01,
	Turn is (90-O)*(-1)+0.01,
	assign_func_value([]).
	
decide_position_to_approach(R,O,Z,Advance,Turn):-
	Advance is 0.01,
	Turn is (90-O)*(-1)+0.01,
	assign_func_value([]).
	
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
	Height is H/100,
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

:- consult('$SITLOG_HOME/apps/test_behaviors/gpsr/action_reasoner.pl').

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



%%%%%%%%%%%%%%%%%%%%%% G U I D E D     T O U R %%%%%%%%%%%%%%%%%%%%
missing_orders(T,O) :-
	T > O,
	assign_func_value(true).

missing_orders(_,_) :-
	assign_func_value(false).

update_class_location_kb(PositionName) :-
	open_kb(KB),
	there_is_class(PositionName,KB),
	add_class_property(PositionName,is_in,PositionName,KB,NewPropKB),
	save_kb(NewPropKB),
	assign_func_value(true).

update_class_location_kb(_) :- assign_func_value(true).

spot_side([XPerson,YPerson,ZPerson,AngleGesture]) :-
	AngleGesture >= 0,
	assign_func_value(right).	

spot_side(_) :-
	assign_func_value(left).	
		
% correct_position([XPerson,YPerson,ZPerson,AngleGesture],[XRobot,YRobot,AngleRobot]) :-
% 	XRobot + Xperson, YR
% 	assign_func_value(CorrectedPosition).

%%%%%%%%%%%%%%%%%%%%%% F E T C H %%%%%%%%%%%%%%%%%%%%
register_max_time(MaxHrs,MaxMins,MaxSecs) :-	
	datime(datime(Year,Month,Day,Hour,Min,Sec)),
     	var_op(set(max_time,[Hour + MaxHours, Min + Maxmins, Sec + MaxSecs])),
	assign_func_value(true).
					

fetch_time_over(_,_) :- assign_func_value(false).

fetch_time_over(_,time) :-  
	var_op(get(strict_time, StrictTime)), 
     	assign_func_value(true).

fetch_time_over(_,time) :- 
	assign_func_value(false).

fetch_time_over(_,time) :- 	
	datime(datime(Year,Month,Day,Hour,Min,Sec)),				    
	var_op(get(max_time, MaxTime)),
	check_time_left(MaxTime, [Hour, Min, Sec]),
	assign_func_value(false).

fetch_time_over(FetchedObjects,time) :-	
	assign_func_value(true).

fetch_time_over(_,_) :-	
	assign_func_value(false).

fetch_choose_next(_,[],_,_) :-
	assign_func_value(success).

fetch_choose_next(_,_,_,[]) :-
	assign_func_value(success).

fetch_choose_next(force_full,ObjectsLeft, SeenObjects, UnexploredPos) :-
	var_op(get(find_currpos,CurrPos)),
	current_location(ObjectsLeft,SeenObjects,CurrPos,UnexploredPos,SearchPath),
	var_op(get(left_arm,LeftArm)),
	var_op(get(right_arm,RightArm)),							
	assign_func_value(fetch(ObjectsLeft,SearchPath,LeftArm,RightArm)).

fetch_choose_next(first_only,_,_,_) :- 
	assign_func_value(success).

fetch_choose_next(time,ObjectsLeft, SeenObjects, UnexploredPos) :-	
	datime(datime(Year,Month,Day,Hour,Min,Sec)),	
	var_op(get(max_time, MaxTime)),
	check_time_left(MaxTime, [Hour, Min, Sec]),
	var_op(get(find_currpos,CurrPos)),					
	current_location(ObjectsLeft,SeenObjects,CurrPos,UnexploredPos,SearchPath),
	var_op(get(left_arm,LeftArm)),
	var_op(get(right_arm,RightArm)),
	assign_func_value(fetch(ObjectsLeft,SearchPath,LeftArm,RightArm)).

fetch_choose_next(time,_,_,_) :-	
	assign_func_value(success).

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

check_time_left([MaxHr,_,_],[CurrHour,_,_]) :- 
	MaxHr > CurrHour.

check_time_left([MaxHr,MaxMin,_],[MaxHr,CurrMin,_]) :- 	
	MaxHr == CurrHour, 
	MaxMin > CurrMin.

check_time_left([MaxHr,MaxMin,MaxSec],[MaxHr,MaxMin,CurrSec]) :- 	
	MaxHr == CurrHour, 
	MaxMin == CurrMin,
	MaxSec > CurrSec.

%%%%%%%%%%%%%%%%%%%%%%%% F I N D    S E A R C H    L O C A T I O N S %%%%%%%%%%%%%%%%%%%%%%%%
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

object_locations_kb([],[]). %%append([], [], SearchPath).

object_locations_kb([H|T],SearchPath) :-	
	consult_locations_kb(H,HeadLoc),
	object_locations_kb(T,TailLocs),
	append(HeadLoc, TailLocs, SearchPath).
			
consult_locations_kb(ObjectID,SearchPath) :-	
	open_kb(KB),
	there_is_object(ObjectID,KB),	
	print('There is '), print(ObjectID), nl,
%%	object_properties(ObjectID,KB,Properties),
%%	there_is_property(is_in,Properties),
	object_property_value(ObjectID,in_location,KB,Location),
	print('Location of '), print(ObjectID), print(' is '), print(Location),nl,
	append([Location], [], SearchPath).

% object_locations_kb(ObjectID,SearchPath) :-	
% 	open_kb(KB),
% 	there_is_object(ObjectID,KB),
% 	object_properties(ObjectID,KB,Properties),
% 	there_is_property(in,Properties),
% 	object_property_value(ObjectID,in,KB,SearchPath).

%%object_locations_kb(_,[]).

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

%%%%%%%%%%%%%%%%%%%%%%%% F I N D   D E S T I N A T I O N %%%%%%%%%%%%%%%%%%%%%%%%
find_destination(free,_) :-	
	assign_func_value(_).

find_destination(Obj,[]) :-	
	print('Fatal error: could not find destination for'), 
	print(Obj), nl, 
	termina_diag_manager.

find_destination(Obj,[order(Obj,Dest)|Tail]) :- assign_func_value(Dest).

find_destination(Obj,[_|Tail]) :-
	find_destination(Obj,Tail).

%%%%%%%%%%%%%%%%%%%%%%%% Function to remove_element%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%% function to update objects search locations %%%%%%%%%%%%%%%%
current_location([], _, _, _,[]). 

current_location(_, [], _, RestLocs,RestLocs). 

current_location(ObjectsLeft, _, CurrLoc, RestLocs, [CurrLoc,RestLocs]) :- 
	var(ObjectsLeft).
 
current_location(ObjectsLeft, [[Object_ID, X, Y, Z, O1, O2, O3, O4, Conf]|RestObjs], CurrLoc, RestLocs,SearchPath) :- 
	member(Object_ID, ObjectsLeft),
	append([CurrLoc],RestLocs,SearchPath).

current_location(ObjectsLeft, [[Object_ID, X, Y, Z, O1, O2, O3, O4, Conf]|RestObjs], CurrLoc, RestLocs,SearchPath) :- 	
	current_location(ObjectsLeft, RestObjs, CurrLoc, RestLocs,SearchPath).

%%%%%%%%%%%%%%%%%%%%%%%% F E T C H     A N D      C A R R Y %%%%%%%%%%%%%%%%%%%%%%%%
choose_search_path(ObjectsLeft, Seen,UnexploredPos) :-
	var_op(get(find_currpos, CurrLoc)),
	current_location(ObjectsLeft,Seen,CurrLoc,UnexploredPos,SearchPath),
	assign_func_value(SearchPath). 

extract_objects(Orders) :-	
	extract_element(Orders, Objects),
	assign_func_value(Objects).
    
extract_element([],ObjList) :- 	
	append([], [], ObjList).

extract_element([order(Obj,Dest)|Tail], ObjList) :-	
	extract_element(Tail, Z),
	append([Obj], Z, ObjList).

%%%%%%%%%%%%%%%%%%%%%%%% R E M O V E / A D D     O B J E C T  (L I S T)%%%%%%%%%%%%%%%%%%%%%%%%
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

append_object([],[]) :-	
	assign_func_value([]).			

append_object([],[H|T]) :-	
	assign_func_value([H|T]).			

append_object([H|T],[]) :- 
	assign_func_value([H|T]).

append_object([H1|T1],[H2|T2]) :- 
	append([H1|T1],[H2|T2],List),
	assign_func_value(List).

append_object([H|T],Rest) :-	
	append([H|T],[Rest],List),
	assign_func_value(List).

append_object(Head,[H|T]) :-	
	append([Head],[H|T],List),
	assign_func_value(List).

append_object(Head,[]) :-	
	append([Head],[],List),
	assign_func_value(List).

append_object(Head,Rest) :-	
	append([Head],[Rest],List),
	assign_func_value(List).

calcular_estrategia(R,D1,D2) :-
	D1 is (R/2000)+1.2,
	D2 is (R/2000)+0.6,
	assign_func_value(rodear_crowd1(D1,D2)).



%Ask: checking not empty hypothesys

check_not_empty_hypothesys(nothing,Conf):-
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

detect_gesture_mode(handup):-
    assign_func_value(1).
    
detect_gesture_mode(waving):-
    assign_func_value(2).
    
detect_gesture_mode(pointing):-
    assign_func_value(3).
    
    
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
    find_human_with_ID(List,ID,Name),
    assign_func_value(Name).
    
find_human_with_ID([],ID,'unknown').

find_human_with_ID([N:ID|T],ID,Name):-
    open_kb(KB),
    object_property_value(N,name,KB,Name).
    
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

supermarket_parser('do you have a dairy product that is on discount'):-
    assign_func_value(bring_me(dairy,on_discount=>yes)).
    
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
   

%%%
%%% Object Manipulation
%%%
remove_repeated(New, Old):-
    print('Possibly adding new seen objects'), nl,
    aux_func(New, Old, Return),assign_func_value(Return)
.

aux_func([], Old, Old)
.
aux_func([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|More_New], Old, Return):-
    is_present(object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score), Old, R0), 
    print('Yay! New object (User function): '), print(R0), nl,
    aux_func(More_New, Old, R1), 
    append(R0, R1, Return)
.

is_present(O, [], [O]):-
print('is present 3 here'), nl
.    
is_present(object(Name,_,_,_,_,_,_,_,_), [object(Name,_,_,_,_,_,_,_,_)|Old], []):-
print('is present 1 here'), nl
.
is_present(Object, [Head|Old], Return):-
    print('is present 2 here'), nl, is_present(Object, Old, Return)
.

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

rel_fin(2):-
	assign_func_value( release_fin )
.

rel_fin(1):-
	assign_func_value( fs )
.
