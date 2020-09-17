%--------------------------------------------------
% Initializing the cognitive model
%--------------------------------------------------

initializing_cognitive_model:-
	write('Starting cognitive model'),nl,
	initializing_parser_general.

% Basic structure for the commands related to speech and person 
% recognition
% Cognitive command recieve a question in natural language and produces an answer in natural language
% cognitive_command(Question in natural language, answer in natural language)
% e.g., Question_NL: 'How many people are in the crowd'
%		Answer_NL: 'There are 6 persons in the crowd'
cognitive_command(Question_NL,Answer_NL):-
	write('Question in NL: '), write(Question_NL),nl,
	spr_question(Question_NL,Question_LF),
	write('Question in LF: '), write(Question_LF),nl,
	consult_LF(Question_LF, Answer_LF),
	write('Answer in LF: '), write(Answer_LF), nl,
	nl_generator(Question_LF, Answer_LF, Answer_NL),
	write('Answer in NL: '),write(Answer_NL),nl.


%--------------------------------------------------------------
% Logical Answer
%--------------------------------------------------------------

% count_property --> count the amount of persons type in the class
% count_property(List of types of persons, Object where to find the properties, Knowledge Base, Amount)
count_property([],_,_,0):-!.
count_property([H|T], Object, KB, Amount):-
	count_property(T, Object, KB, Aux),
	object_property_value(Object, H, KB, Aux_Amount),
	Amount is Aux + Aux_Amount.

% Count the amount of items of a list
% count_items_list(list, Cant Ini, Cant total):-!.
count_items_list([], Amount, Amount):-!.
count_items_list([_|T], Ini, Amount):-
	Next is Ini + 1,
	count_items_list(T, Next, Amount).

% Preguntar si los digo en conjunto o deberían ser individuales
% delete_redundant(List, Old, New)
delete_redundant([], New, New):-!.
delete_redundant([H|T], Old, New):-
	deleteElement(H, Old, Aux),
	delete_redundant(T, Aux, New).

% chose_answer_action_with_gender --> decides the answer to be given
% chose_answer_action_with_gender(Valid, Chosen, Answer)
chose_answer_action_with_gender([], [], []):-!.
chose_answer_action_with_gender([_:V|_], _, V):-!.
chose_answer_action_with_gender([], [_:V|_], V):-!.

% verify the gender of the person in front
%verify_gender_person(person, Gender, Answer_LF)
verify_gender_person(_,_,_,'human'):-!.

% verify_action_with_gender --> determine the persons in a determine action
% verify_action_with_gender(List, Action, KB, Answer_LF)
verify_action_with_gender(Actions, Gender, KB, Answer_LF):-
	property_extension('gender', KB, Gender_1),
	property_extension('pose', KB, Pose_1),
	property_extension('gesture', KB, Gesture_1),	
	class_extension('crowd_person', KB, Descendents),

	cross_property_class(Gender_1, Descendents, Gender_2),
	cross_property_class(Pose_1, Descendents, Pose_2),
	cross_property_class(Gesture_1, Descendents, Gesture_2),

	cross_property_class(Pose_2, Actions, Pose_3),
	cross_property_class(Gesture_2, Actions, Gesture_3),

	cross_property_class(Gender_2, Pose_3, Chosen_1),
	cross_property_class(Gender_2, Gesture_3, Chosen_2),

	append(Chosen_1, Chosen_2, Chosen_3),
	cross_property_class(Chosen_3, Gender, Chosen_4),

	chose_answer_action_with_gender(Chosen_4, Chosen_3, Answer_LF),
	!.

determine_gender_action(Actions, _, KB, Answer_LF):-
	property_extension('gender', KB, Gender_1),
	property_extension('pose', KB, Pose_1),
	property_extension('gesture', KB, Gesture_1),	
	class_extension('crowd_person', KB, Descendents),

	cross_property_class(Gender_1, Descendents, Gender_2),
	cross_property_class(Pose_1, Descendents, Pose_2),
	cross_property_class(Gesture_1, Descendents, Gesture_2),

	cross_property_class(Pose_2, Actions, Pose_3),
	cross_property_class(Gesture_2, Actions, Gesture_3),

	cross_property_class(Gender_2, Pose_3, Chosen_1),
	cross_property_class(Gender_2, Gesture_3, Chosen_2),

	append(Chosen_1, Chosen_2, Chosen_3),

	chose_answer_action_with_gender(Chosen_3, [],Answer_LF),
	!.

