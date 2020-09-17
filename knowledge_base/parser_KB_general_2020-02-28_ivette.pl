[

class(top, none, [], [], []),

class(grammar, top, [], [], []),

class(item, grammar, [], [], [
	[id=>item1,[rule_descriptor=>(item(I-R,X):-human(I-R,X))],[]],
	[id=>item2,[rule_descriptor=>(item(I-R,X):-object(I-R,X))],[]],
	[id=>item3,[rule_descriptor=>(item(I-R,X):-location(I-R,X))],[]],
	[id=>item4,[rule_descriptor=>(item(I-R,X):-room(I-R,X))],[]],
	[id=>item5,[rule_descriptor=>(item(I-R,X):-object_category(I-R,X))],[]],
	[id=>item6,[rule_descriptor=>(item(I-R,X):-category(I-R,X))],[]]
	]),

class(category, grammar, [], [], [
	[id=>category1,[rule_descriptor=>category([person|X]-X,class(human))],[]],
	[id=>category2,[rule_descriptor=>category([human|X]-X,class(human))],[]],
	[id=>category3,[rule_descriptor=>category([people|X]-X,class(human))],[]],
	[id=>category4,[rule_descriptor=>category([robot|X]-X,class(robot))],[]],
	[id=>category5,[rule_descriptor=>category([room|X]-X,class(room))],[]],
	[id=>category6,[rule_descriptor=>category([location|X]-X,class(location))],[]],
	[id=>category7,[rule_descriptor=>category([object|X]-X,class(object))],[]],
	[id=>category8,[rule_descriptor=>category([place|X]-X,class(place))],[]]
	]),

class(gesture, grammar, [], [], [
	[id=>gesture1,[rule_descriptor=>gesture([waving|X]-X,waving)],[]],
	[id=>gesture2,[rule_descriptor=>gesture([pointing,right|X]-X,pointing_right)],[]],
	[id=>gesture3,[rule_descriptor=>gesture([pointing,left|X]-X,pointing_left)],[]]
	]),

class(deliver, grammar, [], [], [
	[id=>deliver1,[rule_descriptor=>(deliver(X-Y,CMD):-take(X-N1,_),sentence_deliver_1(N1-N2,_),vbplace(N2-N3,_),sentence_deliver_2(N3-N4,_),item(N4-Y,_))],[]],
	[id=>deliver2,[rule_descriptor=>(deliver(X-Y,CMD):-vbplace(X-N1,_),sentence_deliver_3(N1-N2,_),item(N2-N3,_),sentence_deliver_4(N3-N4,_),item(N4-Y,_))],[]],
	[id=>deliver3,[rule_descriptor=>(deliver(X-Y,CMD):-vbbring(X-N1,_),sentence_deliver_5(N1-N2,_),item(N2-Y,_))],[]],
	[id=>deliver4,[rule_descriptor=>(deliver(X-Y,CMD):-vbdeliver(X-N1,_),sentence_deliver_3(N1-N2,_),item(N2-N3,_),sentence_deliver_6(N3-N4,_),someone(N4-Y,_))],[]],
	[id=>deliver5,[rule_descriptor=>(deliver(X-Y,CMD):-takefrom(X-N1,_),sentence_deliver_1(N1-N2,_),vbplace(N2-N3,_),sentence_deliver_2(N3-N4,_),item(N4-Y,_))],[]],
	[id=>deliver6,[rule_descriptor=>(deliver(X-Y,CMD):-goplace(X-N1,_),vbfind(N1-N2,_),sentence_deliver_3(N2-N3,_),item(N3-N4,_),sentence_deliver_1(N4-N5,_),place(N5-Y,_))],[]],
	[id=>deliver7,[rule_descriptor=>(deliver(X-Y,CMD):-goplace(X-N1,_),vbfind(N1-N2,_),sentence_deliver_3(N2-N3,_),item(N3-N4,_),sentence_deliver_1(N4-N5,_),delivme(N5-Y,_))],[]],
	[id=>deliver8,[rule_descriptor=>(deliver(X-Y,CMD):-goplace(X-N1,_),vbfind(N1-N2,_),sentence_deliver_3(N2-N3,_),item(N3-N4,_),sentence_deliver_1(N4-N5,_),delivat(N5-Y,_))],[]],
	[id=>deliver9,[rule_descriptor=>(deliver(X-Y,CMD):-vbbtake(X-N1,_),sentence_deliver_3(N1-N2,_),item(N2-N3,_),sentence_deliver_7(N3-N4,_),item(N4-N5,_),sentence_deliver_8(N5-N6,_),item(N6-Y,_))],[]],
	[id=>deliver10,[rule_descriptor=>(deliver(X-Y,CMD):-vbbring(X-N1,_),sentence_deliver_5(N1-N2,_),item(N2-N3,_),sentence_deliver_7(N3-N4,_),item(N4-Y,_))],[]],
	[id=>deliver11,[rule_descriptor=>(deliver(X-Y,CMD):-takefrom(X-N1,_),sentence_deliver_1(N1-N2,_),place(N2-Y,_))],[]],
	[id=>deliver12,[rule_descriptor=>(deliver(X-Y,CMD):-vbbtake(X-N1,_),sentence_deliver_9(N1-N2,_),luggage(N2-N3,_),sentence_deliver_8(N3-N4,_),taxi(N4-Y,_))],[]],
	[id=>deliver13,[rule_descriptor=>(deliver(X-Y,CMD):-takefrom(X-N1,_),sentence_deliver_1(N1-N2,_),delivme(N2-Y,_))],[]],
	[id=>deliver14,[rule_descriptor=>(deliver(X-Y,CMD):-takefrom(X-N1,_),sentence_deliver_1(N1-N2,_),delivat(N2-Y,_))],[]]
	]),

class(sentence_deliver, grammar, [], [], [
	[id=>sentence_deliver1,[rule_descriptor=>sentence_deliver_1([and|X]-X,_)],[]],
	[id=>sentence_deliver2,[rule_descriptor=>sentence_deliver_2([it,on,the|X]-X,_)],[]],
	[id=>sentence_deliver3,[rule_descriptor=>sentence_deliver_3([the|X]-X,_)],[]],
	[id=>sentence_deliver4,[rule_descriptor=>sentence_deliver_4([on,the|X]-X,_)],[]],
	[id=>sentence_deliver5,[rule_descriptor=>sentence_deliver_5([me,the|X]-X,_)],[]],
	[id=>sentence_deliver6,[rule_descriptor=>sentence_deliver_6([to|X]-X,_)],[]],
	[id=>sentence_deliver7,[rule_descriptor=>sentence_deliver_7([from,the|X]-X,_)],[]],
	[id=>sentence_deliver8,[rule_descriptor=>sentence_deliver_8([to,the|X]-X,_)],[]],
	[id=>sentence_deliver9,[rule_descriptor=>sentence_deliver_9([my|X]-X,_)],[]]
	]),

class(fndppl, grammar, [], [], [
	[id=>fndppl1,[rule_descriptor=>(fndppl(X-Y,CMD):-talk(X-N1,_),sentence_fndppl_1(N1-N2,_),whowhere(N2-Y,_))],[]],
	[id=>fndppl2,[rule_descriptor=>(fndppl(X-Y,CMD):-findp(X-N1,_),sentence_fndppl_2(N1-N2,_),item(N2-N3,_),sentence_fndppl_3(N3-N4,_),talk(N4-Y,_))],[]],
	[id=>fndppl3,[rule_descriptor=>(fndppl(X-Y,CMD):-goroom(X-N1,_),findp(N1-N2,_),sentence_fndppl_3(N2-N3,_),talk(N3-Y,_))],[]],
	[id=>fndppl4,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_4(X-N1,_),item(N1-Y,_))],[]],
	[id=>fndppl5,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_5(X-N1,_),item(N1-Y,_))],[]],
	[id=>fndppl6,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_6(X-N1,_),item(N1-Y,_))],[]],
	[id=>fndppl7,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_7(X-N1,_),item(N1-Y,_))],[]],
	[id=>fndppl8,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_8(X-N1,_),item(N1-Y,_))],[]],
	[id=>fndppl9,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_9(X-N1,_),item(N1-Y,_))],[]],
	[id=>fndppl10,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_10(X-N1,_),item(N1-N2,_),sentence_fndppl_11(N2-N3,_),pgenderp(N3-Y,_))],[]],
	[id=>fndppl11,[rule_descriptor=>(fndppl(X-Y,CMD):-sentence_fndppl_10(X-N1,_),item(N1-N2,_),sentence_fndppl_11(N2-N3,_),pose(N3-Y,_))],[]]
	]),

