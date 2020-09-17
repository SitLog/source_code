
register_all :-
	print("Registering topics..."),nl,
	rosswipl_register_topic('recognized_sentence', 'recognized_sentence', 1),
	rosswipl_advertise_topic('change_grammar', 1),
	rosswipl_advertise_topic('speak_sentence', 1).

recognized_sentence(Message) :-
	asserta(message_from_recognizer(Message)),
	message_from_recognizer(GlobalVarValue).


%%%%%%%%%%%%%%%%%

getLastMessage(GlobalVarName, Result) :-
	asserta(message_from_recognizer([])),
	message_from_recognizer(GlobalVarValue),
	print('got in 1 '), print(GlobalVarValue), nl,
	waitForChange(GlobalVarValue,GlobalVarName,Result).

waitForChange([],GlobalVarName,Result) :-
	sleep(1),
	message_from_recognizer(GlobalVarValue),
	print('got in 2 '), print(GlobalVarValue), nl,
	waitForChange(GlobalVarValue,GlobalVarName,Result).

waitForChange(GlobalVarValue,GlobalVarName,Result) :-
	Result = GlobalVarValue.