% count_prop_person_action --> count the number of persons in the class with the action
% count_prop_person_action(List, Object, Actions, KB, Answer_LF)
count_prop_person_action(_, _, Actions, KB, Answer_LF):-
	property_extension('pose', KB, Pose_1),
	property_extension('gesture', KB, Gesture_1),	
	class_extension('crowd_person', KB, Descendents),

	cross_property_class(Pose_1, Descendents, Pose_2),
	cross_property_class(Gesture_1, Descendents, Gesture_2),

	cross_property_class(Pose_2, Actions, Pose_3),
	cross_property_class(Gesture_2, Actions, Gesture_3),
	
	cross_property_class(Pose_3, Gesture_3, Shared),
	cross_property_class(Gesture_3, Pose_3, Shared_2),
	delete_redundant(Shared, Pose_3, Pose_4),
	delete_redundant(Shared, Gesture_3, Gesture_4),
	delete_redundant(Shared_2, Pose_4, Pose_5),
	delete_redundant(Shared_2, Gesture_4, Gesture_5),

	count_items_list(Shared, 0, Total_Shared),
	count_items_list(Pose_5, Total_Shared, Total_Pose),
	count_items_list(Gesture_5, Total_Pose, Answer_LF),
	!.

count_prop_person(_, _, Property, Color, KB, Answer_LF):-
	property_extension(Property, KB, Prop_1),
	class_extension('crowd_person', KB, Descendents),

	cross_property_class(Prop_1, Descendents, Prop_2),
	cross_property_class(Prop_2, Color, Prop_3),

	count_items_list(Prop_3, 0, Answer_LF),
	!.

% count_property_with_value --> count the amount of persons type in the class with the actions
% count_property_with_value(List, Object, Actions, KB, Answer_LF)
count_property_with_value(List, _, Actions, KB, Answer_LF):-
	property_extension('gender', KB, Gender_1),
	property_extension('pose', KB, Pose_1),
	property_extension('gesture', KB, Gesture_1),	
	class_extension('crowd_person', KB, Descendents),

	cross_property_class(Gender_1, Descendents, Gender_2),
	cross_property_class(Pose_1, Descendents, Pose_2),
	cross_property_class(Gesture_1, Descendents, Gesture_2),

	cross_property_class(Gender_2, List, Gender_3),
	cross_property_class(Pose_2, Actions, Pose_3),
	cross_property_class(Gesture_2, Actions, Gesture_3),
	
	cross_property_class(Pose_3, Gender_3, Pose_4),
	cross_property_class(Gesture_3, Gender_3, Gesture_4),
	
	cross_property_class(Pose_4, Gesture_4, Shared),
	cross_property_class(Gesture_4, Pose_4, Shared_2),
	delete_redundant(Shared, Pose_4, Pose_5),
	delete_redundant(Shared, Gesture_4, Gesture_5),
	delete_redundant(Shared_2, Pose_5, Pose_6),
	delete_redundant(Shared_2, Gesture_5, Gesture_6),

	count_items_list(Shared, 0, Total_Shared),
	count_items_list(Pose_6, Total_Shared, Total_Pose),
	count_items_list(Gesture_6, Total_Pose, Answer_LF),
	!.

% person_gender

% verify_element --> analizes if an elemnt belong to the descendets of a class
% verify_element(Element, Descendents, Answer)
verify_element(_,[],[]):-!.
verify_element(H:V,[H|_],[H:V]):-!.
verify_element(H:V,[V|_],[H:V]):-!.
verify_element(H:V,[H:_|_],[H:V]):-!.
verify_element(H,[_|T], Answer):-
	verify_element(H,T,Answer).

% Cross property class --> Cross the value of the properties with the elements that belong to the class
% cross_property_class(Elements, Descendents, New_Elements)
cross_property_class([],_,[]):-!.
cross_property_class([H|T], Descendents, New_Elements):-
	verify_element(H,Descendents, Aux),
	cross_property_class(T,Descendents, Aux2),
	append(Aux, Aux2, New_Elements).

% find_low_value --> find the lowest value of a list
% find_low_value(In, Current_Low, Low_Value)
find_low_value([], Low_Value, Low_Value):-!.
find_low_value([E1:V1|T], _:V2, Low_Value):-
	V1 < V2,
	find_low_value(T, E1:V1, Low_Value).
find_low_value([_|T], E2:V2, Low_Value):-
	find_low_value(T, E2:V2, Low_Value).

% sort_list --> sorts the liSt of the objects
% sort_list --> (In, Ordered, Sorted)
sort_list([], Sorted, Sorted):-!.
sort_list([H|T], Ordered, Sorted):-
	find_low_value(T, H,Low_Value),
	append(Ordered, [Low_Value], New_Ordered),
	deleteElement(Low_Value, [H|T], New_In),
	sort_list(New_In, New_Ordered, Sorted).

% Chosing the number of element need it
% chose_position(List of elements, Position number need it, Current position, Object)
chose_position([], _, _, unknown):-!.
chose_position([H:_|_], Number, Number, H):-!.
chose_position([_|T], Number, Position, Answer):-
	New_Position is Position + 1,
	chose_position(T, Number, New_Position, Answer).

% search_property_with_value --> finds the object of the class with the value Number of the property
% search_property_with_value(Class of search, with_value, Number, KB, Answer_LF)
search_property_with_value([],_,_,_,'unknown'):-!.
search_property_with_value(_,[],_,_,'unknown'):-!.
search_property_with_value(_,_,[],_,'unknown'):-!.
search_property_with_value(Class,Property,Number,KB,Answer):-
	property_extension(Property, KB, Elements),
	class_extension(Class, KB, Descendents),
	cross_property_class(Elements, Descendents, New_Elements),
	sort_list(New_Elements, [], Sorted),
	chose_position(Sorted, Number, 1, Answer).