class(sentence_fndppl, grammar, [], [], [
	[id=>sentence_fndppl1,[rule_descriptor=>sentence_fndppl_1([to|X]-X,_)],[]],
	[id=>sentence_fndppl2,[rule_descriptor=>sentence_fndppl_2([in,the|X]-X,_)],[]],
	[id=>sentence_fndppl3,[rule_descriptor=>sentence_fndppl_3([and|X]-X,_)],[]],
	[id=>sentence_fndppl4,[rule_descriptor=>sentence_fndppl_4([tell,me,the,name,of,the,person,at,the|X]-X,_)],[]],
	[id=>sentence_fndppl5,[rule_descriptor=>sentence_fndppl_5([tell,me,the,gender,of,the,person,at,the|X]-X,_)],[]],
	[id=>sentence_fndppl6,[rule_descriptor=>sentence_fndppl_6([tell,me,the,pose,of,the,person,at,the|X]-X,_)],[]],
	[id=>sentence_fndppl7,[rule_descriptor=>sentence_fndppl_7([tell,me,the,name,of,the,person,in,the|X]-X,_)],[]],
	[id=>sentence_fndppl8,[rule_descriptor=>sentence_fndppl_8([tell,me,the,gender,of,the,person,in,the|X]-X,_)],[]],
	[id=>sentence_fndppl9,[rule_descriptor=>sentence_fndppl_9([tell,me,the,pose,of,the,person,in,the|X]-X,_)],[]],
	[id=>sentence_fndppl10,[rule_descriptor=>sentence_fndppl_10([tell,me,how,many,people,in,the|X]-X,_)],[]],
	[id=>sentence_fndppl11,[rule_descriptor=>sentence_fndppl_11([are|X]-X,_)],[]]
	]),

class(fndobj, grammar, [], [], [
	[id=>fndobj1,[rule_descriptor=>(fndobj(X-Y,CMD):-sentence_fndobj_1(X-N1,_),item(N1-N2,_),sentence_fndobj_2(N2-N3,_),item(N3-Y,_))],[]],
	[id=>fndobj3,[rule_descriptor=>(fndobj(X-Y,find(Object,Place)):-vbfind(X-N1,_),sentence_fndobj_3(N1-N2,_),item(N2-N3,Object),sentence_fndobj_4(N3-N4,_),item(N4-Y,Place))],[]],
	[id=>fndobj4,[rule_descriptor=>(fndobj(X-Y,CMD):-sentence_fndobj_5(X-N1,_),oprop(N1-N2,_),sentence_fndobj_6(N2-N3,_),item(N3-Y,_))],[]],
	[id=>fndobj5,[rule_descriptor=>(fndobj(X-Y,CMD):-sentence_fndobj_5(X-N1,_),oprop(N1-N2,_),item(N2-N3,_),sentence_fndobj_7(N3-N4,_),item(N4-Y,_))],[]],
	[id=>fndobj6,[rule_descriptor=>(fndobj(X-Y,CMD):-vbfind(X-N1,_),sentence_fndobj_8(N1-N2,_),item(N2-N3,_),sentence_fndobj_4(N3-N4,_),room(N4-Y,_))],[]],
	[id=>fndobj7,[rule_descriptor=>(fndobj(X-Y,CMD):-sentence_fndobj_9(X-N1,_),oprop(N1-N2,_),sentence_fndobj_10(N2-N3,_),item(N3-N4,_),sentence_fndobj_11(N4-Y,_))],[]],
	[id=>fndobj8,[rule_descriptor=>(fndobj(X-Y,CMD):-sentence_fndobj_9(X-N1,_),oprop(N1-N2,_),item(N2-N3,_),sentence_fndobj_7(N3-N4,_),item(N4-Y,_))],[]]
	]),

class(sentence_fndobj, grammar, [], [], [
	[id=>sentence_fndobj1,[rule_descriptor=>sentence_fndobj_1([tell,me,how,many|X]-X,_)],[]],
	[id=>sentence_fndobj2,[rule_descriptor=>sentence_fndobj_2([there,are,on,the|X]-X,_)],[]],
	[id=>sentence_fndobj3,[rule_descriptor=>sentence_fndobj_3([the|X]-X,_)],[]],
	[id=>sentence_fndobj4,[rule_descriptor=>sentence_fndobj_4([in,the|X]-X,_)],[]],
	[id=>sentence_fndobj5,[rule_descriptor=>sentence_fndobj_5([tell,me,whats,the|X]-X,_)],[]],
	[id=>sentence_fndobj6,[rule_descriptor=>sentence_fndobj_6([object,on,the|X]-X,_)],[]],
	[id=>sentence_fndobj7,[rule_descriptor=>sentence_fndobj_7([on,the|X]-X,_)],[]],
	[id=>sentence_fndobj8,[rule_descriptor=>sentence_fndobj_8([three|X]-X,_)],[]],
	[id=>sentence_fndobj9,[rule_descriptor=>sentence_fndobj_9([tell,me,which,are,the,three|X]-X,_)],[]],
	[id=>sentence_fndobj10,[rule_descriptor=>sentence_fndobj_10([objects,on,the|X]-X,_)],[]]
	]),

class(follow, grammar, [], [], [
	[id=>follow1,[rule_descriptor=>(follow(X-Y,CMD):-vbfollow(X-N1,_),item(N1-N2,_),sentence_follow_1(N2-N3,_),item(N3-N4,_),sentence_follow_2(N4-N5,_),item(N5-Y,_))],[]],
	[id=>follow2,[rule_descriptor=>(follow(X-Y,CMD):-sentence_follow_3(X-N1,_),item(N1-N2,_),sentence_follow_4(N2-N3,_),item(N3-N4,_),sentence_follow_5(N4-N5,_),vbfollow(N5-N6,_),pron(N6-N7,_),fllwdest(N7-Y,_))],[]],
	[id=>follow3,[rule_descriptor=>(follow(X-Y,CMD):-gobeacon(X-N1,_),sentence_follow_3(N1-N2,_),item(N2-N3,_),sentence_follow_5(N3-N4,_),vbfollow(N4-N5,_),pron(N5-N6,_),fllwhdst(N6-Y,_))],[]]
	]),

class(sentence_follow, grammar, [], [], [
	[id=>sentence_follow1,[rule_descriptor=>sentence_follow_1([from,the|X]-X,_)],[]],
	[id=>sentence_follow2,[rule_descriptor=>sentence_follow_2([to,the|X]-X,_)],[]],
	[id=>sentence_follow3,[rule_descriptor=>sentence_follow_3([meet|X]-X,_)],[]],
	[id=>sentence_follow4,[rule_descriptor=>sentence_follow_4([at,the|X]-X,_)],[]],
	[id=>sentence_follow5,[rule_descriptor=>sentence_follow_5([and|X]-X,_)],[]]
	]),

class(fllwhdst, grammar, [], [], [
	[id=>fllwhdst1,[rule_descriptor=>(fllwhdst(X-Y,CMD):-sentence_fllwhdst_1(X-N1,_),item(N1-Y,_))],[]]
	]),

class(sentence_fllwhdst, grammar, [], [], [
	[id=>sentence_fllwhdst1,[rule_descriptor=>sentence_fllwhdst_1([to,the|X]-X,_)],[]]
	]),

class(guide, grammar, [], [], [
	[id=>guide1,[rule_descriptor=>(guide(X-Y,CMD):-gdcmd(X-Y,_))],[]]
	]),

class(sentence_guide, grammar, [], [], []),

class(gdcmd, grammar, [], [], [
	[id=>gdcmd1,[rule_descriptor=>(gdcmd(X-Y,CMD):-vbguide(X-N1,_),item(N1-N2,_),sentence_gdcmd_1(N2-N3,_),item(N3-N4,_),sentence_gdcmd_2(N4-N5,_),item(N5-Y,_))],[]],
	[id=>gdcmd2,[rule_descriptor=>(gdcmd(X-Y,CMD):-sentence_gdcmd_3(X-N1,_),item(N1-N2,_),sentence_gdcmd_4(N2-N3,_),item(N3-N4,_),sentence_gdcmd_5(N4-N5,_),guideto(N5-Y,_))],[]],
	[id=>gdcmd3,[rule_descriptor=>(gdcmd(X-Y,CMD):-gobeacon(X-N1,_),sentence_gdcmd_3(N1-N2,_),item(N2-N3,_),sentence_gdcmd_5(N3-N4,_),guideto(N4-Y,_))],[]],
	[id=>gdcmd4,[rule_descriptor=>(gdcmd(X-Y,CMD):-vbguide(X-N1,_),item(N1-N2,_),sentence_gdcmd_2(N2-N3,_),item(N3-N4,_),gdwhere(N4-Y,_))],[]]
	]),

class(sentence_gdcmd, grammar, [], [], [
	[id=>sentence_gdcmd1,[rule_descriptor=>sentence_gdcmd_1([from,the|X]-X,_)],[]],
	[id=>sentence_gdcmd2,[rule_descriptor=>sentence_gdcmd_2([to,the|X]-X,_)],[]],
	[id=>sentence_gdcmd3,[rule_descriptor=>sentence_gdcmd_3([meet|X]-X,_)],[]],
	[id=>sentence_gdcmd4,[rule_descriptor=>sentence_gdcmd_4([at,the|X]-X,_)],[]],
	[id=>sentence_gdcmd5,[rule_descriptor=>sentence_gdcmd_5([and|X]-X,_)],[]]
	]),

class(guideto, grammar, [], [], [
	[id=>guideto1,[rule_descriptor=>(guideto(X-Y,CMD):-vbguide(X-N1,_),pron(N1-N2,_),sentence_guideto_1(N2-N3,_),item(N3-Y,_))],[]]
	]),

