%%%%%%%%%%%%%%%%%% GPSR Action Reasoner %%%%%%%%%%%%%%%%%%%%%%%%

actions_reasoner(Speech_Acts):-
	flatten(Speech_Acts,Speech_Acts_Flattened),
	convert_to_commands(Speech_Acts_Flattened,Logic_Form),
	assign_func_value(Logic_Form).

convert_to_commands([],[]).

convert_to_commands([H|T],Final):-
	construct_commands(H,NewH),
	convert_to_commands(T,NewT),
	append(NewH,NewT,Final).



%%%%%%%%% GPSR 2017 %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Answer
construct_commands(answer,[
	answer_question
	]).




%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Move(location)
construct_commands(move(location(Loc)),[
	say(['I will move to the', Loc],_),
	consult_kb(value_object_property, [Loc,position], Position, _),
	move(Position,_),
	consult_kb(change_object_property, [golem,in,Position], _, _),
	say('Ready',_)
	]).


%Move(room)
construct_commands(move(room(Room)),[
	say(['I will move to the', Room],_),
	consult_kb(value_object_property, [Room,main_point], Position, _),
	move(Position,_),
	consult_kb(change_object_property, [golem,in,Position], _, _),
	say('Ready',_)
	]).






%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find(object)
%Find a concrete object (the object is in front of the robot)
construct_commands(find(object(X)),[
	consult_kb(value_object_property, [golem,in], waiting_position, _),
	consult_kb(value_object_relation, [X,in_room], Room, _),
	say(['I will search for the', X,'in the', Room], _),
	consult_kb(value_object_property, [Room,object_path], Positions, _),	
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObj|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found,X], _, _), 
	consult_kb(value_object_property, [golem,found], Obj_Name, _), 
	say(['Here is the ', Obj_Name],_)
	]).



construct_commands(find(object(X)),[
	consult_kb(value_object_property, [golem,in], Pos, _),    
    consult_kb(object_with_prop_value, [position,Pos], Name_Pos, _),
	consult_kb(value_object_relation, [Name_Pos,in_room], Room, _),
	consult_kb(value_object_property, [Room,object_path], Positions, _),
	say(['I will search for the', X], _),	
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObj|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found,X], _, _), 
	consult_kb(value_object_property, [golem,found], Obj_Name, _), 
	say(['Here is the ', Obj_Name],_)
	]).


%Find(object,room)
construct_commands(find(object(X),room(Y)),[
	say(['I will search the', X, 'in the', Y],_),
	consult_kb(value_object_property, [Y,object_path], Positions, _),
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false,false,false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ', Obj_Name],_)
	]).
	

