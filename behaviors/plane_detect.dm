% SitLog (Situation and Logic) 
% Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)

% Dialogue model for detecting plane location
% plane_detect(Turns,Plane,Location)
%
% The Input Arguments of plane detect are:
%   Turns: List of neck orientations to search if object was lost
%   Reference: Object to grasp or empty list      
% The Output Arguments of plane detect are:
%   Plane: Height value
%   ArmLocation: List with location for arm values
%   Location: List with location values

diag_mod(plane_detect(Turns,Reference,Plane,ArmLocation,Location),[
    [
      id   ==> is,	
      type ==> neutral,
      prog ==> [
        set(turn,Turns)
      ],
      arcs ==> [     
        empty : [
          execute('scripts/tablevisual.sh'),
          tiltv(-50),
          platform2arm(0.30,1),
          get(turn,Turn)
        ] => turn(Turn)
      ]
    ],[
      id   ==> turn([]),
      type ==> neutral,
      arcs ==> [
        empty : [
          tilth(0),turn(0),
          execute('scripts/killvisual.sh')
        ] => error(not_found,[])
      ]
    ],[
      id   ==> turn([Turn|Rest]),
      type ==> neutral,
      prog ==> [
        set(turn,Rest)
      ],
      arcs ==> [
        empty : [
          tilth(Turn),
          set(a_turn,Turn),
          ( Turn == 0 ->
            RNSit = plane2
          | otherwise -> 
            RNSit = plane
          ),
          sleep,sleep,
          analyze_scene_plane(-50),
          sleep
        ] => RNSit
      ]
    ],[
      id   ==> plane,	
      type ==> plane_analyzing,
      arcs ==> [
        table(P) : [ 
          apply(get_platform_nearest(Reference,TiltObj, Planes, TiltPlanes, Plane),[Reference,-30,P,-50,Plane]),
          P=[H|T],H=[X,Ya,Z],
          get(a_turn,TurnR),
          turn(TurnR),
          tilth(0),
          set(planes,T)
        ] => success(plane_found),%n1(X,Ya,Z),
        nothing : [
          get(turn,HP)
        ] => turn(HP),
        analyzing : [
          get(count,Count),
          ( Count == 15 ->
            NSit = error(analyzing,[]),
            Rcount = 0
          | otherwise ->
            NSit = plane,
            Rcount is Count + 1
          ), 
          set(count,Rcount)
        ] => NSit,
        error : [
          execute('scripts/tablevisual.sh'),
          get(count,Count),
          analyze_scene_plane(-50),
          ( Count == 2 ->
            NSit = error(not_execute,[]),
            Rcount = 0
          | otherwise ->
            NSit = plane,
            Rcount is Count + 1
          ), 
          set(count,Rcount)
        ] => NSit
      ]
    ],[
      id   ==> plane2,	
      type ==> plane_analyzing,
      arcs ==> [
        table(P) : [ 
          apply(get_platform_nearest(Reference,TiltObj, Planes, TiltPlanes, Plane),[Reference,-30,P,-50,Plane]),
          P=[H|T],H=[X,Ya,Z],
          set(planes,T)
        ] => success(plane_found),%n1(X,Ya,Z),
        nothing : [
          get(turn,HP)
        ] => turn(HP),
        analyzing : [
          get(count,Count),
          ( Count == 15 ->
            NSit = error(analyzing,[]),
            Rcount = 0
          | otherwise ->
            NSit = plane2,
            Rcount is Count + 1
          ), 
          set(count,Rcount)
        ] => NSit,
        error : [
          execute('scripts/tablevisual.sh'),
          get(count,Count),
          ( Count == 2 ->
            NSit = error(not_execute,[]),
            Rcount = 0
          | otherwise ->
            NSit = plane2,
            Rcount is Count + 1
          ), 
          set(count,Rcount)
        ] => NSit
      ]
    ],[
      id   ==> n1(X,Y,Z),	
      type ==> translating_arm, 
      arcs ==> [
        cam_to_arm(plane,X,Y,Z,-50,-0.02,-0.03,0.09,0.075,-0.065,R) : [
          R =[Platf,Angle,Distance], 
          get(planes,Planes), 
%          ( Planes == [] ->
%            Xa = 0.037097,
%            Ya = 0.008202,
%            Za = 0.7178,
%            T  = [0.037097,0.008202,0.7178]
%          | otherwise ->
            %Planes=[H|T],H=[Xa,Ya,Za],
%          ),
%          ( 0.24 > Platf ->
%            NSit = n1(Xa,Ya,Za),
%            RPlatf = 0
%          | otherwise ->
           NSit = n2(X,Y,Z),
            RPlatf = Platf,  
%          ), 
          set(platform,RPlatf),
          set(arm,[Angle,Distance])
          %set(planes,T)

        ] => NSit
      ]
    ],[
      id   ==> n2(X,Y,Z),	
      type ==> translating_nav,
      arcs ==> [
        cam_to_nav(X,Y,Z,-50,-0.02,-0.03,R) : [
          set(location,R),
          execute('scripts/killvisual.sh')
        ] => success(plane_found)
      ]
    ],[
      id   ==> success(Type),
      type ==> final,
      diag_mod ==> plane_detect(Turns,Reference,get(platform,Platform),get(arm,ArmLocation),get(location,Location)) 
    ],[
      id   ==> error(Type,Info),
      type ==> final,
      diag_mod ==> plane_detect(Turns,Reference,get(platform,Platform),get(arm,ArmLocation),get(location,Location)) 
    ]
  ],
  % Second argument: list of local variables
  [
    platform ==> 0,
    count ==> 0,
    location ==> [0,0],
    turn ==> _,
    a_turn ==> _,
    arm ==> [0,0],
    planes ==> []
  ]
).