class(sentence_guideto, grammar, [], [], [
	[id=>sentence_guideto1,[rule_descriptor=>sentence_guideto_1([to,the|X]-X,_)],[]]
	]),

class(place, grammar, [], [], [
	[id=>place1,[rule_descriptor=>(place(X-Y,CMD):-vbplace(X-N1,_),sentence_place_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_place, grammar, [], [], [
	[id=>sentence_place1,[rule_descriptor=>sentence_place_1([it,on,the|X]-X,_)],[]]
	]),

class(goplace, grammar, [], [], [
	[id=>goplace1,[rule_descriptor=>(goplace(X-Y,CMD):-vbgopl(X-N1,_),sentence_goplace_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_goplace, grammar, [], [], [
	[id=>sentence_goplace1,[rule_descriptor=>sentence_goplace_1([to,the|X]-X,_)],[]]
	]),

class(gobeacon, grammar, [], [], [
	[id=>gobeacon1,[rule_descriptor=>(gobeacon(X-Y,CMD):-vbgopl(X-N1,_),sentence_gobeacon_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_gobeacon, grammar, [], [], [
	[id=>sentence_gobeacon1,[rule_descriptor=>sentence_gobeacon_1([to,the|X]-X,_)],[]]
	]),

class(goroom, grammar, [], [], [
	[id=>goroom1,[rule_descriptor=>(goroom(X-Y,CMD):-vbgopl(X-N1,_),sentence_goroom_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_goroom, grammar, [], [], [
	[id=>sentence_goroom1,[rule_descriptor=>sentence_goroom_1([to,the|X]-X,_)],[]]
	]),

class(take, grammar, [], [], [
	[id=>take1,[rule_descriptor=>(take(X-Y,CMD):-vbtake(X-N1,_),sentence_take_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_take, grammar, [], [], [
	[id=>sentence_take1,[rule_descriptor=>sentence_take_1([the|X]-X,_)],[]]
	]),

class(takefrom, grammar, [], [], [
	[id=>takefrom1,[rule_descriptor=>(takefrom(X-Y,CMD):-take(X-N1,_),sentence_takefrom_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_takefrom, grammar, [], [], [
	[id=>sentence_takefrom1,[rule_descriptor=>sentence_takefrom_1([from,the|X]-X,_)],[]]
	]),

class(delivme, grammar, [], [], [
	[id=>delivme1,[rule_descriptor=>(delivme(X-Y,CMD):-vbdeliver(X-N1,_),sentence_delivme_1(N1-Y,_))],[]]
	]),

class(sentence_delivme, grammar, [], [], [
	[id=>sentence_delivme1,[rule_descriptor=>sentence_delivme_1([it,to,me|X]-X,_)],[]]
	]),

class(delivto, grammar, [], [], [
	[id=>delivto1,[rule_descriptor=>(delivto(X-Y,CMD):-vbdeliver(X-N1,_),sentence_delivto_1(N1-N2,_),name(N2-Y,_))],[]]
	]),

class(sentence_delivto, grammar, [], [], [
	[id=>sentence_delivto1,[rule_descriptor=>sentence_delivto_1([it,to|X]-X,_)],[]]
	]),

class(delivat, grammar, [], [], [
	[id=>delivat1,[rule_descriptor=>(delivat(X-Y,CMD):-vbdeliver(X-N1,_),sentence_delivat_1(N1-N2,_),name(N2-N3,_),sentence_delivat_2(N3-N4,_),item(N4-Y,_))],[]]
	]),

class(sentence_delivat, grammar, [], [], [
	[id=>sentence_delivat1,[rule_descriptor=>sentence_delivat_1([it,to|X]-X,_)],[]],
	[id=>sentence_delivat2,[rule_descriptor=>sentence_delivat_2([at,the|X]-X,_)],[]]
	]),

class(answer, grammar, [], [], [
	[id=>answer1,[rule_descriptor=>(answer(X-Y,CMD):-sentence_answer_1(X-N1,_),question(N1-Y,_))],[]]
	]),

class(sentence_answer, grammar, [], [], [
	[id=>sentence_answer1,[rule_descriptor=>sentence_answer_1([answer,a|X]-X,_)],[]]
	]),

class(speak, grammar, [], [], [
	[id=>speak1,[rule_descriptor=>(speak(X-Y,CMD):-vbspeak(X-N1,_),whattosay(N1-Y,_))],[]]
	]),

class(sentence_speak, grammar, [], [], []),

class(whattosay, grammar, [], [], [
	[id=>whattosay1,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_1(X-Y,_))],[]],
	[id=>whattosay2,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_2(X-Y,_))],[]],
	[id=>whattosay3,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_3(X-Y,_))],[]],
	[id=>whattosay4,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_4(X-Y,_))],[]],
	[id=>whattosay5,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_5(X-Y,_))],[]],
	[id=>whattosay6,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_6(X-Y,_))],[]],
	[id=>whattosay7,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_7(X-Y,_))],[]],
	[id=>whattosay8,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_8(X-Y,_))],[]],
	[id=>whattosay9,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_9(X-Y,_))],[]],
	[id=>whattosay10,[rule_descriptor=>(whattosay(X-Y,CMD):-sentence_whattosay_10(X-Y,_))],[]]
	]),

class(sentence_whattosay, grammar, [], [], [
	[id=>sentence_whattosay1,[rule_descriptor=>sentence_whattosay_1([something,about,yourself|X]-X,_)],[]],
	[id=>sentence_whattosay2,[rule_descriptor=>sentence_whattosay_2([the,time|X]-X,_)],[]],
	[id=>sentence_whattosay3,[rule_descriptor=>sentence_whattosay_3([a,joke|X]-X,_)],[]],
	[id=>sentence_whattosay4,[rule_descriptor=>sentence_whattosay_4([what,day,is,today|X]-X,_)],[]],
	[id=>sentence_whattosay5,[rule_descriptor=>sentence_whattosay_5([what,day,is,tomorrow|X]-X,_)],[]],
	[id=>sentence_whattosay6,[rule_descriptor=>sentence_whattosay_6([your,teams,name|X]-X,_)],[]],
	[id=>sentence_whattosay7,[rule_descriptor=>sentence_whattosay_7([your,teams,country|X]-X,_)],[]],
	[id=>sentence_whattosay8,[rule_descriptor=>sentence_whattosay_8([your,teams,affiliation|X]-X,_)],[]],
	[id=>sentence_whattosay9,[rule_descriptor=>sentence_whattosay_9([the,day,of,the,week|X]-X,_)],[]],
	[id=>sentence_whattosay10,[rule_descriptor=>sentence_whattosay_10([the,day,of,the,month|X]-X,_)],[]]
	]),

class(vbfollow, grammar, [], [], [
	[id=>vbfollow1,[rule_descriptor=>(vbfollow(X-Y,CMD):-sentence_vbfollow_1(X-Y,_))],[]]
	]),

class(sentence_vbfollow, grammar, [], [], [
	[id=>sentence_vbfollow1,[rule_descriptor=>sentence_vbfollow_1([follow|X]-X,_)],[]]
	]),

class(polite, grammar, [], [], [
	[id=>polite1,[rule_descriptor=>(polite(X-Y,CMD):-sentence_polite_1(X-Y,_))],[]],
	[id=>polite2,[rule_descriptor=>(polite(X-Y,CMD):-sentence_polite_2(X-Y,_))],[]],
	[id=>polite3,[rule_descriptor=>(polite(X-Y,CMD):-sentence_polite_3(X-Y,_))],[]],
	[id=>polite5,[rule_descriptor=>(polite(X-Y,CMD):-sentence_polite_4(X-Y,_))],[]]
	]),

class(sentence_polite, grammar, [], [], [
	[id=>sentence_polite1,[rule_descriptor=>sentence_polite_1([could,you|X]-X,_)],[]],
	[id=>sentence_polite2,[rule_descriptor=>sentence_polite_2([robot,please|X]-X,_)],[]],
	[id=>sentence_polite3,[rule_descriptor=>sentence_polite_3([could,you,please|X]-X,_)],[]],
	[id=>sentence_polite4,[rule_descriptor=>sentence_polite_4([please|X]-X,_)],[]]
	]),

class(fllmeet, grammar, [], [], [
	[id=>fllmeet1,[rule_descriptor=>(fllmeet(X-Y,CMD):-sentence_fllmeet_1(X-N1,_),item(N1-Y,_))],[]],
	[id=>fllmeet2,[rule_descriptor=>(fllmeet(X-Y,CMD):-sentence_fllmeet_2(X-Y,_))],[]]
	]),

class(sentence_fllmeet, grammar, [], [], [
	[id=>sentence_fllmeet1,[rule_descriptor=>sentence_fllmeet_1([meet|X]-X,_)],[]],
	[id=>sentence_fllmeet2,[rule_descriptor=>sentence_fllmeet_2([find,a,person|X]-X,_)],[]]
	]),

class(fllwdest, grammar, [], [], [
	[id=>fllwdest1,[rule_descriptor=>(fllwdest(X-Y,CMD):-sentence_fllwdest_1(X-N1,_),item(N1-Y,_))],[]],
	[id=>fllwdest3,[rule_descriptor=>(fllwdest(X-Y,CMD):-fllwhdst(X-Y,_))],[]]
	]),

class(sentence_fllwdest, grammar, [], [], [
	[id=>sentence_fllwdest1,[rule_descriptor=>sentence_fllwdest_1([to,the|X]-X,_)],[]]
	]),

class(gdwhere, grammar, [], [], [
	[id=>gdwhere1,[rule_descriptor=>(gdwhere(X-Y,CMD):-sentence_gdwhere_1(X-N1,_),pron(N1-N2,_),sentence_gdwhere_2(N2-N3,_),item(N3-Y,_))],[]],
	[id=>gdwhere2,[rule_descriptor=>(gdwhere(X-Y,CMD):-sentence_gdwhere_3(X-N1,_),pron(N1-N2,_),sentence_gdwhere_2(N2-N3,_),item(N3-Y,_))],[]],
	[id=>gdwhere3,[rule_descriptor=>(gdwhere(X-Y,CMD):-sentence_gdwhere_4(X-N1,_),pron(N1-N2,_),sentence_gdwhere_2(N2-N3,_),item(N3-Y,_))],[]]
	]),

class(sentence_gdwhere, grammar, [], [], [
	[id=>sentence_gdwhere1,[rule_descriptor=>sentence_gdwhere_1([you,may,find|X]-X,_)],[]],
	[id=>sentence_gdwhere2,[rule_descriptor=>sentence_gdwhere_2([at,the|X]-X,_)],[]],
	[id=>sentence_gdwhere3,[rule_descriptor=>sentence_gdwhere_3([you,can,find|X]-X,_)],[]],
	[id=>sentence_gdwhere4,[rule_descriptor=>sentence_gdwhere_4([you,will,find|X]-X,_)],[]]
	]),

class(someone, grammar, [], [], [
	[id=>someone1,[rule_descriptor=>(someone(X-Y,CMD):-sentence_someone_1(X-Y,_))],[]],
	[id=>someone2,[rule_descriptor=>(someone(X-Y,CMD):-whowhere(X-Y,_))],[]]
	]),

class(sentence_someone, grammar, [], [], [
	[id=>sentence_someone1,[rule_descriptor=>sentence_someone_1([me|X]-X,_)],[]]
	]),

class(oprop, grammar, [], [], [
	[id=>oprop1,[rule_descriptor=>(oprop(X-Y,CMD):-sentence_oprop_1(X-Y,_))],[]],
	[id=>oprop2,[rule_descriptor=>(oprop(X-Y,CMD):-sentence_oprop_2(X-Y,_))],[]],
	[id=>oprop3,[rule_descriptor=>(oprop(X-Y,CMD):-sentence_oprop_3(X-Y,_))],[]],
	[id=>oprop4,[rule_descriptor=>(oprop(X-Y,CMD):-sentence_oprop_4(X-Y,_))],[]],
	[id=>oprop5,[rule_descriptor=>(oprop(X-Y,CMD):-sentence_oprop_5(X-Y,_))],[]],
	[id=>oprop6,[rule_descriptor=>(oprop(X-Y,CMD):-sentence_oprop_6(X-Y,_))],[]]
	]),

class(sentence_oprop, grammar, [], [], [
	[id=>sentence_oprop1,[rule_descriptor=>sentence_oprop_1([biggest|X]-X,_)],[]],
	[id=>sentence_oprop2,[rule_descriptor=>sentence_oprop_2([largest|X]-X,_)],[]],
	[id=>sentence_oprop3,[rule_descriptor=>sentence_oprop_3([smallest|X]-X,_)],[]],
	[id=>sentence_oprop4,[rule_descriptor=>sentence_oprop_4([heaviest|X]-X,_)],[]],
	[id=>sentence_oprop5,[rule_descriptor=>sentence_oprop_5([lightest|X]-X,_)],[]],
	[id=>sentence_oprop6,[rule_descriptor=>sentence_oprop_6([thinnest|X]-X,_)],[]]
	]),

class(talk, grammar, [], [], [
	[id=>talk1,[rule_descriptor=>(talk(X-Y,CMD):-answer(X-Y,_))],[]],
	[id=>talk2,[rule_descriptor=>(talk(X-Y,CMD):-speak(X-Y,_))],[]]
	]),

class(sentence_talk, grammar, [], [], []),

class(vbbtake, grammar, [], [], [
	[id=>vbbtake1,[rule_descriptor=>(vbbtake(X-Y,CMD):-sentence_vbbtake_1(X-Y,_))],[]],
	[id=>vbbtake2,[rule_descriptor=>(vbbtake(X-Y,CMD):-sentence_vbbtake_2(X-Y,_))],[]]
	]),

class(sentence_vbbtake, grammar, [], [], [
	[id=>sentence_vbbtake1,[rule_descriptor=>sentence_vbbtake_1([bring|X]-X,_)],[]],
	[id=>sentence_vbbtake2,[rule_descriptor=>sentence_vbbtake_2([take|X]-X,_)],[]]
	]),

class(vbplace, grammar, [], [], [
	[id=>vbplace1,[rule_descriptor=>(vbplace(X-Y,CMD):-sentence_vbplace_1(X-Y,_))],[]],
	[id=>vbplace2,[rule_descriptor=>(vbplace(X-Y,CMD):-sentence_vbplace_2(X-Y,_))],[]]
	]),

class(sentence_vbplace, grammar, [], [], [
	[id=>sentence_vbplace1,[rule_descriptor=>sentence_vbplace_1([put|X]-X,_)],[]],
	[id=>sentence_vbplace2,[rule_descriptor=>sentence_vbplace_2([place|X]-X,_)],[]]
	]),

class(vbbring, grammar, [], [], [
	[id=>vbbring1,[rule_descriptor=>(vbbring(X-Y,CMD):-sentence_vbbring_1(X-Y,_))],[]],
	[id=>vbbring2,[rule_descriptor=>(vbbring(X-Y,CMD):-sentence_vbbring_2(X-Y,_))],[]]
	]),

class(sentence_vbbring, grammar, [], [], [
	[id=>sentence_vbbring1,[rule_descriptor=>sentence_vbbring_1([bring|X]-X,_)],[]],
	[id=>sentence_vbbring2,[rule_descriptor=>sentence_vbbring_2([give|X]-X,_)],[]]
	]),

class(vbdeliver, grammar, [], [], [
	[id=>vbdeliver1,[rule_descriptor=>(vbdeliver(X-Y,CMD):-vbbring(X-Y,_))],[]],
	[id=>vbdeliver2,[rule_descriptor=>(vbdeliver(X-Y,CMD):-sentence_vbdeliver_1(X-Y,_))],[]]
	]),

class(sentence_vbdeliver, grammar, [], [], [
	[id=>sentence_vbdeliver1,[rule_descriptor=>sentence_vbdeliver_1([deliver|X]-X,_)],[]]
	]),

class(vbtake, grammar, [], [], [
	[id=>vbtake1,[rule_descriptor=>(vbtake(X-Y,CMD):-sentence_vbtake_1(X-Y,_))],[]],
	[id=>vbtake2,[rule_descriptor=>(vbtake(X-Y,CMD):-sentence_vbtake_2(X-Y,_))],[]],
	[id=>vbtake3,[rule_descriptor=>(vbtake(X-Y,CMD):-sentence_vbtake_3(X-Y,_))],[]],
	[id=>vbtake4,[rule_descriptor=>(vbtake(X-Y,CMD):-sentence_vbtake_4(X-Y,_))],[]]
	]),

class(sentence_vbtake, grammar, [], [], [
	[id=>sentence_vbtake1,[rule_descriptor=>sentence_vbtake_1([get|X]-X,_)],[]],
	[id=>sentence_vbtake2,[rule_descriptor=>sentence_vbtake_2([grasp|X]-X,_)],[]],
	[id=>sentence_vbtake3,[rule_descriptor=>sentence_vbtake_3([take|X]-X,_)],[]],
	[id=>sentence_vbtake4,[rule_descriptor=>sentence_vbtake_4([pick,up|X]-X,_)],[]]
	]),

class(vbspeak, grammar, [], [], [
	[id=>vbspeak1,[rule_descriptor=>(vbspeak(X-Y,CMD):-sentence_vbspeak_1(X-Y,_))],[]],
	[id=>vbspeak2,[rule_descriptor=>(vbspeak(X-Y,CMD):-sentence_vbspeak_2(X-Y,_))],[]]
	]),

class(sentence_vbspeak, grammar, [], [], [
	[id=>sentence_vbspeak1,[rule_descriptor=>sentence_vbspeak_1([tell|X]-X,_)],[]],
	[id=>sentence_vbspeak2,[rule_descriptor=>sentence_vbspeak_2([say|X]-X,_)],[]]
	]),

class(vbgopl, grammar, [], [], [
	[id=>vbgopl1,[rule_descriptor=>(vbgopl(X-Y,CMD):-sentence_vbgopl_1(X-Y,_))],[]],
	[id=>vbgopl2,[rule_descriptor=>(vbgopl(X-Y,CMD):-sentence_vbgopl_2(X-Y,_))],[]]
	]),

class(sentence_vbgopl, grammar, [], [], [
	[id=>sentence_vbgopl1,[rule_descriptor=>sentence_vbgopl_1([go|X]-X,_)],[]],
	[id=>sentence_vbgopl2,[rule_descriptor=>sentence_vbgopl_2([navigate|X]-X,_)],[]]
	]),

class(vbgor, grammar, [], [], [
	[id=>vbgor1,[rule_descriptor=>(vbgor(X-Y,CMD):-vbgopl(X-Y,_))],[]],
	[id=>vbgor2,[rule_descriptor=>(vbgor(X-Y,CMD):-sentence_vbgor_1(X-Y,_))],[]]
	]),

class(sentence_vbgor, grammar, [], [], [
	[id=>sentence_vbgor1,[rule_descriptor=>sentence_vbgor_1([enter|X]-X,_)],[]]
	]),

class(vbfind, grammar, [], [], [
	[id=>vbfind1,[rule_descriptor=>(vbfind(X-Y,CMD):-sentence_vbfind_1(X-Y,_))],[]],
	[id=>vbfind2,[rule_descriptor=>(vbfind(X-Y,CMD):-sentence_vbfind_2(X-Y,_))],[]],
	[id=>vbfind3,[rule_descriptor=>(vbfind(X-Y,CMD):-sentence_vbfind_3(X-Y,_))],[]]
	]),

class(sentence_vbfind, grammar, [], [], [
	[id=>sentence_vbfind1,[rule_descriptor=>sentence_vbfind_1([find|X]-X,_)],[]],
	[id=>sentence_vbfind2,[rule_descriptor=>sentence_vbfind_2([locate|X]-X,_)],[]],
	[id=>sentence_vbfind3,[rule_descriptor=>sentence_vbfind_3([look,for|X]-X,_)],[]]
	]),

class(vbguide, grammar, [], [], [
	[id=>vbguide1,[rule_descriptor=>(vbguide(X-Y,CMD):-sentence_vbguide_1(X-Y,_))],[]],
	[id=>vbguide2,[rule_descriptor=>(vbguide(X-Y,CMD):-sentence_vbguide_2(X-Y,_))],[]],
	[id=>vbguide3,[rule_descriptor=>(vbguide(X-Y,CMD):-sentence_vbguide_3(X-Y,_))],[]],
	[id=>vbguide4,[rule_descriptor=>(vbguide(X-Y,CMD):-sentence_vbguide_4(X-Y,_))],[]],
	[id=>vbguide5,[rule_descriptor=>(vbguide(X-Y,CMD):-sentence_vbguide_5(X-Y,_))],[]]
	]),

class(sentence_vbguide, grammar, [], [], [
	[id=>sentence_vbguide1,[rule_descriptor=>sentence_vbguide_1([guide|X]-X,_)],[]],
	[id=>sentence_vbguide2,[rule_descriptor=>sentence_vbguide_2([escort|X]-X,_)],[]],
	[id=>sentence_vbguide3,[rule_descriptor=>sentence_vbguide_3([take|X]-X,_)],[]],
	[id=>sentence_vbguide4,[rule_descriptor=>sentence_vbguide_4([lead|X]-X,_)],[]],
	[id=>sentence_vbguide5,[rule_descriptor=>sentence_vbguide_5([accompany|X]-X,_)],[]]
	]),

class(command, grammar, [], [], [
	[id=>command1,[rule_descriptor=>(command(X-Y,CMD):-polite(X-N1,_),command_wp(N1-Y,CMD))],[]],
	[id=>command2,[rule_descriptor=>(command(X-Y,CMD):-command_wp(X-Y,CMD))],[]]
	]),

class(command_wp, command, [], [], [
	[id=>command_wp1,[rule_descriptor=>(command_wp(X-Y,CMD):-fndppl(X-Y,CMD))],[]],
	[id=>command_wp2,[rule_descriptor=>(command_wp(X-Y,CMD):-fndobj(X-Y,CMD))],[]],
	[id=>command_wp3,[rule_descriptor=>(command_wp(X-Y,CMD):-guide(X-Y,CMD))],[]],
	[id=>command_wp4,[rule_descriptor=>(command_wp(X-Y,CMD):-follow(X-Y,CMD))],[]],
	[id=>command_wp5,[rule_descriptor=>(command_wp(X-Y,CMD):-followout(X-Y,CMD))],[]],
	[id=>command_wp6,[rule_descriptor=>(command_wp(X-Y,CMD):-incomplete(X-Y,CMD))],[]],
	[id=>command_wp7,[rule_descriptor=>(command_wp(X-Y,CMD):-man(X-Y,CMD))],[]],
	[id=>command_wp8,[rule_descriptor=>(command_wp(X-Y,CMD):-complexman(X-Y,CMD))],[]],
	[id=>command_wp9,[rule_descriptor=>(command_wp(X-Y,CMD):-partyhost(X-Y,CMD))],[]]
	]),

class(findp, grammar, [], [], [
	[id=>findp1,[rule_descriptor=>(findp(X-Y,CMD):-vbfind(X-N1,_),sentence_findp_1(N1-N2,_),pgenders(N2-Y,_))],[]],
	[id=>findp2,[rule_descriptor=>(findp(X-Y,CMD):-vbfind(X-N1,_),sentence_findp_2(N1-N2,_),gesture(N2-Y,_))],[]],
	[id=>findp3,[rule_descriptor=>(findp(X-Y,CMD):-vbfind(X-N1,_),sentence_findp_2(N1-N2,_),pose(N2-Y,_))],[]]
	]),

class(sentence_findp, grammar, [], [], [
	[id=>sentence_findp1,[rule_descriptor=>sentence_findp_1([a|X]-X,_)],[]],
	[id=>sentence_findp2,[rule_descriptor=>sentence_findp_2([a,person|X]-X,_)],[]]
	]),

class(whowhere, grammar, [], [], [
	[id=>whowhere1,[rule_descriptor=>(whowhere(X-Y,CMD):-sentence_whowhere_1(X-N1,_),gesture(N1-N2,_),sentence_whowhere_2(N2-N3,_),item(N3-Y,_))],[]]
	]),

class(sentence_whowhere, grammar, [], [], [
	[id=>sentence_whowhere1,[rule_descriptor=>sentence_whowhere_1([the,person|X]-X,_)],[]],
	[id=>sentence_whowhere2,[rule_descriptor=>sentence_whowhere_2([in,the|X]-X,_)],[]]
	]),

class(man, grammar, [], [], [
	[id=>man1,[rule_descriptor=>(man(X-Y,CMD):-deliver(X-Y,_))],[]]
	]),

class(sentence_man, grammar, [], [], []),

class(complexman, grammar, [], [], [
	[id=>complexman1,[rule_descriptor=>(complexman(X-Y,CMD):-cmancmd(X-Y,_))],[]]
	]),

class(sentence_complexman, grammar, [], [], []),

class(cmancmd, grammar, [], [], [
	[id=>cmancmd1,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbbtake(X-N1,_),sentence_cmancmd_1(N1-N2,_),item(N2-N3,_),sentence_cmancmd_2(N3-N4,_),item(N4-Y,_))],[]],
	[id=>cmancmd2,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbbring(X-N1,_),sentence_cmancmd_4(N1-N2,_),abspos(N2-N3,_),sentence_cmancmd_5(N3-N4,_),cmanobjsrc(N4-Y,_))],[]],
	[id=>cmancmd3,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbbring(X-N1,_),sentence_cmancmd_6(N1-N2,_),relpos(N2-N3,_),sentence_cmancmd_1(N3-N4,_),item(N4-N5,_),cmanobjsrc(N5-Y,_))],[]],
	[id=>cmancmd4,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbcleanup(X-N1,_),sentence_cmancmd_1(N1-N2,_),item(N2-Y,_))],[]],
	[id=>cmancmd5,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbtakeout(X-N1,_),sentence_cmancmd_1(N1-N2,_),garbage(N2-Y,_))],[]],
	[id=>cmancmd6,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbbring(X-N1,_),sentence_cmancmd_4(N1-N2,_),oprop(N2-N3,_),sentence_cmancmd_5(N3-N4,_),cmanobjsrc(N4-Y,_))],[]],
	[id=>cmancmd7,[rule_descriptor=>(cmancmd(X-Y,CMD):-vbbring(X-N1,_),sentence_cmancmd_4(N1-N2,_),oprop(N2-N3,_),item(N3-N4,_),cmanobjsrc(N4-Y,_))],[]]
	]),

