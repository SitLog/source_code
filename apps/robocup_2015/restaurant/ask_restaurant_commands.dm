% Ask Dialogue Model
%
% 	Description	The robot asks a question and expects the answer
%	
%	Arguments	
%			Promt: Question to ask
%			LanguageModel: Language model
%			Confirmation: true of false, if false does not make a confirmation question
%			Repetitions: an integer which stands for the number of times which the robot will ask you to repeat before 
%				using the keyboard to introduce the command 
%			Output: Speech Act or Utterance transcription
%
%  	Status:	
%			ok .- if something was recognized

diag_mod(ask_restaurant_commands(Prompt, LanguageModel, Confirmation, Repetitions, Output, Status), 
	    
%First argument: list of situations
[
	
	% Initial situation: listening a command
        [
		 id ==> is,
		 type ==> neutral,
		 arcs ==> [
		 	empty : say(Prompt) => listen_command
		 	]
	],
	
	[
		 id ==> listen_command,
		 type ==> listening(LanguageModel),
		 arcs ==> [
                               said(nothing): sleep => listen_command,			     	
				said(Hypothesis): empty => confirm_hypothesis(apply(convert_string_to_atom(HT),[Hypothesis]),Confirmation)			  	
		          ]
        ],

	%The hypothesys is checked in the user function to determine next situation
	%If the hypothesys is 'nothing' the next situation is listen_command
	%Else the next situation is confirm_hypothesis(Hypothesis,Confirmation)
	%[
%		 id ==> listen_command,
%		 type ==> listening(LanguageModel),
%		 arcs ==> [
%                                said(Hypothesis): empty => confirm_hypothesis(drink(coke),true)
% 					%[say('Hypothesis: '),say(Hypothesis),apply(
% 					%check_not_empty_hypothesys(Hyp,Conf),
% 					%[apply(
% 					%convert_string_to_atom(HT),[Hypothesis]
% 					%),Confirmation]
% 					%)		]  	
%		          ]
%        ],

	% Case 1 No confirmation 
	[
		 id ==> confirm_hypothesis(Hypothesis,false),
		 type ==> neutral,
		 out_arg ==> [Hypothesis],
		 arcs ==> [
			     		empty:empty => success
 		 ]
	],
	

	% Case 2 Confirmation
	[
		 id ==> confirm_hypothesis(drink(Drink),true),
		 type ==> neutral,
		 arcs ==> [
			     	empty:say(['do you want me to bring you a ', Drink]) => acknowledge(drink(Drink))
 		 ]
	],
	

	% Case 2 Confirmation
	[
		 id ==> confirm_hypothesis(combo(Obj1,Obj2),true),
		 type ==> neutral,
		 arcs ==> [
			     	empty:say(['do you want me to bring you a ',Obj1, ' and a ', Obj2]) => acknowledge(combo(Obj1,Obj2))
 		 ]
	],
	
	% Case 2 Confirmation
	[
		 id ==> confirm_hypothesis(Hypothesis,true),
		 type ==> neutral,
		 arcs ==> [
			     	empty: [inc(count,C), apply(when(If,TrueVal,FalseVal),[C>Repetitions,say('Sorry, I can not understand you '),say('could you repeat')]) ] => apply(when(If,TrueVal,FalseVal),[C>Repetitions,prompt,listen_command])
 		 ]
	],
	

	[
		 id ==> acknowledge(Hypothesis),
		 type ==> listening(yesno),
		 arcs ==> [
					said(yes):empty => confirm_hypothesis(Hypothesis,false),
					said(no):[inc(count,C), apply(when(If,TrueVal,FalseVal),[C>Repetitions,say('Sorry, I can not understand you '),say('could you repeat')]) ] 
						=> apply(when(If,TrueVal,FalseVal),[C>Repetitions,prompt,listen_command]),
					said(nothing):empty => acknowledge(Hypothesis)
		          ]
	],
		

	%Prompt
 	[  
      		id ==> prompt,
      		type ==> recursive,
		embedded_dm ==> prompt('Use my keyboard to introduce what you are saying', ReadText, Status),
                out_arg ==> [apply(convert_string_to_atom(RT),[ReadText])],
      		arcs ==> [
        			success : empty => success,
        			error : empty => error				
      			]
    	],	


	%Final Situation
	
	[
		id ==> success,
		type ==> final,
                in_arg ==> [Hypothesis],
		diag_mod ==> ask_restaurant_commands(_, _, _, _, Hypothesis, ok)
	],

	[
		id ==> error,
		type ==> final
	]		

], % End situation list

% List of Local Variables
[
	count ==> 0
]

). % End listen











