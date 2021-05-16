class KF1HUD_MusicNotification extends KFGFxWidget_MusicNotification;

function ShowSongInfo(string SongInfoString)
{
	local KFGameEngine KFEngine;   
    local ClassicKFHUD HUD;
    local PopupMessage Msg;
    
    HUD = ClassicKFHUD(GetPC().MyHUD);
	KFEngine = KFGameEngine(Class'Engine'.static.GetEngine());
    
	if(KFEngine != none && KFEngine.MusicVolumeMultiplier > 0)
	{
        Msg.Body = SongInfoString;
        Msg.Image = Texture2D'UI_HUD.InGameHUD_SWF_IBC';
        Msg.MsgPosition = PP_TOP_CENTER;
        
        HUD.AddPopupMessage(Msg);
	}
}

DefaultProperties
{
    
}