class(sentence_cmancmd, grammar, [], [], [
	[id=>sentence_cmancmd1,[rule_descriptor=>sentence_cmancmd_1([the|X]-X,_)],[]],
	[id=>sentence_cmancmd2,[rule_descriptor=>sentence_cmancmd_2([to,the|X]-X,_)],[]],
	[id=>sentence_cmancmd4,[rule_descriptor=>sentence_cmancmd_4([me,the|X]-X,_)],[]],
	[id=>sentence_cmancmd5,[rule_descriptor=>sentence_cmancmd_5([object|X]-X,_)],[]],
	[id=>sentence_cmancmd6,[rule_descriptor=>sentence_cmancmd_6([me,the,object|X]-X,_)],[]]
	]),

class(cmanobjsrc, grammar, [], [], [
	[id=>cmanobjsrc1,[rule_descriptor=>(cmanobjsrc(X-Y,CMD):-sentence_cmanobjsrc_1(X-N1,_), item(N1-Y,_))],[]]
	]),

class(sentence_cmanobjsrc, grammar, [], [], [
	[id=>sentence_cmanobjsrc1,[rule_descriptor=>sentence_cmanobjsrc_1([from,the|X]-X,_)],[]]
	]),

class(followout, grammar, [], [], [
	[id=>followout1,[rule_descriptor=>(followout(X-Y,CMD):-sentence_followout_1(X-N1,_),item(N1-N2,_),sentence_followout_2(N2-N3,_),item(N3-N4,_),vbfollow(N4-N5,_),pron(N5-N6,_),sentence_followout_3(N6-N7,_),goroom(N7-Y,_))],[]],
	[id=>followout2,[rule_descriptor=>(followout(X-Y,CMD):-sentence_followout_1(X-N2,_),item(N2-N3,_),sentence_followout_2(N3-N4,_),item(N4-N5,_),vbfollow(N5-N6,_),pron(N6-N7,_),sentence_followout_3(N7-N8,_),vbguide(N8-N9,_),pron(N9-N10,_),sentence_followout_4(N10-Y,_))],[]]
	]),

