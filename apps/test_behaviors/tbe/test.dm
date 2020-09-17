diag_mod(test,
  [
    [
      id ==> is,
      type ==> neutral,
      arcs ==> [
        empty : [
          screen('Write the name and parameters of the dialogue model to execute')
        ] => k1
      ]
    ],[
      id ==> k1,
      type ==> keyboard,
      arcs ==> [
        res(X) : [
          screen('Ready to execute '),screen(X)
        ] => execute(X)
      ]
    ],[
      id ==> execute(X),
      type ==> neutral,
      arcs ==> [
        empty : [screen('Executing test: '),screen(X)] => rtest(X)
      ]
    ],[
      %Resursive situation to execute tests
      id ==> rtest(M),
      type ==> recursive,
      embedded_dm ==> M, % Name of the recursive situation
      arcs ==> [
	success(Type) : empty => fs,
        error(Type,Info) : empty => fs
      ]
    ],[
      % Final situation
      id ==> fs,
      type ==> final
    ]
  ], 
  % Second argument: list of local variables
  [
  ]
). 
