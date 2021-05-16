Class UIP_ColorSettings extends KFGUI_MultiComponent;

var KFGUI_ComponentList SettingsBox;
var KFGUI_ColorSlider MainHudSlider,OutlineSlider,FontSlider,ArmorSlider,HealthSlider;
var ClassicKFHUD HUD;

function InitMenu()
{
    HUD = ClassicKFHUD(GetPlayer().myHUD);
    
    Super.InitMenu();

    // Client settings
    SettingsBox = KFGUI_ComponentList(FindComponentID('SettingsBox'));

    MainHudSlider = AddColorSlider('HUDColorSlider', "Main HUD Color", HUD.HudMainColor);
    OutlineSlider = AddColorSlider('OutlineColorSlider', "HUD Outline Color", HUD.HudOutlineColor);
    FontSlider = AddColorSlider('FontCSlider', "Font Color", HUD.FontColor);
    ArmorSlider = AddColorSlider('ArmorCSlider', "Player Info Armor Color", HUD.CustomArmorColor);
    HealthSlider = AddColorSlider('HealthCSlider', "Player Info Health Color", HUD.CustomHealthColor);
}

function ShowMenu()
{
    Super.ShowMenu();
    HUD.ColorSettingMenu = self;
    ArmorSlider.SetDefaultColor(HUD.CustomArmorColor);
    HealthSlider.SetDefaultColor(HUD.CustomHealthColor);
}

final function KFGUI_ColorSlider AddColorSlider( name IDN, string Caption, Color DefaultColor )
{
    local KFGUI_MultiComponent MC;
    local KFGUI_ColorSlider SL;
    
    MC = KFGUI_MultiComponent(SettingsBox.AddListComponent(class'KFGUI_MultiComponent'));
    MC.XSize = 0.65;
    MC.XPosition = 0.15;
    MC.InitMenu();
    SL = new(MC) class'KFGUI_ColorSlider';
    SL.CaptionText = Caption;
    SL.DefaultColor = DefaultColor;
    SL.ID = IDN;
    SL.OnColorSliderValueChanged = CheckColorSliderChange;
    MC.AddComponent(SL);
    
    return SL;
}

function CheckColorSliderChange(KFGUI_ColorSlider Sender, KFGUI_Slider Slider, int Value)
{
    switch(Sender.ID)
    {
        case 'HUDColorSlider':
            switch( Slider.ID )
            {
                case 'ColorSliderR':
                    HUD.HudMainColor.R = Value;
                    break;
                case 'ColorSliderG':
                    HUD.HudMainColor.G = Value;
                    break;
                case 'ColorSliderB':
                    HUD.HudMainColor.B = Value;
                    break;
                case 'ColorSliderA':
                    HUD.HudMainColor.A = Value;
                    break;
            }
            HUD.SaveConfig();
            break;
        case 'OutlineColorSlider':
            switch( Slider.ID )
            {
                case 'ColorSliderR':
                    HUD.HudOutlineColor.R = Value;
                    break;
                case 'ColorSliderG':
                    HUD.HudOutlineColor.G = Value;
                    break;
                case 'ColorSliderB':
                    HUD.HudOutlineColor.B = Value;
                    break;
                case 'ColorSliderA':
                    HUD.HudOutlineColor.A = Value;
                    break;
            }
            HUD.SaveConfig();
            break;
        case 'FontCSlider':
            switch( Slider.ID )
            {
                case 'ColorSliderR':
                    HUD.FontColor.R = Value;
                    break;
                case 'ColorSliderG':
                    HUD.FontColor.G = Value;
                    break;
                case 'ColorSliderB':
                    HUD.FontColor.B = Value;
                    break;
                case 'ColorSliderA':
                    HUD.FontColor.A = Value;
                    break;
            }
            HUD.SaveConfig();
            break;
        case 'ArmorCSlider':
            switch( Slider.ID )
            {
                case 'ColorSliderR':
                    HUD.CustomArmorColor.R = Value;
                    break;
                case 'ColorSliderG':
                    HUD.CustomArmorColor.G = Value;
                    break;
                case 'ColorSliderB':
                    HUD.CustomArmorColor.B = Value;
                    break;
                case 'ColorSliderA':
                    HUD.CustomArmorColor.A = Value;
                    break;
            }
            HUD.SaveConfig();
            break;
        case 'HealthCSlider':
            switch( Slider.ID )
            {
                case 'ColorSliderR':
                    HUD.CustomHealthColor.R = Value;
                    break;
                case 'ColorSliderG':
                    HUD.CustomHealthColor.G = Value;
                    break;
                case 'ColorSliderB':
                    HUD.CustomHealthColor.B = Value;
                    break;
                case 'ColorSliderA':
                    HUD.CustomHealthColor.A = Value;
                    break;
            }
            HUD.SaveConfig();
            break;
    }
}

defaultproperties
{
    Begin Object Class=KFGUI_ComponentList Name=ClientSettingsBox
        ID="SettingsBox"
        ListItemsPerPage=3
    End Object
    
    Components.Add(ClientSettingsBox)
}