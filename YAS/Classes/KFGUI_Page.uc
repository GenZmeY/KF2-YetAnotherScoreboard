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

class KFGUI_Page extends KFGUI_MultiComponent
	abstract;

var() byte FrameOpacity; // Transperancy of the frame.
var() bool bPersistant, // Reuse the same menu object throughout the level.
			bUnique, // If calling OpenMenu multiple times with same menu class, only open one instance of it.
			bAlwaysTop, // This menu should stay always on top.
			bOnlyThisFocus, // Only this menu should stay focused.
			bNoBackground; // Don't draw the background.

var bool bWindowFocused; // This page is currently focused.

function DrawMenu()
{
	if (!bNoBackground)
	{
		Owner.CurrentStyle.RenderWindow(Self);
	}
}

defaultproperties
{
	bUnique=true
	bPersistant=true
	FrameOpacity=175
}