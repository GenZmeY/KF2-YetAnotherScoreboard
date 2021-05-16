Class UI_MidGameMenu extends KFGUI_FloatingWindow;

struct FPageInfo
{
    var class<KFGUI_Base> PageClass;
    var string Caption,Hint;
};
var KFGUI_SwitchMenuBar PageSwitcher;
var() array<FPageInfo> Pages;

var transient KFGUI_Button PrevButton;
var transient int NumButtons,NumButtonRows;

var KFPlayerReplicationInfo KFPRI;

function InitMenu()
{
    local int i;
    local KFGUI_Button B;

    PageSwitcher = KFGUI_SwitchMenuBar(FindComponentID('Pager'));
    Super(KFGUI_Page).InitMenu();
    
    AddMenuButton('Close',"Close","Close this menu");
    
    for( i=0; i<Pages.Length; ++i )
    {
        PageSwitcher.AddPage(Pages[i].PageClass,Pages[i].Caption,Pages[i].Hint,B).InitMenu();
    }
}

function Timer()
{
    local PlayerReplicationInfo PRI;
    
    PRI = GetPlayer().PlayerReplicationInfo;
    if( PRI==None )
        return;
        
    if( KFPlayerController(GetPlayer()).IsBossCameraMode() )
    {
        DoClose();
        return;
    }
}

function ShowMenu()
{
    Super.ShowMenu();
    
    PlayMenuSound(MN_DropdownChange);
    
    // Update spectate button info text.
    Timer();
    SetTimer(0.5,true);
    
    Owner.bHideCursor = false;
}

function CloseMenu()
{
    local KFGfxMoviePlayer_Manager MovieManager;
    
    Super.CloseMenu();
    
    Owner.bHideCursor = true;
    
    MovieManager = KFPlayerController(GetPlayer()).MyGFxManager;
    MovieManager.SetMovieCanReceiveInput(MovieManager.bMenusActive);
}

function PreDraw()
{
	local KFGfxMoviePlayer_Manager MovieManager;
	
	Super.PreDraw();
	
	MovieManager = KFPlayerController(GetPlayer()).MyGFxManager;
	if( CaptureMouse() )
		MovieManager.SetMovieCanReceiveInput(false);
	else MovieManager.SetMovieCanReceiveInput(true);
}

function ButtonClicked( KFGUI_Button Sender )
{
    DoClose();
}

final function KFGUI_Button AddMenuButton( name ButtonID, string Text, optional string ToolTipStr )
{
    local KFGUI_Button B;
    
    B = new (Self) class'KFGUI_Button';
    B.ButtonText = Text;
    B.ToolTip = ToolTipStr;
    B.OnClickLeft = ButtonClicked;
    B.OnClickRight = ButtonClicked;
    B.ID = ButtonID;
    B.XPosition = 0.05+NumButtons*0.1;
    B.XSize = 0.099;
    B.YPosition = 0.92+NumButtonRows*0.04;
    B.YSize = 0.0399;

    PrevButton = B;
    if( ++NumButtons>8 )
    {
        ++NumButtonRows;
        NumButtons = 0;
    }
    
    AddComponent(B);
    return B;
}

defaultproperties
{
    WindowTitle="Classic HUD - Menu"
    XPosition=0.2
    YPosition=0.1
    XSize=0.6
    YSize=0.8
    
    bAlwaysTop=true
    bOnlyThisFocus=true
    
    Pages.Add((PageClass=Class'UIP_Settings',Caption="Settings",Hint="Show additional Classic Mode settings"))
    Pages.Add((PageClass=Class'UIP_ColorSettings',Caption="Colors",Hint="Settings to adjust the hud colors"))

    Begin Object Class=KFGUI_SwitchMenuBar Name=MultiPager
        ID="Pager"
        XPosition=0.015
        YPosition=0.04
        XSize=0.975
        YSize=0.8
        BorderWidth=0.05
        ButtonAxisSize=0.1
    End Object
    
    Components.Add(MultiPager)
}