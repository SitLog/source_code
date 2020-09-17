diag_mod(qr_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
                  empty : empty => behavior
               ]
    ],
    
    [  
      id ==> behavior,
      type ==> recursive,
      embedded_dm ==> qr_code(2, true, Text, Status),
      arcs ==> [
       		      success : [say(['The QR code reads as follows ', Text])] => fs,
       			  error : [say('No text obtained from the QR code')] => fs
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

