diag_mod(main,
  [
    [
      id   ==> is,
      type ==> neutral,
      arcs ==> [
        empty : [
          screen('All the system working'),
          screen('These are the options'),
          screen('in, fo, cp, cl, res, gpsr, demo, see_object, detect_face, memorize_face, recognize_face, see_face, see, ask')
        ] => apply(model_to_execute(K1,K3,Model),[k1,k2,'model.pl'])
      ]
    ],[
      id   ==> k1,
      type ==> keyboard,
      arcs ==> [
        res(X) : [
          screen('Input ok to execute '),
          get(X,Sit),
          screen(Sit)
        ] => k2(X)
      ]
    ],[
      id   ==> k2(X),
      type ==> keyboard,
      arcs ==> [
        ok : empty => execute(X)
      ]
    ],[
      id   ==> execute(X),
      type ==> neutral,
      arcs ==> [
        empty : [
          get(X,Sit),
          screen('Executing test: '),
          screen(Sit)
        ] => rtest(Sit)
      ]
    ],[
      %Resursive situation to execute tests
      id   ==> rtest(M),
      type ==> recursive,
      embedded_dm ==> M, % Name of the recursive situation
      arcs ==> [
	fs : empty => final
      ]
    ],[
      id ==> final,	
      type ==> neutral,
      arcs ==> [
        empty : screen('Dialogue model finished, type ok to try again') => fs
      ]
    ],[ 
      id   ==> final_,	
      type ==> keyboard,
      arcs ==> [
        ok : empty => fs
      ]
    ],[
      % Final situation
      id   ==> fs,
      type ==> final
    ]
  ], 
  % Second argument: list of local variables
  [
    % RoboCup tests definition
    dishwasher ==> dishwasher_main,
    receptionist ==> receptionist_main,	
    serving_drinks ==> serving_drinks_main,
    carry ==> carry_main,
    garbage ==> garbage_main,
    whereis ==> where_is_main,
    handme ==> hand_me_that_main,
    demo_supermarket ==> demo_supermarket_main,
    % Behavior definition
    test ==> test
  ]
). 
