% Time Task Dialogue Model
%
% 	Description	The robot says the current time
%	
%	Arguments	None
%				
%			Status:	
%				ok .- if the time was correctly said
%				time_not_said .- the time couldn't be said

diag_mod(time(Status),
   [
      [
      id ==> is,
      type ==> neutral,
      arcs ==> [
               empty : empty => say_time( apply(hora, []) ) %The user function 'hora' makes up the string with the current time
               ]
      ],

      % Say the time computed by the 'hora' user function
      [
      id ==> say_time(T),
      type ==> recursive,
      embedded_dm ==> say(T, Status),
      arcs ==> [
               success : empty => success,
               error : empty => error
               ]
      ],

      [
      id ==> success,
      type ==> final,
      diag_mod ==> time(ok)
      ],

      [
      id ==> error,
      type ==> final,
      diag_mod ==> time(time_not_said)
      ]
   ],

   %Local variables
   []
).