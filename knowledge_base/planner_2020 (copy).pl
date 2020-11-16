%%%%%%%%%%%%%%%%%%%%%%%
%%                   %%
%%     PLANNER       %%
%%                   %%
%%%%%%%%%%%%%%%%%%%%%%%


%Input:  KB,Diagnosis,Decisions
%Output:  Plan
		
planner_dlic(KB,Diagnosis,Decisions,Plan):-
	nl,nl,write('Starting planner'),nl, 

	object_property_value(golem,position,KB,Position),
	write('Robot position: '),write(Position),nl,

	object_property_value(golem,left_arm,KB,LeftArm),
	write('Left arm: '),write(LeftArm),nl,

	object_property_value(golem,right_arm,KB,RightArm),
	write('Right arm: '),write(RightArm),nl,

	write('Decisions: '),write(Decisions),nl,
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,Decisions,LeftArm,RightArm,BasicActions),	
	write('Basic actions: '),write(BasicActions),nl,

	%Calculate all permutations of basic actions
	setof(X,permutation(BasicActions,X),AllPlans),
	nl,write('All possible plans: '),nl,
	
	%Filter to get only valid plans
	filter_plans_dlic(AllPlans,Position,LeftArm,RightArm,FilteredPlans),

	%Order plans and get the best
	sort(FilteredPlans,[_=>Plan|_]),
	nl,write('The best plan is: '),write(Plan),nl.



%Converting the set of decisions in a set of basic actions

convert_decisions_to_basic_actions_dlic(_,_,[],_,_,[]).

%Case 1a Bring an object in the left hand of the robot
convert_decisions_to_basic_actions_dlic(KB,Diagnosis,[bring(LeftArm)|T],LeftArm,RightArm,NewList):-
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,T,LeftArm,RightArm,Aux),
	append([deliver(LeftArm,start)],Aux,NewList).

%Case 1b Bring an object in the right hand of the robot
convert_decisions_to_basic_actions_dlic(KB,Diagnosis,[bring(RightArm)|T],LeftArm,RightArm,NewList):-
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,T,LeftArm,RightArm,Aux),
	append([deliver(RightArm,start)],Aux,NewList).

%Case 1c Bring an object which is not in the hands of the robot
convert_decisions_to_basic_actions_dlic(KB,Diagnosis,[bring(X)|T],LeftArm,RightArm,NewList):-
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,T,LeftArm,RightArm,Aux),
	get_position_from_diagnosis_dlic(X,Diagnosis,ObjectCurrentPosition),
	append([take(X,ObjectCurrentPosition),deliver(X,start)],Aux,NewList).

%Case 2a Rearrange an object in the left hand of the robot
convert_decisions_to_basic_actions_dlic(KB,Diagnosis,[rearrange(LeftArm)|T],LeftArm,RightArm,NewList):-
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,T,LeftArm,RightArm,Aux),
	object_relation_value(LeftArm,associated_shelf,KB,CorrectPosition),
	append([deliver(LeftArm,CorrectPosition)],Aux,NewList).

%Case 2b Rearrange an object in the right hand of the robot
convert_decisions_to_basic_actions_dlic(KB,Diagnosis,[rearrange(RightArm)|T],LeftArm,RightArm,NewList):-
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,T,LeftArm,RightArm,Aux),
	object_relation_value(RightArm,associated_shelf,KB,CorrectPosition),
	append([deliver(RightArm,CorrectPosition)],Aux,NewList).

%Case 2c Rearrange an object which is not in the hands of the robot
convert_decisions_to_basic_actions_dlic(KB,Diagnosis,[rearrange(X)|T],LeftArm,RightArm,NewList):-
	convert_decisions_to_basic_actions_dlic(KB,Diagnosis,T,LeftArm,RightArm,Aux),
	object_relation_value(X,associated_shelf,KB,CorrectPosition),
	get_position_from_diagnosis_dlic(X,Diagnosis,ObjectCurrentPosition),
	append([take(X,ObjectCurrentPosition),deliver(X,CorrectPosition)],Aux,NewList).


%Get the position of an object according to the diagnosis (so it can be an observed or a believed position)

get_position_from_diagnosis_dlic(_,[],unknown).

get_position_from_diagnosis_dlic(Object,[move(Shelf),place(ListObjects)|_],Shelf):-
	isElement(Object,ListObjects).

get_position_from_diagnosis_dlic(Object,[move(_),place(_)|T],Shelf):-
	get_position_from_diagnosis_dlic(Object,T,Shelf).
	

