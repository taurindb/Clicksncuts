//OnsetSeq - Uses onset detection to trigger steps in sequencer


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
	//sound= SinGrain.ar(onsets,1,demand,0.2);

	Out.ar([0,1],((sound)));

//some code for UGens - the sort of thing that went inside {}.play before

Out.ar([0,1],((sound))) //finaloutput is the final result UGen you want to hear

}).send(s)
)


(
OSCdef(\touchlistener, {
	arg msg;
	a.set(\s1,msg[1]);
}, "/1/fader1");
	)


a = Synth(\OnsetSeq);






//////////////////////

//a = Synth(\OnsetSeq, [\s1, 88]); //inputval1 is the constant

(
OSCdef(\fader1, {
	arg msg;
	a.set(s1, msg[1]);
}, "/1/fader1");
	)

(
OSCdef(\fader2, {
	arg msg;
	a.set(s2, msg[1]);
}, "/1/fader2");
	)















//Computer Recieve
o = OSCresponder(nil, '/1’, {arg time, responder, msg, addr;
	//[addr.addr, addr.port].postln;
	msg.postln;
	a.set(\fader1,msg[1]);
}).add;


o.remove;
