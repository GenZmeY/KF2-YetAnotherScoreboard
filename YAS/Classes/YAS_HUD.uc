class YAS_HUD extends KFGFxHudWrapper;

const HUDBorderSize = 3;

var float ScaledBorderSize;
var array<KFGUI_Base> HUDWidgets;

var class<YAS_ScoreBoard> ScoreboardClass;
var YAS_ScoreBoard Scoreboard;

var transient KF2GUIController GUIController;
var transient GUIStyleBase GUIStyle;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	PlayerOwner.PlayerInput.OnReceivedNativeInputKey = NotifyInputKey;
	PlayerOwner.PlayerInput.OnReceivedNativeInputAxis = NotifyInputAxis;
	PlayerOwner.PlayerInput.OnReceivedNativeInputChar = NotifyInputChar;

	RemoveMovies();
	CreateHUDMovie();
}

function PostRender()
{
	if (KFGRI == None)
		KFGRI = KFGameReplicationInfo(WorldInfo.GRI);

	if (GUIController != None && PlayerOwner.PlayerInput == None)
		GUIController.NotifyLevelChange();

	if (GUIController == None || GUIController.bIsInvalid)
	{
		GUIController = Class'YAS.KF2GUIController'.Static.GetGUIController(PlayerOwner);
		if (GUIController != None)
		{
			GUIStyle = GUIController.CurrentStyle;
			GUIStyle.HUDOwner = self;
			LaunchHUDMenus();
		}
	}
	GUIStyle.Canvas = Canvas;
	GUIStyle.PickDefaultFontSize(Canvas.ClipY);

	if (!GUIController.bIsInMenuState)
		GUIController.HandleDrawMenu();

	ScaledBorderSize = FMax(GUIStyle.ScreenScale(HUDBorderSize), 1.f);

	Super.PostRender();
}

function LaunchHUDMenus()
{
	Scoreboard = YAS_ScoreBoard(GUIController.InitializeHUDWidget(ScoreboardClass));
	Scoreboard.SetVisibility(false);
}

function bool NotifyInputKey(int ControllerId, Name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
	local int i;

	for (i=(HUDWidgets.Length-1); i >= 0; --i)
	{
		if (HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
			return true;
	}

	return false;
}

function bool NotifyInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
	local int i;

	for (i=(HUDWidgets.Length-1); i >= 0; --i)
	{
		if (HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad))
			return true;
	}

	return false;
}

function bool NotifyInputChar(int ControllerId, string Unicode)
{
	local int i;

	for (i=(HUDWidgets.Length-1); i >= 0; --i)
	{
		if (HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputChar(ControllerId, Unicode))
			return true;
	}

	return false;
}

exec function SetShowScores(bool bNewValue)
{
	if (Scoreboard != None)
		Scoreboard.SetVisibility(bNewValue);
	else Super.SetShowScores(bNewValue);
}

defaultproperties
{
	ScoreboardClass=class'YAS_ScoreBoard'
}