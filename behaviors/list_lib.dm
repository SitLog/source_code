diag_mod(list_lib(In,_,NumFunc),
[
    [
      id   ==> start,
      type ==> neutral,
      arcs ==> [
               empty : empty => next_situation(NumFunc)
               ]
    ],
    
    [
      id   ==> next_situation(0),
      type ==> neutral,
      arcs ==> [
               empty : empty => head(In)
               ]
    ],
    
    [
      id   ==> next_situation(1),
      type ==> neutral,
      out_arg ==> [Final_Lst],
      arcs ==> [
               empty : [assign(Final_Lst,apply(add_interleaved_vals(I_),[In]))] => success
               ]
    ],
                           
    [
      id   ==> head([]),
      type ==> neutral,
      arcs ==> [
               empty : empty => error
               ]
    ],
    
    [
      id   ==> head([H|_]),
      type ==> neutral,
      out_arg ==> [H],
      arcs ==> [
               empty : empty => success
               ]
    ],
    
    [
      id ==> success,
      type ==> final,
      in_arg ==> [L],
      diag_mod ==> list_lib(_,L,_)
    ],
    
    [
      id ==> error,
      type ==> final
    ]
  
  ],

  % Second argument: list of local variables
  [
  ]

).
