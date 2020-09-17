diag_mod(test_students_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ apply(initialize_KB,[]), apply( location_of_an_object(O,P), [soap, Res] ) ] => n(Res)
      ]
    ],
  
    [
      id ==> n(X),	
      type ==> neutral,
      arcs ==> [
        empty : empty => fs
      ]
    ],
    
    [
      id ==> fs,
      type ==> final
    ]
  ],

  % Second argument: list of local variables
  [
  ]

).	
