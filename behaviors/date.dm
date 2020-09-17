% Date Task Dialogue Model
%
% 	Description	The robot says the current date
%	
%	Arguments	None
%				
%			Status:	
%				ok .- if the date was correctly said
%				date_not_said .- the date couldn't be said

diag_mod(date(Option, Status),
   [
      [
      id ==> is,
      type ==> neutral,
      arcs ==> [
               empty : empty => choice(Option) %The user function 'fecha' makes up the string with the current date
               ]
      ],
      
      % Find current weekday
      [
      id ==> choice(today),
      type ==> neutral,
      arcs ==> [
               empty : empty => say_date( apply(hoy, []) )
               ]
      ],

      % Find tomorrow weekday
      [
      id ==> choice(tomorrow),
      type ==> neutral,
      arcs ==> [
               empty : empty => say_date( apply(manana, []) )
               ]
      ],
      
      % Find the day of the month
      [
      id ==> choice(month_day),
      type ==> neutral,
      arcs ==> [
               empty : empty => say_date( apply(fecha, []) )
               ]
      ],      
      
      % Say the date computed by the 'fecha' user function
      [
      id ==> say_date(D),
      type ==> recursive,
      embedded_dm ==> say(D, Status),
      arcs ==> [
               success : empty => success,
               error : empty => error
               ]
      ],

      [
      id ==> success,
      type ==> final,
      diag_mod ==> date(_, ok)
      ],

      [
      id ==> error,
      type ==> final,
      diag_mod ==> date(_, date_not_said)
      ]
   ],

   %Local variables
   []
).
