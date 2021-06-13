class ScoreboardStyleClient extends ScoreboardStyle
	config(ScoreboardExt);

`include(Build.uci)
`include(Logger.uci)

var config bool bEnable;

defaultProperties
{
	bEnable=false
}