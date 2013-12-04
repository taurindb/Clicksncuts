//OnsetSeq - Uses onset detection to trigger steps in sequencer

//First allocate buffer and load synthDef
(
b = Buffer.alloc(s, 1024);

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


	//Out.ar([0,1],((sound)));
	//Out.ar([0,1],((sound*SinOsc.ar(demand))));

//some code for UGens - the sort of thing that went inside {}.play before

Out.ar([0,1],((sound*SinOsc.ar(demand)))) //finaloutput is the final result UGen you want to hear

}).send(s)
)
)



///LOAD OSCdefs individually, UGH

(
OSCdef(\fader1, {
	arg msg;
	a.set(\s1,msg[1]);
}, "/1/fader1");
);

(
OSCdef(\fader2, {
	arg msg;
	a.set(\s2,msg[1]);
}, "/1/fader2");
);

(
OSCdef(\fader3, {
	arg msg;
	a.set(\s3,msg[1]);
}, "/1/fader3");
);

(
OSCdef(\fader4, {
	arg msg;
	a.set(\s4,msg[1]);
}, "/1/fader4");
);

(
OSCdef(\fader5, {
	arg msg;
	a.set(\s5,msg[1]);
}, "/1/fader5");
	);

(
OSCdef(\fader6, {
	arg msg;
	a.set(\s6,msg[1]);
}, "/1/fader6");
	);

(
OSCdef(\fader7, {
	arg msg;
	a.set(\s7,msg[1]);
}, "/1/fader7");
	);

(
OSCdef(\fader8, {
	arg msg;
	a.set(\s8,msg[1]);
}, "/1/fader8");
	);

(
OSCdef(\fader9, {
	arg msg;
	a.set(\s9,msg[1]);
}, "/1/fader9");
	);

(
OSCdef(\fader10, {
	arg msg;
	a.set(\s10,msg[1]);
}, "/1/fader10");
	);

(
OSCdef(\fader11, {
	arg msg;
	a.set(\s11,msg[1]);
}, "/1/fader11");
	);

(
OSCdef(\fader12, {
	arg msg;
	a.set(\s12,msg[1]);
}, "/1/fader12");
	);

(
OSCdef(\fader13, {
	arg msg;
	a.set(\s13,msg[1]);
}, "/1/fader13");
	);

(
OSCdef(\fader14, {
	arg msg;
	a.set(\s14,msg[1]);
}, "/1/fader14");
	);

(
OSCdef(\fader15, {
	arg msg;
	a.set(\s15,msg[1]);
}, "/1/fader15");
	);

(
OSCdef(\fader16, {
	arg msg;
	a.set(\s16,msg[1]);
}, "/1/fader16");
	);
)

//Load Synth
a = Synth(\OnsetSeq);



