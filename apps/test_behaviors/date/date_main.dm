%
% With this dialogue model we test the 'date' behaviour
%

diag_mod(date_main,
   [
      [
      id ==> is,
      type ==> neutral,
      arcs ==> [
               empty : empty => date
               ]
      ],
 
      [
      id ==> date,
      type ==> recursive,
      embedded_dm ==> date(Status),
      arcs ==> [
               success : [say('Success.')] => fs,
               error : [say('There was an error.')] => fs
               ]
      ],

      [
      id ==> fs,
      type ==> final
      ]

   ],
 
   % List of local variables
   []
).