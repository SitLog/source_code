% QR Code recognition dialogue model
%
%                 Description: The robot tries to recognize a QR code
%
%                 Arguments: 
%                             Repetitions: Number of tries to read a QR code
%                             Output: The text codified within the QR code
%
%                 Status:
%                             ok: if the code was succesfully read
%                             fail: otherwise
%
% Author: Noe Hernandez

diag_mod(qr_code(Repetitions, Confirmation, Output, Status), 
%First argument: list of situations
[
	% Initial situation
        [
           id ==> is,
           type ==> neutral,
           arcs ==> [
                       empty:[say('I am about to read a QR code. Please, put the QR code close to my left cam and slowly move it farther away.')] => read_qr
                    ]
        ],

        % Try to read QR code
        [
           id ==> read_qr,
           type ==> qr_recognition, %see in_communication.pl file
           arcs ==> [
                       fail_status:[inc(count_rdgs,C), get(readings, Readings)] 
                                  => apply(when(If,TrueVal,FalseVal),[C>Readings,next_attempt,read_qr]),
                       code(Code):empty => check_confirmation( apply(parse_string_gpsr(T1), [Code]) )
                    ]
        ],
        
        % Golem  tries to read  the QR code as  many times as set by the variable Repetitions
        [
           id ==> next_attempt,
           type ==> neutral,
           arcs ==> [
                       empty:[inc(count_rpts,Count), set(count_rdgs, 0),
                             apply(when(If,TrueVal,FalseVal),[Count>Repetitions,
                                                                   say('Sorry, I am unable to read the QR code. I quit'),
                                                                   say('I could not read the QR code. Please, slowly move it closer or farther away to my left eye.')]) ]
                                  => apply(when(If,TrueVal,FalseVal),[Count>Repetitions,error,read_qr])
                    ]
        ],

        % Checks whether the user needs confirmation of the QR code just read
        [
           id ==> check_confirmation(Text),
           type ==> neutral,
           arcs ==> [
                       empty:empty => apply( when(If,TrueVal,FalseVal),
                                                      [Confirmation,
                                                       confirm_hypothesis(Text),
                                                       save_qr(Text)] )
                    ]
        ],      
        
        % Confirmation
	[
           id ==> confirm_hypothesis(Hypothesys),
           type ==> neutral,
           arcs ==> [
                       empty:say(['Does the QR code say ', Hypothesys]) => acknowledge(Hypothesys)
                    ]
	], 
	
	
        % Check if the QR code just read is correct
        [
           id ==> acknowledge(Hypothesys),
           type ==> listening(yesno),
           arcs ==> [
                       said(yes):empty => save_qr(Hypothesys),
                       said(no) :empty => read_qr
		    ]
	],
	
	
        % Save QR code
        [
           id ==> save_qr(CodeText),
           type ==> neutral,
           out_arg ==> [CodeText],
           arcs ==> [
                       empty:empty => success
                    ]
        ],
                
        % Success situation
        [
           id ==> success,
           type ==> final,
           in_arg ==> [Value],
           diag_mod ==> qr_code(_, _, Value, ok)
        ],

        % Error situation
        [
           id ==> error,
           type ==> final
        ]
],
% List of Local Variables
[
	count_rdgs ==> 0,
	readings ==> 25,
	count_rpts ==> 0
]

). % End 
