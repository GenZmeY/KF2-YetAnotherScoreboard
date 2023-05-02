class MessageOfTheDay extends Object
	config(YAS);

var public config bool bRandomize;
var public config int DisplayTime;
var public config Array<String> Message;

public static function InitConfig(int Version, int LatestVersion)
{
	switch (Version)
	{
		case `NO_CONFIG:
			ApplyDefault();

		default: break;
	}

	if (LatestVersion != Version)
	{
		StaticSaveConfig();
	}
}

private static function ApplyDefault()
{
	default.DisplayTime = 30;
	default.bRandomize  = true;

	default.Message.Length = 0;
	default.Message.AddItem("UwU");
	default.Message.AddItem("OwO");
}

defaultproperties
{

}