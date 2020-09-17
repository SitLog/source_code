% ContextualizedAsk  Dialogue Model
%
% 	Description	The robot asks a question and expects the answer
%	
%	Arguments	
%			Promt: Question to ask
%			LanguageModel: Language model
%			Confirmation: true of false, if false does not make a confirmation question
%			Repetitions: an integer which stands for the number of times which the robot will ask you to repeat before 
%			Mode: 	regular - regular ask
%				intermediate - call for attention and then ask
%				advanced - find person, get closer, and ask 
% 
%			Output: Speech Act or Utterance transcription
%
%  	Status:	
%			ok .- if something was recognized

diag_mod(contextualized_ask(Prompt, LanguageModel, Confirmation, Repetitions,Mode, Output, Status), 
	    
%First argument: list of situations
[
	
	% Decide which ask to execute
    [
		 id ==> is,
		 type ==> neutral,
		 arcs ==> [
	              empty : empty => ask(Mode)
		 	      ]
	],
	
	% Regular ask starts
	
[
		id ==> ask(regular),
		type ==> recursive,
		embedded_dm ==> detect_body(nearest,3,Body_Positions,Detect_Status),  
		arcs ==> [
        			success : [advance(0.15,_),mood(feliz)] => ask_r,
        			error : [mood(triste), say('I dont see you please stand in front of me')] => ask(regular)
				
      			 ]
],
    [
		 id ==> ask_r,
		 type ==> neutral,
		 arcs ==> [
	              empty : [say(Prompt), mood(ledhabla)] => listen_command
		 	      ]
	],
	
	[
		 id ==> listen_command,
		 type ==> listening(LanguageModel),
		 arcs ==> [
                    said(Hypothesys): [mood(ledcalla)] =>
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
			     	empty:[say(['did you say ', Hypothesys]), mood(ledhabla)] => acknowledge(Hypothesys)
 		          ]
	],
	
	[
		 id ==> acknowledge(Hypothesys),
		 type ==> listening(yesno),
		 arcs ==> [
					said(yes):[mood(ledcalla)] => confirm_hypothesis(Hypothesys,false),
					said(no):[mood(ledcalla), inc(count,C), apply(when(If,TrueVal,FalseVal),[C>Repetitions,say('Sorry, I can not understand you '),say('could you repeat your query')]) ] 
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	INTERMEDIATE ASK
    % Initial situation: listening a command
    [
		 id ==> ask(intermediate),
		 type ==> neutral,
		 arcs ==> [
		 	empty : [advance(0.15,_),robotheight(1.25), switchpose('nav'),sleep,switchpose('grasp'),mood(alegre) ] => see	
	              
	              ]
	],
	
	[
		id ==> see,
		type ==> recursive,
		embedded_dm ==> detect_body(nearest,3,Body_Positions,Detect_Status),  
		arcs ==> [
        			success : mood(feliz) => ask_q,
        			error : [mood(triste),say('I dont see you please stand in front of me')] => see %fs
				
      			 ]
      	],
	
	[
		 id ==> ask_q,
		 type ==> neutral,
		 arcs ==> [
	              empty : [say(Prompt), mood(ledhabla)] => listen_command
		 	      ]
	],
	
	[
		 id ==> listen_command,
		 type ==> listening(LanguageModel),
		 arcs ==> [
                    said(Hypothesys): [mood(ledcalla)] =>
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
			     	empty:[say(['did you say ', Hypothesys]), mood(ledhabla)] => acknowledge(Hypothesys)
 		          ]
	],
	
	[
		 id ==> acknowledge(Hypothesys),
		 type ==> listening(yesno),
		 arcs ==> [
					said(yes):[mood(ledcalla)] => confirm_hypothesis(Hypothesys,false),
					said(no):[mood(ledcalla), inc(count,C), apply(when(If,TrueVal,FalseVal),[C>Repetitions,say('Sorry, I can not understand you '),say('could you repeat it to me')]) ] 
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INTERMEDIATE FINISHES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	ADVANCED ASK
     [
		 id ==> ask(advanced),
		 type ==> neutral,
		 arcs ==> [
	              empty : [advanced(0.15,_),switchpose('nav'),sleep,switchpose('grasp'),mood(feliz)
	              ] => approaching		 	      
	              ]
	],
     [
		 id ==> approaching,
		 type ==> recursive,
		 embedded_dm ==> approach_person(body, Final_Position, Status),
		 arcs ==> [
	              success : empty => ask_question,
	              error : [say('searching'),turn(70.0,_)] => approaching		 	      
	              ]
	],	
	[
		 id ==> ask_question,
		 type ==> neutral,
		 arcs ==> [
	              empty : [say(Prompt), mood(ledhabla)] => listen_command
		 	      ]
	],
	
	[
		 id ==> listen_command,
		 type ==> listening(LanguageModel),
		 arcs ==> [
                    said(Hypothesys): [mood(ledcalla)] =>
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
			     	empty:[say(['did you say ', Hypothesys]),mood(ledhabla)] => acknowledge(Hypothesys)
 		          ]
	],
	
	[
		 id ==> acknowledge(Hypothesys),
		 type ==> listening(yesno),
		 arcs ==> [
					said(yes):[mood(ledcalla)] => confirm_hypothesis(Hypothesys,false),
					said(no):[mood(ledcalla), inc(count,C), apply(when(If,TrueVal,FalseVal),[C>Repetitions,say('Sorry, I can not understand you '),say('could you repeat your query')]) ] 
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
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	ADVANCED ASK FINISHES
    
    
    
	%Final Situation
	
	[
		id ==> success,
		type ==> final,
        in_arg ==> [Hypothesys],
		diag_mod ==> contextualized_ask(_, _, _, _, _, Hypothesys, ok)
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
