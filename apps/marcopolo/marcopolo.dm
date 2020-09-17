diag_mod(marcopolo,
[
    [
        id ==> is,
        type ==> neutral,
        arcs ==> [
            empty : [robotheight(1.22),set(last_height,1.22),reset_speakerid] => start
        ]
    ],

    [
        id ==> start,
        type ==> neutral,
        arcs ==> [
            empty : [say('Marco.'),reset_soundloc] => polo
        ]
    ],

    [
        id ==> polo,
        type ==> neutral,
        arcs ==> [
            empty : [sleep,sleep,sleep] => getdoa
        ]
    ],

    [  
        id ==> getdoa,
        type ==> recursive,
        embedded_dm ==> doas(one,doa(Angle),Status),
        arcs ==> [
            success : [turn(Angle,Res)] => identifyspeaker,
            error : [say('I did not hear anybody. Please say Polo when I say Marco.'), sleep] => start
        ]
    ],

    [  
        id ==> identifyspeaker,
        type ==> recursive,
        embedded_dm ==> speakerid(Speaker, Confidence, Status),
        arcs ==> [
            success : empty => speaker(Speaker,Confidence),
            error : [say('I could not identify a person. Please say Polo when I say Marco.'), sleep] => start
        ]
    ],

    [
        id ==> speaker(Speaker,high),
        type ==> neutral,
        arcs ==> [
            empty : [say('I heard'), say(Speaker), say('from this direction. I am going to catch you.')] => getclose
        ]
    ],

    [
        id ==> speaker(Speaker,mid),
        type ==> neutral,
        arcs ==> [
            empty : [say('Is your name'), say(Speaker)] => confirmname(Speaker)
        ]
    ],

    [
        id ==> speaker(Speaker,low),
        type ==> neutral,
        arcs ==> [
            empty : [say('I do not think I know you. Please tell me your name.')] => askname
        ]
    ],

    [
        id ==> confirmname(Speaker),
        type ==> listening(yesno),
        arcs ==> [
            said(yes): [assignname(Speaker), say('Good to hear you again. '), say(Speaker), say('I am going to catch you.')] => getclose,
            said(no): [say('I am sorry. What is your name.')] => askname,
            said(nothing): [say('I did not hear you.'), say('Is your name'), say(Speaker)] => confirmname(Speaker)
        ]
    ],

    [
        id ==> askname,
        type ==> listening(human),
        arcs ==> [
            said(Speaker): empty => queryname(Speaker),
            said(nothing): [say('I did not hear you. Please tell me your name.')] => askname
        ]
    ],

    [
        id ==> queryname(Speaker),
        type ==> query_speakerid(Speaker),
        arcs ==> [
            success : [assignname(Speaker), say('Good to hear you again. '), say(Speaker), say('I am going to catch you.')] => getclose,
            error : [assignname(Speaker), say('Good to meet you '), say(Speaker), say('Say Polo when I say Marco to play with me. I am going to catch you now.')] => getclose
        ]
    ],

    [  
        id ==> getclose,
        type ==> neutral,
        arcs ==> [
            empty : [switchpose('nav'),advance_nonblock(1.0,Advanceresult)] => nav_status
        ]
    ],

	[
		 id ==> nav_status,
		 type ==> navigate_status,
		 arcs ==> [
                                active: empty => polo_status,
                                ok: [switchpose('grasp'),say('Nobody here.')] => start,
                                inactive: [switchpose('grasp'),say('I did not catch you.')] => start,
                                error: [switchpose('grasp'),say('I did not found you.')] => start
		          ]
    ],

	[
		 id ==> polo_status,
		 type ==> detect_polo,
		 arcs ==> [
                                success: [navigate_abort, switchpose('grasp'),say('Here you are. I catched you.')] => start,
                                error: empty => nav_status
		          ]
    ],

    % Final Situations
    [
        id ==> success,
        type ==> final
    ],

    [
        id ==> error,
        type ==> final
    ]

],

% local vars
[
]

).
