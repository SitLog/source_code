%%%%%%%%%%%%%%%%%% GPSR Action Reasoner %%%%%%%%%%%%%%%%%%%%%%%%


actions_reasoner(Speech_Acts,Logic_Form):-
	convert_to_commands(Speech_Acts,Logic_Form),
	assign_func_value(empty).

convert_to_commands([],[]).

convert_to_commands([H|T],Final):-
	construct_commands(H,NewH),
	convert_to_commands(T,NewT),
	append(NewH,NewT,Final).


%MOVE%

%Case 1: Move to the exit

construct_commands(move(exit),[
	say(['I will move to the exit'],_),
	move(exit,_),
	consult_kb(change_object_property, [golem,in,exit], _, _),
	say('Good bye',_)
	]).

%Case 2: Move to a concrete location X

construct_commands(move(X),[
	consult_kb(value_object_property, [X,name], LocationName, _),
	say(['I will move to the',LocationName],_),
	consult_kb(value_object_property, [X,position], Position, _),
	move(Position,_),
	consult_kb(change_object_property, [golem,in,X], _, _),
	say('Ready',_)
	]):-
	open_kb(KB),
	there_is_object(X,KB).

%Case 3: Move to a location of the class X

construct_commands(move(X),[
	consult_kb(value_class_property, [X,name], ClassName, _),
	say(['So you want me to move to a',ClassName,'Which',ClassName,'do you want specifically'],_),
	ask('Tell me',gpsrI,true,[],Location,_),
	consult_kb(value_object_property, [Location,name], LocationName, _),
	say(['I will move to the',LocationName],_),
	consult_kb(value_object_property, [Location,position], Position, _),
	move(Position, _),
	say(['I am in the',LocationName,'which is a',ClassName],_),
	consult_kb(change_object_property, [golem,in,Location], _, _)
	]):-
	open_kb(KB),
	there_is_class(X,KB).



%SAY%

construct_commands(say,[
	say('Hello, my name is Golem. I am a service robot.',_)
	]).



%MEMORIZE%

construct_commands(memorize,[
	say('I will memorize a person',_),
	execute('scripts/personvisual.sh',_),
	ask('Which is your name',names,true,[name(X)],name(PersonID),_),
	say('Stand in front of me four feet away and see my camera please',_),
	scan(person, PersonID, [0,10,-10], [0,10,20,30], memorize_with_approach, _, false, false, _),
	consult_kb(value_object_property, [PersonID,name], PersonName, _),
	say(['Nice to meet you',PersonName],_),
	consult_kb(change_object_property, [golem,attending_to,PersonID], _, _),
	execute('scripts/killvisual.sh',_)
	]).



%RECOGNIZE%

construct_commands(recognize,[
	consult_kb(value_object_property, [golem,attending_to], PersonID, _),
	execute('scripts/personvisual.sh',_),	
	consult_kb(value_object_property, [PersonID,name], PersonName, _),
	say(['I will find to',PersonName,'in the house'],_),
	find(person, PersonID, [turn=>(0),p1,p2,p3,p4], [0,-20,20], [0,20], recognize_with_approach, _, _, false, false, false, _),
	say(['Hello',PersonName],_),
	execute('scripts/killvisual.sh',_)
	]).



%FOLLOW%

construct_commands(follow,[
	execute('scripts/upfollow.sh',_),	
	execute('scripts/follow_nav.sh',_),
	say('I will follow the person in front of me. Wave your hands to start and also wave them when you want to finish.',_),	
	follow(learn,gesture_only,Happened_Event,Status),
	execute('scripts/killfollow.sh',_),
	execute('scripts/topo_nav.sh',_),
	say('Perfect, we finish',_)
	]).
	


%FIND%

%Case 1 Find a person

construct_commands(find(human),[
	say(['I will find a person in the house'],_),
	execute('scripts/personvisual.sh',_),
	find(person, X, [p1,p2,p3,p4], [0,-20,20], [0,30], detect_with_approach, _, _, true, false, false, _),
	say(['I found a person'],_),
	execute('scripts/killvisual.sh',_)
	]).

%Case 2 Find a concrete object X

