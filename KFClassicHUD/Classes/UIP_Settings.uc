Class UIP_Settings extends KFGUI_MultiComponent;

var KFGUI_ComponentList SettingsBox;
var KFGUI_TextLable ResetColorLabel,PerkStarsLabel,PerkStarsRowLabel,ControllerTypeLabel,PlayerInfoTypeLabel;
var KFGUI_EditBox PerkStarsBox, PerkRowsBox;
var KFGUI_ComboBox ControllerBox;

var ClassicKFHUD HUD;
var KFPlayerController PC;

function InitMenu()
{
    local string S;
    
    PC = KFPlayerController(GetPlayer());
    HUD = ClassicKFHUD(PC.myHUD);
    
    Super.InitMenu();

    // Client settings
    SettingsBox = KFGUI_ComponentList(FindComponentID('SettingsBox'));
    
    AddCheckBox("Disable HUD","Disables the HUD entirely.",'bDisableHUD',HUD.bDisableHUD);
    AddCheckBox("Light HUD","Show a light version of the HUD.",'bLight',HUD.bLightHUD);
    AddCheckBox("Show weapon info","Show current weapon ammunition status.",'bWeapons',!HUD.bHideWeaponInfo);
    AddCheckBox("Show personal info","Display health and armor on the HUD.",'bPersonal',!HUD.bHidePlayerInfo);
    AddCheckBox("Show score","Check to show scores on the HUD.",'bScore',!HUD.bHideDosh);
    AddCheckBox("Show hidden player icons","Shows the hidden player icons.",'bDisableHiddenPlayers',!HUD.bDisableHiddenPlayers);
    AddCheckBox("Show damage messages","Shows the damage popups when damaging ZEDs.",'bEnableDamagePopups',HUD.bEnableDamagePopups);
    AddCheckBox("Show player speed","Shows how fast you are moving.",'bShowSpeed',HUD.bShowSpeed);
    AddCheckBox("Show pickup information","Shows a UI with infromation on pickups.",'bDisablePickupInfo',!HUD.bDisablePickupInfo);
    AddCheckBox("Show lockon target","Shows who you have targeted with a medic gun.",'bDisableLockOnUI',!HUD.bDisableLockOnUI);
    AddCheckBox("Show medicgun recharge info","Shows what the recharge info is on various medic weapons.",'bDisableRechargeUI',!HUD.bDisableRechargeUI);
    AddCheckBox("Show last remaining ZED icons","Shows the last remaining ZEDs as icons.",'bDisableLastZEDIcons',!HUD.bDisableLastZEDIcons);
    AddCheckBox("Show XP earned","Shows when you earn XP.",'bShowXPEarned',HUD.bShowXPEarned);
    AddCheckBox("Show Dosh earned","Shows when you earn Dosh.",'bShowDoshEarned',HUD.bShowDoshEarned);
    AddCheckBox("Enable Modern Scoreboard","Makes the scoreboard look more modern.",'bNewScoreboard',HUD.bNewScoreboard);
    
    switch(HUD.PlayerInfoType)
    {
        case INFO_CLASSIC:
            S = "Classic";
            break;
        case INFO_LEGACY:
            S = "Legacy";
            break;
        case INFO_MODERN:
            S = "Modern";
            break;
    }
    
    ControllerBox = AddComboBox("Player Info Type","What style to draw the player info system in.",'PlayerInfo',PlayerInfoTypeLabel);
    ControllerBox.Values.AddItem("Classic");
    ControllerBox.Values.AddItem("Legacy");
    ControllerBox.Values.AddItem("Modern");
    ControllerBox.SetValue(S);
    
    AddButton("Reset","Reset HUD Colors","Resets the color settings for the HUD.",'ResetColors',ResetColorLabel);
}
final function KFGUI_CheckBox AddCheckBox( string Cap, string TT, name IDN, bool bDefault )
{
    local KFGUI_CheckBox CB;
    
    CB = KFGUI_CheckBox(SettingsBox.AddListComponent(class'KFGUI_CheckBox'));
    CB.LableString = Cap;
    CB.ToolTip = TT;
    CB.bChecked = bDefault;
    CB.InitMenu();
    CB.ID = IDN;
    CB.OnCheckChange = CheckChange;
    return CB;
}
final function KFGUI_Button AddButton( string ButtonText, string Cap, string TT, name IDN, out KFGUI_TextLable Label )
{
    local KFGUI_Button CB;
    local KFGUI_MultiComponent MC;
    
    MC = KFGUI_MultiComponent(SettingsBox.AddListComponent(class'KFGUI_MultiComponent'));
    MC.InitMenu();
    Label = new(MC) class'KFGUI_TextLable';
    Label.SetText(Cap);
    Label.XSize = 0.60;
    Label.FontScale = 1;
    Label.AlignY = 1;
    MC.AddComponent(Label);
    CB = new(MC) class'KFGUI_Button';
    CB.XPosition = 0.77;
    CB.XSize = 0.15;
    CB.ButtonText = ButtonText;
    CB.ToolTip = TT;
    CB.ID = IDN;
    CB.OnClickLeft = ButtonClicked;
    CB.OnClickRight = ButtonClicked;
    MC.AddComponent(CB);

    return CB;
}
final function KFGUI_ComboBox AddComboBox( string Cap, string TT, name IDN, out KFGUI_TextLable Label )
{
    local KFGUI_ComboBox CB;
    local KFGUI_MultiComponent MC;
    
    MC = KFGUI_MultiComponent(SettingsBox.AddListComponent(class'KFGUI_MultiComponent'));
    MC.InitMenu();
    Label = new(MC) class'KFGUI_TextLable';
    Label.SetText(Cap);
    Label.XSize = 0.60;
    Label.FontScale = 1;
    Label.AlignY = 1;
    MC.AddComponent(Label);
    CB = new(MC) class'KFGUI_ComboBox';
    CB.XPosition = 0.77;
    CB.XSize = 0.15;
    CB.ToolTip = TT;
    CB.ID = IDN;
    CB.OnComboChanged = OnComboChanged;
    MC.AddComponent(CB);

    return CB;
}

