% Answer Dialogue Model
%
% 	Description	The robot requests a question and delivers an answer
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

diag_mod(answer(Status), 
	    
%First argument: list of situations
[
	
	% Initial situation: request a question
        [
		 id ==> is,
		 type ==> neutral,
		 arcs ==> [
		 	empty : say('Ask me something.') => listen_command
		 	]
	],
	
	[
		 id ==> listen_command,
		 type ==> listening(questions),
		 arcs ==> [
                                said(H): [say('The answer is '), say(H)] => success,
                                said(nothing): [say('I could not hear you. Sorry.')] => error
		          ]
        ],

	%Final Situations
	[
		id ==> success,
		type ==> final
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











