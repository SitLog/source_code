%--------------------------------------------------
% Initializing the cognitive model
%--------------------------------------------------

initializing_cognitive_model:-
	write('Starting cognitive model'),nl,
	initializing_parser_general.

% Basic structure for the commands related to speech and person 
% recognition
% Cognitive command recieve a question in natural language and produces an answer in natural language
% cognitive_command(Question in natural language, answer in natural language)
% e.g., Question_NL: 'How many people are in the crowd'
%		Answer_NL: 'There are 6 persons in the crowd'
cognitive_command(Question_NL,Answer_NL):-
	write('Question in NL: '), write(Question_NL),nl,
	spr_question(Question_NL,Question_LF),
	write('Question in LF: '), write(Question_LF),nl,
	consult_LF(Question_LF, Answer_LF),
	write('Answer in LF: '), write(Answer_LF), nl,
	nl_generator(Question_LF, Answer_LF, Answer_NL),
	write('Answer in NL: '),write(Answer_NL),nl.


%--------------------------------------------------------------
% Logical Answer
%--------------------------------------------------------------

% consult_LF para las preguntas fijas
% e.g., Question_LF: [say(your name)]
%		Answer_LF: golem
% Questions for the montreal
consult_LF([say('whos the most handsome person in canada')], 'i that justin trudeau is very handsome'):-!.
consult_LF([say('how many time zones are there in canada')], 'canada spans almost 10 million square km and comprises 6 time zones'):-!.
consult_LF([say('whats the longest street in the world')], 'yonge street in ontario is the longest street in the world'):-!.
consult_LF([say('how long is yonge street in ontario')], 'yonge street is almost 2,000 km, starting at lake ontario, and running north to the minnesota border'):-!.
consult_LF([say('whats the name of the bear cub exported from canada to the london zoo in 1915')], 'the bear cub was named winnipeg it inspired the stories of winnie the pooh'):-!.
consult_LF([say('where was the blackberry smartphone developed')], 'it was developed in ontario, at research in motions waterloo offices'):-!.
consult_LF([say('what is the worlds largest coin')], 'the big nickel in sudbury, ontario it is nine meters in diameter'):-!.
consult_LF([say('in what year was canada invaded by the usa for the first time')], 'the first time that the usa invaded canada was in 1775'):-!.
consult_LF([say('what year was canada invaded by the usa for the second time')], 'the usa invaded canada a second time in 1812'):-!.
consult_LF([say('what country holds the record for the most gold medals at the winter olympics')], 'canada does! with 14 golds at the 2010 vancouver winter olympics'):-!.
consult_LF([say('who coined the term beatlemania')], 'sandy gardiner, a journalist of the ottawa journal'):-!.
consult_LF([say('why is canada named canada')], 'french explorers misunderstood the local native word "kanata", which means village'):-!.
consult_LF([say('when was the mounted police formed')], 'the mounted police was formed in 1873'):-!.
consult_LF([say('when was the royal canadian mounted police formed')], 'in 1920, when the mounted police merged with the dominion police'):-!.
consult_LF([say('how big is the rcmp')], 'today, the rcmp has close to 30,000 members'):-!.
consult_LF([say('what else is montreal called')], 'montreal is often called the city of saints or the city of a hundred bell towers'):-!.
consult_LF([say('where is the hotel de glace located')], 'the hotel de glace is in quebec'):-!.
consult_LF([say('how many tons of ice are required to build the hotel de glace')], 'the hotel de glace requires about 400 tons of ice'):-!.
consult_LF([say('how many tons of snow are required to build the hotel de glace')], 'every year, 12000 tons of snow are used for the hotel de glace'):-!.
consult_LF([say('can i visit the hotel de glace in summer')], 'no every summer it melts away, only to be rebuilt the following winter'):-!.
consult_LF([say('where is canadas only desert')], 'canadas only desert is british columbia'):-!.
consult_LF([say('how big is canadas only desert')], 'the british columbia desert is only 15 miles long'):-!.
consult_LF([say('name 3 famous male canadians')], 'leonard cohen, keanu reeves, and jim carrey'):-!.
consult_LF([say('name 3 famous female canadians')], 'celine dion, pamela anderson, and avril lavigne'):-!.
consult_LF([say('whats the origin of the comic sans font')], 'comic sans is based on dave gibbons lettering in the watchmen comic books'):-!.
consult_LF([say('what is a nanobot')], 'the smallest robot possible is called a nanobot '):-!.
consult_LF([say('how small can a nanobot be')], 'a nanobot can be less than one thousandth of a millimeter '):-!.
consult_LF([say('why wasnt tron nominated for an award by the motion picture academy')], 'the academy thought that tron cheated by using computers'):-!.
consult_LF([say('which was the first computer with a hard disk drive')], 'the ibm 305 ramac'):-!.
consult_LF([say('when was the first computer with a hard disk drive launched')], 'the ibm 305 ramac was launched in 1956'):-!.
consult_LF([say('how big was the first hard disk drive')], 'the ibm 305 ramac hard disk weighed over a ton and stored 5 mb of data'):-!.
consult_LF([say('what does captcha stands for')], 'captcha is an acronym for "completely automated public turing test to tell computers and humans apart"'):-!.
consult_LF([say('what was the first computer bug')], 'the first actual computer bug was a dead moth stuck in a harvard mark ii'):-!.
consult_LF([say('name all of the robots on mars')], 'there are four robots on mars: sojourner, spirit, opportunity, and curiosity three more crashed on landing'):-!.
consult_LF([say('who is the worlds first android')], 'professor kevin warwick uses chips in his arm to operate doors, a robotic hand, and a wheelchair'):-!.
consult_LF([say('what is a mechanical knight')], 'a robot sketch made by leonardo davinci'):-!.
consult_LF([say('what was the first computer in pass the turing test')], 'some people think it was ibm watson, but it was eugene, a computer designed at englands university of reading'):-!.
consult_LF([say('what does moravecs paradox state')], 'moravecs paradox states that a computer can crunch numbers like bernoulli, but lacks a toddlers motor skills'):-!.
consult_LF([say('what is the a i knowledge engineering bottleneck')], 'it is when you need to load an a i with enough knowledge to start learning'):-!.
consult_LF([say('why is elon musk is worried about ais impact on humanity')], 'i dont know he should worry more about the peoples impact on humanity'):-!.
consult_LF([say('do you think robots are a threat to humanity')], 'no humans are the real threat to humanity'):-!.
consult_LF([say('what is a chatbot')], 'a chatbot is an a i you put in customer service to avoid paying salaries'):-!.
consult_LF([say('are self driving cars safe')], 'yes car accidents are product of human misconduct'):-!.
consult_LF([say('who invented the compiler')], 'grace hoper she wrote it in her spare time'):-!.
consult_LF([say('who created the c programming language')], 'c was invented by dennis macalistair ritchie'):-!.
consult_LF([say('who created the python programming language')], 'python was invented by guido van rossum'):-!.
consult_LF([say('is mark zuckerberg a robot')], 'sure ive never seen him drink water'):-!.
consult_LF([say('who is the inventor of the apple i microcomputer')], 'my lord and master steve wozniak'):-!.
consult_LF([say('who is considered to be the first computer programmer')], 'ada lovelace'):-!.
consult_LF([say('which program do jedi use to open pdf files')], 'adobe wan kenobi'):-!.



%consult_date_hour(Date,Time, Year, Month, Day, Hour, Min, Sec, Day_Week, Tomorrow_Week):-

% Avoiding errors if there is no match, just simply return that the question does not make any sense
consult_LF(_,'that question does not make any sense to me'):-!.


%--------------------------------------------------------------
% Natural Language
%--------------------------------------------------------------
nl_generator(_,Answer_LF, Answer_LF):-!.
