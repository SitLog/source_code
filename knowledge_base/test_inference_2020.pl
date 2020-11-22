:- op(600,xfx,':').
:- op(800,xfx,'=>').
:- op(900,xfx,'=>>').
:- consult(change_KB_extensions).
:- consult(daily_life_inference_cycle_2020).
:- consult(new_observation_2020).
:- consult(diagnosis_2020).
:- consult(decision_maker_2020).
:- consult(planner_2020).

open_kb(Path,KB):-
        print('Loading KB from '),print(Path),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,Path,KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

test_inference_2020_case_A:-
	open_kb('/rosagents/SitLog/knowledge_base/inference_case_A_2020_KB.txt',KB),
	print(KB),nl,
	new_observation_dlic(KB,shelf1=>[heineken,noodles],NewKB1),
	golem_daily_life_inference_cycle(NewKB1,coke,NewKB2,Diagnosis,Decision,Plan),
	nl,nl,nl,write('Results'),nl,write('Diagnosis: '),write(Diagnosis),nl,
        write('Decision: '),write(Decision),nl,write('Plan: '),write(Plan). 

test_inference_2020_case_B:-
	open_kb('/rosagents/SitLog/knowledge_base/inference_case_B_2020_KB.txt',KB),
	print(KB),nl,
	%new_observation_dlic(KB,shelf2=>[bisquits],NewKB1),
	new_observation_dlic(KB,shelf2=>[kellogs],NewKB1),
	golem_daily_life_inference_cycle(NewKB1,coke,NewKB2,Diagnosis,Decision,Plan),
	nl,nl,nl,write('Results'),nl,write('Diagnosis: '),write(Diagnosis),nl,
        write('Decision: '),write(Decision),nl,write('Plan: '),write(Plan). 



	
	