function OnComboChanged(KFGUI_ComboBox Sender)
{
    switch( Sender.ID )
    {
    case 'PlayerInfo':
        switch(Sender.GetCurrent())
        {
            case "Classic":
                HUD.PlayerInfoType = INFO_CLASSIC;
                break;
            case "Legacy":
                HUD.PlayerInfoType = INFO_LEGACY;
                break;
            case "Modern":
                HUD.PlayerInfoType = INFO_MODERN;
                break;
        }
    
        break;
    }
    
    switch(HUD.PlayerInfoType)
    {
        case INFO_CLASSIC:
            HUD.CustomArmorColor = HUD.BlueColor;
            HUD.CustomHealthColor = HUD.RedColor;
            break;
        case INFO_LEGACY:
            HUD.CustomArmorColor = HUD.ClassicArmorColor;
            HUD.CustomHealthColor = HUD.ClassicHealthColor;
            break;
        case INFO_MODERN:
            HUD.CustomArmorColor = HUD.ArmorColor;
            HUD.CustomHealthColor = HUD.HealthColor;
            break;    
    }
    
    HUD.SaveConfig();
}

function CheckChange( KFGUI_CheckBox Sender )
{
    switch( Sender.ID )
    {
    case 'bDisableHUD':
        HUD.bDisableHUD = Sender.bChecked;
        
        HUD.RemoveMovies();
        if( HUD.bDisableHUD )
        {
            HUD.HUDClass = class'KFGFxHudWrapper'.default.HUDClass;
            HUD.CreateHUDMovie();
        }
        else
        {
            HUD.HUDClass = HUD.default.HUDClass;
            HUD.CreateHUDMovie();
        }
        break;
    case 'bLight':
        HUD.bLightHUD = Sender.bChecked;
        break;
    case 'bWeapons':
        HUD.bHideWeaponInfo = !Sender.bChecked;
        break;
    case 'bPersonal':
        HUD.bHidePlayerInfo = !Sender.bChecked;
        break;
    case 'bScore':
        HUD.bHideDosh = !Sender.bChecked;
        break;
    case 'bDisableHiddenPlayers':
        HUD.bDisableHiddenPlayers = !Sender.bChecked;
        break;    
    case 'bEnableDamagePopups':
        HUD.bEnableDamagePopups = Sender.bChecked;
        break;      
    case 'bShowSpeed':
        HUD.bShowSpeed = Sender.bChecked;
        break;     
    case 'bDisableLastZEDIcons':
        HUD.bDisableLastZEDIcons = !Sender.bChecked;
        break;    
    case 'bDisablePickupInfo':
        HUD.bDisablePickupInfo = !Sender.bChecked;
        break;    
    case 'bDisableLockOnUI':
        HUD.bDisableLockOnUI = !Sender.bChecked;
        break;   
    case 'bDisableRechargeUI':
        HUD.bDisableRechargeUI = !Sender.bChecked;
        break;    
    case 'bNewScoreboard':
        HUD.bNewScoreboard = Sender.bChecked;
        
        HUD.Scoreboard.SetVisibility(false);
        if( HUD.HUDMovie.GfxScoreBoardPlayer != None )
            HUD.HUDMovie.GfxScoreBoardPlayer.ShowScoreboard(false);
        break;    
    case 'bShowXPEarned':
        HUD.bShowXPEarned = Sender.bChecked;
        break;    
    case 'bShowDoshEarned':
        HUD.bShowDoshEarned = Sender.bChecked;
        break;    
    }
    
    HUD.SaveConfig();
}
function ButtonClicked( KFGUI_Button Sender )
{
    switch( Sender.ID )
    {
    case 'ResetColors':
        HUD.ResetHUDColors();
        if( HUD.ColorSettingMenu != None )
        {
            HUD.ColorSettingMenu.MainHudSlider.SetDefaultColor(HUD.HudMainColor);
            HUD.ColorSettingMenu.OutlineSlider.SetDefaultColor(HUD.HudOutlineColor);
            HUD.ColorSettingMenu.FontSlider.SetDefaultColor(HUD.FontColor);
        }
        break;
    }
}

defaultproperties
{
    Begin Object Class=KFGUI_ComponentList Name=ClientSettingsBox
        ID="SettingsBox"
        ListItemsPerPage=16
    End Object
    
    Components.Add(ClientSettingsBox)
}