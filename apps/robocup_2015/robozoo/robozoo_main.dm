%%
diag_mod(robozoo_main,
[
    [
    id ==> realstart,	
    type ==> neutral,
    arcs ==> [
        empty : [tiltv(0.0),set(last_tilt,0.0),tilth(0.0),set(last_scan,0.0),set_ang_speed(25.0)] => start
        ]
    ],

    [
    id ==> start,	
    type ==> neutral,
    arcs ==> [
        empty : [mood(neutral),say('Hello, my name is Golem.'),mood(feliz)] => torso1
        ]
    ],

    %torso stuff
    [  
    id ==> torso1,
    type ==> neutral,
    arcs ==> [
        empty : [mood(neutral),say('I can be very tall.'),mood(sorpresa),robotheight(1.8),set(last_height,1.8),say('Or very short.'),mood(disgusto),robotheight(1.15),set(last_height,1.15),mood(triste),say('But this is too low.'),mood(disgusto),robotheight(1.35),set(last_height,1.35),mood(feliz),say('I like this height better.')] => hand1
        ]
    ],

    %hand stuff
    [
    id ==> hand1,	
    type ==> neutral,
    arcs ==> [
        empty : [mood(neutral),say('I can use my right arm.'),switcharm(1),mood(feliz),grasp(0.0,0.5,Result),say('I can use my left arm.'),mood(sorpresa),switcharm(2),grasp(0.0,0.5,Result2)] => nav1
        ]
    ],

    %nav stuff
    [  
    id ==> nav1,
    type ==> neutral,
    arcs ==> [
        empty : [mood(neutral),say('I can turn this way.'),turn_fine(-30.0,Res),mood(feliz),say('Or this way.'),turn_fine(60.0,Res),say('Or towards you.'),turn_fine(-30.0,Res),mood(sorpresa)] => asking1
        ]
    ],

    %nav stuff two
    [  
    id ==> nav2,
    type ==> neutral,
    arcs ==> [
        empty : [say('Lets see how big this place is.'),turn_fine(-90.0,Res),advance_fine(0.5,Res),say('There is a wall here.'),turn_fine(180.0,Res),advance_fine(0.5,Res),say('Another wall.'),turn_fine(90.0,Res),say('I do not like being in this cage.')] => asking1
        ]
    ],

    %speech stuff
    [
    id ==> asking1,	
    type ==> neutral,
    arcs ==> [
        %empty : [say('I know what can make me feel better.'),say('I could talk to you. I could ask you a question. Like, hmmm.'),say('What do you like more. Milk or soda.')] => asking2
        empty : [mood(neutral),say('Let me ask you a question.'),say('What do you like more. Milk or soda.')] => asking2
        ]
    ],

    [
    id ==> asking2,
    type ==> listening(drink),
    arcs ==> [
        said(H): [say('You said you like '),say(H)] => asking3(H),
        said(nothing): [say('I could not hear you. I guess you do not like to talk loud. Oh well.')] => start
        ]
    ],

    [
    id ==> asking3(milk),
    type ==> neutral,
    arcs ==> [
        empty: [mood(sorpresa),say('How healthy of you. Big strong bones.')] => start
        ]
    ],

    [
    id ==> asking3(soda),
    type ==> neutral,
    arcs ==> [
        empty: [mood(triste),say('It has too much sugar. Drink healthier.')] => start
        ]
    ],

    [
    id ==> asking3(A),
    type ==> neutral,
    arcs ==> [
        empty: [say('That is nice, I guess.')] => start
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