% search_property_value --> finds the value of the objects property
% search_property_value(Object, Property, KB, Value)
search_property_value([],_, _,'unknown'):-!.
search_property_value(_,[], _, 'unknown'):-!.
search_property_value(Object,Property, KB, Value):-
	object_property_value(Object,Property,KB,Value),!.


% consult_location --> finds the location of an object
% consult_location(Object, Answer)
consult_location_object(Object, KB, Answer):-
	object_relation_value(Object,in,KB,Answer),!.

consult_location_class(Class, KB, Answer):-
	class_relation_value(Class,in,KB,Answer),!.


% determine_amount
% determine_amount(Location, Place, Amount, Answer)
determine_amount(Location, Location, Amount, Amount):-!.
determine_amount(_, _, _, 0):-!.


% clear data --> eliminates the extra data that is not need it
% clear_data(List, Out):-
clear_data([],[]):-!.
clear_data([H:_|T], Out):-
	clear_data(T, Aux),
	append([H], Aux, Out).

% consult_amount --> finds the amount of an object
% consult_amount(Object, Answer)
consult_amount(Object, Place, KB, Answer):-
	object_property_value(Object,amount,KB,Amount),
	object_relation_value(Object,in,KB,Location),
	determine_amount(Location, Place, Amount, Answer),!.

consult_amount_objects(Place, KB, Answer):-
	relation_extension(in, KB, Elements),
	cross_property_class(Elements, [[Place]], New_Elements),
	count_items_list(New_Elements, 0, Answer),!.


% verify_location_category
verify_location_category(Location, Location, Category, KB, Answer):-
	consult_amount_category(Category, KB, Answer),!.
verify_location_category(_,_,_,_,0):-!.


% consult_amount_category_place
consult_amount_category_place(Category, Place, KB, Answer):-
	class_relation_value(Category, in, KB, Location),
	verify_location_category(Location, Place, Category, KB, Answer),!.

consult_amount_category(Category, KB, Answer):-
	class_extension(Category, KB, Descendents),
	count_items_list(Descendents, 0, Answer),!.

consult_amount_object(Object, KB, Answer):-
	object_property_value(Object,amount,KB,Answer),!.	

which_objects(Place, KB, Answer):-
	relation_extension(in, KB, Elements),
	cross_property_class(Elements, [[Place]], New_Elements),
	clear_data(New_Elements, Answer),!.


% day_of_week --> says the day of the week
day_of_week(1, 'monday'):-!.
day_of_week(2, 'tuesday'):-!.
day_of_week(3, 'wednesday'):-!.
day_of_week(4, 'thursday'):-!.
day_of_week(5, 'friday'):-!.
day_of_week(6, 'saturday'):-!.
day_of_week(0, 'sunday'):-!.


% consult about the dates and hours
consult_date_hour(Date, Time, Year, Month, Day, Hour, Min, Sec, Day_Week, Tomorrow_Week):-
	get_time(X),
	% Organizando la hora a la zona horaria correcta, en méxico -5 horas, para japón +9 horas
	%Y is X + (3600*(-5)),
	Y is X + (3600*(9)),
	%stamp_date_time(X, date(Year, Month, Day, Hour, Min, Sec, Off, TZ, DST), 0),
	stamp_date_time(Y, date(Year, Month, Day, Hour, Min, Sec, _, _, _), 'UTC'),
	day_of_the_week(date(Year, Month, Day), Day_W),
	T_W is Day_W + 1,
	Tomorrow_W is T_W mod 7,
	day_of_week(Day_W, Day_Week),
	day_of_week(Tomorrow_W, Tomorrow_Week),
	Date = ['year', Year, 'month', Month, 'Day', Day],
	Time = [Hour,'hours', Min, 'minuts'].


% determine if two classes are the same
same_class(Class, Class, 'yes'):-!.
same_class(_, _, 'no'):-!.

% Compare two objects with its respect value
compare_adjective(Value1, Value2, Object1, Object2, Object1, Object2):-Value1<Value2,!.
compare_adjective(_, _, Object1, Object2, Object2, Object1):-!.

% Traduction from superlative to comparative adjective
traduction_super_comp(smallest, smaller):-!.
traduction_super_comp(biggest, bigger):-!.
traduction_super_comp(highest, higher):-!.
traduction_super_comp(tallest, taller ):-!.
traduction_super_comp(largest, larger ):-!.
traduction_super_comp(thinnest, thinner ):-!.
traduction_super_comp(oldest, older):-!.
traduction_super_comp(youngest, younger):-!.
traduction_super_comp(heaviest, heavier):-!.
traduction_super_comp(lightest, lighter):-!.
traduction_super_comp(biodegradable, 'more biodegradable'):-!.
traduction_super_comp(darkest, darker):-!.
traduction_super_comp(brightest, brighter):-!.
traduction_super_comp(strongest, stronger):-!.
traduction_super_comp(most_delicate, 'more delicate'):-!.
traduction_super_comp(edible, edible):-!.
traduction_super_comp(kosher, kosher):-!.
traduction_super_comp(tastiest, tastier):-!.
traduction_super_comp(most_acidic, 'more acidic'):-!.
traduction_super_comp(H, H):-!.