class(sentence_followout, grammar, [], [], [
	[id=>sentence_followout1,[rule_descriptor=>sentence_followout_1([meet|X]-X,_)],[]],
	[id=>sentence_followout2,[rule_descriptor=>sentence_followout_2([at,the|X]-X,_)],[]],
	[id=>sentence_followout3,[rule_descriptor=>sentence_followout_3([and|X]-X,_)],[]],
	[id=>sentence_followout4,[rule_descriptor=>sentence_followout_4([back|X]-X,_)],[]]
	]),

class(incomplete, grammar, [], [], [
	[id=>incomplete1,[rule_descriptor=>(incomplete(X-Y,CMD):-vbfollow(X-N1,_),item(N1-N2,_),sentence_incomplete_1(N2-N3,_),item(N3-Y,_))],[]],
	[id=>incomplete2,[rule_descriptor=>(incomplete(X-Y,CMD):-vbbring(X-N1,_),sentence_incomplete_3(N1-N2,_),item(N2-Y,_))],[]],
	[id=>incomplete3,[rule_descriptor=>(incomplete(X-Y,CMD):-vbdeliver(X-N1,_),item(N1-N2,_),sentence_incomplete_4(N2-N3,_),someone(N3-Y,_))],[]],
	[id=>incomplete4,[rule_descriptor=>(incomplete(X-Y,CMD):-vbguide(X-N1,_),item(N1-N2,_),sentence_incomplete_1(N2-N3,_),item(N3-N5,_),item(N5-Y,_))],[]],
	[id=>incomplete5,[rule_descriptor=>(incomplete(X-Y,CMD):-sentence_incomplete_6(X-N1,_),item(N1-N2,_),sentence_incomplete_7(N2-N3,_),vbguide(N3-N4,_),pron(N4-Y,_))],[]],
	[id=>incomplete6,[rule_descriptor=>(incomplete(X-Y,CMD):-gobeacon(X-N1,_),sentence_incomplete_6(N1-N2,_),item(N2-N3,_),sentence_incomplete_7(N3-N4,_),vbguide(N4-N5,_),pron(N5-Y,_))],[]]
	]),