%Filter plans using the restriction of number of free arms

filter_plans_dlic([],_,_,_,[]).

filter_plans_dlic([H|T],Position,LeftArm,RightArm,NewList):-
	filter_plans_dlic(T,Position,LeftArm,RightArm,AuxList),
	transform_plan_dlic(H,Position,LeftArm,RightArm,TransformedPlan,Value),
	write('Possible plan: '),write(H),
	write('  Transformed plan: '),write(TransformedPlan),nl,
	write('Value: '),write(Value),nl,nl,
	append([Value=>TransformedPlan],AuxList,NewList).

%Transform plan from the set of actions take/deliver to a lower level of granularity move/grasp(left)/grasp(right)/deliver
%notvalid ocurrs when the robot tries to take an object but both arms are occupied, or when the robot tries to deliver an object that is not in his arms

transform_plan_dlic([],_,_,_,[],0).

%Case 1 A take in the current position of the robot and both hands are free
transform_plan_dlic([take(Object,Position)|T],Position,free,free,TransformedPlan,NewValue):-
	transform_plan_dlic(T,Position,Object,free,Aux,Value),
	append([grasp(Object,left)],Aux,TransformedPlan),
	take_action_dlic(Object,CostAction,_),
	NewValue is (Value+CostAction).
	
%Case 2 A take in the current position of the robot and only left hand is free
transform_plan_dlic([take(Object,Position)|T],Position,free,RightArm,TransformedPlan,NewValue):-
	RightArm\=free,
	transform_plan_dlic(T,Position,Object,RightArm,Aux,Value),
	append([grasp(Object,left)],Aux,TransformedPlan),
	take_action_dlic(Object,CostAction,_),
	NewValue is (Value+CostAction).
	
%Case 3 A take in the current position of the robot and only right hand is free
transform_plan_dlic([take(Object,Position)|T],Position,LeftArm,free,TransformedPlan,NewValue):-
	LeftArm\=free,
	transform_plan_dlic(T,Position,LeftArm,Object,Aux,Value),
	append([grasp(Object,right)],Aux,TransformedPlan),
	take_action_dlic(Object,CostAction,_),
	NewValue is (Value+CostAction).	

%Case 4 A take in the current position but both hands are busy
transform_plan_dlic([take(_,Position)|_],Position,LeftArm,RightArm,[notvalid],100000):-
	RightArm\=free,
	LeftArm\=free.

%Case 5 A take in other place of the scenario
transform_plan_dlic([take(Object,Shelf)|T],Position,LeftArm,RightArm,TransformedPlan,NewValue):-
	Shelf\=Position,
	transform_plan_dlic([take(Object,Shelf)|T],Shelf,LeftArm,RightArm,Aux,Value),
	append([move(Shelf)],Aux,TransformedPlan),
	move_action_dlic(Position,Shelf,CostAction,_),
	NewValue is (Value+CostAction).
	
%Case 6 A deliver in the current position of the robot of an object in the left arm
transform_plan_dlic([deliver(Object,Position)|T],Position,Object,RightArm,TransformedPlan,NewValue):-
	transform_plan_dlic(T,Position,free,RightArm,Aux,Value),
	append([deliver(Object,left)],Aux,TransformedPlan),
	deliver_action_dlic(Object,CostAction,_),
	NewValue is (Value+CostAction).	

%Case 7 A deliver in the current position of the robot of an object in the right arm
transform_plan_dlic([deliver(Object,Position)|T],Position,LeftArm,Object,TransformedPlan,NewValue):-
	transform_plan_dlic(T,Position,LeftArm,free,Aux,Value),
	append([deliver(Object,right)],Aux,TransformedPlan),
	deliver_action_dlic(Object,CostAction,_),
	NewValue is (Value+CostAction).	

%Case 8 A deliver in the current position of the robot of an object which is not in the hands
transform_plan_dlic([deliver(Object,Position)|_],Position,LeftArm,RightArm,[notvalid],100000):-
	RightArm\=Object,
	LeftArm\=Object.

%Case 9 A deliver in other place of the scenario
transform_plan_dlic([deliver(Object,Shelf)|T],Position,LeftArm,RightArm,TransformedPlan,NewValue):-
	Shelf\=Position,
	transform_plan_dlic([deliver(Object,Shelf)|T],Shelf,LeftArm,RightArm,Aux,Value),
	append([move(Shelf)],Aux,TransformedPlan),
	move_action_dlic(Position,Shelf,CostAction,_),
	NewValue is (Value+CostAction).	