% Traduction from elements with _ to elements without
traduction_hypen(raising_arms,'raising arms'):-!.
traduction_hypen(raising_left_arm,'raising left arm'):-!.
traduction_hypen(raising_right_arm, 'raising right arm'):-!.
traduction_hypen(pointing_left, 'pointing left'):-!.
traduction_hypen(pointing_right, 'pointing right'):-!.
traduction_hypen(H,H):-!.


translate_actions([],[]):-!.
translate_actions([H|T], Out):-
	translate_actions(T, Aux),
	traduction_hypen(H, NH),
	append([NH], Aux, Out).

% consult_LF --> Consult logical form
% consult_LF(Question in Logical Form, Answer in Logical Form)
% e.g., Question_LF : [count([size],crowd)]
%		Answer_LF: 6
consult_LF([count(List, Object)|_], Answer_LF):-
	open_kb(KB),
	count_property(List, Object, KB, Answer_LF),!.

% consult_LF for count with Actions
% e.g., Question_LF : [count([size],crowd, [Actions])]
%		Answer_LF: 6
consult_LF([count([persons], Object, Actions)|_], Answer_LF):-
	open_kb(KB),
	count_prop_person_action([persons], Object, Actions, KB, Answer_LF),!.

consult_LF([count(List, Object, Actions)|_], Answer_LF):-
	open_kb(KB),
	count_property_with_value(List, Object, Actions, KB, Answer_LF),!.

consult_LF([count([persons], Object, Property, Value)|_], Answer_LF):-
	open_kb(KB),
	count_prop_person([persons], Object, Property, Value, KB, Answer_LF),!.

% luego de la llamada para le predicado de búsqueda property_extension
% este mismo va a servir para el de consultar adjetivos, puede que no funcione porque este necesitaría la cuenta


% consult_LF for answer a question with an adjective
% e.g., Question_LF: [answer(object_category(food),smallest,1)]
%		Answer_LF: kellogs
consult_LF([answer(object_category(Class), Adjective, Number)], Answer_LF):-
	open_kb(KB),
	search_property_with_value(Class, Adjective, Number, KB, Answer_LF),!.

consult_LF([answer(class(Class), Adjective, Number)], Answer_LF):-
	open_kb(KB),
	search_property_with_value(Class, Adjective, Number, KB, Answer_LF),!.

% consult_LF for answer a question about a property
% e.g., Question_LF: [answer(object(chili),color)]
%		Answer_LF: red	
consult_LF([answer(object(Object), Property)], Answer_LF):-
	open_kb(KB),
	search_property_value(Object, Property, KB, Answer_LF),!.

% consult_LF for answer a question about a property
% e.g., Question_LF: [answer(object(chili),color, blue)]
%		Answer_LF: red
% consult_LF([answer(object(Object), Property, Value)], Answer_LF)
consult_LF([answer(object(Object), Property, _)], Answer_LF):-
	open_kb(KB),
	search_property_value(Object, Property, KB, Answer_LF),!.

% consult_LF for answer a question about the gender of the person in front of golem
% e.g., Question_LF: person_gender(person, [man,woman])]
%		Answer_LF: man
consult_LF([person_gender(person,Gender)], Answer_LF):-
	open_kb(KB),
	verify_gender_person(person, Gender, KB, Answer_LF),!.

% consult_LF for answer a question about the gender o a person in a certain action
% e.g., Question_LF: person_gender([sitting], [man,woman])]
%		Answer_LF: man
consult_LF([person_gender(Actions)], Answer_LF):-
	open_kb(KB),
	determine_gender_action(Actions, [], KB, Answer_LF),!.

consult_LF([person_gender(Actions,Gender)], Answer_LF):-
	open_kb(KB),
	verify_action_with_gender(Actions, Gender, KB, Answer_LF),!.



% consult_LF for the location of an object
% e.g., Question_LF: [location(object_category(candy))]
%		Answer_LF: kitchen
consult_LF([location(object_category(Object))], Answer_LF):-
	open_kb(KB),
	consult_location_class(Object, KB, Answer_LF),!.

consult_LF([location(location(Object))], Answer_LF):-
	open_kb(KB),
	consult_location_object(Object, KB, Answer_LF),!.

consult_LF([location(object(Object))], Answer_LF):-
	open_kb(KB),
	consult_location_object(Object, KB, Answer_LF),!.


consult_LF([amount(human(Human),room(Room))], unknown):-!.

% consult_LF for the amount of objects in a location
% e.g., Question_LF: [amount(Item, Location)]
%		Answer_LF: 4
consult_LF([amount(objects,room(Room))], Answer_LF):-
	open_kb(KB),
	consult_amount_objects(Room, KB, Answer_LF),!.