class(sentence_incomplete, grammar, [], [], [
	[id=>sentence_incomplete1,[rule_descriptor=>sentence_incomplete_1([is,at,the|X]-X,_)],[]],
	[id=>sentence_incomplete3,[rule_descriptor=>sentence_incomplete_3([me,the|X]-X,_)],[]],
	[id=>sentence_incomplete4,[rule_descriptor=>sentence_incomplete_4([to|X]-X,_)],[]],
	[id=>sentence_incomplete6,[rule_descriptor=>sentence_incomplete_6([meet|X]-X,_)],[]],
	[id=>sentence_incomplete7,[rule_descriptor=>sentence_incomplete_7([and|X]-X,_)],[]]
	]),

class(partyhost, grammar, [], [], [
	[id=>partyhost1,[rule_descriptor=>(partyhost(X-Y,CMD):-vbmeet(X-N1,_),name(N1-N2,_),sentence_partyhost_1(N2-N3,_),door(N3-N4,_),sentence_partyhost_2(N4-N5,_),pron(N5-N6,_),sentence_partyhost_3(N6-N7,_),phpeopler(N7-Y,_))],[]],
	[id=>partyhost2,[rule_descriptor=>(partyhost(X-Y,CMD):-vbmeet(X-N1,_),name(N1-N2,_),sentence_partyhost_1(N2-N3,_),item(N3-N4,_),sentence_partyhost_4(N4-N5,_),pron(N5-N6,_),sentence_partyhost_5(N6-Y,_))],[]],
	[id=>partyhost3,[rule_descriptor=>(partyhost(X-Y,CMD):-vbmeet(X-N1,_),item(N1-N2,_),sentence_partyhost_1(N2-N3,_),item(N3-N4,_),sentence_partyhost_2(N4-N5,_),pron(N5-N6,_),sentence_partyhost_3(N6-N7,_),item(N7-N8,_),sentence_partyhost_1(N8-N9,_),item(N9-Y,_))],[]],
	[id=>partyhost4,[rule_descriptor=>(partyhost(X-Y,CMD):-vbmeet(X-N1,_),item(N1-N2,_),sentence_partyhost_1(N2-N3,_),item(N3-N4,_),sentence_partyhost_6(N4-N5,_),vbguide(N5-N6,_),pron(N6-N7,_),sentence_partyhost_3(N7-N8,_),item(N8-N9,_),taxi(N9-Y,_))],[]],
	[id=>partyhost5,[rule_descriptor=>(partyhost(X-Y,CMD):-vbserve(X-N1,_),sentence_partyhost_7(N1-N2,_),phpeopler(N2-Y,_))],[]],
	[id=>partyhost6,[rule_descriptor=>(partyhost(X-Y,CMD):-vbserve(X-N1,_),sentence_partyhost_8(N1-N2,_),phpeopler(N2-Y,_))],[]]
	]),

class(sentence_partyhost, grammar, [], [], [
	[id=>sentence_partyhost1,[rule_descriptor=>sentence_partyhost_1([at,the|X]-X,_)],[]],
	[id=>sentence_partyhost2,[rule_descriptor=>sentence_partyhost_2([and,introduce|X]-X,_)],[]],
	[id=>sentence_partyhost3,[rule_descriptor=>sentence_partyhost_3([to|X]-X,_)],[]],
	[id=>sentence_partyhost4,[rule_descriptor=>sentence_partyhost_4([and,ask|X]-X,_)],[]],
	[id=>sentence_partyhost5,[rule_descriptor=>sentence_partyhost_5([to,leave|X]-X,_)],[]],
	[id=>sentence_partyhost6,[rule_descriptor=>sentence_partyhost_6([and|X]-X,_)],[]],
	[id=>sentence_partyhost7,[rule_descriptor=>sentence_partyhost_7([drinks,to|X]-X,_)],[]],
	[id=>sentence_partyhost8,[rule_descriptor=>sentence_partyhost_8([snacks,to|X]-X,_)],[]]
	]),

class(phpeopler, grammar, [], [], [
	[id=>phpeopler1,[rule_descriptor=>(phpeopler(X-Y,CMD):-phpeople(X-N1,_),sentence_phpeopler_1(N1-N2,_),item(N2-Y,_))],[]]
	]),

class(sentence_phpeopler, grammar, [], [], [
	[id=>sentence_phpeopler1,[rule_descriptor=>sentence_phpeopler_1([in,the|X]-X,_)],[]]
	]),

class(relpos, grammar, [], [], [
	[id=>relpos1,[rule_descriptor=>(relpos(X-Y,CMD):-sentence_relpos_1(X-Y,_))],[]],
	[id=>relpos2,[rule_descriptor=>(relpos(X-Y,CMD):-sentence_relpos_2(X-Y,_))],[]],
	[id=>relpos3,[rule_descriptor=>(relpos(X-Y,CMD):-sentence_relpos_3(X-Y,_))],[]],
	[id=>relpos4,[rule_descriptor=>(relpos(X-Y,CMD):-sentence_relpos_4(X-Y,_))],[]],
	[id=>relpos5,[rule_descriptor=>(relpos(X-Y,CMD):-sentence_relpos_5(X-Y,_))],[]],
	[id=>relpos6,[rule_descriptor=>(relpos(X-Y,CMD):-sentence_relpos_6(X-Y,_))],[]]
	]),

