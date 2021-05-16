class KF1HUD_ChatBoxWidget extends KFGFxHUD_ChatBoxWidget;

function AddChatMessage(string NewMessage, string HexVal)
{
	Super.AddChatMessage(NewMessage, HexVal);
    if( InStr(NewMessage, "<"$class'KFCommon_LocalizedStrings'.default.TeamString$">") != INDEX_NONE || InStr(NewMessage, "<"$class'KFCommon_LocalizedStrings'.default.AllString$">") != INDEX_NONE )
        LocalPlayer(GetPC().Player).ViewportClient.ViewportConsole.OutputText(NewMessage);
}

defaultproperties
{
}