consult_LF([amount(objects,location(Location))], Answer_LF):-
	open_kb(KB),
	consult_amount_objects(Location, KB, Answer_LF),!.


% consult_LF for the amount of specific objects are in a location
% e.g., Question_LF: [amount(Item, Location)]
%		Answer_LF: 4
consult_LF([amount(object(Object),room(Room))], Answer_LF):-
	open_kb(KB),
	consult_amount(Object, Room, KB, Answer_LF),!.

consult_LF([amount(object(Object),location(Location))], Answer_LF):-
	open_kb(KB),
	consult_amount(Object, Location, KB, Answer_LF),!.



consult_LF([amount(object_category(Category),room(Room))], Answer_LF):-
	open_kb(KB),
	consult_amount_category_place(Category, Room, KB, Answer_LF),!.

consult_LF([amount(object_category(Category),location(Location))], Answer_LF):-
	open_kb(KB),
	consult_amount_category_place(Category, Location, KB, Answer_LF),!.



consult_LF([amount(location(Location),room(Room))], Answer_LF):-
	open_kb(KB),
	consult_amount(Location, Room, KB, Answer_LF),!.


consult_LF([amount(Property, room(Room))], Answer_LF):-
	open_kb(KB),
	object_property_value(Room,Property,KB,Answer_LF),!.


consult_LF([amount(object_category(Category))], Answer_LF):-
	open_kb(KB),
	consult_amount_category(Category, KB, Answer_LF),!.

consult_LF([amount(object(Object))], Answer_LF):-
	open_kb(KB),
	consult_amount_object(Object, KB, Answer_LF),!.



% consult_LF for the objects in a location
% e.g., Question_LF: [which(objects, Location)]
%		Answer_LF: soap, shampoo, coffee
consult_LF([which(objects,room(Room))], Answer_LF):-
	open_kb(KB),
	which_objects(Room, KB, Answer_LF),!.

consult_LF([which(objects,location(Location))], Answer_LF):-
	open_kb(KB),
	which_objects(Location, KB, Answer_LF),!.


% consult_LF for the category of an object
% e.g., Question_LF: [which(category, object(juice))]
%		Answer_LF: drink
consult_LF([which(category,object(Object))], Answer_LF):-
	open_kb(KB),
	class_of_an_object(Object, KB, Answer_LF),!.


% consult_LF for the category of two objects and compare
% e.g., Question_LF: [same(category, [object(juice), object(boing)])]
%		Answer_LF: yes, no
consult_LF([same(category,[object(Object1), object(Object2)])], Answer_LF):-
	open_kb(KB),
	class_of_an_object(Object1, KB, Class1),
	class_of_an_object(Object2, KB, Class2),
	same_class(Class1, Class2, Answer_LF),!.


consult_LF([compare(Adjective,[object(Object1), object(Object2)])], Answer_LF):-
	open_kb(KB),
	object_property_value(Object1,Adjective,KB,Value1),
	object_property_value(Object2,Adjective,KB,Value2),
	compare_adjective(Value1, Value2, Object1, Object2, Res1, Res2),
	traduction_super_comp(Adjective, Adj_Comp),
	append(['the', Res1, 'is', Adj_Comp, 'than', 'the', Res2],[], Answer_LF),!.