class(sentence_relpos, grammar, [], [], [
	[id=>sentence_relpos1,[rule_descriptor=>sentence_relpos_1([on,top,of|X]-X,_)],[]],
	[id=>sentence_relpos2,[rule_descriptor=>sentence_relpos_2([at,the,left,of|X]-X,_)],[]],
	[id=>sentence_relpos3,[rule_descriptor=>sentence_relpos_3([at,the,right,of|X]-X,_)],[]],
	[id=>sentence_relpos4,[rule_descriptor=>sentence_relpos_4([above|X]-X,_)],[]],
	[id=>sentence_relpos5,[rule_descriptor=>sentence_relpos_5([behind|X]-X,_)],[]],
	[id=>sentence_relpos6,[rule_descriptor=>sentence_relpos_6([under|X]-X,_)],[]]
	]),

class(pgenderp, grammar, [], [], [
	[id=>pgenderp1,[rule_descriptor=>(pgenderp(X-Y,CMD):-sentence_pgenderp_1(X-Y,_))],[]],
	[id=>pgenderp2,[rule_descriptor=>(pgenderp(X-Y,CMD):-sentence_pgenderp_2(X-Y,_))],[]],
	[id=>pgenderp3,[rule_descriptor=>(pgenderp(X-Y,CMD):-sentence_pgenderp_3(X-Y,_))],[]],
	[id=>pgenderp4,[rule_descriptor=>(pgenderp(X-Y,CMD):-sentence_pgenderp_4(X-Y,_))],[]],
	[id=>pgenderp5,[rule_descriptor=>(pgenderp(X-Y,CMD):-sentence_pgenderp_5(X-Y,_))],[]],
	[id=>pgenderp6,[rule_descriptor=>(pgenderp(X-Y,CMD):-sentence_pgenderp_6(X-Y,_))],[]]
	]),

class(sentence_pgenderp, grammar, [], [], [
	[id=>sentence_pgenderp1,[rule_descriptor=>sentence_pgenderp_1([men|X]-X,_)],[]],
	[id=>sentence_pgenderp2,[rule_descriptor=>sentence_pgenderp_2([women|X]-X,_)],[]],
	[id=>sentence_pgenderp3,[rule_descriptor=>sentence_pgenderp_3([boys|X]-X,_)],[]],
	[id=>sentence_pgenderp4,[rule_descriptor=>sentence_pgenderp_4([girls|X]-X,_)],[]],
	[id=>sentence_pgenderp5,[rule_descriptor=>sentence_pgenderp_5([male|X]-X,_)],[]],
	[id=>sentence_pgenderp6,[rule_descriptor=>sentence_pgenderp_6([female|X]-X,_)],[]]
	]),

class(pose, grammar, [], [], [
	[id=>pose1,[rule_descriptor=>(pose(X-Y,CMD):-sentence_pose_1(X-Y,_))],[]],
	[id=>pose2,[rule_descriptor=>(pose(X-Y,CMD):-sentence_pose_2(X-Y,_))],[]],
	[id=>pose3,[rule_descriptor=>(pose(X-Y,CMD):-sentence_pose_3(X-Y,_))],[]]
	]),

class(sentence_pose, grammar, [], [], [
	[id=>sentence_pose1,[rule_descriptor=>sentence_pose_1([sitting|X]-X,_)],[]],
	[id=>sentence_pose2,[rule_descriptor=>sentence_pose_2([standing|X]-X,_)],[]],
	[id=>sentence_pose3,[rule_descriptor=>sentence_pose_3([lying,down|X]-X,_)],[]]
	]),

class(abspos, grammar, [], [], [
	[id=>abspos1,[rule_descriptor=>(abspos(X-Y,CMD):-sentence_abspos_1(X-Y,_))],[]],
	[id=>abspos2,[rule_descriptor=>(abspos(X-Y,CMD):-sentence_abspos_2(X-Y,_))],[]]
	]),

class(sentence_abspos, grammar, [], [], [
	[id=>sentence_abspos1,[rule_descriptor=>sentence_abspos_1([left,most|X]-X,_)],[]],
	[id=>sentence_abspos2,[rule_descriptor=>sentence_abspos_2([right,most|X]-X,_)],[]]
	]),

class(garbage, grammar, [], [], [
	[id=>garbage1,[rule_descriptor=>(garbage(X-Y,CMD):-sentence_garbage_1(X-Y,_))],[]],
	[id=>garbage2,[rule_descriptor=>(garbage(X-Y,CMD):-sentence_garbage_2(X-Y,_))],[]],
	[id=>garbage3,[rule_descriptor=>(garbage(X-Y,CMD):-sentence_garbage_3(X-Y,_))],[]],
	[id=>garbage4,[rule_descriptor=>(garbage(X-Y,CMD):-sentence_garbage_4(X-Y,_))],[]],
	[id=>garbage5,[rule_descriptor=>(garbage(X-Y,CMD):-sentence_garbage_5(X-Y,_))],[]],
	[id=>garbage6,[rule_descriptor=>(garbage(X-Y,CMD):-sentence_garbage_6(X-Y,_))],[]]
	]),

class(sentence_garbage, grammar, [], [], [
	[id=>sentence_garbage1,[rule_descriptor=>sentence_garbage_1([litter|X]-X,_)],[]],
	[id=>sentence_garbage2,[rule_descriptor=>sentence_garbage_2([garbage|X]-X,_)],[]],
	[id=>sentence_garbage3,[rule_descriptor=>sentence_garbage_3([trash|X]-X,_)],[]],
	[id=>sentence_garbage4,[rule_descriptor=>sentence_garbage_4([waste|X]-X,_)],[]],
	[id=>sentence_garbage5,[rule_descriptor=>sentence_garbage_5([debris|X]-X,_)],[]],
	[id=>sentence_garbage6,[rule_descriptor=>sentence_garbage_6([junk|X]-X,_)],[]]
	]),

class(luggage, grammar, [], [], [
	[id=>luggage1,[rule_descriptor=>(luggage(X-Y,CMD):-sentence_luggage_1(X-Y,_))],[]],
	[id=>luggage2,[rule_descriptor=>(luggage(X-Y,CMD):-sentence_luggage_2(X-Y,_))],[]],
	[id=>luggage3,[rule_descriptor=>(luggage(X-Y,CMD):-sentence_luggage_3(X-Y,_))],[]],
	[id=>luggage4,[rule_descriptor=>(luggage(X-Y,CMD):-sentence_luggage_4(X-Y,_))],[]],
	[id=>luggage5,[rule_descriptor=>(luggage(X-Y,CMD):-sentence_luggage_5(X-Y,_))],[]]
	]),

class(sentence_luggage, grammar, [], [], [
	[id=>sentence_luggage1,[rule_descriptor=>sentence_luggage_1([bag|X]-X,_)],[]],
	[id=>sentence_luggage2,[rule_descriptor=>sentence_luggage_2([baggage|X]-X,_)],[]],
	[id=>sentence_luggage3,[rule_descriptor=>sentence_luggage_3([valise|X]-X,_)],[]],
	[id=>sentence_luggage4,[rule_descriptor=>sentence_luggage_4([suitcase|X]-X,_)],[]],
	[id=>sentence_luggage5,[rule_descriptor=>sentence_luggage_5([trolley|X]-X,_)],[]]
	]),

class(taxi, grammar, [], [], [
	[id=>taxi1,[rule_descriptor=>(taxi(X-Y,CMD):-sentence_taxi_1(X-Y,_))],[]],
	[id=>taxi2,[rule_descriptor=>(taxi(X-Y,CMD):-sentence_taxi_2(X-Y,_))],[]],
	[id=>taxi3,[rule_descriptor=>(taxi(X-Y,CMD):-sentence_taxi_3(X-Y,_))],[]]
	]),

class(sentence_taxi, grammar, [], [], [
	[id=>sentence_taxi1,[rule_descriptor=>sentence_taxi_1([taxi|X]-X,_)],[]],
	[id=>sentence_taxi2,[rule_descriptor=>sentence_taxi_2([cab|X]-X,_)],[]],
	[id=>sentence_taxi3,[rule_descriptor=>sentence_taxi_3([uber|X]-X,_)],[]]
	]),

class(door, grammar, [], [], [
	[id=>door1,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_1(X-Y,_))],[]],
	[id=>door2,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_2(X-Y,_))],[]],
	[id=>door3,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_3(X-Y,_))],[]],
	[id=>door4,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_4(X-Y,_))],[]],
	[id=>door5,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_5(X-Y,_))],[]],
	[id=>door6,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_6(X-Y,_))],[]],
	[id=>door7,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_7(X-Y,_))],[]],
	[id=>door8,[rule_descriptor=>(door(X-Y,CMD):-sentence_door_8(X-Y,_))],[]]
	]),

class(sentence_door, grammar, [], [], [
	[id=>sentence_door1,[rule_descriptor=>sentence_door_1([front,entrance|X]-X,_)],[]],
	[id=>sentence_door2,[rule_descriptor=>sentence_door_2([back,entrance|X]-X,_)],[]],
	[id=>sentence_door3,[rule_descriptor=>sentence_door_3([main,entrance|X]-X,_)],[]],
	[id=>sentence_door4,[rule_descriptor=>sentence_door_4([rear,entrance|X]-X,_)],[]],
	[id=>sentence_door5,[rule_descriptor=>sentence_door_5([front,door|X]-X,_)],[]],
	[id=>sentence_door6,[rule_descriptor=>sentence_door_6([back,door|X]-X,_)],[]],
	[id=>sentence_door7,[rule_descriptor=>sentence_door_7([main,door|X]-X,_)],[]],
	[id=>sentence_door8,[rule_descriptor=>sentence_door_8([rear,door|X]-X,_)],[]]
	]),

