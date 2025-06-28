// This file is part of Yet Another Scoreboard.
// Yet Another Scoreboard - a mutator for Killing Floor 2.
//
// Copyright (C) 201?      Marco
// Copyright (C) 2020      ForrestMarkX
// Copyright (C) 2021-2024 GenZmeY (mailto: genzmey@gmail.com)
//
// Yet Another Scoreboard is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Yet Another Scoreboard is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Yet Another Scoreboard. If not, see <https://www.gnu.org/licenses/>.

class KFGUI_TextLable extends KFGUI_Base;

var() protected string Text;
var() color TextColor;
var() Canvas.FontRenderInfo TextFontInfo;
var() byte AlignX, AlignY; // Alignment, 0=Left/Up, 1=Center, 2=Right/Down
var() float FontScale;
var() bool bUseOutline;
var() int OutlineSize;

var transient Font InitFont;
var transient float OldSize[2], InitOffset[2], InitFontScale;

function InitSize()
{
	local float XL, YL, TS;

	OldSize[0] = CompPos[2];
	OldSize[1] = CompPos[3];

	TS = Owner.CurrentStyle.GetFontScaler();
	TS *= FontScale;

	while (true)
	{
		Canvas.Font = Owner.CurrentStyle.MainFont;
		if (TextFontInfo.bClipText)
			Canvas.TextSize(Text, XL, YL, TS, TS);
		else
		{
			Canvas.SetPos(0, 0);
			if (TS == 1)
				Canvas.StrLen(Text, XL, YL);
			else
			{
				Canvas.SetClip(CompPos[2]/TS, CompPos[3]); // Hacky, since StrLen has no TextSize support.
				Canvas.StrLen(Text, XL, YL);
				XL*=TS;
				YL*=TS;
			}
		}
		if ((XL < (CompPos[2]*0.99) && YL < (CompPos[3]*0.99)))
			break;

		TS -= 0.001;
	}
	Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
	InitFont = Canvas.Font;
	InitFontScale = TS;

	switch (AlignX)
	{
	case 0:
		InitOffset[0] = 0;
		break;
	case 1:
		InitOffset[0] = FMax((CompPos[2]-XL)*0.5, 0.f);
		break;
	default:
		InitOffset[0] = CompPos[2]-(XL+1);
	}
	switch (AlignY)
	{
	case 0:
		InitOffset[1] = 0;
		break;
	case 1:
		InitOffset[1] = FMax((CompPos[3]-YL)*0.5, 0.f);
		break;
	default:
		InitOffset[1] = CompPos[3]-YL;
	}
}
function SetText(string S)
{
	if (Text == S)
		return;
	Text = S;
	OldSize[0] = -1; // Force to refresh.
}
final function string GetText()
{
	return Text;
}

function DrawMenu()
{
	if (Text == "")
		return;

	// Need to figure out best fitting font.
	if (OldSize[0] != CompPos[2] || OldSize[1] != CompPos[3])
		InitSize();

	Canvas.Font = InitFont;
	Canvas.DrawColor = TextColor;
	if (bUseOutline)
	{
		Owner.CurrentStyle.DrawTextShadow(Text, InitOffset[0], InitOffset[1], OutlineSize, InitFontScale);
	}
	else
	{
		Canvas.SetPos(InitOffset[0], InitOffset[1]);
		Canvas.DrawText(Text, ,InitFontScale, InitFontScale, TextFontInfo);
	}
}
function bool CaptureMouse()
{
	return false;
}

defaultproperties
{
	Text="Label"
	TextColor=(R=255, G=255, B=255, A=255)
	TextFontInfo=(bClipText=false, bEnableShadow=true)
	FontScale=1.f
	OutlineSize=1
	bCanFocus=false
}