% consult_LF para las preguntas fijas
% e.g., Question_LF: [say(your name)]
%		Answer_LF: golem
consult_LF([say('your name')], 'golem three'):-!.
consult_LF([say('name of your team')], 'golem group'):-!.
consult_LF([say('year robocup at home founded')], '2006'):-!.
consult_LF([say('the time')], Time):- consult_date_hour(_,Time, _, _, _, _, _, _, _, _), write(Time), !.
consult_LF([say('the date')], Date):- consult_date_hour(Date,_, _, _, _, _, _, _, _, _),!.
consult_LF([say('day of the month')], Day_Month):- consult_date_hour(_,_, _, _, Day_Month, _, _, _, _, _),!.
consult_LF([say('day of the week')], Day_Week):- consult_date_hour(_,_, _, _, _, _, _, _, Day_Week, _),!.
consult_LF([say('what day is today')], Day_Week):- consult_date_hour(_,_, _, _, _, _, _, _, Day_Week, _),!.
consult_LF([say('what day is tomorrow')], Tomorrow_Week):- consult_date_hour(_,_, _, _, _, _, _, _, _, Tomorrow_Week),!.
consult_LF([say('c language')], 'ken thompson and dennis ritchie'):-!.
consult_LF([say('c invented')], 'c was developed after b in 1972 at bell labs'):-!.
consult_LF([say('b invented')], 'b was developed circa 1969 at bell labs'):-!.
consult_LF([say('term bug')], 'from a moth trapped in a relay'):-!.
consult_LF([say('first compiler')], 'grace brewster murray hopper invented it'):-!.
consult_LF([say('robot opl')], 'there is no standard defined for opl'):-!.
consult_LF([say('robot dspl')], 'the toyota human support robot'):-!.
consult_LF([say('robot sspl')], 'the softbank robotics pepper'):-!.
consult_LF([say('people japan')], 'a little over 80 million'):-!.
consult_LF([say('flag japan')], 'japanese flag is a red circle centred over white'):-!.
consult_LF([say('capital japan')], 'the capital of japan is tokyo'):-!.
consult_LF([say('highest point japan')], 'the highest point in japan is mount fuji which reaches 3776 meters above sea level'):-!.
consult_LF([say('what is sakura')], 'sakura is the japanese term for ornamental cherry blossom and its tree'):-!.
consult_LF([say('emperor japan')], 'his majesty akihito sama is the emperor in japan since january 7 1989'):-!.
consult_LF([say('have dreams')], 'i dream of electric sheep'):-!.
consult_LF([say('next robocup')], 'it hasnt been announced yet but i think is montreal'):-!.
consult_LF([say('how did oscar from sesame street turn green')], 'he went on vacation to the very damp swamp mushy muddy and turned green overnight'):-!.
consult_LF([say('in what object where the ashes of fredric baur buried in')], 'in a pringles can'):-!.
consult_LF([say('what does the chocolate brand initials m and m stand for')], 'for mars and murries the candys founders'):-!.
consult_LF([say('to what inanimate object did france issue a passport')], 'to the mummy of ramses ii'):-!.
consult_LF([say('what brand of cookies came first hydrox or oreo')], 'hydrox came first'):-!.
consult_LF([say('what gender of mosquitoes bite')], 'female mosquitoes'):-!.
consult_LF([say('where the term jaywalker come from')], 'jay used to be slang for foolish person'):-!.
consult_LF([say('what is the name of the only state in the usa that can be typed on one row of keys')], 'alaska'):-!.
consult_LF([say('why was ted kaczynski called the unabomber')], 'because he sent his bombs to universities and airlines'):-!.
consult_LF([say('what is the only number whose letters are in alphabetical order')], 'the number 40'):-!.
consult_LF([say('go to the exit')], 'move exit'):-!.


%consult_date_hour(Date,Time, Year, Month, Day, Hour, Min, Sec, Day_Week, Tomorrow_Week):-

% Avoiding errors if there is no match, just simply return that the question does not make any sense
consult_LF(_,'that question does not make any sense to me'):-!.


%--------------------------------------------------------------
% Natural Language
%--------------------------------------------------------------
	
% concat and --> concatenates a sentence with the objects of the list
% concat_and(List of objects, Entrance list, Exit List)
% e.g., List: [men, women]
%		In: ['there', 'are', '6']
%		Out: ['there', 'are', '6', 'men', 'and', 'women']
concat_and([], In, In) :-!.
concat_and([H|[]], In, Out) :- 
	append(In, ['and', H], Out).
concat_and([H|T], In, Out):-
	append(In, [H], Aux),
	concat_and(T, Aux, Out).

% list with and--> analizes the number of elements of the list and if there are more than one 
% object, it adds the string and to the sentence
list_with_and([], In, In):-!.
list_with_and([H], In, Out):-
	append(In, [H], Out),!.
list_with_and(List, In, Out):-
	concat_and(List, In, Out).

% string_there --> analizes the number of elements and say if the string must be there is or there are
string_there(1, Out):-
	Out = ['there', 'is', 1].
string_there(Amount, Out):-
	Out = ['there', 'are', Amount].

% ordinal_number --> analizes a number and transform it in an ordinal number
ordinal_number(1, 'first'):-!.
ordinal_number(2, 'second'):-!.
ordinal_number(3, 'third'):-!.
ordinal_number(4, 'fourth'):-!.
ordinal_number(5, 'fifth'):-!.
ordinal_number(6, 'sixth'):-!.


nl_generator([amount(human(Human), room(Room))],Answer_LF, Answer_LF):-!.

% nl_generator --> generates an answer in natural language
% nl_generator(Question in Logical Form, Answer Logical Form, Answer in natural language)
% e.g., Question in LF: count([men, women], crowd)
%		Answer in LF: 6
%		Answer in natural language: 'there are 6 men and women in the crowd'

