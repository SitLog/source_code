/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2012 Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)

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

%:- use_module(library(random)).
%:- use_module(library(system)).

% Random functions 

get_random_element(L,E) :-
	  pid(PID),
	  ( PID > 30000 ->
	    setrand(rand(5,13,890))
	  | otherwise ->
	    setrand(rand(PID,13,PID))
	  ),
  length_list(L,Size),
  random(0,Size,Id),
  idx_object(Id,L,E).

get_random_element2(L,E) :-
  length_list(L,Size),
  random(0,Size,Id),
  idx_object(Id,L,E).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Operations on lists                                 %   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% append([],L,L).
%% append([X|L1],L2,[X|L3]) :- 
%%   append(L1,L2,L3), !.

%% reverse([],[]).
%% reverse([H|T],L) :- 
%%   reverse(T,Z), append(Z,[H],L), !.

% Stack
push(Element, In_Stack, Out_Stack) :- 
  append([Element], In_Stack, Out_Stack).

pop([], empty).
pop([Element|Rest], Element). 

%% member(E, []) :- 
%%   fail.
%% member(E, [E|T]).
%% member(E, [_|T]) :- 
%%   member(E, T).

not_member(_,[]).
not_member(E, [H|T]) :- 
  E \== H,
  not_member(E,T).

length_list([],0):-
print('Empty list'),nl. 
length_list([H|T],N) :-
  length_list(T,M),
  N is M + 1, !.

empty_list(L) :-
  length_list(L,N),
  N == 0, !.

first([], non).
first([H|T],H).

rest([], []).
rest([H|T], T).

%% last(LIST,L) :-
%%   reverse(LIST,R),
%%   first(R,L), !.

rotate_list([H|T],R) :- 
  append(T,[H],R).

% filter_elment(E,L,F) filters E element from list L and returns list F
filter_element(_,[],[]).
filter_element(E,[E|T],LIST) :-
append([],T,LIST).
%  filter_element(E,T,LIST).

filter_element(E,[H|T],LIST) :-
  filter_element(E,T,R),
  append([H],R,LIST).

% Eliminates duplicated information in lists
filter_duplicates([], RL, L) :- 
  reverse(RL,L).
filter_duplicates([H|T], A, NL) :-
  not_member(H, A),
  append([H], A, NewA), 
  filter_duplicates(T, NewA, NL),
  !.

filter_duplicates([_|T], A, NL) :-
  filter_duplicates(T, A, NL).

%return indexed object from list		
idx_object(0, [OBJECT|_], OBJECT).

idx_object(IDX, [_|OBJECTS_T], OBJECT) :-
  NEW_IDX is IDX - 1,
  idx_object(NEW_IDX, OBJECTS_T, OBJECT),
  !.

get_options(LC,LI,E,Option) :-
  (member(E,LC)) ->
    Option = ok
  | otherwise ->
    Option = no.

% Print list
print_list([]).
print_list([List|T]) :-
  List =.. ['.'|_],
  print('['),nl,
  print_list(List),
  print(']'),nl,
  print_list(T).
		
print_list([H|T]) :-
  print(H),nl,
  print_list(T).

fix_format(A,Res):-
	fix_format(A,[],Res).

fix_format([],Acc,Acc).
fix_format([A|Rets],Acc,Res):-
	number(A),
	number_chars(A,Cs),
	atom_chars(Cs,Atom),
	fix_format(Rest,[Atom|Acc],Res).
fix_format([A|Rets],Acc,Res):-
	fix_format(Rest,[A|Acc],Res).




% Formating message
msg_format([caption(A)],A1):-
  caption(A,A1).
msg_format([A],A).

msg_format([pause,caption(B)],MSG):-
  caption(B,B1),
  atom_concat('. ',B1,MSG).
msg_format([pause,B],MSG):-
  atom_concat('. ',B,MSG).

msg_format([caption(A),pause],MSG):-
  caption(A,A1),
  atom_concat(A1,' .',MSG).
msg_format([A,pause],MSG):-
  atom_concat(A,' .',MSG).

msg_format([caption(A),caption(B)],MSG):-
  caption(A,A1),
  caption(B,B1),
  atom_concat(A1,' ',Fst_),
  atom_concat(Fst_,B1,MSG).
msg_format([caption(A),B],MSG):-
  caption(A,A1),
  atom_concat(A1,' ',Fst_),
  atom_concat(Fst_,B,MSG).
msg_format([A,caption(B)],MSG):-
  caption(B,B1),
  atom_concat(A,' ',Fst_),
  atom_concat(Fst_,B1,MSG).
msg_format([A,B],MSG):-
  atom_concat(A,' ',Fst_),
  atom_concat(Fst_,B,MSG).

msg_format([pause,caption(B)|Rest],MSG):-
  caption(B,B1),
  atom_concat('. ',B1,Fst),
  msg_format(Fst,Rest,MSG).
