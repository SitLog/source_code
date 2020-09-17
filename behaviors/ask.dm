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

diag_mod(ask(Prompt, LanguageModel, Confirmation, Repetitions, Output, Status), 
	    
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
	
%	[
%		 id ==> listen_command,
%		 type ==> listening(LanguageModel),
%		 arcs ==> [
%                               said(nothing):empty => listen_command,			     	
%				said(Hypothesis): empty => confirm_hypothesis(Hypothesis,Confirmation)			  	
%		          ]
%        ],

	%The hypothesys is checked in the user function to determine next situation
	%If the hypothesys is 'nothing' the next situation is listen_command
	%Else the next situation is confirm_hypothesis(Hypothesis,Confirmation)
	[
		 id ==> listen_command,
		 type ==> listening(LanguageModel),
		 arcs ==> [
                    said(Hypothesys): empty =>
 					          apply(check_not_empty_hypothesys(Hyp,Conf),[Hypothesys,Confirmation])		  	
		          ]
        ],

	% Case 1 No confirmation 
	[
		 id ==> confirm_hypothesis(Hypothesys,false),
		 type ==> neutral,
		 out_arg ==> [Hypothesys],
		 arcs ==> [
			      empty:empty => success
 		          ]
	],
	

	% Case 2 Confirmation
	[
		 id ==> confirm_hypothesis(Hypothesys,true),
		 type ==> neutral,
		 arcs ==> [
			     	empty:say(['did you say ', Hypothesys]) => acknowledge(Hypothesys)
 		          ]
	],
	
	[
		 id ==> acknowledge(Hypothesys),
		 type ==> listening(yesno),
		 arcs ==> [
					said(yes):empty => confirm_hypothesis(Hypothesys,false),
					said(no):[inc(count,C), apply(when(If,TrueVal,FalseVal),[C>Repetitions,say('Sorry, I can not understand you '),say('could you repeat me please')]) ] 
						=> apply(when(If,TrueVal,FalseVal),[C>Repetitions, qr, listen_command]), % apply(when(If,TrueVal,FalseVal),[C>Repetitions, prompt, listen_command]),
					% 2017-05-30 Caleb e Ivette cambiaron este reglón para que de nuevo pregunte si dijo la frase
					%said(nothing):empty => acknowledge(Hypothesys)
					said(nothing):say('Sorry, I could not hear you ') => confirm_hypothesis(Hypothesys,true)
		          ]
	],
		

    %QR
 	[  
      	 id ==> qr,
      	 type ==> recursive,
	 embedded_dm ==> qr_code(2, true, Text, Status),
         out_arg ==> [Text],
      	 arcs ==> [
        			success : empty => success,
        			error : empty => error				
      	          ]
    ],
    
	%Prompt
 	%[  
    %  	 id ==> prompt,
    %  	 type ==> recursive,
	%	 embedded_dm ==> prompt('Use my keyboard to introduce what you are saying', ReadText, Status),
    %    out_arg ==> [ReadText],
    %  	 arcs ==> [
    %    			success : empty => success,
    %    			error : empty => error				
    %  	          ]
    %],	


	%Final Situation
	
	[
		id ==> success,
		type ==> final,
        in_arg ==> [Hypothesys],
		diag_mod ==> ask(_, _, _, _, Hypothesys, ok)
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