nl_generator([count([persons], Object)|_], 1, Answer_NL):-
	Aux =  ['there', 'is', 1, 'person', 'in', 'the', Object],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([count(List, Object)|_], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	list_with_and(List, Aux, Aux2),
	append(Aux2, ['in', 'the', Object], Aux3),
	atomic_list_concat(Aux3, ' ', Answer_NL).


% nl_generator for count questions with positions
% e.g., Question in LF: count([men, women], crowd, [waving, sitting])
%		Answer in LF: 6
%		Answer in natural language: 'there are 6 men and women waving and sitting in the crowd'
nl_generator([count([persons],Object, Actions)], 1, Answer_NL):-
	Aux = ['there', 'is', 1, 'person'],
	translate_actions(Actions, Actions2),
	list_with_and(Actions2, Aux, Aux2),
	append(Aux2, ['in', 'the', Object], Aux3),
	atomic_list_concat(Aux3, ' ', Answer_NL).

nl_generator([count(List,Object, Actions)], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	list_with_and(List, Aux, Aux2),
	translate_actions(Actions, Actions2),
	list_with_and(Actions2, Aux2, Aux3),
	append(Aux3, ['in', 'the', Object], Aux4),
	atomic_list_concat(Aux4, ' ', Answer_NL).

nl_generator([count([persons],_, _, [Value])], 1, Answer_NL):-
	Aux = ['there', 'is', 1, 'person'],
	append(Aux, ['in', Value], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([count([persons],_, _, [Value])], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, ['persons', 'in', Value], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).


% nl_generator for answer questions about adjectives
% e.g., Question in LF: answer(object_category(food), smallest, 1)]
%		Answer in LF: 'chili'
%		Answer in NL: 'the smallest food is the chili'
nl_generator([answer(object_category(Class), Adjective, 1)], Answer_LF, Answer_NL):-
	Aux = ['the', Adjective, Class, 'is', 'the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([answer(object_category(Class), Adjective, Number)], Answer_LF, Answer_NL):-
	ordinal_number(Number, Ordinal),
	Aux = ['the', Ordinal, Adjective, Class, 'is', 'the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([answer(class(human), Adjective, 1)], Answer_LF, Answer_NL):-
	Aux = ['the', Adjective, 'person', 'is', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([answer(class(human), Adjective, Number)], Answer_LF, Answer_NL):-
	ordinal_number(Number, Ordinal),
	Aux = ['the', Ordinal, Adjective, 'person', 'is', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([answer(class(Class), Adjective, 1)], Answer_LF, Answer_NL):-
	Aux = ['the', Adjective, Class, 'is', 'the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([answer(class(Class), Adjective, Number)], Answer_LF, Answer_NL):-
	ordinal_number(Number, Ordinal),
	Aux = ['the', Ordinal, Adjective, Class, 'is', 'the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl_generator for answer questions about a property value
% e.g., Question in LF: answer(object(chili), color)]
%		Answer in LF: 'red'
%		Answer in NL: 'the color of the chili is red'
nl_generator([answer(object(Object), Property)], Answer_LF, Answer_NL):-
	Aux = ['the', Property, 'of', 'the', Object, 'is', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl_generator for answer questions about a property value compare with a value given by the user
% e.g., Question in LF: answer(object(chili), color, blue)]
%		Answer in LF: 'red'
%		Answer in NL: 'no, the color of the chili is red not blue'
nl_generator([answer(object(Object), Property, Answer_LF)], Answer_LF, Answer_NL):-
	Aux = ['yes, the', Property, 'of', 'the', Object, 'is', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).	

nl_generator([answer(object(Object), Property, Value)], Answer_LF, Answer_NL):-
	Aux = ['no, the', Property, 'of', 'the', Object, 'is', Answer_LF, 'not', Value],
	atomic_list_concat(Aux, ' ', Answer_NL).




% nl generator for answer questions about the gender of someone in front of golem
nl_generator([person_gender(person,_)], Answer_LF, Answer_NL):-
	Aux = ['i', 'think', 'you', 'are', 'a', Answer_LF, 'but', 'i', 'do', 'not', 'know', 'if', 'you', 'identify','yourself','with','another','gender'],
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl generator for answer questions about the gender of someone doing an action
nl_generator([person_gender(_)], [], Answer_NL):-
	Aux = ['there', 'is', 'nobody', 'on', 'that', 'pose', 'or', 'doing', 'that', 'gesture'],
	atomic_list_concat(Aux, ' ', Answer_NL).

% nl generator for answer questions about the gender of someone doing an action
nl_generator([person_gender([Actions])], Gender, Answer_NL):-
	translate_actions([Actions], [Actions2]),
	Aux = ['the', Actions2, 'person', 'was', 'a', Gender],
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl generator for answer questions about the gender of someone doing an action
nl_generator([person_gender(_,_)], [], Answer_NL):-
	Aux = ['there', 'is', 'nobody', 'on', 'that', 'pose', 'or', 'doing', 'that', 'gesture'],
	atomic_list_concat(Aux, ' ', Answer_NL).	

nl_generator([person_gender([Actions],[Gender])], Gender, Answer_NL):-
	translate_actions([Actions], [Actions2]),
	Aux = ['yes','the', Actions2, 'person', 'was', 'a', Gender],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([person_gender([Actions],[Gender])], Answer_LF, Answer_NL):-
	translate_actions([Actions], [Actions2]),
	Aux = ['no','the', Actions2, 'person', 'was', 'not', 'a', Gender, 'but', 'a', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([person_gender([Actions],_)], Answer_LF, Answer_NL):-
	translate_actions([Actions], [Actions2]),
	Aux = ['the', Actions2, 'person', 'was', 'a', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL)	.


% nl generator for answer questions about the location of an object
nl_generator([location(object_category(Object))], Answer_LF, Answer_NL):-
	Aux = ['the', Object, 'is', 'in','the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([location(location(Object))], Answer_LF, Answer_NL):-
	Aux = ['the', Object, 'is', 'in','the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([location(object(Object))], Answer_LF, Answer_NL):-
	Aux = ['the', Object, 'is', 'in','the', Answer_LF],
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl generator for answer questions about the amount of an object

nl_generator([amount(objects,room(Room))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [objects, 'in','the', Room], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(objects,location(Location))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [objects, 'in','the', Location], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(object(Object),room(Room))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Object, 'in','the', Room], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(object(Object),location(Location))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Object, 'in','the', Location], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(object_category(Category),room(Room))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Category, 'in','the', Room], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(object_category(Category),location(Location))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Category, 'in','the', Location], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(location(Location),room(Room))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Location, 'in','the', Room], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(Property, room(Room))], Answer_LF, Answer_NL):-
	append([],['the', Room, 'has', Answer_LF, Property], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).


nl_generator([amount(object_category(Category))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Category], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).

nl_generator([amount(object(Category))], Answer_LF, Answer_NL):-
	string_there(Answer_LF, Aux),
	append(Aux, [Category], Aux2),
	atomic_list_concat(Aux2, ' ', Answer_NL).



% nl generator for answer questions about which objects are in a location
nl_generator([which(objects,room(Room))], [], Answer_NL):-
	atomic_list_concat(['there','are', 'no', 'objects', 'in', 'the', Room], ' ', Answer_NL).

nl_generator([which(objects,location(Location))], [], Answer_NL):-
	atomic_list_concat(['there','are', 'no', 'objects', 'in', 'the', Location], ' ', Answer_NL).


nl_generator([which(objects,room(_))], Answer_LF, Answer_NL):-
	list_with_and(Answer_LF, ['the'], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([which(objects,location(_))], Answer_LF, Answer_NL):-
	list_with_and(Answer_LF, ['the'], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl generator for answer questions about which is the category of an object

nl_generator([which(category,object(Object))], Answer_LF, Answer_NL):-
	append([],['the',Object, 'belongs','to', 'the', Answer_LF, 'category'], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).


% nl generator for answer questions about the category of two objects
nl_generator([same(category,[object(Object1), object(Object2)])], 'yes', Answer_NL):-
	append([],['yes', 'the',Object1, 'and', Object2, 'belong','to', 'the', 'same', 'category'], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([same(category,[object(Object1), object(Object2)])], 'no', Answer_NL):-
	append([],['no', 'the',Object1, 'and', Object2, 'do', 'not', 'belong','to', 'the', 'same', 'category'], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

% nl generator for answe questions about the comparision of two objects
nl_generator([compare(Adjective,[object(Object1), object(Object2)])], Answer_LF, Answer_NL):-
	atomic_list_concat(Answer_LF, ' ', Answer_NL).




% answer to fixed questions
nl_generator([say('your name')], Answer_LF, Answer_NL):-
	append([], ['my','name','is',Answer_LF], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('name of your team')], Answer_LF, Answer_NL):-
	append([], ['the','name','of', 'my','team','is',Answer_LF], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('year robocup at home founded')], Answer_LF, Answer_NL):-
	append([], ['the','robocup','at', 'home','was','founded', 'in',Answer_LF], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('the time')], Answer_LF, Answer_NL):- 
	append(['the','time','is'], Answer_LF, Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('the date')], Answer_LF, Answer_NL):- 
	append(['the','date','is'], Answer_LF, Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('day of the month')], Answer_LF, Answer_NL):- 
	append(['it','is','the'], Answer_LF, Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('day of the week')], Answer_LF, Answer_NL):-
	append(['today','is'], [Answer_LF], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('what day is today')], Answer_LF, Answer_NL):- 
		append(['today','is'], [Answer_LF], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('what day is tomorrow')], Answer_LF, Answer_NL):- 
	append(['tomorrow','is'], [Answer_LF], Aux),
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([say('c language')], Answer_LF, Answer_LF):-!.
nl_generator([say('c invented')], Answer_LF, Answer_LF):-!.
nl_generator([say('b invented')], Answer_LF, Answer_LF):-!.
nl_generator([say('term bug')], Answer_LF, Answer_LF):-!.
nl_generator([say('first compiler')], Answer_LF, Answer_LF):-!.
nl_generator([say('robot opl')], Answer_LF, Answer_LF):-!.
nl_generator([say('robot dspl')], Answer_LF, Answer_LF):-!.
nl_generator([say('robot sspl')], Answer_LF, Answer_LF):-!.
nl_generator([say('people japan')], Answer_LF, Answer_LF):-!.
nl_generator([say('flag japan')], Answer_LF, Answer_LF):-!.
nl_generator([say('capital japan')], Answer_LF, Answer_LF):-!.
nl_generator([say('highest point japan')], Answer_LF, Answer_LF):-!.
nl_generator([say('what is sakura')], Answer_LF, Answer_LF):-!.
nl_generator([say('emperor japan')], Answer_LF, Answer_LF):-!.
nl_generator([say('have dreams')], Answer_LF, Answer_LF):-!.
nl_generator([say('next robocup')], Answer_LF, Answer_LF):-!.

nl_generator(unknown,Answer_LF, Answer_LF):-!.

nl_generator(_,Answer_LF, Answer_LF):-!.
