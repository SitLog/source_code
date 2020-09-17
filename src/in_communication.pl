/*********************************************************************************
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

% Code for predicate to OAA agent
%:- attribute expect/1.
% :- module(expect,
%           [ expect/1                    % Var, ?Domain
%           ]).
%% :- use_module(library(atts)).

%% module(domain,
%%           [ domain/2                    % Var, ?Domain
%%           ]).

person_recognition(JsonMsg) :- 
    rosswipl_to_ioca(JsonMsg, [PersonList]),
    assert(persons(PersonList)).

%:- rosswipl_register_topic('/person_recognition', person_detected, 1).

%%%%%%%%%%%%%%%%%%%%%%%%% Others %%%%%%%%%%%%%%%%%%%%%%%%%
% Neutral
communication_int(neutral,Expected_Intentions,Result) :-
    (Expected_Intentions == empty, Result = Expected_Intentions | otherwise, false),
    true.

% Keyboard
communication_int(keyboard,Expected_Intentions,NL_Input) :-
    %read natural language textual input
    print(Expected_Intentions),nl,
    read(NL_Input),   
    print(NL_Input),nl,
    save_info(feat,'INPUT',[NL_Input]).

 % Click
 communication_int(click,Expected_Intentions,NL_Input) :-
     print(Expected_Intentions),
     nl,
     ( mode_exe(test) ->
	   %read natural language textual input
	   read(NL_Input),
	   print(NL_Input),nl
			       | otherwise ->
	       %% oaa_Solve(espera_click(NL_Input),[blocking(true)]),   
	       print(NL_Input),nl
     ),
     save_info(feat,'INPUT',[NL_Input]).

 communication_int(get_cmd(Expected_Intentions,cmd(Input,Cmd))) :-
     print(hello),
     print(Expected_Intentions),
     ( member(cmd(Input,Cmd),Expected_Intentions)->
	   save_info(feat,'OLDCMD',[Input])
		    | otherwise ->
	       true
     ),
     % Calling the interpreter
     %% oaa_Solve(gfVerify(Input,Cmd),[blocking(true)]),

     % Logging information
     save_info(feat,'NEWCMD',[Cmd]).

 communication_int(gfOrders,Expected_Intentions,gfOrder(Order)) :-
     print(Order),
     save_info(feat,'DMS',[DMS]).



 communication_int(get_dms,Expected_Intentions,cmds2dms(Input,DMS)) :-
     print(Input),
     ( member(cmds2dms(Input,_),Expected_Intentions)->
	   save_info(feat,'Decoder',[gpsr1]),
	   %% oaa_Solve(switchDecoder(gpsr1,_),[blocking(true)]),
	   print('recogniser changed to gpsr1'),nl
						    | otherwise ->
	       true
     ),

     % Calling the interpreter
     %% oaa_Solve(gfInterpret(Input,DMS),[blocking(true)]),

     % Logging information
     %% oaa_Solve(switchDecoder(default,_),[blocking(true)]),
     save_info(feat,'DMS',[DMS]).

 %Speech acts for translating information
 communication_int(translating_nav,Expectations,cam_to_nav(X,Y,Z,T,A,B,R)) :-
     print('Getting translation from camera to navigation '),nl,
     memberchk(cam_to_nav(X,Y,Z,T,A,B,_),Expectations),
     ( mode_exe(test) ->
	   %R = [0,0.5],
	   read(R),
	   Result = cam_to_nav(X,Y,Z,T,A,B,R),
	   print('Expectation (again):   '),print(Result),nl
							      | otherwise ->
	       print('Run mode')
     ),
     save_info(feat,'INPUT',[Result])
 .

 %% communication_int(translating_arm,Expectations,cam_to_arm(P,X,Y,Z,T,A,B,C,D,E,R)) :-
 %%     print('Getting translation from camera to arm:   '),
 %%     memberchk(cam_to_arm(P,X,Y,Z,T,A,B,C,D,E,_),Expectations),
 %%     print(P),print(', '),print(X),print(', '),print(Y),print(', '),print(Z),print(', '),print(T),nl,
 %%     (P == right ->
 %% 	 Ca is C * 1,
 %% 	 print('Using C right as : '),print(Ca),nl,
 %% 	 ( mode_exe(test) ->
 %% 	       %R = [0,0.5,1],
 %% 	       read(R),
 %% 	       Result = cam_to_arm(P,X,Y,Z,T,A,B,Ca,D,E,R)
 %% 				  | otherwise ->
 %% 		   print('Run mode')
 %% 	 )
 %%     )
 %% 	| otherwise ->
 %% 	Ca is C * -1,
 %% 	print('Using C left or C plane as : '),print(Ca),nl,
 %% 	( mode_exe(test) ->
 %% 	      %R = [0,0.5,1],
 %% 	      read(R),
 %% 	      Result = cam_to_arm(P,X,Y,Z,T,A,B,Ca,D,E,R)
 %% 				 | otherwise ->
 %% 		  print('Run mode')
 %% 	),
 %% 	print('Expectation solved:   '),print(Result),nl
 %% ),
 %%  save_info(feat,'INPUT',[Result])
 %%  .


 %%%%%%%%%%%%%%%%%%%%%%%%% speech %%%%%%%%%%%%%%%%%%%%%%%%%
 %KB input agent
 communication_int(speech,Expected_Intentions,Result) :-

     print('In speech interpreter'),nl,
     %% ( mode_exe(test) ->
     read(Input), 
     print(Input),
     Result = Input,
			%% | otherwise ->

     % Calling the recognizer
     %% oaa_Solve(recognize(ID,Input),[blocking(true)]),
     %read(Input), 
     % Calling the interpreter
     %% oaa_Solve(interpretaVoz(Expected_Intentions,Input,Result),[blocking(true)])
     %% ),

     % Logging information
     save_info(feat,'INPUT',[Input]),

     save_info(feat,'INPUT',[Input]),

     save_info(feat,'SPACT',[Result]),
     nl,print('Inter '),print(Result),nl
  .

 % 
 communication_int(nkeyboard,Expected_Intentions,Result) :-
     print('In speech Resultpreter'),nl,
     read(Input),
     Result = said(Input)
  .



 %KB input agent
 communication_int(nlistening(LanguageModel),Expected_Intentions,Result) :-
     print('In speech Resultpreter'),nl,
     %% ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = said(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl.
     %% 					       | otherwise ->
     %% 	      %% oaa_Solve(switchDecoder(LanguageModel,_),[blocking(true)]),
     %% 	      %% oaa_Solve(nbest(on,Res)),
     %% 	      %% oaa_Solve(recognize(ID,Input),[blocking(true)]),
     %% 	      save_info(feat,'INPUT',[Input]),
     %% 	      ( Input == '__NONE__' ->
     %% 		    Result = said(nada)
     %% 				 | otherwise ->
     %% 			Result = said(Input)
     %% 	      ),
     %% %% oaa_Solve(nbest(off,Res)),
     %% %% oaa_Solve(switchDecoder(default,_),[blocking(true)])
     %% ).

 communication_int(listening(LanguageModel),Expected_Intentions,Result) :-
     print('In speech Resultpreter'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = said(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
           ioca_to_rosswipl( text(LanguageModel), JsonLanguageModel),
	   rosswipl_call_service('/recognize_sentence', JsonLanguageModel, Response),
           rosswipl_to_ioca(Response, [text(MSG)]),
    
	   Result = said(MSG),
	   nl,print('Inter '),print(Result),nl
     ).




 communication_int(listening,Expected_Intentions,Result) :-
     print('In speech Resultpreter'),nl,
     %% ( mode_exe(test) ->
     read(Input), 
     print(Input),
     % Logging information
     save_info(feat,'INPUT',[Input]),
     Result = Input,
     save_info(feat,'SPACT',[Result]),
     nl,print('Inter '),print(Result),nl.
 %% 					       | otherwise ->
 %% 	      % Calling the recognizer
 %% 	      ( member(ok,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[yesno]),
 %% 		    %% oaa_Solve(switchDecoder(yesno,_),[blocking(true)]),
 %% 		    print('recogniser changed to yesno'),nl
 %% 							     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(fonemas(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[fonemas]),
 %% 		    %% oaa_Solve(switchDecoder(fonemas,_),[blocking(true)]),
 %% 		    print('recogniser changed to fonemas'),nl
 %% 							       | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(wakeup,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[wakeup]),
 %% 		    %% oaa_Solve(switchDecoder(wakeup,_),[blocking(true)]),
 %% 		    print('recogniser changed to wakeup'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(card(_,_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[card]),
 %% 		    %% oaa_Solve(switchDecoder(card,_),[blocking(true)]),
 %% 		    print('recogniser changed to card'),nl
 %% 							    | otherwise ->
 %% 			true
 %% 	      ),

 %% 	      ( member(figura(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[figura]),
 %% 		    %% oaa_Solve(switchDecoder(figura,_),[blocking(true)]),
 %% 		    print('recogniser changed to figura'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(moreless(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[moreless]),
 %% 		    %% oaa_Solve(switchDecoder(moreless,_),[blocking(true)]),
 %% 		    print('recogniser changed to moreless'),nl
 %% 								| otherwise ->
 %% 			true
 %% 	      ),

 %% 	      ( member(room(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[room]),
 %% 		    %% oaa_Solve(switchDecoder(room,_),[blocking(true)]),
 %% 		    print('recogniser changed to room'),nl
 %% 							    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(name(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[names]),
 %% 		    %% oaa_Solve(switchDecoder(names,_),[blocking(true)]),
 %% 		    print('recogniser changed to names'),nl
 %% 							     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(card(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[card]),
 %% 		    %% oaa_Solve(switchDecoder(card,_),[blocking(true)]),
 %% 		    print('recogniser changed to card'),nl
 %% 							    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(feat(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[feat]),
 %% 		    %% oaa_Solve(switchDecoder(feats,_),[blocking(true)]),
 %% 		    print('recogniser changed to feat'),nl
 %% 							    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(age(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[age]),
 %% 		    %% oaa_Solve(switchDecoder(age,_),[blocking(true)]),
 %% 		    print('recogniser changed to age'),nl
 %% 							   | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(follow,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[follow]),
 %% 		    %% oaa_Solve(switchDecoder(follow,_),[blocking(true)]),
 %% 		    print('recogniser changed to follow'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(leave,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[leave]),
 %% 		    %% oaa_Solve(switchDecoder(leave,_),[blocking(true)]),
 %% 		    print('recogniser changed to leave'),nl
 %% 							     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(orders(_,_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[orders]),
 %% 		    %% oaa_Solve(switchDecoder(orders,_),[blocking(true)]),
 %% 		    print('recogniser changed to orders language model'),nl
 %% 									     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(label(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[label]),
 %% 		    %% oaa_Solve(switchDecoder(label,_),[blocking(true)]),
 %% 		    print('recogniser changed to product language model'),nl
 %% 									      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(order(_,_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[order]),
 %% 		    %% oaa_Solve(switchDecoder(order,_),[blocking(true)]),
 %% 		    print('recogniser changed to product language model'),nl
 %% 									      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(drink(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[drink]),
 %% 		    %% oaa_Solve(switchDecoder(drink,_),[blocking(true)]),
 %% 		    print('recogniser changed to drink language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(bread(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[bread]),
 %% 		    %% oaa_Solve(switchDecoder(bread,_),[blocking(true)]),
 %% 		    print('recogniser changed to bread language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(snack(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[snack]),
 %% 		    %% oaa_Solve(switchDecoder(snack,_),[blocking(true)]),
 %% 		    print('recogniser changed to snack language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(cleaning(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[cleaning]),
 %% 		    %% oaa_Solve(switchDecoder(cleaning,_),[blocking(true)]),
 %% 		    print('recogniser changed to snack language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(food(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[food]),
 %% 		    %% oaa_Solve(switchDecoder(food,_),[blocking(true)]),
 %% 		    print('recogniser changed to snack language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(furniture(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[furniture]),
 %% 		    %% oaa_Solve(switchDecoder(furniture,_),[blocking(true)]),
 %% 		    print('recogniser changed to furniture language model'),nl
 %% 										| otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(table(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[table]),
 %% 		    %% oaa_Solve(switchDecoder(table,_),[blocking(true)]),
 %% 		    print('recogniser changed to table language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(loc(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[table]),
 %% 		    %% oaa_Solve(switchDecoder(table,_),[blocking(true)]),
 %% 		    print('recogniser changed to table language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(figura(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[figura]),
 %% 		    %% oaa_Solve(switchDecoder(figura,_),[blocking(true)]),
 %% 		    print('recogniser changed to figura'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(moreless(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[moreless]),
 %% 		    %% oaa_Solve(switchDecoder(moreless,_),[blocking(true)]),
 %% 		    print('recogniser changed to moreless'),nl
 %% 								| otherwise ->
 %% 			true
 %% 	      ),


 %% 	      ( member(object(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[object]),
 %% 		    %% oaa_Solve(switchDecoder(object,_),[blocking(true)]),
 %% 		    print('recogniser changed to object language model'),nl
 %% 									     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(medicine(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[medicine]),
 %% 		    %% oaa_Solve(switchDecoder(medicine,_),[blocking(true)]),
 %% 		    print('recogniser changed to object language model'),nl
 %% 									     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(drop,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[drop]),
 %% 		    %% oaa_Solve(switchDecoder(drop,_),[blocking(true)]),
 %% 		    print('recogniser changed to object language model'),nl
 %% 									     | otherwise ->
 %% 			true
 %% 	      ),

 %% 	      %% oaa_Solve(recognize(ID,Input),[blocking(true)]),

 %% 	      nl,print('Input'),
 %% 	      %read(Input), 
 %% 	      print(Input),

 %% 	      % Calling the interpreter
 %% 	      %% oaa_Solve(interpretaVoz(Expected_Intentions,Input,Result),[blocking(true)]),
 %% 	      print(Result),
 %% 	      % Logging information
 %% 	      save_info(feat,'INPUT',[Input]),
 %% 	      save_info(feat,'SPACT',[Result]),
 %% 	      nl,print('Inter '),print(Result),nl,

 %%     %% oaa_Solve(switchDecoder(default,_),[blocking(true)])
 %%     ).


 %% %KB input agent
 communication_int(listening_softloud,Expected_Intentions,Result) :-
     print('In speech interpreter'),nl,
     %% ( mode_exe(test) ->
     read(Input), 
     print(Input),
     % Logging information
     save_info(feat,'INPUT',[Input]),
     Result = Input,
     save_info(feat,'SPACT',[Result]),
     nl,print('Inter '),print(Result),nl.
 %% 					       | otherwise ->
 %% 	      % Calling the recognizer
 %% 	      ( member(fonemas(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[fonemas]),
 %% 		    %% oaa_Solve(switchDecoder(fonemas,_),[blocking(true)]),
 %% 		    print('recogniser changed to fonemas'),nl
 %% 							       | otherwise ->
 %% 			true
 %% 	      ),

 %% 	      ( member(ok,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[yesno]),
 %% 		    %% oaa_Solve(switchDecoder(yesno,_),[blocking(true)]),
 %% 		    print('recogniser changed to yesno'),nl
 %% 							     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(figura(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[figura]),
 %% 		    %% oaa_Solve(switchDecoder(figura,_),[blocking(true)]),
 %% 		    print('recogniser changed to figura'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(card(_,_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[card]),
 %% 		    %% oaa_Solve(switchDecoder(card,_),[blocking(true)]),
 %% 		    print('recogniser changed to card'),nl
 %% 							    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(moreless(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[moreless]),
 %% 		    %% oaa_Solve(switchDecoder(moreless,_),[blocking(true)]),
 %% 		    print('recogniser changed to moreless'),nl
 %% 								| otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(wakeup,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[wakeup]),
 %% 		    %% oaa_Solve(switchDecoder(wakeup,_),[blocking(true)]),
 %% 		    print('recogniser changed to wakeup'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(room(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[room]),
 %% 		    %% oaa_Solve(switchDecoder(room,_),[blocking(true)]),
 %% 		    print('recogniser changed to room'),nl
 %% 							    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(name(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[names]),
 %% 		    %% oaa_Solve(switchDecoder(names,_),[blocking(true)]),
 %% 		    print('recogniser changed to names'),nl
 %% 							     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(follow,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[follow]),
 %% 		    %% oaa_Solve(switchDecoder(follow,_),[blocking(true)]),
 %% 		    print('recogniser changed to follow'),nl
 %% 							      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(leave,Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[leave]),
 %% 		    %% oaa_Solve(switchDecoder(leave,_),[blocking(true)]),
 %% 		    print('recogniser changed to leave'),nl
 %% 							     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(orders(_,_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[orders]),
 %% 		    %% oaa_Solve(switchDecoder(orders,_),[blocking(true)]),
 %% 		    print('recogniser changed to orders language model'),nl
 %% 									     | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(loc(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[table]),
 %% 		    %% oaa_Solve(switchDecoder(table,_),[blocking(true)]),
 %% 		    print('recogniser changed to table language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(label(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[label]),
 %% 		    %% oaa_Solve(switchDecoder(label,_),[blocking(true)]),
 %% 		    print('recogniser changed to product language model'),nl
 %% 									      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(order(_,_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[order]),
 %% 		    %% oaa_Solve(switchDecoder(order,_),[blocking(true)]),
 %% 		    print('recogniser changed to product language model'),nl
 %% 									      | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(drink(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[drink]),
 %% 		    %% oaa_Solve(switchDecoder(drink,_),[blocking(true)]),
 %% 		    print('recogniser changed to drink language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(bread(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[bread]),
 %% 		    %% oaa_Solve(switchDecoder(bread,_),[blocking(true)]),
 %% 		    print('recogniser changed to bread language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(snack(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[snack]),
 %% 		    %% oaa_Solve(switchDecoder(snack,_),[blocking(true)]),
 %% 		    print('recogniser changed to snack language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(furniture(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[furniture]),
 %% 		    %% oaa_Solve(switchDecoder(furniture,_),[blocking(true)]),
 %% 		    print('recogniser changed to furniture language model'),nl
 %% 										| otherwise ->
 %% 			true
 %% 	      ),
 %% 	      ( member(table(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[table]),
 %% 		    %% oaa_Solve(switchDecoder(table,_),[blocking(true)]),
 %% 		    print('recogniser changed to table language model'),nl
 %% 									    | otherwise ->
 %% 			true
 %% 	      ),

 %% 	      ( member(object(_),Expected_Intentions)->
 %% 		    save_info(feat,'Decoder',[object]),
 %% 		    %% oaa_Solve(switchDecoder(object,_),[blocking(true)]),
 %% 		    print('recogniser changed to object language model'),nl
 %% 									     | otherwise ->
 %% 			true
 %% 	      ),

 %% 	      %% oaa_Solve(startMeasuringdB(-58),[blocking(true)]),
 %% 	      %% oaa_Solve(recognize(ID,Input),[blocking(true)]),
 %% 	      %% oaa_Solve(stopMeasuringdB(SoftLoudResult),[blocking(true)]),

 %% 	      %print('Input'),
 %% 	      %read(Input), 

 %% 	      % Logging information
 %% 	      save_info(feat,'INPUT',[Input]), 
 %% 	      save_info(feat,'INPUT',[SoftLoudResult]),

 %% 	      ( SoftLoudResult == soft->
 %% 		    Result = soft,
 %% 		    print('Recognition not valid. Voice too soft.'),nl
 %% 									| SoftLoudResult == loud->
 %% 			Result = loud,
 %% 			print('Recognition not valid. Voice too loud.'),nl
 %% 									    | otherwise ->
 %% 			    print('Recognition valid. Interpreting.'),nl,
 %% 	      % Calling the interpreter
 %% 	      %% oaa_Solve(interpretaVoz(Expected_Intentions,Input,Result),[blocking(true)])
 %% 	      ),

 %% 	      save_info(feat,'SPACT',[Result]),
 %%     %% oaa_Solve(switchDecoder(default,_),[blocking(true)])
 %%     ).

 %% %%%%%%%%%%%%%%%%%%%%%%%%% Audition information %%%%%%%%%%%%%%%%%%%%%%%%%
 communication_int(doas,Expected_Intentions,Result) :-
     print('Asking for DOAs to soundloc'),nl,
     ( mode_exe(test) ->
	   read(Input),     
	   Result = doas(Input),
	   print('DOAs = '),print(Result),nl
     | otherwise ->
	   rosswipl_call_service('/soundloc/get_sound_directions', '', Response),
           print('Received from soundloc json: '), print(Response),nl,
           rosswipl_to_ioca(Response, DOAList),
           print('Received from soundloc: '), print(DOAList),nl,
           Result = doas(DOAList),
           print('DOAS = '), print(Result),nl
     ).

 communication_int(speakerid,Expected_Intentions,Result) :-
     print('Asking for speaker name to speakerid'),nl,
     ( mode_exe(test) ->
           read(Input),
           Result = speaker(Input),
           print('Speaker Name = '),print(Result),nl
     | otherwise ->
           rosswipl_call_service('/speakerid', '', Response),
           print('Received from speakerid json: '), print(Response),nl,
           rosswipl_to_ioca(Response, [name(SpeakerName),confidence(SpeakerConf)]),
           print('Received from speakerid: '), print(SpeakerName),print(', '), print(SpeakerConf),nl,
           Result = speaker([SpeakerName,SpeakerConf]),
           print('Speaker Expectation = '),print(Result),nl
     )
     .

 communication_int(query_speakerid(N),Expected_Intentions,Result) :-
     ( mode_exe(test) ->
           print('Querying name to speaker id: '),print(N),nl,
           read(Input),
           Result = Input,
           print('Received: '),print(Result),nl
     | otherwise ->
           print('Querying name to speaker id: '),print(N),nl,
           ioca_to_rosswipl(text(N), Request),
           rosswipl_call_service('/query_speakerid', Request, JsonRes),
           print('Received from speakerid json: '), print(JsonRes),nl,
           rosswipl_to_ioca(JsonRes,[status(Result)]),
           print('Query Expectation = '),print(Result),nl
     )
.

 %% %%%%%%%%%%%%%%%%%%%%%%%%% Visual acts %%%%%%%%%%%%%%%%%%%%%%%%%
 %% %Vision input agent
 communication_int(seeing,Expected_Intentions,Result) :-
 %%     print('Agent seeing for looking for person'),nl,
 %%     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input,
	   nl,print('Inter '),print(Result),nl,
 %% 					       | otherwise ->
 %% 	      print('Agent saw'),nl,
 %% 	      %% oaa_Solve(ve(NL_Input),[]), 
 %% 	      print('Agent saw'),nl,
 %% 	      % Communication with OAA
 %% 	      print('Agent interpreting'),nl,
 %% 	      %% oaa_Solve(interpretaVision(Expected_Intentions, NL_Input, Result),[]),
 %% 	      print('Agent interprets: '),print(Result),nl
 %%     ),

     %check potential interpretation
     member(Result,Expected_Intentions),

     % Logging information
     save_info(feat,'INPUT',[Result]).




 communication_int(vision,Expected_Intentions,Result) :-
     print('Agent seeing for looking for person'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
						| otherwise ->
	       %% oaa_Solve(busca_persona(Expected_Intentions, Result),[]),
	       %% oaa_Solve(ve(NL_Input),[]), 
	       print('Agent saw'),nl,

	       % Communication with OAA
	       print('Agent interpreting'),nl,
	       %% oaa_Solve(interpretaVision(Expected_Intentions, NL_Input, Result),[]),
	       print('Agent interprets: '),print(Result),nl
     ),

     %check potential interpretation
     member(Result,Expected_Intentions),

     % Logging information
     save_info(feat,'INPUT',[Result]).


 communication_int(vision_simple,Expected_Intentions,Result) :-
     print('Agent seeing for looking for person'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
						| otherwise ->
	       %% oaa_Solve(busca_persona(Expected_Intentions, Result),[]),
	       %% oaa_Solve(ve(NL_Input),[]), 
	       print('Agent saw'),nl,

	       % Communication with OAA
	       print('Agent interpreting'),nl,
	       %% oaa_Solve(interpretaVision(Expected_Intentions, NL_Input, Result),[]),
	       print('Agent interprets: '),print(Result),nl
     ),

     %check potential interpretation
     member(Result,Expected_Intentions),

     % Logging information
     save_info(feat,'INPUT',[Result]).


 %Laser agent for "catching" people in Marco Polo
 communication_int(pulso,Expected_Intentions,Result) :-
     print('Reading pulso from user '),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
						| otherwise ->
	       print('Expected_Intentions: '),print(Expected_Intentions),nl,
	       ( %% oaa_Solve(pulso(V,R),[]) ->
		   print(Result),nl,
		   Result = pulso(R,V)
				 | otherwise ->
		       Result = error
	       )
     ),
     save_info(feat,'INPUT',[Result])
 .



 %Laser agent for "catching" people in Marco Polo
 communication_int(catching,Expected_Intentions,Result) :-
     print('In detecting catched people agent '),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
						| otherwise ->
	       print('Expected_Intentions: '),print(Expected_Intentions),nl,
	       ( %% oaa_Solve(catched(Result),[]) ->
		   print(Result),nl
				     | otherwise ->
		       Result = error
	       )
     ),
     save_info(feat,'INPUT',[Result])
 .


 %Vision agent for detecting for people
 communication_int(detect_people,Expected_Intentions,Result) :-
     print('In detecting people agent '),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
						| otherwise ->
	       print('Expected_Intentions: '),print(Expected_Intentions),nl,
	       ( %% oaa_Solve(person_detect(person_detect_with,person_detect,person_not_detect,Result),[]) ->
		   print(Result),nl
				     | otherwise ->
		       Result = error
	       )
     ),
     save_info(feat,'INPUT',[Result])
 .
 %Vision agent for getting the state of saving pictuResult from people
 communication_int(save_face,Expected_Intentions,Result) :-
     N = save(Name),
     member(N,Expected_Intentions),
     print('In saving face agent '),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input
			| otherwise ->
	       ( %% oaa_Solve(save_face(Name,saved,not_saved,Result),[]) ->
		   Result = Result
				| otherwise ->
		       Result = error
	       )

     ),
     print('Inter: '),print(Result),nl,
     save_info(feat,'INPUT',[Result])
 .
 %Vision agent for getting state of training ended
 communication_int(learn_faces,Expected_Intentions,Result) :-
     print('In learn face agent '),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input
			| otherwise ->
	       ( %% oaa_Solve(learn_faces(done,error,Result),[]) ->
		   Result = Result
				| otherwise ->
		       Result = error
	       )
     ),
     print('Inter: '),print(Result),nl,
     save_info(feat,'INPUT',[Result])
 .
 %Vision agent for getting state of recognition of people
 communication_int(recognized_face,Expected_Intentions,Result) :-
     print('In recognized face agent '),nl,
     %print('Expected_Intentions: '),print(Expected_Intentions),nl, 
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   Result = Input
			| otherwise ->
	       print('Executing mode'),nl,   
	       ( %% oaa_Solve(recognize_face(recognized,unknown,not_detected,Result),[]) ->
		   Result = Result
				| otherwise ->
		       Result = error
	       )
     ),
     print('Inter: '),print(Result),nl,
     save_info(feat,'INPUT',[Result])
 .

 %Vision agent for analyzing objects
 communication_int(object_analyzing(LastTilt, RecognitionMode, Approaching),Expected_Intentions, Result) :-
     ( mode_exe(test) ->
	  read(Result),
	  print('Analyze object Result: '),
          print(Result),
          nl
    | otherwise ->    
	  ioca_to_rosswipl(object_recognition_request(LastTilt, RecognitionMode, Approaching), Request),

	  % Communication with ROS
          rosswipl_call_service('/tabletop_detection', Request, Response),

          rosswipl_to_ioca(Response, ObjectList),

          print('object list = '), print(ObjectList),
          
          ( equivalent_terms(ObjectList, [status(Status)]) ->
            Result = status(Status)
            | otherwise ->	   
            Result = objects(ObjectList)
        ),
          print('Result = '), print(Result)
    ),
    save_info(feat,'INPUT',[Result])
.

%Vision agent for analyzing objects
communication_int(uobject_analyzing,Expected_Intentions, Result) :-
    print('In Uobject_analyzing'),nl,
    ( mode_exe(test) ->
	  %Result = object([[1,1,1],[2,1,1]]),
	  read(Result),
	  print('Analyze object Result: '),print(Result),nl
							     | otherwise ->
	      % Communication with OAA
	      ( %% oaa_Solve(vision_pclobject_retrieve(object,nothing,analyzing,Result),[]) ->
		  print('Analyze object Result: '),print(Result),nl
								     | otherwise ->
		      Result = error
	      )
    ),
    save_info(feat,'INPUT',[Result])
.

%Vision agent for analyzing objects
communication_int(plane_analyzing,Expected_Intentions, Result) :-
    print('In Plane analyzing'),nl,
    ( mode_exe(test) ->
	  %Result = table([[1,1,1],[2,2,2]]),
	  read(Result),
	  print('Analyze plane Result: '),print(Result),nl
							    | otherwise ->
	      % Communication with OAA
	      ( %% oaa_Solve(vision_pcltable_retrieve(table,nothing,analyzing,Result),[]) ->
		  print('Analyze plane Result: '),print(Result),nl
								    | otherwise ->
		      Result = error
	      )
    ),
    save_info(feat,'INPUT',[Result])
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% YOLO object detection agent %%%%%%%%%%%%%
 communication_int(yolo_object_detection(LastTilt,Object),Expected_Intentions, Result) :-
     ( mode_exe(test) ->
	  read(Result),
	  print('Analyze object Result: '),
          print(Result),
          nl
    | otherwise ->    
	  %ioca_to_rosswipl(yolo_object_recognition_request(LastTilt,Object, yolo, true), Request),
	  Request='json:\'{\"tilt\":-30.0,\"objects\":\"drinks\"}\'',
	  % Communication with ROS
          rosswipl_call_service('/yolo', Request, Response),%Request

          rosswipl_to_ioca(Response, ObjectList),

          print('object list = '), print(ObjectList),
          
          ( equivalent_terms(ObjectList, [status(Status)]) ->
            Result = status(Status)
            | otherwise ->	   
            Result = objects(ObjectList)
        ),
          print('Result = '), print(Result)
    ),
    save_info(feat,'INPUT',[Result])
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Vision agent for analyzing planes %%%%%%%
communication_int(plane_recognition(LastTilt,X_max,Y_max,Z_max),Expected_Intentions, Result) :-
     ( mode_exe(test) ->
	  read(Result),
	  print('Plane recognition result: '),
          print(Result),
          nl
    | otherwise ->    
	  ioca_to_rosswipl(plane_recognition_request(LastTilt,X_max,Y_max,Z_max), Request),

	  % Communication with ROS
          rosswipl_call_service('/plane_detection', Request, Response),

          rosswipl_to_ioca(Response, Plane_List),

          print('Plane list = '), print(Plane_List),
          
          ( equivalent_terms(Plane_List, [status(Status)]) ->
            Result = status(Status)
            | otherwise ->	   
            Result = planes(Plane_List)
        ),
          print('Result = '), print(Result)
    ),
    save_info(feat,'INPUT',[Result])
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Follow/tracking input agent    
communication_int(following,Expected_Intentions,Result) :-
    print('Agent seeing person for following'),nl,
    print('Expected_Intentions: '),print(Expected_Intentions),nl,
    ( mode_exe(test) ->
	  read(Input), 
	  print(Input),
	  % Logging information
	  Result = Input,
	  nl,print('Result '),print(Result),nl
						| otherwise ->
	      print('OAA mode'),nl,
	      %% oaa_Solve(busca_persona(Expected_Intentions, Result),[]),
	      print('Agent saw'),nl
    ),

    % Logging information
    save_info(feat,'INPUT',[Result]).

%Laser act for looking for opened door
communication_int(waiting,Expected_Intentions, Result) :-
    % Communication with OAA
    save_info(feat,'INTERPRETER',[open_door]),
    print('Agent interpreting waiting'),nl,
    ( mode_exe(test) ->
	  read(Result)
	      | otherwise ->
	      ( %% oaa_Solve(openDoor(Expected_Intentions, Result),[]) ->
		  Result = Result
			       | otherwise ->
		      Result = error
	      )
    ),
    print('Agent interprets: '),
    print(Result), nl,

    % Logging information
    save_info(feat,'INPUT',[Result]).

%Laser agent for detecting people
communication_int(person_detect,Expected_Intentions, Result) :-
    print('In person detect with laser agent '),nl,
    ( mode_exe(test) ->
	  read(Result)
	      | otherwise ->
	      ( %% oaa_Solve(personaLaser(person,Result),[]) ->
		  print(Result),nl
				    | otherwise ->
		      Result = error
	      )
    ),
    save_info(feat,'INPUT',[Result])
.    

%Visual sensor for detecting grasped object
communication_int(grasping,Expected_Intentions, Result) :-
    ( mode_exe(test) ->
	  read(Result)
	      | otherwise ->
	      ( %% oaa_Solve(objectgrasped(Result),[]) ->
		  Result = Result
			       | otherwise ->
		      Result = error
	      )
    ),
    print(Result),nl,
    save_info(feat,'INPUT',[Result])
.    

%%%%%%%%%%%%%%%%%%%%%%%%% Movement %%%%%%%%%%%%%%%%%%%%%%%%%
%Navigation with the agent
communication_int(walking,[Pos,Int,Neg|Resultt],Result) :-
    % Calling the interpreter
    print('Nav Value pos '),print(Pos),nl,
    print('Nav Value int '),print(Int),nl,
    print('Nav Value neg '),print(Neg),nl,
    %% ( mode_exe(test) ->
    read(Result),
	%% | otherwise ->
    %% oaa_Solve(get_state(Pos,Int,Neg,Result),[])

    %      ( %% oaa_Solve(get_state(Pos,Int,Neg,Result),[]) ->
    %        Result = Result
    %      | otherwise ->
    %        Result = error
    %      )
    %% ),
    print('The Nav state is '),print(Result),nl,

    % Logging information
    save_info(feat,'STATE',[Result]).

communication_int(displacing,[Stop,Turn,Movi,Err|Resultt],Result) :-
    % Calling the interpreter
    print('Nav Value stop '),print(Stop),nl,
    print('Nav Value turn '),print(Turn),nl,
    print('Nav Value movi '),print(Movi),nl,
    print('Nav Value err  '),print(Err),nl,
    %% ( mode_exe(test) ->
	  read(Result),
	      %% | otherwise ->
    %% oaa_Solve(get_state_full(Stop,Turn,Movi,Err,Result),[])
    %% ),
    print('The Nav state is '),print(Result),nl,

    % Logging information
    save_info(feat,'STATE',[Result]).

%Audio location with the agent
communication_int(position,[Pos,Int,Neg|Resultt],Result) :-
    % Calling the interpreter
    print('Loc Value pos '),print(Pos),nl,
    print('Loc Value int '),print(Int),nl,
    print('Loc Value neg '),print(Neg),nl,
    %% ( mode_exe(test) ->
	  print('Chose one option '),nl,
	  read(Result),
    %% 	      | otherwise ->
    %% 	      ( %% oaa_Solve(get_location_status(Pos,Int,Neg,Result),[]) ->
    %% 		  Result = Result 
    %% 			       | otherwise ->
    %% 		      Result = error
    %% 	      )
    %% ),
    print('The Loc state is '),print(Result),nl,

    % Logging information
    save_info(feat,'STATE',[Result]).


communication_int(directions,[directions(Angles)],directions(Angles)) :-
    % Calling the interpreter
    print('Asking for list of angles'),nl,
    %% ( mode_exe(test) ->
	  read(Angles),
	      %% | otherwise ->
    %% oaa_Solve(get_sound_directions(Angles))
%% ),
    print('Golem source direction angles '),print(Angles),
    % Logging information
    save_info(feat,'ANGLES',[Angles]).

communication_int(directions_pre,[directions(Angles_pre)],directions(Angles_pre)) :-
    % Calling the interpreter
    print('Asking for list of angles_pre'),nl,
    %% ( mode_exe(test) ->
          read(Angles_pre),
    %% 	      | otherwise ->
    %% %% oaa_Solve(get_sound_directions_pre(Angles_pre))
    %% ),
    print('Golem source direction angles_pre '),print(Angles_pre),
    % Logging information
    save_info(feat,'ANGLES_PRE',[Angles_pre]).


communication_int(direction,[direction(Angle)],direction(Angle)) :-
    % Calling the interpreter
    print('Asking for angle'),nl,
    %% ( mode_exe(test) ->
          read(Angle2),
	      %% | otherwise ->
    %% oaa_Solve(get_sound_direction(Angle2))
    %% ),
    Angle is round(Angle2*10)/10,
    print('Golem source direction angle '),print(Angle),
    % Logging information
    save_info(feat,'ANGLE',[Angle]).

communication_int(calculate_distance,[distance_to(Tag,Re)],distance_to(Tag,Re)) :-
    % Calling the interpreter
    %% ( mode_exe(test) ->
	  read(Re),
	      %% | otherwise ->
    %% oaa_Solve(get_distance_to(Tag,Re),[])
    %% ),
    print('Distance to '),print(Tag), print(' : '), print(Re),nl,
    save_info(feat,'DISTANCE TO POINT',[Re]).

%Audio location with the agent
communication_int(positionxyz,[pos(X,Y,Z)],pos(X,Y,Z)) :-
    %% ( mode_exe(test) ->
	  print('X value '),nl,read(X),
	  print('Y value '),nl,read(Y),
	  print('Z value '),nl,read(Z),
				   %% | otherwise ->
    %% oaa_Solve(get_odometry(X,Y,Z),[])
    %% ),
    print('Golem location is '),
    print('X '),print(X),nl,
    print('Y '),print(Y),nl,
    print('Z '),print(Z),nl,
    % Logging information
    save_info(feat,'Position',[X,Y,Z]).

%Navigation for getting state from turning
communication_int(turning,Expectations,State) :-
    print('Getting get_state for turn:   '),nl,
    %% oaa_Solve(get_state(stopped,turning,moving,State),[]),%to be used with navega_followme
    print(State),nl,
    save_info(feat,'INPUT',[State])
.

%Arm movement for getting state from taking 
communication_int(taking,Expectations,Result) :-
    print('Getting get_state for arm movement:   '),nl,
    %% (mode_exe(test) ->
	 read(Result),
	 print('State: '),print(Result),nl,
    %% 					    | otherwise ->
    %% 	     ( %% oaa_Solve(get_arm_state(stopped,moving,Result),[]) ->
    %% 		 print('State: '),print(Result),nl
    %% 						    | otherwise ->
    %% 		     Result = error
    %% 	     )
    %% ),
    save_info(feat,'INPUT',[Result])
.

%Arm movement for getting state from taking 
communication_int(grasping_obj,Expectations,State) :-
    print('Getting get_state for arm movement:   '),nl,
    %% (mode_exe(test) ->
	 read(Result),
	 print('State: '),print(State),nl,
    %% 					   | otherwise ->
    %% 	     ( %% oaa_Solve(get_arm_state(stopped,moving,State),[]) ->
    %% 		 print('State: '),print(State),nl
    %% 						   | otherwise ->
    %% 		     Result = error
    %% 	     )
    %% ),
    save_info(feat,'INPUT',[State])
.

%%%%% Communications for behaviors 2014

    
% Vision agent for detecting faces
communication_int(detect_head,Expected_Intentions,Result) :-
    print('In face detection '),nl,
    print(Expected_Intentions),nl, 
    ( mode_exe(test) ->
	  read(Input), 
	  print(Input),
	  % Logging information
	  Result = Input
    | otherwise ->
    	  % Communication with ROS
          rosswipl_call_service('/detect_head', '', Response),
 
          rosswipl_to_ioca(Response, HeadList),
          
    	  print('Head list = '), print(HeadList),
 
          (equivalent_terms(HeadList, [status(Status)]) ->
            Result = status(Status)
           | otherwise ->
            Result = heads(HeadList)
           ),
          % Result = heads(HeadList),

          print('Result = '), print(Result)
    ),
    print('Face detection result: '),print(Result),nl,
    save_info(feat,'INPUT',[Result]).

% Vision agent for detecting tables
communication_int(detect_table,Expected_Intentions,Result) :-
    print('In table detection '),nl,
    print(Expected_Intentions),nl, 
    ( mode_exe(test) ->
	  read(Input), 
	  print(Input),
	  % Logging information
	  Result = Input
    | otherwise ->
    	  % Communication with ROS
          rosswipl_call_service('/detect_table', '', Response),
 
          rosswipl_to_ioca(Response, TableList),
          
    	  print('Head list = '), print(TableList),
 
          (equivalent_terms(TableList, [status(Status)]) ->
            Result = status(Status)
           | otherwise ->
            Result = tables(TableList)
           ),
          print('Result = '), print(Result)
    ),
    print('Table detection result: '), print(Result), nl,
    save_info(feat,'INPUT',[Result]).


% Vision agent for detecting faces
communication_int(detect_face,Expected_Intentions,Result) :-
    print('In face detection '),nl,
    print(Expected_Intentions),nl, 
    ( mode_exe(test) ->
	  read(Input), 
	  print(Input),
	  % Logging information
	  Result = Input
    | otherwise ->
    	  % Communication with ROS
          rosswipl_call_service('/detect_face', '', Response),
          rosswipl_to_ioca(Response, FaceList),
          
    	  print('Face list = '), print(FaceList),
 
          (equivalent_terms(FaceList, [status(Status)]) ->
            Result = status(Status)
           | otherwise ->
            Result = faces(FaceList)
           ),
          
          print('Result = '), print(Result)
    ),
    print('Face detection result: '),print(Result),nl,
    save_info(feat,'INPUT',[Result]).


% Vision agent for recognizing faces
communication_int(recognize_face,Expected_Intentions,Result) :-
    print('In face recognition '),nl,
    print(Expected_Intentions),nl, 
    ( mode_exe(test) ->
	  read(Input), 
	  print(Input),
	  % Logging information
	  Result = Input
    | otherwise ->
    	  % Communication with ROS
          rosswipl_call_service('/recognize_face', '', Response),
           
          rosswipl_to_ioca(Response, [RecognitionResult]),
          
    	  print('Recognition result = '), print(RecognitionResult),
 
          (equivalent_terms(RecognitionResult, status(Status)) ->
            Result = status(Status)
           | otherwise ->
                Result = RecognitionResult
          ),
          
          print('Result = '), print(Result)
    ),
    print('Face recognition result: '),print(Result),nl,
    save_info(feat,'INPUT',[Result]).



    
communication_int(detect_body(Mode),Expected_Intentions,Result) :-
     print('In detect body'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = detected(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([Mode],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/detect_body', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = detected(Res),
       nl,print('Inter '),print(Result),nl
     ).


communication_int(memorize_body(ID,W,Name),Expected_Intentions,Result) :-
     print('In memorize body'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = said(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([ID,W,Name],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/memorize_body', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = memorized(Res),
       nl,print('Inter '),print(Result),nl
     ).

communication_int(recognize_body(ID,W),Expected_Intentions,Result) :-
     print('In recognize body'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = said(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([ID,W],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/recognize_body', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = recognized(Res),
       nl,print('Inter '),print(Result),nl
     ).

communication_int(detect_gesture(Type,Mode),Expected_Intentions,Result) :-
     print('In detect body'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = detected(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([Type,Mode],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/recognize_gesture', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = detected(Res),
       nl,print('Inter '),print(Result),nl
     ).

communication_int(detect_any_gesture(Mode),Expected_Intentions,Result) :-
     print('In detect any gesture'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = detected(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([Mode],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/recognize_any_gesture', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = detected(Res),
       nl,print('Inter '),print(Result),nl
     ).
     
communication_int(analyzing_crowd(Mode),Expected_Intentions,Result) :-
     print('In analyzing_crowd'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = detected(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([Mode],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/analyzing_crowd', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = detected(Res),
       nl,print('Inter '),print(Result),nl
     ).
     

communication_int(detect_crowd(Mode),Expected_Intentions,Result) :-
     print('In detect crowd'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = detected(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([Mode],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/detect_crowd', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = detected(Res),
       nl,print('Inter '),print(Result),nl
     ).


communication_int(describe_body(ID,W),Expected_Intentions,Result) :-
     print('Describe body'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   % Logging information
	   save_info(feat,'INPUT',[Input]),
	   Result = said(Input),
	   save_info(feat,'SPACT',[Result]),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
       term_to_atom([ID,W],InText),
       ioca_to_rosswipl( text(InText), JsonOut),
	   rosswipl_call_service('/describe_body', JsonOut, Response),
       rosswipl_to_ioca(Response, [text(MSG)]),
       term_to_atom(Res,MSG),
       Result = description(Res),
       nl,print('Inter '),print(Result),nl
     ).



%Laser act for looking for opened door
communication_int(waiting_door,Expected_Intentions, Result) :-
    % Communication with OAA
    save_info(feat,'INTERPRETER',[detect_door]),
    print('Agent interpreting door'),nl,
    ( mode_exe(test) ->
	  read(Result)
	| otherwise ->
    	  % Communication with ROS
          rosswipl_call_service('/door_checker_service', '', Response),
          rosswipl_to_ioca(Response, [door_status(Result)]),
    	  print('Door status = '), print(Result),nl
    ),
    print('Door agent interprets: '),
    print(Result), nl,

    % Logging information
    save_info(feat,'INPUT',[Result]).

communication_int(detect_polo,Expected_Intentions, Result) :-
    % Communication with OAA
    save_info(feat,'INTERPRETER',[detect_polo]),
    ( mode_exe(test) ->
    	  print('Write success (if detected), or error (if not)'),
    	  read(Result)
	| otherwise ->
    	  % Communication with ROS
          rosswipl_call_service('/polo_checker_service', '', Response),
          rosswipl_to_ioca(Response, [status(Result)])
    ),
    print('Polo detected = '), print(Result),nl,

    % Logging information
    save_info(feat,'INPUT',[Result]).

%Navigation act for obtaining the navigation status
communication_int(navigate_status,Expected_Intentions, Result) :-
    save_info(feat,'INTERPRETER',[navigate_status]),
    print('Agent interpreting navigation status'),nl,
    ( mode_exe(test) ->
	  read(Result),print('Nav. Status: '),print(Result),nl,
	  save_info(feat,'INPUT',[Result])
	| otherwise ->
    	  % Communication with ROS
          ioca_to_rosswipl(navigate_status('empty'),JsonOut),
          rosswipl_call_service('/navigate_service',JsonOut,JsonRes),
          rosswipl_to_ioca(JsonRes,[status(Result)]),
          print('Nav. Status: '),print(Result),nl,
	  save_info(feat,'INPUT',[Result])
    ).

communication_int(follow_status,Expected_Intentions, Result) :-
    save_info(feat,'INTERPRETER',[follow_status]),
    print('Agent interpreting following status'),nl,
    ( mode_exe(test) ->
	  read(Result),
	  print('Follow Status: '),print(Result),nl
	| otherwise ->
    	  % Communication with ROS
          ioca_to_rosswipl(text('empty'), JsonOut),
          rosswipl_call_service('/follow_status',JsonOut,JsonRes),
          rosswipl_to_ioca(JsonRes,[status(Result)]),
          print('Follow Status: '),print(Result),nl,
	  save_info(feat,'INPUT',[Result])
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Noe Hdez   type ==> qr_recognition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Agent for QR code recognition
communication_int(qr_recognition, Expected_Intentions, Result) :-
	( mode_exe(test) ->
	     read(Result),
         print('QR code recognition result: '),
         print(Result), nl
      | otherwise ->
         % Communication with ROS
 	     rosswipl_call_service('/qr_codes/qr_reader', '', Response),
         rosswipl_to_ioca(Response, QRCode),
        
         print('QR code = '), print(QRCode),
          
         ( equivalent_terms(QRCode, [text(MSG)]) ->
              Result = code(MSG)
         | otherwise ->	   
              Result = fail_status
         ),

         print('Result = '), print(Result)
    ),

    save_info(feat,'INPUT',[Result])
.            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Follow with OpenPose%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Recognize person to follow
communication_int(recognize_follow,Expected_Intentions,Result) :-
     print('In recognize follow'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   ioca_to_rosswipl(text('empty'), JsonOut),
	   rosswipl_call_service('/recognize_follow', JsonOut, Response),
	   rosswipl_to_ioca(Response,[status(Result)]),
           nl,print('Inter********************************* '),print(Result),nl
     ).
     
%%Find followed person
communication_int(find_follow,Expected_Intentions,Result) :-
     print('In recognize follow'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   ioca_to_rosswipl(text('empty'), JsonOut),
	   rosswipl_call_service('/find_follow', JsonOut, Response),
	   rosswipl_to_ioca(Response,[status(Result)]),
           nl,print('Inter********************************* '),print(Result),nl
     ).

%%see pointing of followed person
communication_int(see_pointing_follow,Expected_Intentions,Result) :-
     print('In see_pointing_follow'),nl,
     ( mode_exe(test) ->
	   read(X),
	   read(Y),
	   read(Z), 
	   print("X: "),print(X),nl,
	   print("Y: "),print(Y),nl,
	   print("Z: "),print(Z),nl,
	   Result = pointing_coords(X,Y,Z),
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
           ioca_to_rosswipl(text('empty'), JsonOut),
	   rosswipl_call_service('/see_pointing_follow', JsonOut, Response),
           rosswipl_to_ioca(Response,ObjectList),
           %equivalent_terms(ObjectList, [x(X)]),
           %equivalent_terms(ObjectList, [y(Y)]),
           %equivalent_terms(ObjectList, [z(Z)]), 
           X is 5,
           Y is 5,
           Z is 9,
           Result = pointing_coords(X,Y,Z),
           nl,print('Inter '),print(Result),nl
     ).



%%See gesture with openpose
communication_int(see_gesture_op(Mode),Expected_Intentions,Result) :-
     print('In see gesture OP'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	       ioca_to_rosswipl(Mode, JsonOut),
	       rosswipl_call_service('/see_gesture_op', JsonOut, Response),
           rosswipl_to_ioca(Response, [status(Result)]),
           nl,print('Inter '),print(Result),nl
     ).
     
%% Conitive Services
%Detect face
communication_int(detect_face_cognitive(Command),Expected_Intentions,Result) :-
     print('In detect face cognitive'),nl,
     sleep(5),
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	       ioca_to_rosswipl(detect_request('detect'), JsonOut),
	       print(JsonOut),
	       %%ioca_to_rosswipl(text('empty'), JsonOut),
	       rosswipl_call_service('/face_detection_cog', JsonOut, Response),
	       
           rosswipl_to_ioca(Response, [Result]),
           %esult = status(ok),
           nl,print('Inter '),print(Result),nl
     ).



%Identify face 
communication_int(identify_face_cognitive(Command,FaceId),Expected_Intentions,Result) :-
     print('In identify face cognitive'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   ioca_list_to_rosswipl([command('identify'),faceId(FaceId)], JsonOut),
           rosswipl_call_service('/face_detection_cog', JsonOut, Response),

	   rosswipl_to_ioca(Response, [Val]),
	   (
	       equivalent_terms(Val,status(St)) ->
		   nl,nl,print(St),nl,nl,
		   Result = status(St)
		| Result = Val
	   )
	       
     ).

%gesture OpenPose 
communication_int(gesture_op,Expected_Intentions,Result) :-
     print('In gesture_op'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   rosswipl_call_service('/person_gesture_op', '',Response),
	   print(Response),
	   %Result = status(ok)
	   %rosswipl_to_ioca('{\"person_gesture_op\": {\"angle\":0.1,\"pointX\":0.2,\"pointY\":0.3,\"pointZ\":0.4} }', [Val] ),
	   %{"identified_face":[{"confidence":0.8443099856376648,"distanciaX":0.06708060950040817,"distanciaY":-0.4520608186721802,"distanciaZ":1.478000044822693,"isIdentical":"true"}]}
	   %rosswipl_to_ioca('{\"person\":[{\"angle\":0.1,\"pointX\":0.2,\"pointY\":0.3,\"pointZ\":0.4}] }', [Val] ),
	   rosswipl_to_ioca(Response, [Val] ),
	   print(Val),
	   (
	       equivalent_terms(Val,status(St)) ->
		   nl,nl,print(St),nl,nl,
		   Result = status(St)
		| Result = Val
	   )
	       
     ).
     
%PersonPoseOp 
communication_int(person_pose_op,Expected_Intentions,Result) :-
     print('In person_pose_op'),nl,
     ( mode_exe(test) ->
% print("Calling person_pose_op service"),
	  rosswipl_call_service('/person_pose_op', '', Response),
          rosswipl_to_ioca(Response, [Val]),
          %Ang is 0,
          %X is 0.5,
          %Y is -0.45,
          %Z is 0,
          Result = Val,
	  nl,print('Inter '),print(Result),nl
     | otherwise ->
     	  % print("Calling person_pose_op service"),
	  rosswipl_call_service('/person_pose_op', '', Response),
	  print(Response),
          rosswipl_to_ioca(Response, [Val]),
          %Ang is 0,
          %X is 0.5,
          %Y is -0.45,
          %Z is 0,
          
          Result = Val,
	  nl,print('Inter '),print(Result),nl
     ).
     
     
communication_int(pointing_op,Expected_Intentions,Result) :-
     print('In pointing_op'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   rosswipl_call_service('/person_pointing_op', '',Response),
	   print(Response),
	   %Result = status(ok)
	   %rosswipl_to_ioca('{\"person_gesture_op\": {\"angle\":0.1,\"pointX\":0.2,\"pointY\":0.3,\"pointZ\":0.4} }', [Val] ),
	   %{"identified_face":[{"confidence":0.8443099856376648,"distanciaX":0.06708060950040817,"distanciaY":-0.4520608186721802,"distanciaZ":1.478000044822693,"isIdentical":"true"}]}
	   %rosswipl_to_ioca('{\"person\":[{\"angle\":0.1,\"pointX\":0.2,\"pointY\":0.3,\"pointZ\":0.4}] }', [Val] ),
	   rosswipl_to_ioca(Response, [Val] ),
	   print(Val),
	   (
	       equivalent_terms(Val,status(St)) ->
		   nl,nl,print(St),nl,nl,
		   Result = status(St)
		| Result = Val
	   )
	       
     ).
     
%Where is this      
     
communication_int(whereiam,Expected_Intentions,Result) :-
     print('In whereiam'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   rosswipl_call_service('/where_iam', '',Response),
	   print(Response),
	   rosswipl_to_ioca(Response, [Val] ),
	   print(Val),
	   (
	       equivalent_terms(Val,status(St)) ->
		   nl,nl,print(St),nl,nl,
		   Result = status(St)
		| Result = Val
	   )
	       
     ).
     
communication_int(whereiam_dummy,Expected_Intentions,Result) :-
     print('In whereiam'),nl,
     ( mode_exe(test) ->
	   read(Input), 
	   print(Input),
	   Result = Input,
	   nl,print('Inter '),print(Result),nl
     | otherwise ->
	   Val=text(bar),
	   (
	       equivalent_terms(Val,status(St)) ->
		   nl,nl,print(St),nl,nl,
		   Result = status(St)
		| Result = Val
	   )
	       
     ).


     
