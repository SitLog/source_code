
%Input: KB, MissingObject(the one that caused the invocation of the deliberative reasoning)
%Output: NewKB, Diagnosis, Decision, Plan

golem_daily_life_inference_cycle(KB,MissingObject,NewKB,Diagnosis,Decision,Plan):-
	diagnosis_dlic(KB,MissingObject,Diagnosis,NewKB),
	decision_maker_dlic(NewKB,Decision),
	planner_dlic(NewKB,Diagnosis,Decision,Plan).









