/*******************************************************************************
    SitLog (Situation and Logic)

    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2012 Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)
    Copyright (C) 2012 Ivan Meza (http://turing.iimas.unam.mx/~ivanvladimir)
    Copyright (C) 2012 Caleb Rascón (http://turing.iimas.unam.mx/~caleb)
    Copyright (C) 2012 Lisset Salinas (http://turing.iimas.unam.mx/~liz)

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

%%%%%%%%%%%%%%%%%%%%%%%%% Actions definitions %%%%%%%%%%%%%%%%%%%%%%%%%%
%% :- use_module(library(system)).

systems_service_call(A,despliega(I,X),_) :-
        save_info(third_level,'RHTACT',[]),
        save_info(feat,'NAME',[despliega]),
        save_info(feat,'IMAGE',[I]),
        save_info(feat,'COLOR',[X]),

        save_info(feat,'INITIME',[]),
        (mode_exe(test) ->
             print('Visualiza imagen: '),print(I),print(', '),print(X),nl
        | otherwise ->
		 print('ROSSWIPL call')
	%%oaa_Solve(visualizaImagen(I,X),[])
        ),
        save_info(feat,'FINTIME',[]).



%Act for starting the saving for log files
systems_service_call(start,initSpeech,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[initSpeech]),
  day_wavlog(WavLog),
  save_info(feat,'FILE',[WavLog]),
  (mode_exe(test) ->
    print('Automatic speech recognizer starts with '),
    print(WavLog),nl
  | otherwise ->
    print('Automatic speech recognizer starts with '),
    print(WavLog),nl
    %% oaa_Solve(initSpeech(WavLog),[])
).

%Act for starting the voice recognizer and synthesis
systems_service_call(start,initASR,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[initASR]),
  day_wavlog(WavLog),
  save_info(feat,'FILE',[WavLog]),
  (mode_exe(test) ->
    print('Initializating the ASR '),
    print(WavLog), nl
  | otherwise ->
    print('Initializating the ASR '),
    print(WavLog), nl
    %% oaa_Solve(initSpeech(WavLog),[])
).

%Rethorical acts for display in the screen
%Act for cleaning the screen
systems_service_call(Action_Type,clean,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[clean]),
  (mode_exe(test) ->
    print('Screen elements erased...'),nl
  | otherwise ->
		 print('ROSSWIPL call')
	%% oaa_Solve(clean(''),[])
),!.

%Act for displaying an image
systems_service_call(Action_Type,putImage(Id,Im,X,Y),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[putImage]),
  save_info(feat,'IMAGE',[Im]),
  save_info(feat,'IDIMAGE',[Id]),
  save_info(feat,'XPOS',[X]),
  save_info(feat,'YPOS',[Y]),
  (mode_exe(test) ->
    print('Shows picture...'),nl
  | otherwise ->
	print('ROSSWIPL call')
	%% oaa_Solve(putImage(Id,Im,X,Y),[])
),!.


systems_service_call(AT,understand(Expected_Intentions,Input,Result),Args_Action) :-
   (mode_exe(test) ->
    print('input speech act...'),nl,read(Result),nl
						     | otherwise ->
	print('ROSSWIPL call')
    %% oaa_Solve(interpretaVoz(Expected_Intentions,Input,Result),[blocking(true)])
),!.



%Act for displaying a button
systems_service_call(Action_Type,putButton(Id,Im,X,Y),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[putButton]),
  save_info(feat,'IMAGE',[Im]),
  save_info(feat,'IDIMAGE',[Id]),
  save_info(feat,'XPOS',[X]),
  save_info(feat,'YPOS',[Y]),
  (mode_exe(test) ->
    print('Displays button...'),nl
  | otherwise ->
	print('ROSSWIPL call')
	%% oaa_Solve(putButton(Id,Im,X,Y),[])
),!.


%Act for analyzing objects
systems_service_call(Action_Type,uo_analyze_scene(T),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[uo_analyze_scene]),
  (mode_exe(test) ->
    print('Analyzing for unknown object '),nl
  | otherwise ->
    print('Analyzing for unknown object '),nl
    %% ( oaa_Solve(vision_pclobject_analyze(T),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  ).

%Act for analyzing objects
systems_service_call(Action_Type,analyze_scene_plane(T),Args_Action) :-
  print('In analyze_scene_plane'),nl,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[analyze_scene_plane]),
  save_info(feat,'ANGLE',[T]),
  (mode_exe(test) ->
    print('Analyzing plane on:'),print(T),nl
  | otherwise ->
    print('Analyzing plane on: '),print(T),nl
    %% ( oaa_Solve(vision_pcltable_analyze(T),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  ).

%Act for saving images taken
systems_service_call(Action_Type,save_face(Name),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[save_face]),
  (mode_exe(test) ->
    print('Saving face from: '),print(Name),nl
  | otherwise ->
    print('Saving face from: '),print(Name),nl,
    print('Now'),nl,
    %% oaa_Solve(save_face(Name),[]),
    print('Ready'),nl
  ),
  save_info(feat,'ID',[Name])
.

%Act for trainig the agent for face recognition
systems_service_call(Action_Type,train_faces,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[train_faces]),
  (mode_exe(test) ->
    print('Learning faces'),nl
  | otherwise ->
    print('Learning faces'),nl
    %% oaa_Solve(learn_faces,[])
  ).

%Act for asking for people recognition
systems_service_call(Action_Type,recognize_people,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[recognize_people]),
  (mode_exe(test) ->
    print('Recognizing faces'),nl
  | otherwise ->
    print('Recognizing faces'),nl
    %% oaa_Solve(recognize_face,[])
  ).

systems_service_call(Action_Type,take_photo,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[take_photo]),
  (mode_exe(test) ->
    print('Foto taken Result: '),print(taken),nl
  | otherwise ->
	%% oaa_Solve(take_photo(Result),[]),
		rosswipl_call_service('/image_saver/image', '', Response),
    print('Nav. Result: '),print(Result),nl
  ),
  save_info(feat,'RESULT',[Result])
.

%Rethorical acts for movement
%Navigation
%Act for navigating to points
systems_service_call(Action_Type,ma(Dest),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[Dest]),
  (mode_exe(test) ->
    print('Moving to: '),print(Dest),nl
  | otherwise ->
    print('Moving to: '),print(Dest),nl
    %% oaa_Solve(move_to(Dest),[])
  ).

%systems_service_call(Action_Type,navigate(Location,Block,Result),Args_Action) :-
%  save_info(third_level,'BASIC_ACT',[]),
%  save_info(feat,'TYPE',[Action_Type]),
%  save_info(feat,'NAME',[ma]),
%  save_info(feat,'LOCATION',[Location]),
%  (mode_exe(test) ->
%    print('Nav. Moving to: '),print(Location),nl,
%    print('Nav. Blocking: '),print(Block),nl,
%    print('Nav. Result: '),print(Result),nl
%  | otherwise ->
%    print('Nav. Moving to: '),print(Location),nl,
%    print('Nav. Blocking: '),print(Block),nl,
%    %% oaa_Solve(navigate(Location,Block,Result),[]),
%    print('Nav. Result: '),print(Result),nl
%  ).

%Act for navigating to points
systems_service_call(Action_Type,ma_xyr(X,Y,D),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[move_to]),
  save_info(feat,'X',[X]),
  save_info(feat,'Y',[Y]),
  save_info(feat,'D',[D]),
  (mode_exe(test) ->
    print('Moving to coordinates: '),print(X),print(' , '),print(Y),print(' , '),print(Z),nl
  | otherwise ->
    print('Moving to coordinates: '),print(X),print(' , '),print(Y),print(' , '),print(Z),nl
    %% oaa_Solve(move_to_xyr(X,Y,D),[])
  ).

%Act for navigation to distance and angle
systems_service_call(Action_Type,get_close(Distance,Angle),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[get_close]),
  save_info(feat,'DISTANCE',[Distance]),
  save_info(feat,'ANGLE',[Angle]),
  (mode_exe(test) ->
    T is round(Distance*10000)/10000,
    T2 is round(Angle*10000)/10000,
    print('Golem moves '),print(T),print(' meters and '),print(T2),print(' degrees'),nl
  | otherwise ->
    T is round(Distance*10000)/10000,
    T2 is round(Angle*10000)/10000,
    print('Golem moves '),print(T),print(' meters and '),print(T2),print(' degrees'),nl
    %% oaa_Solve(get_close(T, T2),[])
  ),
  save_info(feat,'REAL DISTANCE',[T]),
  save_info(feat,'REAL ANGLE',[T2])
.

%Act for navigation to distance and angle
systems_service_call(Action_Type,get_close_odom(X,Y),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[get_close_odom]),
  save_info(feat,'X',[X]),
  save_info(feat,'Y',[Y]),
  (mode_exe(test) ->
    T is round(X*10000)/10000,
    T2 is round(Y*10000)/10000,
    print('Golem moves '),print(T),print(' , '),print(T2),print(' meters'),nl
  | otherwise ->
    T is round(X*10000)/10000,
    T2 is round(Y*10000)/10000,
    print('Golem moves '),print(T),print(' , '),print(T2),print(' meters'),nl
    %% oaa_Solve(get_close_odom(T, T2),[])
  ),
  save_info(feat,'REAL DISTANCE X',[T]),
  save_info(feat,'REAL DISTANCE Y',[T2])
.

%Act for navigation to distance and angle
systems_service_call(Action_Type,get_closer(Distance,Angle),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[get_closer]),
  save_info(feat,'DISTANCE',[Distance]),
  save_info(feat,'ANGLE',[Angle]),
  (mode_exe(test) ->
    T is round(Distance*10000)/10000,
    T2 is round(Angle*10000)/10000,
    print('Golem moves '),print(T),print(' meters and '),print(T2),print(' degrees'),nl
  | otherwise ->
    T is round(Distance*10000)/10000,
    T2 is round(Angle*10000)/10000,
    print('Golem moves '),print(T),print(' meters and '),print(T2),print(' degrees'),nl
    %% oaa_Solve(get_close_fine(T,T2),[])
  ),
  save_info(feat,'REAL DISTANCE',[T]),
  save_info(feat,'REAL ANGLE',[T2])
.

%Act for navigation to distance and angle
systems_service_call(Action_Type,get_close_precise(Distance,Angle),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[get_close_precise]),
  save_info(feat,'DISTANCE',[Distance]),
  save_info(feat,'ANGLE',[Angle]),
  (mode_exe(test) ->
    T is round(Distance*10000)/10000,
    T2 is round(Angle*10000)/10000,
    print('Golem moves '),print(T),print(' meters and '),print(T2),print(' degrees'),nl
  | otherwise ->
    T is round(Distance*10000)/10000,
    T2 is round(Angle*10000)/10000,
    print('Golem moves '),print(T),print(' meters and '),print(T2),print(' degrees'),nl
    %% oaa_Solve(get_close_fine(T,T2),[])
  ),
  save_info(feat,'REAL DISTANCE',[T]),
  save_info(feat,'REAL ANGLE',[T2])
.

%Act for navigation to turning angle
systems_service_call(Action_Type,turn(Degrees),Args_Action) :-
  T is round(Degrees*10000)/10000,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[turn_block]),
  save_info(feat,'TURNING',[T]),
  (mode_exe(test) ->
    print('Turning '),print(T),nl
  | otherwise ->
    print('Turning '),print(T),nl
    %% oaa_Solve(turn_block(T))
  ).


%Act for navigation for turning and speaking without interruption
systems_service_call(Action_Type,turn_s(Degrees),Args_Action) :-
  T is round(Degrees*10000)/10000,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[turn_s]),
  save_info(feat,'TURNING',[T]),
  (mode_exe(test) ->
    print('Turning '),print(T),nl
  | otherwise ->
    print('Turning '),print(T),nl
    %% oaa_Solve(turn(T),[])
  ).


%Act for saving position from odometry
systems_service_call(Action_Type,odometry(X,Y,Z),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[odometry]),
  save_info(feat,'X',[X]),
  save_info(feat,'Y',[Y]),
  save_info(feat,'Z',[Z]),
  (mode_exe(test) ->
    print('Saving position: '),print(X),print(', '),print(Y),print(', '),print(Z),nl
  | otherwise ->
	%% oaa_Solve(odometry(X,Y,Z),[]),
    print('Saving position: '),print(X),print(', '),print(Y),print(', '),print(Z),nl
  ).


%Act for aproaching person, distance betweet user and robot
systems_service_call(Action_Type,avanzar(Separacion),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[avanzar]),
  save_info(feat,'WITH DISTANCE TO TARGET',[Separacion]),
  (mode_exe(test) ->
    print('Avanzando... '),nl
  | otherwise ->
    print('Avanzando... '),nl,
    ioca_to_rosswipl(distance(Separacion), Request),
    rosswipl_call_service('/start_follow_person', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Respuesta: '),print(Result),nl
  ).

%Act for adjusting the robot to location left/right
systems_service_call(Action_Type,adjust(Dest),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[adjust]),
  save_info(feat,'DESTINATION',[Dest]),
  (mode_exe(test) ->
    print('Adjusting to: '),print(Dest),nl
  | otherwise ->
    print('Adjusting to: '),print(Dest),nl,
    %% oaa_Solve(nudge(Dest),[]),
    print('End adjusting to: '),print(Dest),nl
  ).

%Act for stoping navigator
systems_service_call(Action_Type,detener,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[detener]),
  (mode_exe(test) ->
    print('Alto... '),nl
  | otherwise ->
    print('Alto... '),nl,
    ioca_to_rosswipl(text('empty'), Request),
    rosswipl_call_service('/stop_follow_person', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Respuesta: '),print(Result),nl
  ).

%Act for switching to amcl (normal) navigation
systems_service_call(Action_Type,start_amcl,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[switch_amcl]),
  (mode_exe(test) ->
    print('Switching to AMCL Navigation... '),nl
  | otherwise ->
    print('Switching to AMCL Navigation... '),nl,
    ioca_to_rosswipl(text('empty'), Request),
    rosswipl_call_service('/start_amcl', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[method(Result)]),
    print('Status: '),print(Result),nl
  ).

%Act for switching to gmapping (no map) navigation
systems_service_call(Action_Type,start_gmapping,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[switch_gmapping]),
  (mode_exe(test) ->
    print('Switching to GMapping Navigation... '),nl
  | otherwise ->
    print('Switching to GMapping Navigation... '),nl,
    ioca_to_rosswipl(text('empty'), Request),
    rosswipl_call_service('/start_gmapping', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[method(Result)]),
    print('Status: '),print(Result),nl
  ).

%Act for disconnecting current topological points
systems_service_call(Action_Type,disconnect_topo_points,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[disconnect_topo_points]),
  (mode_exe(test) ->
    print('Disconnecting Topo Points... '),nl
  | otherwise ->
    print('Disconnecting Topo Points... '),nl
    %% oaa_Solve(disconnect_topo_points,[])
  ).

%Hernandos arm
%Act for grasping object
systems_service_call(Action_Type,grasp(Angle,Dist,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[grasp]),
  save_info(feat,'ANGLE',[Angle]),
  save_info(feat,'DISTANCE',[Dist]),
  (mode_exe(test) ->
    print('Grasping object in: '),print(Angle),print(', '),print(Dist),nl
  | otherwise ->
    print('Grasping object in: '),print(Angle),print(', '),print(Dist),nl,
    ioca_to_rosswipl(graspcoord(Angle,Dist), Request),
    rosswipl_call_service('/grasp', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Grasp Result: '),print(Result),nl
  ).
  
%Act for grasping bag
systems_service_call(Action_Type,grasp_bag(Angle,Dist,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[grasp_bag]),
  save_info(feat,'ANGLE',[Angle]),
  save_info(feat,'DISTANCE',[Dist]),
  (mode_exe(test) ->
    print('Grasping bag in: '),print(Angle),print(', '),print(Dist),nl
  | otherwise ->
    print('Grasping object in: '),print(Angle),print(', '),print(Dist),nl,
    ioca_to_rosswipl(graspcoord(Angle,Dist), Request),
    rosswipl_call_service('/grasp_bag', Request, JsonRes),
    Result = ok,
    print('Grasp Result: '),print(Result),nl
  ).

%Act to offer an object
systems_service_call(Action_Type,offer,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[offer]),
  (mode_exe(test) ->
    print('Offering object '),nl
  | otherwise ->
    print('Offering object '),nl,
    ioca_to_rosswipl(graspcoord(0.0,0.5), Request),
    rosswipl_call_service('/offerobject', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Offering Result: '),print(Result),nl
  )
.

systems_service_call(Action_Type,offer(Ang,Dist),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[offer]),
  (mode_exe(test) ->
    print('Offering object '),nl
  | otherwise ->
    print('Offering object '),nl,
    ioca_to_rosswipl(graspcoord(Ang,Dist), Request),
    rosswipl_call_service('/offerobject', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Offering Result: '),print(Result),nl
  )
.

%Act to offer an object
systems_service_call(Action_Type,offer_args(Ang,Dist),Args_Action) :-
  print('In action offer'),nl,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[offer_args]),
  save_info(feat,'ANGLE',[Ang]),
  save_info(feat,'DISTANCE',[Dist]),
  (mode_exe(test) ->
    print('Offering object at: '), print(Ang), print(', '), print(Dist),nl
  | otherwise ->
    print('Offering object at: '), print(Ang), print(', '), print(Dist),nl
    %% oaa_Solve(offerobject(Ang,Dist),[])
  )
.

%Act to open gripper
systems_service_call(Action_Type,open_grip,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[open_grip]),
  (mode_exe(test) ->
    print('Opening gripper '),nl
  | otherwise ->
    print('Opening gripper '),nl,
    ioca_to_rosswipl(text('open'), Request),
    rosswipl_call_service('/grip', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Opening gripper Result: '),print(Result),nl
  ).

%Act to close gripper
systems_service_call(Action_Type,close_grip,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[close_grip]),
  (mode_exe(test) ->
    print('Closing gripper '),nl
  | otherwise ->
    print('Closing gripper '),nl,
    ioca_to_rosswipl(text('close'), Request),
    rosswipl_call_service('/grip', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Closing gripper Result: '),print(Result),nl
  ).

%Act to move arm to start
systems_service_call(Action_Type,return_gobj,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[return_gobj]),
  (mode_exe(test) ->
    print('Returning arm with object '),nl
  | otherwise ->
    print('Returning arm with object '),nl
    %% oaa_Solve(parkarmwithobject,[])
  ).

%Act to move arm to start
systems_service_call(Action_Type,return_grip,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[return_grip]),
  (mode_exe(test) ->
    print('Returning arm '),nl
  | otherwise ->
    print('Returning arm '),nl
    %% oaa_Solve(parkarmwithobject,[])
    %oaa_Solve(parkarm,[])
  ).

%Act to reset arm pose
systems_service_call(Action_Type,reset_arm,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[reset_arm]),
  (mode_exe(test) ->
    print('Reseting gripper pose '),nl
  | otherwise ->
    print('Reseting gripper pose'),nl
    %% oaa_Solve(armposereset,[])
  ).

%Act to reset arm state
systems_service_call(Action_Type,reset_arm_state,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[reset_arm_state]),
  (mode_exe(test) ->
    print('Reseting gripper state '),nl
  | otherwise ->
    print('Reseting gripper state '),nl
    %% oaa_Solve(resetarm,[])
  ).

%Act for switching arms
systems_service_call(Action_Type,switcharm(Arm),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[switcharm]),
  save_info(feat,'ARM',[Arm]),
  (mode_exe(test) ->
    print('Switching to arm '),print(Arm),nl
  | otherwise ->
    print('Switching to arm '),print(Arm),nl,
    %% oaa_Solve(switcharm(Arm),[])
    ioca_to_rosswipl(arm(Arm), Request),
    rosswipl_call_service('/switcharm', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Switch Arm Result: '),print(Result),nl
  )
.

%Act for switching pose
systems_service_call(Action_Type,switchpose(Pose),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[switchpose]),
  save_info(feat,'POSE',[Pose]),
  (mode_exe(test) ->
    print('Switching pose to '),print(Pose),nl
  | otherwise ->
    print('Switching pose to '),print(Pose),nl,
    ioca_to_rosswipl(pose(Pose), Request),
    rosswipl_call_service('/switchpose', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Switch Pose Result: '),print(Result),nl
  )
.

%Platform
%Act for moving the platform for arm 1
systems_service_call(Action_Type,platform(A),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[platform]),
  save_info(feat,'HEIGHT',[A]),
  (mode_exe(test) ->
    print('Moving platform to '),print(A),nl
  | otherwise ->
    print('Moving platform to  '),print(A),nl
    %% ( oaa_Solve(move_platform(A),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  )
.

%Act for moving the platform for a specific arm
systems_service_call(Action_Type,robotheight(A),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[robotheight]),
  save_info(feat,'HEIGHT',[A]),
  (mode_exe(test) ->
    print('Moving Robot Height to '),print(A)
  | otherwise ->
    print('Moving Robot Height to '),print(A),nl,
    ioca_to_rosswipl(height(A), Request),
    rosswipl_call_service('/platform', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Robot Height Result: '),print(Result),nl
  ),
  print('Exit'),nl
.
%Act for moving the platform for a specific arm
systems_service_call(Action_Type,platform2arm(A,Arm),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[platform2arm]),
  save_info(feat,'HEIGHT',[A]),
  save_info(feat,'ARM',[Arm]),
  (mode_exe(test) ->
    print('Moving platform to '),print(A),
    print('for arm '),print(Arm),nl
  | otherwise ->
    print('Moving platform to '),print(A),
    print('for arm '),print(Arm),nl
    %% ( oaa_Solve(move_platform_arm(A,Arm),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  ),
  print('Exit'),nl
.
%Act for moving the platform for a specific arm to a guess height
systems_service_call(Action_Type,platform2armguess(A,Arm),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[platform2armguess]),
  save_info(feat,'HEIGHT',[A]),
  save_info(feat,'ARM',[Arm]),
  (mode_exe(test) ->
    print('Moving platform gess to '),print(A),
    print('for arm '),print(Arm),nl
  | otherwise ->
    print('Moving platform gess to '),print(A),
    print('for arm '),print(Arm),nl
    %% ( oaa_Solve(move_platform_arm_guess(A,Arm),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )

  )
.

%Kinect
%Act for moving kinect to certain angle
systems_service_call(Action_Type,tilt(A),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[tilt]),
  save_info(feat,'ANGLE',[A]),
  (mode_exe(test) ->
    print('Moving kinect to '),print(A),nl
  | otherwise ->
    print('Moving kinect to '),print(A),nl
    %% ( oaa_Solve(tilt(A),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )

  ).

%Act for moving cameras to certain angle vertically
systems_service_call(Action_Type,tiltv(A),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[tiltv]),
  save_info(feat,'ANGLE',[A]),
  (mode_exe(test) ->
    print('Moving Neck vertically to '),print(A),nl
  | otherwise ->
    print('Moving Neck vertically to '),print(A),nl,
    ioca_to_rosswipl(neckcoord(A,1), Request),
    rosswipl_call_service('/turn_neck', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Turn Neck Result: '),print(Result),nl
  ).

%Act for moving cameras to certain angle horizontally
systems_service_call(Action_Type,tilth(A),Args_Action) :-
  %A is round(A_),
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[tilth]),
  save_info(feat,'ANGLE',[A]),

  (mode_exe(test) ->
    print('Moving Neck horizontally to '),print(A),nl
  | otherwise ->
    print('Moving Neck horizontally to '),print(A),nl,
    ioca_to_rosswipl(neckcoord(A,2), Request),
    print(Request), nl,
    rosswipl_call_service('/turn_neck', Request, JsonRes),
   print(JsonRes), nl,
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Turn Neck Result: '),print(Result),nl
  ).

%Act for moving the laser to certain angle vertically
systems_service_call(Action_Type,lasertiltv(A),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[lasertiltv]),
  save_info(feat,'ANGLE',[A]),
  (mode_exe(test) ->
    print('Moving Laser vertically to '),print(A),nl
  | otherwise ->
    print('Moving Laser vertically to '),print(A),nl,
    ioca_to_rosswipl(neckcoord(A,1), Request),
    rosswipl_call_service('/turn_laser', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Turn Laser Result: '),print(Result),nl
  ).

%Act for moving the laser to certain angle horizontally
systems_service_call(Action_Type,lasertilth(A),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[lasertilth]),
  save_info(feat,'ANGLE',[A]),
  (mode_exe(test) ->
    print('Moving Laser horizontally to '),print(A),nl
  | otherwise ->
    print('Moving Laser horizontally to '),print(A),nl,
    ioca_to_rosswipl(neckcoord(A,2), Request),
    rosswipl_call_service('/turn_laser', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Turn Laser Result: '),print(Result),nl
  ).

%Rethorical acts for audio location
%Act for pausing audio location
systems_service_call(Action_Type,pause_audio_loc,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[pause_audio_loc]),
  (mode_exe(test) ->
    print('Audio Loc Paused.'),nl
  | otherwise ->
    print('Audio Loc Paused.'),nl
    %% ( oaa_Solve(pause_soundloc(Result),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  ).

%Rethorical acts for audio location
%Act for pausing audio location
systems_service_call(Action_Type,reset_soundloc,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[reset_soundloc]),
  (mode_exe(test) ->
    print('Resetting soundloc.'),nl
  | otherwise ->
    print('Resetting soundloc.'),nl,
    rosswipl_call_service('/soundloc/reset_soundloc', '', _)
  ).

%Act for restarting audio location
systems_service_call(Action_Type,start_soundloc,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[start_soundloc]),
  (mode_exe(test) ->
    print('Audio Loc Restarted.'),nl
  | otherwise ->
    print('Audio Loc Restarted.'),nl
    %% ( oaa_Solve(start_soundloc(Result),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  ).



%Act for restarting audio location
systems_service_call(Action_Type,restart_audio_loc,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[reset_audio_loc]),
  (mode_exe(test) ->
    print('Audio Loc Restarted.'),nl
  | otherwise ->
    print('Audio Loc Restarted.'),nl
    %% ( oaa_Solve(start_soundloc(Result),[]) ->
    %%   print('Starting')
    %% | otherwise ->
    %%   print('Error'),
    %%   save_info(feat,'ERROR',[no_agent])
    %% )
  ).

%Rethorical acts for voice synthesis
systems_service_call(speech, synthesize, Out_Text) :-
  print('In speech communication'),
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[speech]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'MSG',[Out_Text]),
  (mode_exe(test) ->
    print('Golem says: '),print(Out_Text),nl
  | otherwise ->
    print('Golem says: '),print(Out_Text),nl
    %% oaa_Solve(di(Out_Text,_X),[blocking(true)])
  ).


%Rethorical acts for voice synthesis
systems_service_call(get_speechact, SpeechActs, Input, SA) :-
  print('Speech acts'),
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[interpretation]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'SPACTS',SpeechActs),
  (mode_exe(test) ->
    print('Choose an speech act:'),nl,
    read(S)
  | otherwise ->
    %% oaa_Solve(interpretaVoz(SpeechActs,Input,SA),[blocking(true)]),
    print('SA: '),print(SA),nl
  ),
  save_info(feat,'SPACT',SA)
  .


%%% OUT Communications with ROSS %%%


%%% SAY with ross %%%

%Act for saying a message
systems_service_call(Action_Type,say([A|Rest]),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'INITIME',[]),
  msg_format([A|Rest],MSG),
  save_info(feat,'MESSAGE',[MSG]),
  (mode_exe(test) ->
    print('Golem says: '),print(MSG),nl
  | otherwise ->
    print('Golem says: '),print(MSG),nl,
    ioca_to_rosswipl(text(MSG), Request),
    print(Request),nl,
    rosswipl_call_service('/speak_sentence', Request, _)
  ),
  save_info(feat,'FINTIME',[]).

systems_service_call(Action_Type,say(MSG),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'MSG',[MSG]),
  (mode_exe(test) ->
    print('Golem says: '),print(MSG),nl
  | otherwise ->
    print('Golem says: '),print(MSG),nl,
    ioca_to_rosswipl(text(MSG), Request),
    print(Request),nl,
    rosswipl_call_service('/speak_sentence', Request, _)
).


%%% MOVE with ross %%%

%%Case 1 Coordinate

systems_service_call(Action_Type,navigate([X,Y,Angle],Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[[X,Y,Angle]]),
  (mode_exe(test) ->
    print('Nav. Moving (Coords) to: '),print([X,Y,Angle]),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    X_f is round(X*1.1)/1.1,
    Y_f is round(Y*1.1)/1.1,
    Angle_f is round(Angle*1.1)/1.1,
    print('Nav. Moving (Coords) to: '),print([X_f,Y_f,Angle_f]),nl,
    ioca_to_rosswipl(navigate(navpoint(X_f,Y_f,Angle_f)), Request),
    rosswipl_call_service('/navigate_service', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 1 Coordinate (nonblock)

systems_service_call(Action_Type,navigate_nonblock([X,Y,Angle],Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[Location]),
  (mode_exe(test) ->
    print('Nav. Starting to move to (nonblock): '),print(Location),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    X_f is round(X*1.1)/1.1,
    Y_f is round(Y*1.1)/1.1,
    Angle_f is round(Angle*1.1)/1.1,
    print('Nav. Starting to move to (nonblock): '),print(Location),nl,
    ioca_to_rosswipl(navigate_nonblock(navpoint(X_f,Y_f,Angle_f)), Request),
    rosswipl_call_service('/navigate_service', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).


%%Case 2 Label

systems_service_call(Action_Type,navigate(Location,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[Location]),
  (mode_exe(test) ->
    print('Nav. Moving (Label) to: '),print(Location),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Nav. Moving (Label) to: '),print(Location),nl,
    ioca_to_rosswipl(navigate(Location),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 2 Label (nonblock)

systems_service_call(Action_Type,navigate_nonblock(Location,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[Location]),
  (mode_exe(test) ->
    print('Nav. Starting to move to (nonblock): '),print(Location),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Nav. Starting to move to (nonblock): '),print(Location),nl,
    ioca_to_rosswipl(navigate_nonblock(Location),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 3 Advance

systems_service_call(Action_Type,advance(Distance,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'DISTANCE',[Distance]),
  (mode_exe(test) ->
    print('Advancing: '),print(Distance),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Advancing: '),print(Distance),nl,
    ioca_to_rosswipl(advance(Distance),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

systems_service_call(Action_Type,advance_nonblock(Distance,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'DISTANCE',[Distance]),
  (mode_exe(test) ->
    print('Advancing nonblock: '),print(Distance),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Advancing nonblock: '),print(Distance),nl,
    ioca_to_rosswipl(advance_nonblock(Distance),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 4 Turn

systems_service_call(Action_Type,turn(Angle,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'ANGLE',[Angle]),
  (mode_exe(test) ->
    print('Nav. Turning: '),print(Angle),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Nav. Turning: '),print(Angle),nl,
    ioca_to_rosswipl(turn(Angle),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 5 Advance precise

systems_service_call(Action_Type,advance_fine(Distance,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'DISTANCE',[Distance]),
  (mode_exe(test) ->
    print('Advancing (fine): '),print(Distance),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Advancing (fine): '),print(Distance),nl,
    ioca_to_rosswipl(advance_fine(Distance),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 6 Turn precise

systems_service_call(Action_Type,turn_fine(Angle,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'ANGLE',[Angle]),
  (mode_exe(test) ->
    print('Nav. Turning (fine): '),print(Angle),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Nav. Turning (fine): '),print(Angle),nl,
    ioca_to_rosswipl(turn_fine(Angle),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 7 Face towards Label

systems_service_call(Action_Type,face_towards(Location,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[Location]),
  (mode_exe(test) ->
    print('Nav. Facing towards: '),print(Location),nl,
    print('Nav. Result: '),print(Result),nl
  | otherwise ->
    print('Nav. Facing towards: '),print(Location),nl,
    ioca_to_rosswipl(face_towards(Location),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 8 Set Linear Velocity

systems_service_call(Action_Type,set_lin_speed(Vel),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'VELOCITY',[Vel]),
  (mode_exe(test) ->
    print('Nav. Setting Linear Velocity: '),print(Vel),nl,
    print('Nav. Result: success'),nl
  | otherwise ->
    print('Nav. Setting Linear Velocity: '),print(Vel),nl,
    ioca_to_rosswipl(set_lin_vel(Vel),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 9 Set Angular Velocity

systems_service_call(Action_Type,set_ang_speed(Vel),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'VELOCITY',[Vel]),
  (mode_exe(test) ->
    print('Nav. Setting Angular Velocity: '),print(Vel),nl,
    print('Nav. Result: success'),nl
  | otherwise ->
    print('Nav. Setting Angular Velocity: '),print(Vel),nl,
    ioca_to_rosswipl(set_ang_vel(Vel),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).

%%Case 10 Abort Navigation

systems_service_call(Action_Type,navigate_abort,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'VELOCITY',[Vel]),
  (mode_exe(test) ->
    print('Nav. Abort. '),nl,
    print('Nav. Result: success'),nl
  | otherwise ->
    print('Nav. Abort. '),nl,
    ioca_to_rosswipl(navigate_abort('abort'),Request),
    rosswipl_call_service('/navigate_service',Request,JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Nav. Result: '),print(Result),nl
  ).


%%MEMORIZE WITH ROS

systems_service_call(Action_Type,memorize_face(coord3(X,Y,Z),Name,Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[ma]),
  save_info(feat,'LOCATION',[Location]),
  (mode_exe(test) ->
    print('Memorizing face '),nl
  | otherwise ->
    print('Memorizing face '),nl,
    ioca_to_rosswipl(memorize_face(X,Y,Z,Name), Request),
    rosswipl_call_service('/memorize_face', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Memorize Result: '),print(Result),nl
  ).


%%MOOD WITH ROS

systems_service_call(Action_Type,mood(M),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[mood]),
  (mode_exe(test) ->
    print('Changing mood to '),print(M),nl
  | otherwise ->
    print('Changing mood to '),print(M),nl,
    ioca_to_rosswipl(text(M), Request),
    rosswipl_call_service('/mood', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Mood Result: '),print(Result),nl
  ).


%%ASSIGN NAME TO SPEAKER WITH ROS

systems_service_call(Action_Type,assignname(N),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[offer]),
  (mode_exe(test) ->
    print('Assigning name '),print(N),nl
  | otherwise ->
    print('Assigning name '),print(N),nl,
    ioca_to_rosswipl(text(N), Request),
    rosswipl_call_service('/assignname', Request, JsonRes),
    rosswipl_to_ioca(JsonRes,[status(Result)]),
    print('Assigning name Result: '),print(Result),nl
  )
.

systems_service_call(Action_Type,reset_speakerid,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[reset_soundloc]),
  (mode_exe(test) ->
    print('Resetting speakerid.'),nl
  | otherwise ->
    print('Resetting speakerid.'),nl,
    rosswipl_call_service('/reset_speakerid', '', _)
  ).

%%% END OF ROSS Out communications %%%


%Act for saying a message
systems_service_call(Action_Type,say_fix([A|Rest]),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'INITIME',[]),
  fix_format([A|Rest],Fix_format),
  msg_format(Fix_format,MSG),
  save_info(feat,'MESSAGE',[MSG]),
  (mode_exe(test) ->
    print('Golem says: '),print(MSG),nl
  | otherwise ->
    print('Golem says: '),print(MSG),nl
    %% oaa_Solve(di(MSG,_X),[blocking(true)])
  ),
  save_info(feat,'FINTIME',[]).


%Act for saying a message
systems_service_call(Action_Type,screen([A|Rest]),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  msg_format([A|Rest],MSG),
  save_info(feat,'MESSAGE',[MSG]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'SCREEN',[MSG]),
  print('Golem prints on screen: '),print(MSG),nl,
  save_info(feat,'FINTIME',[]).

systems_service_call(Action_Type,screen(MSG),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'MESSAGE',[MSG]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'SCREEN',[MSG]),
   print('Golem prints on screen: '),print(MSG),nl.

%Act for saying a message from template
systems_service_call(Action_Type,caption(ID),Args_Action) :-
  print('Caption'),nl,
  print('ID: '),print(ID),nl,
  caption(ID,MSG_),
  print('MSG_: '),print(MSG_),nl,
  msg_format(MSG_,MSG),
  print('MSG: '),print(MSG),nl,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'MESSAGE',[MSG]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'MSG',[MSG]),
  (mode_exe(test) ->
    print('Golem says: '),print(MSG),nl
  | otherwise ->
    print('Golem says: '),print(MSG),nl
    %% oaa_Solve(di(MSG,_X),[blocking(true)])
  ).

%Act for saying a message from template
systems_service_call(Type,txt_act_1(ID),Args_Action) :-
  print('In txt_act_1 action'),nl,
  % Obtains text from template
  gen_text(txt_act_1(ID), MSG),
  print('Out_Text: '),print(MSG),nl,

  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'MESSAGE',[MSG]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'MSG',[MSG]),
  (mode_exe(test) ->
    print('Golem says: '),print(MSG),nl
  | otherwise ->
    print('Golem says: '),print(MSG),nl
    %% oaa_Solve(di(MSG,_X),[blocking(true)])
  ).

%Act for saying a message from template
systems_service_call(parse,parse(In_Arg,Out_Arg,Pos_Arg),yes) :-
  Action =.. [parse,In_Arg, Out_Arg,Pos_Arg],
  print('Action: '),print(Action),nl,
  print('Int Arguments: '), print(In_Arg), nl,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'PARSER',[Action_ID]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'MSG',[In_Arg]),
  (mode_exe(test) ->
    read(Out_Arg),
    read(Pos_Arg)
  | otherwise ->
	print('ROSSWIPL call')
    %% oaa_Solve(gfInterpret(In_Arg,Out_Arg,Pos_Arg),[blocking(true)])
  ),
  print('Out Arguments: '),print(Out_Arg),nl,
  print('Out Action: '), print(Action), nl,
  save_info(feat,'PARSERED',[Out_Arg]),!
.

%Act for saying a message from template
systems_service_call(gfInterpret,gfInterpret(In_Arg,Out_Arg),yes) :-
  Action =.. [gfInterpret,In_Arg, Out_Arg],
  print('Action: '),print(Action),nl,
  print('Int Arguments: '), print(In_Arg), nl,
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'PARSER',[Action_ID]),
  save_info(feat,'INITIME',[]),
  save_info(feat,'MSG',[In_Arg]),
  print('gfInter: '),nl,
  (mode_exe(test) ->
    read(Out_Arg)
  | otherwise ->
	ioca_to_rosswipl(text(In_Arg),JsonReq),
	rosswipl_call_service('/gfSimpleInterpret', JsonReq, JsonRes),
	print('JsonRes:: '), print(JsonRes), nl,
	rosswipl_to_ioca(JsonRes,[text(IOCARes)]),
	atom_to_term(IOCARes, Out_Arg, [])
  ),
  print('Out Arguments: '),print(Out_Arg),nl,
  print('Out Action: '), print(Action), nl,
  save_info(feat,'PARSE',Out_Arg)
.
%%%%%%% Version to work in parallel in GPSR
%systems_service_call(parse, parse(Input_String, Semantics), yes) :-
%  save_info(third_level,'BASIC_ACT',[]),
%  save_info(feat,'TYPE',[parse]),
%  save_info(feat,'PARSER',[parse(Input_String, Semantics)]),
%  save_info(feat,'INITIME',[]),
%  save_info(feat,'MSG',[Input_String]),
%  (mode_exe(test) ->
%		var(Semantics),
%		print('System Call: '), print(parse(Input_String, Semantics)), nl,
%		print('Input semantic representation: '),
%		read(Semantics), nl
%  | otherwise ->
%		var(Semantics),
%		print('System Call: '), print(parse(Input_String, Semantics)), nl,
%		print('Input semantic representation: '),
%		read(Semantics), nl
%  ),
%  print('Out Arguments: '),print(Semantics),nl,
%  print('Out Action: '), print(parse(Input_String, Semantics)), nl,
%  save_info(feat,'PARSERED',[Semantics])
%.

systems_service_call(parse, _, _) :-
		print('Fatal Error in Semantics: Must be a variable'), end_diag_manager.

%Rethorical acts for different functions
%Act for waiting one second, recomended to be used in navigation cases
systems_service_call(Action_Type,sleep,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[sleep]),
  (mode_exe(test) ->
    print('Wait a second... '),nl
  | otherwise ->
    print('Wait a second... '),nl,
    sleep(1)
).

%Rethorical acts for different functions
%Act for waiting one second, recomended to be used in navigation cases
systems_service_call(Action_Type,sleep(X),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[sleep]),
  save_info(feat,'SECONDS',[X]),
  (mode_exe(test) ->
    print('Wait '),print(X),print(' seconds... '),nl
  | otherwise ->
    print('Wait '),print(X),print(' seconds... '),nl,
    sleep(X)
).

%Act for closing all the scripts, applications and terminal, usually used in a closed button
systems_service_call(Action_Type,closed,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[cierra]),
  exec('sh cierra',[null,std,std],PID),!.

%Act for retrieving next point to visit
systems_service_call(Action_Type,caption_random(retrieve_next_point),Args_Action) :-
  random(1,5,N), systems_service_call(caption(retrieve_next_point(N))).

%Act for pushing dialogue models
systems_service_call(Action_Type,pushDM(DMs),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[pushDM]),
  save_info(feat,'DIALOGUE MODEL',[DMs]),
  (mode_exe(test) ->
    print('Pushing dialogue modesl: '),print(DMs),nl
  | otherwise ->
    print('Pushing dialogue modesl: '),print(DMs),nl,
    oaa_Solve(pushDM(DMs,Res),[])
  ).

%Act for ensambling
systems_service_call(Action_Type,paste(Dest,Res),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[paste]),
  save_info(feat,'DESTINATION',[Dest]),
  reverse(Dest,Dest_),
  paste(Dest_,Res),
  (mode_exe(test) ->
    print('Assembly: '),print(Res),nl
  | otherwise ->
    print('Assembly: '),print(Res),nl
  ),
  save_info(feat,'RESULT',[Res])
.

%Act for execute
systems_service_call(Action_Type,execute(Cmd),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[execute]),
  save_info(feat,'COMMAND',[Cmd]),
  (mode_exe(test) ->
    print('Executing: '),print(Cmd),nl
  | otherwise ->
    print('Executing: '),print(Cmd),nl,
    oaa_Solve(execute(Cmd),[])
  ).

%Act for seeing and walking
systems_service_call(Action_Type,move_and_look(D),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[move_and_look]),
  save_info(feat,'DESTINATION',[D]),
  (mode_exe(test) ->
    print('seeing and walking to '),print(D),nl
  | otherwise ->
    print('seeing and walking to '),print(D),nl,
    oaa_Solve(move_and_look(D),[])
  ).

%Act for starting the saving for log files
systems_service_call(Action_Type,empty,Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[empty]),
  print('In empty action'),nl,
  (mode_exe(test) ->
    print('No action '),nl
  | otherwise ->
    print('No action '),nl
).

%%%%%%%%%%%%%%%% Systems calls %%%%%%%%%%%%%%%%%%%%%
% Format: systems_service_call(Modality, System_Call, Break)

systems_service_call(speech, Action, _) :-
		print('In system service call: speech'), nl,
		gen_text(Action, Out_Text),
		print('System Call: '), print(synthesise(Out_Text)), nl.

systems_service_call(motor, move(Dest), _) :-
		atom(Dest),
		print('In system service call: motor'), nl,
		print('System Call: '), print(move(Dest)), nl.

systems_service_call(motor, move(Dest), Break) :-
		print('Fatal Error in move robot: Destination must be an atom'), termina_diag_manager.

systems_service_call(motor, move_break(Dest, Status), yes) :-
		atom(Dest),
		print('In system service call: motor'), nl,
		print('System Call: '), print(move_break(Dest, Status)), nl,
		print('Status: '), read(Status), nl.

systems_service_call(motor, move_break(Dest, Status), yes) :-
		print('Fatal Error in move robot (break mode): Destination must be an atom'), termina_diag_manager.

systems_service_call(neck, neck(Orientation), yes) :-
		atom(Orientation),
		print('In system service call: neck'), nl,
		print('System Call: '), print(neck(Orientation)), nl.

systems_service_call(neck, neck(Orientation), yes) :-
		print('Fatal Error in rotate neck: Orientation must be an atom'), termina_diag_manager.

systems_service_call(neck, tilt(Direction), yes) :-
		atom(Direction),
		print('In system service call: tilt'), nl,
		print('System Call: '), print(tilt(Direction)), nl.

systems_service_call(neck, tilt(Orientation), yes) :-
		print('Fatal Error in tilt: Direction must be an atom'), termina_diag_manager.

% Detect face
systems_service_call(vision, detect_face(Status), yes) :-
		print('In system service call: Detect Face'), nl,
		print('System Call: '), print(detect_face(Status)), nl,
		print('Status: '), read(Status), nl.

% Recognize face
systems_service_call(vision, see_face(Face_ID, Mode, Status), yes) :-
		print('In system service call: see face'), nl,
		atom(Face_ID),
		print('System Call: '), print(see_face(Face_ID, Mode, Status)), nl,
		print('Status: '), read(Status), nl.

% See a face
systems_service_call(vision, see_face(Face_ID, Mode, Status), yes) :-
		print('In system service call: see face'), nl,
		var(Face_ID),
		print('System Call: '), print(see_face(Face_ID, Mode, Status)), nl,
		print('Input Face_ID: '), read(Face_ID), nl,
		print('Status: '), read(Status), nl.

% Analize visual scene
systems_service_call(vision, see_object(Scene), yes) :-
		var(Scene),
		print('In system service call: see object'), nl,
		print('System Call: '), print(see_object(Scene)), nl,
		print('Input Parameters: '), read(Scene), nl.

systems_service_call(vision, see_object(Scene), yes) :-
		print('Fatal Error in Scene: Must be a variable'), termina_diag_manager.

systems_service_call(parse, parse(Input_String, Semantics), yes) :-
		print('In system service call: parser'), nl,
		var(Semantics),
		print('System Call: '), print(parse(Input_String, Semantics)), nl,
		print('Input semantic representation: '),
		read(Semantics), nl.

systems_service_call(parse, _, _) :-
		print('Fatal Error in Semantics: Must be a variable'), termina_diag_manager.

systems_service_call(hand, grasp(Object_ID, Hand, Pars, Status), yes) :-
		print('In system service call: grasp object'), nl,
		atom(Object_ID),
		member(Hand, [right, left]),
		print('System Call: '), print(grasp_object(Object_ID, Hand, Pars, Status)), nl,
		print('Status: '), read(Status), nl.

systems_service_call(hand, _, _) :-
		print('Fatal Error in grasp: Object must be defined'), termina_diag_manager.

%%%%% Communications for behaviors 2014
% Act for memorizing a face
%systems_service_call(Action_Type,memorize_face(Name,Result),Args_Action) :-
%  save_info(third_level,'BASIC_ACT',[]),
%  save_info(feat,'TYPE',[Action_Type]),
%  save_info(feat,'NAME',[memorize_face]),
%  print('Memorizing face of: '),print(Name),nl,
%  (mode_exe(test) ->
%    print('Result[memorized|not_memorized|error(ErrorCode)]: '),
%    read(Result)
%  | otherwise ->
%    %oaa_Solve(memorize_face(Name,memorized,error,Result),[])
%    oaa_Solve(memorize_face(Name,Result),[])
%  ),
%   print('Memorization result: '),print(Result),nl,
%   save_info(feat,'STATUS',[Result]).

systems_service_call(Action_Type,take_shot(Result),Args_Action) :-
  save_info(third_level,'BASIC_ACT',[]),
  save_info(feat,'TYPE',[Action_Type]),
  save_info(feat,'NAME',[take_shot]),
  (mode_exe(test) ->
   print('Result[taken|not_taken|error(ErrorCode)]: '),
   read(Result)
  | otherwise ->
    oaa_Solve(take_shot(taken,error,Result),[])
  ),
  print('Shot taking result: '),print(Result),nl,
  save_info(feat,'Status',[Result]).


systems_service_call(Action_Type, add_action(A, B, Result), Args_Action) :-
    save_info(third_level,'BASIC_ACT',[]),
    save_info(feat,'TYPE',[Action_Type]),
    save_info(feat,'NAME',[add_action]),
    print('Adding two floats '),

    rosswipl_call_service('add_two_ints', (Name,Result),[]),
    print('Addition = '), print(Result), nl,
    save_info(feat,'STATUS',[Result]).
