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