class(vbtakeout, grammar, [], [], [
	[id=>vbtakeout1,[rule_descriptor=>(vbtakeout(X-Y,CMD):-sentence_vbtakeout_1(X-Y,_))],[]],
	[id=>vbtakeout3,[rule_descriptor=>(vbtakeout(X-Y,CMD):-sentence_vbtakeout_2(X-Y,_))],[]]
	]),

class(sentence_vbtakeout, grammar, [], [], [
	[id=>sentence_vbtakeout1,[rule_descriptor=>sentence_vbtakeout_1([take,out|X]-X,_)],[]],
	[id=>sentence_vbtakeout2,[rule_descriptor=>sentence_vbtakeout_2([dump|X]-X,_)],[]]
	]),

class(vbcleanup, grammar, [], [], [
	[id=>vbcleanup2,[rule_descriptor=>(vbcleanup(X-Y,CMD):-sentence_vbcleanup_1(X-Y,_))],[]],
	[id=>vbcleanup3,[rule_descriptor=>(vbcleanup(X-Y,CMD):-sentence_vbcleanup_2(X-Y,_))],[]],
	[id=>vbcleanup4,[rule_descriptor=>(vbcleanup(X-Y,CMD):-sentence_vbcleanup_3(X-Y,_))],[]],
	[id=>vbcleanup5,[rule_descriptor=>(vbcleanup(X-Y,CMD):-sentence_vbcleanup_4(X-Y,_))],[]],
	[id=>vbcleanup6,[rule_descriptor=>(vbcleanup(X-Y,CMD):-sentence_vbcleanup_5(X-Y,_))],[]]
	]),

class(sentence_vbcleanup, grammar, [], [], [
	[id=>sentence_vbcleanup1,[rule_descriptor=>sentence_vbcleanup_1([neaten|X]-X,_)],[]],
	[id=>sentence_vbcleanup2,[rule_descriptor=>sentence_vbcleanup_2([order|X]-X,_)],[]],
	[id=>sentence_vbcleanup3,[rule_descriptor=>sentence_vbcleanup_3([clean,out|X]-X,_)],[]],
	[id=>sentence_vbcleanup4,[rule_descriptor=>sentence_vbcleanup_4([clean,up|X]-X,_)],[]],
	[id=>sentence_vbcleanup5,[rule_descriptor=>sentence_vbcleanup_5([tidy,op|X]-X,_)],[]]
	]),

class(vbserve, grammar, [], [], [
	[id=>vbserve1,[rule_descriptor=>(vbserve(X-Y,CMD):-sentence_vbserve_1(X-Y,_))],[]],
	[id=>vbserve2,[rule_descriptor=>(vbserve(X-Y,CMD):-sentence_vbserve_2(X-Y,_))],[]],
	[id=>vbserve3,[rule_descriptor=>(vbserve(X-Y,CMD):-sentence_vbserve_3(X-Y,_))],[]],
	[id=>vbserve4,[rule_descriptor=>(vbserve(X-Y,CMD):-sentence_vbserve_4(X-Y,_))],[]],
	[id=>vbserve5,[rule_descriptor=>(vbserve(X-Y,CMD):-sentence_vbserve_5(X-Y,_))],[]],
	[id=>vbserve6,[rule_descriptor=>(vbserve(X-Y,CMD):-sentence_vbserve_6(X-Y,_))],[]]
	]),

class(sentence_vbserve, grammar, [], [], [
	[id=>sentence_vbserve1,[rule_descriptor=>sentence_vbserve_1([serve|X]-X,_)],[]],
	[id=>sentence_vbserve2,[rule_descriptor=>sentence_vbserve_2([arrange|X]-X,_)],[]],
	[id=>sentence_vbserve3,[rule_descriptor=>sentence_vbserve_3([deliver|X]-X,_)],[]],
	[id=>sentence_vbserve4,[rule_descriptor=>sentence_vbserve_4([distribute|X]-X,_)],[]],
	[id=>sentence_vbserve5,[rule_descriptor=>sentence_vbserve_5([give|X]-X,_)],[]],
	[id=>sentence_vbserve6,[rule_descriptor=>sentence_vbserve_6([provide|X]-X,_)],[]]
	]),

class(vbmeet, grammar, [], [], [
	[id=>vbmeet1,[rule_descriptor=>(vbmeet(X-Y,CMD):-sentence_vbmeet_1(X-Y,_))],[]],
	[id=>vbmeet2,[rule_descriptor=>(vbmeet(X-Y,CMD):-sentence_vbmeet_2(X-Y,_))],[]],
	[id=>vbmeet3,[rule_descriptor=>(vbmeet(X-Y,CMD):-sentence_vbmeet_3(X-Y,_))],[]],
	[id=>vbmeet4,[rule_descriptor=>(vbmeet(X-Y,CMD):-sentence_vbmeet_4(X-Y,_))],[]]
	]),

class(sentence_vbmeet, grammar, [], [], [
	[id=>sentence_vbmeet1,[rule_descriptor=>sentence_vbmeet_1([contact|X]-X,_)],[]],
	[id=>sentence_vbmeet2,[rule_descriptor=>sentence_vbmeet_2([face|X]-X,_)],[]],
	[id=>sentence_vbmeet3,[rule_descriptor=>sentence_vbmeet_3([find|X]-X,_)],[]],
	[id=>sentence_vbmeet4,[rule_descriptor=>sentence_vbmeet_4([greet|X]-X,_)],[]]
	]),

class(phpeople, grammar, [], [], [
	[id=>phpeople1,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_1(X-Y,_))],[]],
	[id=>phpeople2,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_2(X-Y,_))],[]],
	[id=>phpeople3,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_3(X-Y,_))],[]],
	[id=>phpeople4,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_4(X-Y,_))],[]],
	[id=>phpeople5,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_5(X-Y,_))],[]],
	[id=>phpeople6,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_6(X-Y,_))],[]],
	[id=>phpeople7,[rule_descriptor=>(phpeople(X-Y,CMD):-sentence_phpeople_7(X-Y,_))],[]]
	]),

class(sentence_phpeople, grammar, [], [], [
	[id=>sentence_phpeople1,[rule_descriptor=>sentence_phpeople_1([everyone|X]-X,_)],[]],
	[id=>sentence_phpeople2,[rule_descriptor=>sentence_phpeople_2([all,the,people|X]-X,_)],[]],
	[id=>sentence_phpeople3,[rule_descriptor=>sentence_phpeople_3([all,the,men|X]-X,_)],[]],
	[id=>sentence_phpeople4,[rule_descriptor=>sentence_phpeople_4([all,the,women|X]-X,_)],[]],
	[id=>sentence_phpeople5,[rule_descriptor=>sentence_phpeople_5([all,the,guests|X]-X,_)],[]],
	[id=>sentence_phpeople6,[rule_descriptor=>sentence_phpeople_6([all,the,elders|X]-X,_)],[]],
	[id=>sentence_phpeople7,[rule_descriptor=>sentence_phpeople_7([all,the,children|X]-X,_)],[]]
	]),

class(pgenders, grammar, [], [], [
	[id=>pgenders1,[rule_descriptor=>(pgenders(X-Y,CMD):-sentence_pgenders_1(X-Y,_))],[]],
	[id=>pgenders2,[rule_descriptor=>(pgenders(X-Y,CMD):-sentence_pgenders_2(X-Y,_))],[]],
	[id=>pgenders3,[rule_descriptor=>(pgenders(X-Y,CMD):-sentence_pgenders_3(X-Y,_))],[]],
	[id=>pgenders4,[rule_descriptor=>(pgenders(X-Y,CMD):-sentence_pgenders_4(X-Y,_))],[]],
	[id=>pgenders5,[rule_descriptor=>(pgenders(X-Y,CMD):-sentence_pgenders_5(X-Y,_))],[]],
	[id=>pgenders6,[rule_descriptor=>(pgenders(X-Y,CMD):-sentence_pgenders_6(X-Y,_))],[]]
	]),

class(sentence_pgenders, grammar, [], [], [
	[id=>sentence_pgenders1,[rule_descriptor=>sentence_pgenders_1([man|X]-X,_)],[]],
	[id=>sentence_pgenders2,[rule_descriptor=>sentence_pgenders_2([woman|X]-X,_)],[]],
	[id=>sentence_pgenders3,[rule_descriptor=>sentence_pgenders_3([boy|X]-X,_)],[]],
	[id=>sentence_pgenders4,[rule_descriptor=>sentence_pgenders_4([girl|X]-X,_)],[]],
	[id=>sentence_pgenders5,[rule_descriptor=>sentence_pgenders_5([male,person|X]-X,_)],[]],
	[id=>sentence_pgenders6,[rule_descriptor=>sentence_pgenders_6([female,person|X]-X,_)],[]]
	])


]