//OnsetSeq - Uses onset detection to trigger steps in sequencer

//First allocate buffer and load synthDef
(
b = Buffer.alloc(s, 1024);

(
SynthDef(\OnsetSeq,{
	arg s1=50,s2=25,s3=14,s4=120,s5=10,s6=60,s7=3,s8=50,
	s9=30,s10=100,s11=80,s12=50,s13=10,s14=24,s15=60,s16=7;//any arguments go here

var sig, chain, onsets, demand, sound;

	sig = SoundIn.ar(1);

	chain = FFT(b, sig);

	//onset threshold dependent on MouseXpos
	onsets = Onsets.kr(chain, MouseX.kr(0,1), \rcomplex);

	//move sequence along when onset detected
	demand = Demand.kr(Trig1.kr(onsets,0.01), 0,
	//long Dseq sounds generative, but it isn't, bonus!
		Dseq([s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16],inf));
	//demand = Stepper.kr(onsets,0,1,8)*200; //different ways to step
	demand.poll;

	sound = (MoogFF.ar(sig ,demand*50,3.5)); //Insert any Ugen here


	//Out.ar([0,1],((sound)));
	//Out.ar([0,1],((sound*SinOsc.ar(demand))));

Out.ar([0,1],((sound*SinOsc.ar(demand)))) //finaloutput is the final result UGen you want to hear

}).send(s)
)
)

c = Synth(\OnsetSeq);
(
~setFunc = {|synth, argName, val| // read the "Control Structure" help file for more on using swtch
	switch (argName,
		{\s1}, {synth.set(argName, val)},
		{\s2}, {synth.set(argName, val)},
		{\s3}, {synth.set(argName, val)},
		{\s4}, {synth.set(argName, val)},
		{\s5}, {synth.set(argName, val)},
		{\s6}, {synth.set(argName, val)},
		{\s7}, {synth.set(argName, val)},
		{\s8}, {synth.set(argName, val)},
		{\s9}, {synth.set(argName, val)},
		{\s10}, {synth.set(argName, val)},
		{\s11}, {synth.set(argName, val)},
		{\s12}, {synth.set(argName, val)},
		{\s13}, {synth.set(argName, val)},
		{\s14}, {synth.set(argName, val)},
		{\s15}, {synth.set(argName, val)},
		{\s16}, {synth.set(argName, val)},

	);
};

// make an array of synth argument names
~argNames = [\s1, \s2, \s3, \s4, \s5, \s6, \s7, \s8, \s9, \s10, \s11, \s12, \s13, \s14, \s15];

// make another array of osc message names
~oscMessageNames = Array.fill(16, {|i| i = i + 1; ("/1/multifader1/"++i).asSymbol});

// now use the two arrays you just made to build all your OSCresponderNodes
~oscResponders = Array.fill(16, {|i|
	OSCresponderNode(nil, ~oscMessageNames[i], {|time, resp, msg|
		msg.postln;
		~setFunc.value(c, ~argNames[i], msg[1])
	}).add; // important to .add them!  I forgot this in my last email to you - sorry about that
});
)