%% Added by Ivette and Noe in 17/02/2017
%Find(object,location)
construct_commands(find(object(X),location(Y)),[
	say(['I will search the', X, 'in the', Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(object, [X], [Point], [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ',Obj_Name],_) 
	]).


%Find(object_category,room)
construct_commands(find(object_category(Category),room(Room)),[
	say(['I will search the', Category, 'in the', Room],_),
	consult_kb(value_object_property, [Room,object_path], Positions, _),
	find(object, Category, Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], category, Found_objs, _, false, false, false, _),
	list_lib(Found_objs,object(Id,_,_,_,_,_,_,_,_),0),
	consult_kb(change_object_property, [golem,found, Id], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ', Category, ' it is a ', Obj_Name],_)
	]).

	
%Find(object_category,location)
construct_commands(find(object_category(Category),location(Loc)),[
	say(['I will search the', Category, 'in the', Loc],_),
	consult_kb(value_object_property, [Loc,position], Point, _),
	find(object, Category, [Point], [0.0, -35.0, 35.0], [-30.0, -5.0], category, Found_objs, _, false, false, false, _),
	list_lib(Found_objs,object(Id,_,_,_,_,_,_,_,_),0),
	consult_kb(change_object_property, [golem,found, Id], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ', Category, ' it is a ', Obj_Name],_)
	]).
	
		
%Find(person,room)
construct_commands(find(person,room(Room)),[
	say(['I will search for a person in the ',Room],_),
	consult_kb(value_object_property, [Room,human_path], Positions, _),
	find(person, X, Positions, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	say(['I see', 'a person'],_)
	]).
	
%Find(person,location)
construct_commands(find(person,location(Loc),[
	say(['I will search for a person in the ',Loc],_),
	consult_kb(value_object_property, [Loc,position], Point, _),
	find(person, X, [Point], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	say(['I see', 'a person'],_)
	]).
	

%Find(person,_) room is not specified
construct_commands(find(person),[
	say(['I will search for a person'],_),
	consult_kb(value_object_property, [golem,in], Pos, _),
        consult_kb(object_with_prop_value, [position,Pos], Name_Pos, _),
	consult_kb(value_object_relation, [Name_Pos,in_room], Room, _),
	consult_kb(value_object_property, [Room,human_path], Positions, _),
	find(person, X, Positions, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	say(['I see', 'a person'],_)
	]).
	

% Ivette y Caleb, agregan estos predicados para buscar específicamente una persona, 
% falta que completar que de verdad busque a la persona específica
%Find(person, human, room)
construct_commands(find(person,human(Y),room(X)),[
	say(['I will search for ',Y, ' in the ', X],_),
	consult_kb(value_object_property, [X,human_path], Positions, _),
	find(person, Name, Positions, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	say(['I see', Y],_)
	]).

%Find(person, human, location)
construct_commands(find(person,human(Y),location(Loc)),[
	say(['I will search for ',Y, ' in the ', Loc],_),
	consult_kb(value_object_property, [Loc,position], Point, _),
	find(person, Name, [Point], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	say(['I see', Y],_)
	]).
	

%Find(person,_) room is not specified
construct_commands(find(person,human(Y),_),[
	say(['I will search for ', Y],_),
	find(person, Name, [turn=>(0.0), turn=>(20.0),turn=>(-40.0)], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	say(['I see', Y],_)
	]).
	
	

	
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Take(object,room)
construct_commands(take(object(X),room(Y)),[
	say(['I will search for the', X,'in the', Y], _),
	consult_kb(value_object_property, [Y,object_path], Positions, _),
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the',Obj_Name,'so I will take it'],_), 
	take(FoundObject, right, _, _),
	consult_kb(change_object_property, [golem,has,Obj_Name], _, _)
	]).
	
%Take(object,location)
construct_commands(take(object(X),location(Y)),[
	say(['I will search for the', X,'in the', Y], _),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(object, [X], [Point], [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the',Obj_Name,'so I will take it'],_), 
	take(FoundObject, right, _, _),
	consult_kb(change_object_property, [golem,has,Obj_Name], _, _)
	]).
	
%Take(object_category,room)
construct_commands(take(object(Cat),room(Room)),[
	say(['I will search for the', Cat,'in the', Room], _),
	consult_kb(value_object_property, [Room,object_path], Positions, _),
	find(object, Cat, Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], category, [object(Id, X, Y, Z, O1, O2, O3, O4, C)|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, Id], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the',Obj_Name,'so I will take it'],_), 
	take(object(Id, X, Y, Z, O1, O2, O3, O4, C), right, _, _),
	consult_kb(change_object_property, [golem,has,Obj_Name], _, _)
	]).
	
%Take(object_category,location)
construct_commands(take(object_category(Cat),location(Loc)),[
	say(['I will search for the', Cat,'in the', Loc], _),
	consult_kb(value_object_property, [Loc,position], Point, _),
	find(object, Cat, [Point], [0.0, -35.0, 35.0], [-30.0, -5.0], category, [object(Id, X, Y, Z, O1, O2, O3, O4, C)|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, Id], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the',Obj_Name,'so I will take it'],_), 
	take(object(Id, X, Y, Z, O1, O2, O3, O4, C), right, _, _),
	consult_kb(change_object_property, [golem,has,Obj_Name], _, _)
	]).
	
%Take(object,unkown)
construct_commands(take(object(X),unknown),[
        consult_kb(value_object_relation, [X,in_room], Room, _),
	say(['I will search for the', X,'in the', Room], _),
	consult_kb(value_object_property, [Room,object_path], Positions, _),
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the',Obj_Name,'so i will take it'],_), 
	take(FoundObject, right, _, _),
	consult_kb(change_object_property, [golem,has,Obj_Name], _, _)
	]).

% Added by Noe 13/01/2017
%Take(object)
%Take a concrete object (the object is in front of the robot)
construct_commands(take(object(X)),[
	say(['I will search for the', X], _),
	find(object, [X], [turn=>(0.0)], [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObj|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found,X], _, _), 
	consult_kb(value_object_property, [golem,found], Obj_Name, _), 
	say(['Here is the',Obj_Name,'so i will take it'], _),
	take(FoundObj, right, _, _),
	consult_kb(change_object_property, [golem,has,Obj_Name], _, _)
	]).




%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Deliver(object,me)
construct_commands(deliver(object(X),destiny(me)),[
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will deliver the',X],_),
	deliver(X, waiting_position, _, handle, _),
	say(['I delivered the',X],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).
	

%Deliver(object,location)
construct_commands(deliver(object(X),destiny(location(Y))),[
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will carry the',X,'to the',Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	deliver(X, Point, Y, put, _),
	say(['I delivered the',X,'in the',Y],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).

%Deliver(location)
construct_commands(deliver(destiny(location(Y))),[
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will carry the',X,'to the',Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	deliver(X, Point, Y, put, _),
	say(['I delivered the',X,'in the',Y],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).
	
%Deliver(location,room)
construct_commands(deliver(destiny(location(Y),room(Z))),[
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will carry the',X,'to the',Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	deliver(X, Point, Y, put, _),
	say(['I delivered the',X,'in the',Y],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).

% Added by Ivette and Noe 12/05/17	
%Deliver(human,room)
construct_commands(deliver(destiny(human(H), room(Y))),[
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will carry the ',X,' to ',H],_),
	consult_kb(value_object_property, [Y,human_path], Human_Path, _),
	find(person, Name, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	relieve(right, _),
	say(['I delivered the ',X,' to ',H],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).
	
% Added by Ivette and Noe 19/05/17	
%Deliver(human,location)
construct_commands(deliver(destiny(human(H), location(Y))),[
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will carry the ',X,' to ',H],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(person, Name, [Point], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	relieve(right, _),
	say(['I delivered the ',X,' to ',H],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).

% Added by Noe 17/01/2017	
%Delive(me)
%Deliver the grasped object to the waiting position
construct_commands(deliver(destiny(me)),[
	consult_kb(value_object_property, [golem,has], Object, _),
	say(['I will carry the ',Object,'to you'],_),
	deliver(Object, waiting_position, _, handle, _),
	say(['I delivered the',Object,'to you'],_),
	consult_kb(change_object_property, [golem,in,waiting_position], _, _),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).

% Added by Ivette and Noe 12/05/17	
%Deliver(human)
construct_commands(deliver(destiny(human(H))),[
        move([waiting_position], _),
        ask(['Please, tell me only the name of the room where', H, 'is'], gpsr2015, true, 2, Room, _),
        consult_kb(value_object_property, [golem,has], X, _),
	say(['I will carry the ',X,' to ', H],_),
	consult_kb(value_object_property, [Room,human_path], Human_Path, _),
	find(person, Name, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	relieve(right, _),
	say(['I delivered the ',X,' to ',H],_),
	consult_kb(change_object_property, [golem,has,nothing], _, _),
	consult_kb(change_object_property, [golem,found,nothing], _, _)
	]).




%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%	
%Say
construct_commands(say('name of your team'),[
	say(['Hello, the name of my team is Golem'],_)
	]).
	
construct_commands(say('your name'),[
	say(['Hello, my name is golem three'],_)
	]).
	
construct_commands(say('something about yourself'),[
	say(['Hello, my name is Golem and I like tacos'],_)
	]).
	
	
construct_commands(say('country of your team'),[
	say(['Hello, the country of my team is Mexico'],_)
	]).	

construct_commands(say('affiliation of your team'),[
	say(['Hello, the affiliation of my team is Autonomous National University of Mexico'],_)
	]).

construct_commands(say('a joke'),[
	say(['Why do not robots ever get scared? Because they have nerve of steel'],_)
	]).

construct_commands(say('whether you dream or not on electric sheep'),[
	say(['yes I do, and I count them'],_)
	]).

construct_commands(say('the time'),[
	time(_)
	]).

construct_commands(say('what day is today'),[
	date(today, _)
	]).
	
construct_commands(say('what day is tomorrow'),[
	date(tomorrow, _)
	]).	

construct_commands(say('day of the week'),[
	date(today, _)
	]).

construct_commands(say('day of the month'),[
	date(month_day, _)
	]).
	
construct_commands(say('dark side'),[
	say(['The dark side? A bunch of wusses they are. A great Jedi I will always be, the true balance of the force they represent'],_)
	]).	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%	
%Ask(name, person, room, reply(me))
construct_commands(ask(name, person, room(Y), reply(me)),[
	say(['I will ask the name of the person in the ', Y],_),
	consult_kb(value_object_property, [Y,human_path], Human_Path, _),
	find(person, Id, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	ask('Please, tell me your name', gpsr2015, true, 2, Name, _),
	say(['Thanks', Name, 'I will now inform my master'],_),
	move(waiting_position,_),
	say(['The name of the person in the', Y, 'is', Name],_)	
	]).
	

%Ask(name, person, location, reply(me))
construct_commands(ask(name, person, location(Y), reply(me)),[
	say(['I will ask the name of the person in the ', Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(person, Id, [Point], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	ask('Please, tell me your name', gpsr2015, true, 2, Name, _),
	say(['Thanks', Name, 'I will now inform my master'],_),
	move(waiting_position,_),
	say(['The name of the person in the', Y, 'is', Name],_)	
	]).

%Ask(gender, person, room, reply(me))
construct_commands(ask(gender, person, room(Y), reply(me)),[
	say(['I will get the gender of the person in the ', Y],_),
	consult_kb(value_object_property, [Y,human_path], Human_Path, _),
	find(person, Id, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	gender(Gender,_),
	move(waiting_position,_),
	say(['The gender of the person is', Gender],_)	
	]).
	
%Ask(gender, person, location, reply(me))
construct_commands(ask(gender, person, location(Y), reply(me)),[
        say(['I will get the gender of the person in the ', Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(person, Id, [Point], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	gender(Gender,_),
	move(waiting_position,_),
        say(['The gender of the person is', Gender],_)	
	]).

%Ask(pose, person, room, reply(me))
construct_commands(ask(pose, person, room(Y), reply(me)),[
	say(['I will get the pose of the person in the ', Y],_),
	consult_kb(value_object_property, [Y,human_path], Human_Path, _),
	find(person, Id, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	pose(Pose,_),
	move(waiting_position,_),
	say(['The person is', Pose],_)	
	]).

%Ask(pose, person, location, reply(me))
construct_commands(ask(pose, person, location(Y), reply(me)),[
        say(['I will get the pose of the person in the ', Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(person, Id, [Point], [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
	pose(Pose,_),
	move(waiting_position,_),
        say(['The person is', Pose],_)	
	]).





%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Guide(room, find(person,human), room)
construct_commands(guide(room(RoomSrc), find(person, human(Name)), room(RoomDst)),[
        say(['I will go to the ', RoomSrc, ' and find ', Name],_),
        consult_kb(value_object_property, [RoomSrc,human_path], Human_Path, _),
       	find(person, Id, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
       	say(['I found ', Name],_),
       	say(['Please ', Name, ' follow me to the ', RoomDst],_),
       	consult_kb(value_object_property, [RoomDst,main_point], Position, _),
       	move(Position,_),
       	say(['We arrived', 'I am finished guiding ', Name, ' to the ', RoomDst],_)
	]).




%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Follow(room, find(person,human), room)
construct_commands(follow(room(RoomSrc), find(person, human(Name)), room(RoomDst)),[
        say(['I will go to the ', RoomSrc, ' and find ', Name],_),
        consult_kb(value_object_property, [RoomSrc,human_path], Human_Path, _),
       	find(person, Id, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
       	say(['I found ', Name],_),
       	follow(learn,gesture_only,Happened_Event,_),
	say(['I am finished following this person'],_)
	]).
	
%Follow(room, find(person), room)
construct_commands(follow(room(RoomSrc), find(person), room(RoomDst)),[
        say(['I will go to the ', RoomSrc, ' and find a person'],_),
        consult_kb(value_object_property, [RoomSrc,human_path], Human_Path, _),
       	find(person, Id, Human_Path, [0.0, -15.0, 15.0], [0.0, -15.0], detect_body_with_approach, Found_Persons, Remaining_Pos, false, false, false, _),
       	say(['I found her'],_),
       	follow(learn,gesture_only,Happened_Event,_),
       	say(['I am finished following this person'],_)
	]).
	
%Follow(until_gesture)
construct_commands(follow(until_gesture)),[
        follow(learn,gesture_only,Happened_Event,_),
       	say(['I am finished following this person'],_)
        ]).




%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Count(object(X), room(Y))
construct_commands(say(count(object(X), room(Y))),[
        say(['I will search the', X, 'in the', Y],_),
	consult_kb(value_object_property, [Y,object_path], Positions, _),
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false,false,false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ', Obj_Name],_)
        move(waiting_position,_),
	say(['There is one ', Obj_Name],_)
	]).
	
%Count(object(X), location(Y))
construct_commands(say(count(object(X), location(Y))),[
        say(['I will search the', X, 'in the', Y],_),
	consult_kb(value_object_property, [Y,position], Point, _),
	find(object, [X], [Point], [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ',Obj_Name],_), 
        move(waiting_position,_),
	say(['There is one ', Obj_Name],_)
	]).



		
%DEFAULT
construct_commands(X,[say('Sorry, I dont know that command',_)]).

