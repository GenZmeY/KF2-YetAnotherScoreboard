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

class KFGUI_Tooltip extends KFGUI_Base;

var() array<string> Lines;
var() Canvas.FontRenderInfo TextFontInfo;
var byte CurrentAlpha;

function InputMouseMoved()
{
	DropInputFocus();
}
function MouseClick(bool bRight)
{
	DropInputFocus();
}
function MouseRelease(bool bRight)
{
	DropInputFocus();
}
function ShowMenu()
{
	CurrentAlpha = 1;
}

final function SetText(string S)
{
	ParseStringIntoArray(S, Lines, "<SEPERATOR>", false);
}

function PreDraw()
{
	if (!bVisible)
		return;

	Owner.CurrentStyle.RenderToolTip(Self);
}

defaultproperties
{
	TextFontInfo=(bClipText=true, bEnableShadow=true)
	bCanFocus=false
	bFocusedPostDrawItem=true
}