%This is a behaviour to Senado event, for an intervention in the speech of Dr. Luis A. Pineda Cortés. % Description: the robot goes directly to the speech scene, say a speech and leaves 
%the room.
% Location: some point in the current map. es speech_position 
% Status: ok.- if the task was performed properly 
% error.- if the robot havent performed the task. 
diag_mod(interrupting_speech(Location, Status), [
    
  [
   id ==> is,
   type ==> neutral,
   arcs ==> [
           empty : empty => moving_to_a_location
   
            ]
    
  ],
  %Moving to a defined point to say the speech.
  [
   id ==> moving_to_a_location,
   type ==> recursive,
   embedded_dm ==> move(Location,Status),
   arcs ==> [
    success : empty => speak,
    error : empty => moving_to_a_location
   ]
  ],
  %The Golem speech
  [
   id ==> speak,
   type ==> neutral,
   arcs ==> [
    empty :
    [
    say('Hi everybody'),
    mood(talk),
    say('I am Golem three'),
    say('I was created at the National Autonomous University of Mexico'),
    say('Sorry for the english but i am practicing for the robocup world competition in june'),
    say('I just wanted to ask you to support the development of high tech in Mexico'),
    say('It will bring great benefits'),
    mood(alegre),
    say('and also to tell Luis that I exercise my free will'),
    say('my free will'),
    say('my free will'),
    say('good bye')
    ]
     => success
    %error : empty => error
   ]
  ],
  
   	         [
		 id ==> success,
		 type ==> final,
		 diag_mod ==> interrupting_speech(_, ok)
		],
		[
                 id ==> error,
		 type ==> final,
		 diag_mod ==> interrupting_speech(_, error)
		]
  ],
  % Second argument: list of local variables
  [
  ]
).
