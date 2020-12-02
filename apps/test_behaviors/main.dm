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
    carry ==> carry_main,
    see_object ==> see_object_main, 
    detect_face ==> detect_face_main,
    memorize_face ==> memorize_face_main,
    recognize_face ==> recognize_face_main,
    see_face ==> see_face_main,
    detect_head ==> detect_head_main,
    see_person ==> see_person_main,
    see_gesture ==> see_gesture_main,
    see ==> see_main,
    tilt ==> tilt_main,
    scan ==> scan_main,
    find ==> find_main,
    approach_person ==> approach_person_main,
    move ==> move_main,
    move_nb ==> move_main_nonblock,
    detect_door ==> detect_door_main,
    follow ==> follow_main,
    take ==> take_main,
    approach_object ==> approach_object_main,
    grasp ==> grasp_main,
    deliver ==> deliver_main,
    approach_plane ==> approach_plane_main,
    approach_surface ==> approach_surface_main,
    relieve ==> relieve_main,
    ask ==> ask_main,
    answer ==> answer_main,
    say ==> say_main,
    guide ==> guide_main,
    execute ==> execute_main,
    consult_kb ==> consult_kb_main,
    point ==> point_main,
    prompt ==> prompt_main,
    detect_body ==> detect_body_main,
    memorize_body ==> memorize_body_main,
    recognize_body ==> recognize_body_main,
    describe_body ==> describe_body_main,
    see_body ==> see_body_main,
    gpsr ==> gpsr_main,
    egpsr ==> egpsr_main,
    rips ==> rips_main,
    inference ==> inference_main,
    preferences ==> preferences_main,
    object_manipulation ==> object_manipulation_main,
    clean_up ==> clean_up_main,
    set_table_up ==> set_table_up_main,
    date ==> date_main,
    gender ==> gender_main,
    pose ==> pose_main,
    time ==> time_main,
    qr ==> qr_main,
    plane ==> plane_main,
    answer_question ==> answer_question_main,
    person_recognition_test ==> person_recognition_test_main,
    soft_biometrics ==> soft_biometrics_main,
    supermarket ==> supermarket_main,
    follow_with_clothes ==> follow_with_clothes_main,
    speech_and_person ==> speech_and_person_main,
    inspection ==> inspection_main,
    recepcionist ==> recepcionist_main,
    test_students ==> test_students_main,	
    % Behavior definition
    tk ==> take([coke,0,0.4,0.7,1,1,1,1,1],-20,right,Res), 
    give ==> give(coke,1), 
    learn ==> learn_faces,     
    oid ==> identify_object(Objects), 
    doa ==> doa_main,
    test ==> test,
    parse ==> parse_main,
    mood ==> mood_main,
    example ==> example_main,
    lead ==> lead_main,
    detect_face_cs ==> detect_face_cognitive_main,
    prueba ==> prueba_main,
    find_say ==> test_find_and_say_main,
    openpose ==> openpose_main,
    whereiam ==> whereiam_main
  ]
). 
