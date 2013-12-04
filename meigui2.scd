//System

Server.default.options.inDevice_("MOTU UltraLite")
Server.default.options.outDevice_("Soundflower (2ch)")

Server.killAll;

(

var w;
var slider, string;
var num;
var names, data, specs, lastval;
var bbcutter, clock;
var buf;

//GUI control of all arguments for bbcut2
names= ["tempo","cut","phrasebars","stutterchance","stutterspeed","restchance","ampvariation","panvariation","numrepeats","beatsperbar","randomoffset"];

data=	//control spec data for ui controls to be put in array
[
[2.0,10.0,\exp, 0.0,2.5],	//tempo //Gets wonky above 4
[4,16,\lin,1,8],			//cuts
[1,5,\lin,1,2],			//phrasebars
[0.0,1.0,\lin,0.0,0.2],		//stutterchance
[1,10,\lin,1,2],			//stutterspeed
[0.0,1.0,\lin, 0.0,0.0],	//restchance
[0.0,1.0,\amp, 0.0,1.0],	//ampvariation
[0.0,1.0,\lin, 0.0,0.0],	//panvariation
[1,20,\lin,1,2],			//numrepeats
[2.0,6.0,\lin,1.0, 4.0],	//subdivision over x beats
[0.0,1.0,\lin,0.0, 0.0]	 	//offsetchance
];

specs= Array.fill(data.size, {arg i; ControlSpec.performList(\new, data.at(i))});

num= names.size;
string= Array.fill(num);
slider= Array.fill(num);

//Create GUI window
w = Window.new("BBCut2Slizzzerp", 500@(30*num));

//Fill with defaults. This array will hold the updated last value of any GUI element
lastval= Array.fill(num, {arg i; data.at(i).at(4);});

num.do(
{
arg i;

StaticText( w, Rect.new(5, (30*i)+5, 95,20)).string_(names.at(i));
slider.put(i,Slider.new( w, Rect.new(105, (30*i)+5, 95,20)));
//set slider to default value, else will default to 0.0
slider.at(i).value_(specs.at(i).unmap(data.at(i).at(4)));
string.put(i, StaticText( w, Rect.new(205, (30*i)+5, 95,20)).string_(data.at(i).at(4)));

slider.at(i).action_({arg sl;
var val; val = specs.at(i).map(sl.value);  string.at(i).string_(val);
			lastval.put(i, val);  //set associated variable to this value, bbcut code will poll this rather than the slider directly (srsly? wtf)
});

});

w.front;

buf= BBCutBuffer.alloc(s,44100*1,1);

bbcutter=BBCut2(CutStream2(s.options.numOutputBusChannels, buf),
BBCutProc11.new(
{lastval.at(1)},	//cut
{lastval.at(9)},	//sdbeats
{lastval.at(2)},	//phrasebars
{lastval.at(8)},	//numrepeats
{lastval.at(3)},	//stutterchance
{lastval.at(4)}	//stutterspeed
));

clock=ExternalClock(TempoClock(lastval[0])).play;

bbcutter.play(clock);

//update tempo ten times a second
SystemClock.sched(0.0,{clock.tempoclock.tempo_(lastval.at(0)); 0.1});

)


    //d = Buffer.read(s, "/Users/taurinbarrera/Desktop/Jiaxin/real read.aif");


(
b = Buffer.alloc(s, 1024);
{
	var sig, chain, onsets, demand, sound, field, snd;

	snd = Buffer.read(s,"/Users/taurinbarrera/Desktop/Jiaxin/jiaxin cuihu.wav");
	field = PlayBuf.ar(2,snd,loop:1);
	sig = SoundIn.ar(1);

	chain = FFT(b, sig);

	onsets = Onsets.kr(chain, MouseX.kr(0,1), \rcomplex);

	//move sequence along when onset detected
	demand = Demand.kr(Trig1.kr(onsets,0.01), 0,
		Dseq([50,25,14,120, 10,60,3,50,55,30,100,80,50,10,24,60,30,100,10,80],inf));
	//demand = Stepper.kr(onsets,0,1,8)*200;
	demand.poll;


	//sound= SinGrain.ar(onsets,1,demand,0.2);
	sound = (MoogFF.ar(sig +field ,demand*50,3.5));

	Out.ar(0,((sound)));
	//Out.ar(0,((sound*SinOsc.ar(demand))));
	//Out.ar(Pan2.ar(sound,MouseX.kr(-1,1),1));
	//Out.ar(Pan4.ar(sound,MouseX.kr,MouseY.kr,1));
}.play;
)




(
var winenv, sig, chain, onsets, demand, sound;
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

    sig = SoundIn.ar(1);

	chain = FFT(b, sig);

	onsets = Onsets.kr(chain, MouseX.kr(0,1), \rcomplex);

	//move sequence along when onset detected
	demand = Demand.kr(Trig1.kr(onsets,0.01), 0, Dseq([50,25,80,44,60,45,50,55].midicps,inf));
	//demand = Stepper.kr(onsets,0,1,8)*200;
	demand.poll;

	//sound= SinGrain.ar(onsets,1,demand,0.2);
	sound = (sig + SinOsc(demand, 0.4));



SynthDef(\in_grain_test, {arg gate = 1, amp = 1, envbuf;
    var pan, env;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
    Out.ar(0,
		        GrainIn.ar(2, onsets, 1, sound, pan, envbuf) * env)
    }).send(s);

)

// use built-in env
x = Synth(\in_grain_test, [\envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);
