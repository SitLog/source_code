%
% With this dialogue model we test the 'time' behaviour
%

diag_mod(time_main,
   [
      [
      id ==> is,
      type ==> neutral,
      arcs ==> [
               empty : empty => time
               ]
      ],
 
      [
      id ==> time,
      type ==> recursive,
      embedded_dm ==> time(Status),
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