msg_format([pause,B|Rest],MSG):-
  atom_concat('. ',B,Fst),
  msg_format(Fst,Rest,MSG).

msg_format([caption(A),pause|Rest],MSG):-
  caption(A,A1),
  atom_concat(A1,' .',Fst),
  msg_format(Fst,Rest,MSG).
msg_format([A,pause|Rest],MSG):-
  atom_concat(A,' .',Fst),
  msg_format(Fst,Rest,MSG).

msg_format([caption(A),caption(B)|Rest],MSG):-
  caption(A,A1),
  caption(B,B1),
  atom_concat(A1,' ',Fst_),
  atom_concat(Fst_,B1,Fst),
  msg_format(Fst,Rest,MSG).
msg_format([caption(A),B|Rest],MSG):-
  caption(A,A1),
  atom_concat(A1,' ',Fst_),
  atom_concat(Fst_,B,Fst),
  msg_format(Fst,Rest,MSG).
msg_format([A,caption(B)|Rest],MSG):-
  caption(B,B1),
  atom_concat(A,' ',Fst_),
  atom_concat(Fst_,B1,Fst),
  msg_format(Fst,Rest,MSG).
msg_format([A,B|Rest],MSG):-
  atom_concat(A,' ',Fst_),
  atom_concat(Fst_,B,Fst),
  msg_format(Fst,Rest,MSG).

msg_format(caption(Tmp),[],MSG):-
  caption(Tmp,Tmp2),
  atom_concat(Tmp2,'.',MSG).
msg_format(Tmp,[],MSG):-
  atom_concat(Tmp,'.',MSG).

msg_format(caption(Tmp),[pause|Rest],MSG):-
  caption(Tmp,Tmp2),
  atom_concat(Tmp2,'. ',Fst),
  msg_format(Fst,Rest,MSG).
msg_format(Tmp,[pause|Rest],MSG):-
  atom_concat(Tmp,'. ',Fst),
  msg_format(Fst,Rest,MSG).

msg_format(caption(Tmp),[caption(A)|Rest],MSG):-
  caption(Tmp,Tmp1),
  caption(A,A1),
  atom_concat(Tmp1,' ',Fst_),
  atom_concat(Fst_,A1,Fst),
  msg_format(Fst,Rest,MSG).
msg_format(caption(Tmp),[A|Rest],MSG):-
  caption(Tmp,Tmp1),
  atom_concat(Tmp1,' ',Fst_),
  atom_concat(Fst_,A,Fst),
  msg_format(Fst,Rest,MSG).
msg_format(Tmp,[caption(A)|Rest],MSG):-
  caption(A,A1),
  atom_concat(Tmp,' ',Fst_),
  atom_concat(Fst_,A1,Fst),
  msg_format(Fst,Rest,MSG).
msg_format(Tmp,[A|Rest],MSG):-
  atom_concat(Tmp,' ',Fst_),
  atom_concat(Fst_,A,Fst),
  msg_format(Fst,Rest,MSG).



%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions for converting coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Dummy version. Always return the same height, angle and distance
%%cam2arm(Arm, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], [1.25,10.0,0.5]).
%cam2arm(Arm, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], [1.25,-11.2511,0.3954]).


cam2arm(right, RobotHeight, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], ArmPolarCoords) :-

        PI is 3.14159,
        
        XObj is XCam - XArm,
	YObj is YCam - YArm,
	ZObj is ZCam - ZArm,

	print('YObj= '),print(YObj),nl,
	print('XObj= '),print(XObj),nl,
	print('ZObj= '),print(ZObj),nl,
	YPlatform is round( (RobotHeight + 0.45 - YObj) * 10000) / 10000,
	DistObj is round( (sqrt(XObj * XObj + ZObj * ZObj) ) * 10000) / 10000,
	AngleObj is round((atan(XObj / ZObj) * (180 / PI)) * 10000) / 10000,
	print('YPlatform = '), print(YPlatform), nl,
	print('DistObj = '), print(DistObj), nl,
	print('AngleObj = '), print(AngleObj), nl,

	ArmPolarCoords = [YPlatform, AngleObj, DistObj].

cam2arm(left, RobotHeight, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], ArmPolarCoords) :-

        PI is 3.14159,
        
        XObj is XCam - XArm,
	YObj is YCam - YArm,
	ZObj is ZCam - ZArm,

	print('YObj= '),print(YObj),nl,
	print('XObj= '),print(XObj),nl,
	print('ZObj= '),print(ZObj),nl,
	YPlatform is round( (RobotHeight + 0.45 - YObj) * 10000) / 10000,
	DistObj is round( (sqrt(XObj * XObj + ZObj * ZObj) ) * 10000) / 10000,
	AngleObj is round((atan(XObj / ZObj) * (180 / PI)) * 10000) / 10000 - 12.0,
	print('YPlatform = '), print(YPlatform), nl,
	print('DistObj = '), print(DistObj), nl,
	print('AngleObj = '), print(AngleObj), nl,

	ArmPolarCoords = [YPlatform, AngleObj, DistObj].