construct_commands(find(X),[
	consult_kb(value_object_relation, [X,in], Room, _),
	consult_kb(value_object_property, [Room,object_path], SearchPath, _),
	consult_kb(value_object_property, [X,name], ObjectName, _),
	consult_kb(value_object_property, [Room,name], RoomName, _),
	say(['I will search the',ObjectName,'in the',RoomName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [X], SearchPath, [-20,0,20], [-30,-15,0], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, false, false, false, _),
	say(['Here is the',ObjectName],_),
	execute('scripts/killvisual.sh',_)
	]):-
	open_kb(KB),
	there_is_object(X,KB).

%Case 3 Find an object of the class X

construct_commands(find(X),[
	consult_kb(value_class_relation, [X,in], Room, _),
	consult_kb(value_object_property, [Room,object_path], SearchPath, _),
	consult_kb(value_class_property, [X,name], ClassName, _),
	consult_kb(value_object_property, [Room,name], RoomName, _),
	say(['So you want me to find a',ClassName,'Which',ClassName,'do you want specifically'],_),
	ask('Tell me',gpsrI,true,[],Object,_),
	consult_kb(value_object_property, [Object,name], ObjectName, _),
	say(['I will search the',ObjectName,'in the',RoomName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [Object], SearchPath, [-20,0,20], [-30,-15,0], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, false, false, false, _),
	say(['Here is the',ObjectName,'which is a',ClassName],_),
	execute('scripts/killvisual.sh',_)
	]):-
	open_kb(KB),
	there_is_class(X,KB).



%POINT%

% Move to a location of the class X and point to it

construct_commands(point(X),[
	consult_kb(value_class_property, [X,name], ClassName, _),
	say(['So you want me to point a',ClassName,'Which',ClassName,'do you want specifically'],_),
	ask('Tell me',locations,true,[locations(Anything)],Location,_),
	consult_kb(value_object_property, [Location,name], LocationName, _),
	say(['I will move to the',LocationName],_),
	consult_kb(value_object_property, [Location,position], Point, _),
	move(Point, _),
	say(['Here is the',LocationName,'which is a',ClassName],_),
	point(left, _),
	consult_kb(change_object_property, [golem,in,Location], _, _)
	]):-
	open_kb(KB),
	there_is_class(X,KB).



%TAKE%

%Grasp a concrete object (the object is in front of the robot)

construct_commands(take(X),[
	consult_kb(value_object_property, [X,name], ObjectName, _),
	say(['I will grasp the',ObjectName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [X], [turn=>(0),turn=>(10),turn=>(-10)], [0,20,-20], [0,-15,-30], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, true, false, false, _),
	take([Object,P1,P2,P3,P4,P5,P6,P7,P8], right, _, _),
	execute('scripts/killvisual.sh',_),
	consult_kb(change_object_property, [golem,has,Object], _, _)
	]):-
	open_kb(KB),
	there_is_object(X,KB).



%GET_ITEM%

%Find and take a concrete object

construct_commands(get_item(X),[
	consult_kb(value_object_relation, [X,in], Room, _),
	consult_kb(value_object_property, [Room,object_path], SearchPath, _),
	consult_kb(value_object_property, [X,name], ObjectName, _),
	consult_kb(value_object_property, [Room,name], RoomName, _),
	say(['I will search the',ObjectName,'in the',RoomName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [X], SearchPath, [-20,0,20], [-30,-15,0], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, false, false, false, _),
	say(['Here is the',ObjectName,'so i will take it'],_),
	take([Object,P1,P2,P3,P4,P5,P6,P7,P8], right, _, _),
	execute('scripts/killvisual.sh',_),
	consult_kb(change_object_property, [golem,has,Object], _, _)
	]):-
	open_kb(KB),
	there_is_object(X,KB).



%DELIVER%

%Case 1 Deliver the grasped object to the waiting position

construct_commands(deliver(me),[
	consult_kb(value_object_property, [golem,has], Object, _),
	consult_kb(value_object_property, [Object,name], ObjectName, _),
	say(['I will carry the',ObjectName,'to you'],_),
	deliver(Object, waiting_position, handle, _),
	say(['I delivered the',ObjectName,'to you'],_),
	consult_kb(change_object_property, [golem,in,waiting_position], _, _),
	consult_kb(change_object_property, [golem,has,nothing], _, _)
	]).

%Case 2 Deliver the grasped object to a concrete location X

construct_commands(deliver(X),[
	consult_kb(value_object_property, [golem,has], Object, _),
	consult_kb(value_object_property, [Object,name], ObjectName, _),
	consult_kb(value_object_property, [X,name], LocationName, _),
	say(['I will carry the',ObjectName,'to the',LocationName],_),
	consult_kb(value_object_property, [X,position], Point, _),
	deliver(Object, Point, put, Status),
	say(['I delivered the',ObjectName,'in the',LocationName],_),
	consult_kb(change_object_property, [golem,in,Location], _, _),
	consult_kb(change_object_property, [golem,has,nothing], _, _)
	]):-
	open_kb(KB),
	there_is_object(X,KB).



%CARRY%

%Case 1 Find, take and deliver a concrete object X to a concrete location Y

construct_commands(carry(X,Y),[
	consult_kb(value_object_relation, [X,in], Room, _),
	consult_kb(value_object_property, [Room,object_path], SearchPath, _),
	consult_kb(value_object_property, [X,name], ObjectName, _),
	consult_kb(value_object_property, [Room,name], RoomName, _),
	say(['I will search the',ObjectName,'in the',RoomName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [X], SearchPath, [-20,0,20], [-30,-15,0], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, false, false, false, _),
	say(['Here is the',ObjectName,'so i will take it'],_),
	take([Object,P1,P2,P3,P4,P5,P6,P7,P8], right, _, _),
	execute('scripts/killvisual.sh',_),
	consult_kb(change_object_property, [golem,has,Object], _, _),
	consult_kb(value_object_property, [Y,name], LocationName, _),
	say(['I will carry the',ObjectName,'to the',LocationName],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	deliver(Object, Point, put, Status),
	say(['I delivered the',ObjectName,'in the',LocationName],_),
	consult_kb(change_object_property, [golem,in,Location], _, _),
	consult_kb(change_object_property, [golem,has,nothing], _, _)
	]):-
	open_kb(KB),
	there_is_object(X,KB),
	there_is_object(Y,KB).

%Case 2 Find, take and deliver an object of the X class to the waiting position

construct_commands(carry(X,me),[
	consult_kb(value_class_property, [X,name], ClassName, _),
	say(['So you want me to bring a',ClassName,'Which',ClassName,'do you want specifically'],_),
	ask('Tell me',gpsrI,true,[],Object,_),
	consult_kb(value_object_property, [Object,name], ObjectName, _),
	consult_kb(value_class_relation, [X,in], Room, _),
	consult_kb(value_object_property, [Room,object_path], SearchPath, _),
	consult_kb(value_object_property, [Room,name], RoomName, _),
	say(['I will search the',ObjectName,'in the',RoomName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [Object], SearchPath, [-20,0,20], [-30,-15,0], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, false, false, false, _),
	say(['Here is the',ObjectName,'which is a',ClassName,'so i will take it'],_),
	take([Object,P1,P2,P3,P4,P5,P6,P7,P8], right, _, _),
	execute('scripts/killvisual.sh',_),
	consult_kb(change_object_property, [golem,has,Object], _, _),
	say(['I will carry the',ObjectName,'to you'],_),
	deliver(Object, waiting_position, handle, Status),
	say(['I delivered the',ObjectName,'to you'],_),
	consult_kb(change_object_property, [golem,in,waiting_position], _, _),
	consult_kb(change_object_property, [golem,has,nothing], _, _)
	]):-
	open_kb(KB),
	there_is_class(X,KB).

%Case 3 Find, take and deliver an object of the class X to a location of the class Y

construct_commands(carry(X,Y),[
	consult_kb(value_class_property, [X,name], ObjectClassName, _),
	say(['So you want me to bring a',ObjectClassName,'Which',ObjectClassName,'do you want specifically'],_),
	ask('Tell me',gpsrI,true,[],Object,_),
	consult_kb(value_object_property, [Object,name], ObjectName, _),
	consult_kb(value_class_property, [Y,name], LocationClassName, _),
	say(['And you want to bring the',ObjectName,'to a',LocationClassName,'Which',LocationClassName,'do you want specifically'],_),
	ask('Tell me',gpsrI,true,[],Location,_),
	consult_kb(value_class_relation, [X,in], Room, _),
	consult_kb(value_object_property, [Room,object_path], SearchPath, _),
	consult_kb(value_object_property, [Room,name], RoomName, _),
	say(['I will search the',ObjectName,'in the',RoomName],_),
	execute('scripts/objectvisual.sh',_),
	find(object, [Object], SearchPath, [-20,0,20], [-30,-15,0], object, [[Object,P1,P2,P3,P4,P5,P6,P7,P8]|Rest], _, false, false, false, _),
	say(['Here is the',ObjectName,'which is a',ObjectClassName,'so i will take it'],_),
	take([Object,P1,P2,P3,P4,P5,P6,P7,P8], right, _, _),
	execute('scripts/killvisual.sh',_),
	consult_kb(change_object_property, [golem,has,Object], _, _),
	consult_kb(value_object_property, [Location,name], LocationName, _),
	say(['I will carry the',ObjectName,'to the',LocationName,'which is a',LocationClassName],_),
	consult_kb(value_object_property, [Location,position], Point, _),
	deliver(Object, Point, put, Status),
	say(['I delivered the',ObjectName,'in the',LocationName],_),
	consult_kb(change_object_property, [golem,in,Location], _, _),
	consult_kb(change_object_property, [golem,has,nothing], _, _)
	]):-
	open_kb(KB),
	there_is_class(X,KB),
	there_is_class(Y,KB).



%DEFAULT

construct_commands(X,[say('Sorry, I dont know that command',_)]).
