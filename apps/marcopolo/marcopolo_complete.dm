diag_mod(marcopolo,
[
    [
        id ==> is,
        type ==> neutral,
        arcs ==> [
            %empty : [robotheight(1.42),set(last_height,1.42),reset_speakerid] => start
            empty : [reset_speakerid] => start
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
            %empty : empty => getdoa
            empty : [sleep,sleep] => getdoa
        ]
    ],

    [  
        id ==> getdoa,
        type ==> recursive,
        embedded_dm ==> doas(one,doa(Angle),Status),
        arcs ==> [
            %success : [turn_fine(Angle,Res)] => identifyspeaker,
            success : empty => identifyspeaker,
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
            empty : [say('I heard'), say(Speaker), say('from this direction. I am going to catch you.')] => getclose_dummy
        ]
    ],

    [
        id ==> speaker(Speaker,mid),
        type ==> neutral,
        arcs ==> [
            empty : [say('Is your name'), say(Speaker)] => confirmnamekb(Speaker)
        ]
    ],

    [
        id ==> speaker(Speaker,low),
        type ==> neutral,
        arcs ==> [
            empty : [say('I do not think I know you. Please tell me your name.')] => asknamekb
        ]
    ],

    [
        id ==> confirmname(Speaker),
        type ==> listening(yesno),
        arcs ==> [
            said(yes): [assignname(Speaker), say('Good to hear you again. '), say(Speaker), say('I am going to catch you.')] => getclose_dummy,
            said(no): [say('I am sorry. What is your name.')] => askname,
            said(nothing): [say('I did not hear you.'), say('Is your name'), say(Speaker)] => confirmname(Speaker)
        ]
    ],

    [
        id ==> confirmnamekb(Speaker),
        type ==> recursive,
        embedded_dm ==> prompt('Type it.', Response, Status),
        arcs ==> [
            success : empty => confirmnamekb_response(Response,Speaker),
            error : [say('Please type yes or no.')] => confirmnamekb(Speaker)
        ]
    ],

    [
        id ==> confirmnamekb_response(yes,Speaker),
        type ==> neutral,
        arcs ==> [
            empty : [assignname(Speaker), say('Good to hear you again '), say(Speaker), say('I am going to catch you.')] => getclose_dummy
        ]
    ],

    [
        id ==> confirmnamekb_response(no,Speaker),
        type ==> neutral,
        arcs ==> [
            empty : [say('I am sorry. What is your name.')] => asknamekb
        ]
    ],

    [
        id ==> confirmnamekb_response(A,Speaker),
        type ==> neutral,
        arcs ==> [
            empty : [say('Type yes or no.')] => confirmnamekb(Speaker)
        ]
    ],

    [
        id ==> askname,
        type ==> listening(name),
        arcs ==> [
            said(Speaker): empty => queryname(Speaker),
            said(nothing): [say('I did not hear you. Please tell me your name.')] => askname
        ]
    ],

    [
        id ==> asknamekb,
        type ==> recursive,
        embedded_dm ==> prompt('Type it.', Speaker, Status),
        arcs ==> [
            success : empty => queryname(Speaker),
            error : [say('I did not hear you. Please type your name.')] => asknamekb
        ]
    ],

    [
        id ==> queryname(Speaker),
        type ==> query_speakerid(Speaker),
        arcs ==> [
            success : [assignname(Speaker), say('Good to hear you again. '), say(Speaker), say('I am going to catch you.')] => getclose_dummy,
            error : [assignname(Speaker), say('Good to meet you '), say(Speaker), say('Say Polo when I say Marco to play with me. I am going to catch you now.')] => getclose_dummy
        ]
    ],

    [  
        id ==> getclose,
        type ==> neutral,
        arcs ==> [
            empty : [switchpose('nav'),advance_nonblock(1.0)] => nav_status
        ]
    ],

	[
		 id ==> nav_status,
		 type ==> navigate_status,
		 arcs ==> [
                                active: empty => polo_status,
                                ok: [switchpose('grasp'),say('Nobody here.')] => start,
                                inactive: [switchpose('grasp'),say('I did not catch you.')] => start,
                                error: [switchpose('grasp'),say('Something went wrong. Trying again.')] => start
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

    [  
        id ==> getclose_dummy,
        type ==> neutral,
        arcs ==> [
            empty : [say('Nobody here.')] => start
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