cam2nav([XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], NavCoords) :-
        
        PI is 3.14159,
        XBase is XCam - 0.10,
	ZBase is ZCam,			  
				      
	DistObj is round(sqrt(XBase * XBase + ZBase * ZBase) * 10000) / 10000,
	AngleObj is round((atan(XBase / ZBase) * (180 / PI)) * 10000) / 10000,

	print('DistObj = '), print(DistObj), nl,
	print('AngleObj = '), print(AngleObj), nl,
	
	NavCoords = [AngleObj, DistObj].
	

cam2nav_with_tilt([XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], NavCoords) :-
	PI is 3.14159,
		
	RadiansAngleTilt is (-AngleTilt * PI) / 180,
	DistRef is sqrt(YCam * YCam + ZCam * ZCam),
	AngleRef is atan(YCam / ZCam),
	
	XRef is XCam,
	YRef is DistRef * sin(AngleRef + RadiansAngleTilt),
	ZRef is DistRef * cos(AngleRef + RadiansAngleTilt),
	
	XOri is XRef,
	YOri is YRef + (YTilt - YTilt * sin(PI / 2 - RadiansAngleTilt)),
	ZOri is ZRef + (ZTilt + YTilt * cos(PI / 2 - RadiansAngleTilt)),
	
	DistObj is round(sqrt(XOri * XOri + ZOri * ZOri) * 10000) / 10000,
	AngleObj is round((atan(XOri / ZOri) * (180 / PI)) * 10000) / 10000,

	print('DistObj = '), print(DistObj), nl,
	print('AngleObj = '), print(AngleObj), nl,
	
	NavCoords = [AngleObj, DistObj].
	

%%Dummy version. Always return the same height, angle and distance
%%cam2arm(Arm, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], [1.25,10.0,0.5]).
%cam2arm(Arm, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], [1.25,-11.2511,0.3954]).


cam2arm_with_tilt(Arm, RobotHeight, [XCam, YCam, ZCam], [AngleTilt, YTilt, ZTilt], [XArm, YArm, ZArm], ArmPolarCoords) :-

	PI is 3.14159,

	RadiansAngleTilt is (-AngleTilt * PI) / 180,
	
	DistRef is sqrt(YCam * YCam + ZCam * ZCam),
	AngleRef is atan(YCam / ZCam),
	
	XRef is XCam,
	YRef is DistRef * sin(AngleRef + RadiansAngleTilt),
	ZRef is DistRef * cos(AngleRef + RadiansAngleTilt),

	XOri is XRef,
	YOri is YRef + (YTilt * sin(RadiansAngleTilt)),
	ZOri is ZRef + (YTilt * cos(RadiansAngleTilt)),
	
	print('YOri= '),print(YOri),nl,

	XObj is XOri - XArm,
	YObj is YOri - YArm,
	ZObj is ZOri - ZArm,

	print('YObj= '),print(YObj),nl,
	YPlatform is round( (RobotHeight + 0.45 - YObj) * 10000) / 10000,
	DistObj is round( (sqrt(XObj * XObj + ZObj * ZObj) ) * 10000) / 10000,
	AngleObj is round((atan(XObj / ZObj) * (180 / PI)) * 10000) / 10000,
	print('YPlatform = '), print(YPlatform), nl,
	print('DistObj = '), print(DistObj), nl,
	print('AngleObj = '), print(AngleObj), nl,

	ArmPolarCoords = [YPlatform, AngleObj, DistObj].


timeOver(X):- 
    statistics(walltime, [H | T]),
    N1 is H - X,
    N is 10000-N1,
    N =< 0.


remove_turn(L,R):-                                                                                                                                                              
    remove_turn(L,[],R).                                                                                                                                                        
                                                                                                                                                                                
remove_turn([],Res,Res).                                                                                                                                                        
remove_turn([turn=>A|Rest],Acc,Res):-                                                                                                                                           
    remove_turn(Rest,Acc,Res).                                                                                                                                                  
remove_turn([H|Rest],Acc,Res):-                                                                                                                                                 
    remove_turn(Rest,[H|Acc],Res).                                                                                                                                              
                                                                                                                                                                                
arrived_posit([P], _, P).                                                                                                                                                      
arrived_posit(Posit, Rem, Cp) :-                                                                                                                                               
        remove_turn(Posit, Posit1),                                                                                                                                             
        reverse(Rem, Rem1),                                                                                                                                                     
        diff(Posit1, Rem1, Cp).                                                                                                                                                 
                                                                                                                                                                                
diff([X|XS], [Y|YS], Out) :-                                                                                                                                                    
        diff(XS,YS,Out).                                                                                                                                                        
diff([X|XS], [], X).

equivalent_terms(X, X).
