diag_mod(parse_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [screen('Parsing'), gfInterpret('take the milk move to the bed and leave the apartment',ParsedCmds)] => fs
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

