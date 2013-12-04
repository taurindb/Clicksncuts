//OnsetSeq - Uses onset detection to trigger steps in sequencer
(
b = Buffer.alloc(s, 1024);
{
	var sig, chain, onsets, demand, sound, field, snd;

	sig = SoundIn.ar(1);

	chain = FFT(b, sig);

	//onset threshold dependent on MouseXpos
	onsets = Onsets.kr(chain, MouseX.kr(0,1), \rcomplex);

	//move sequence along when onset detected
	demand = Demand.kr(Trig1.kr(onsets,0.01), 0,
	//long Dseq sounds generative, but it isn't, bonus!
		Dseq([50,25,14,120, 10,60,3,50,55,30,100,80,50,10,24,60,30,100,10,80],inf));
	//demand = Stepper.kr(onsets,0,1,8)*200;
	demand.poll;



	sound = (MoogFF.ar(sig ,demand*50,3.5));
	//sound= SinGrain.ar(onsets,1,demand,0.2);

	Out.ar([0,1],((sound)));
	//Out.ar(0,((sound*SinOsc.ar(demand)))); //nice bass rider 4 BentoBox
	//Out.ar(Pan2.ar(sound,MouseX.kr(-1,1),1));
	//Out.ar(Pan4.ar(sound,MouseX.kr,MouseY.kr,1));
}.play;
)


(

SynthDef(\OnsetSeq,{arg s1=50,s2=25,s3=14,s4=120,s5=10,s6=60,s7=3,s8=50; //any arguments go here

var sig, chain, onsets, demand, sound;

	sig = SoundIn.ar(1);

	chain = FFT(b, sig);

	//onset threshold dependent on MouseXpos
	onsets = Onsets.kr(chain, MouseX.kr(0,1), \rcomplex);

	//move sequence along when onset detected
	demand = Demand.kr(Trig1.kr(onsets,0.01), 0,
	//long Dseq sounds generative, but it isn't, bonus!
		Dseq([s1,s2,s3,s4,s5,s6,s7,s8],inf));
	//demand = Stepper.kr(onsets,0,1,8)*200; //different ways to step
	demand.poll;

	sound = (MoogFF.ar(sig ,demand*50,3.5)); //Insert any Ugen here
	//sound= SinGrain.ar(onsets,1,demand,0.2);

	Out.ar([0,1],((sound)));

//some code for UGens - the sort of thing that went inside {}.play before

Out.ar([0,1],((sound))) //finaloutput is the final result UGen you want to hear

}).send(s)
)



Synth(\OnsetSeq, [\s1, 88]); //inputval1 is the constant
