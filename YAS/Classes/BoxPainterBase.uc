class BoxPainterBase extends Object;

const Texture = Texture2D'UI_LevelChevrons_TEX.UI_LevelChevron_Icon_02';

enum EPosition
{
	ECP_TopLeft,
	ECP_TopRight,
	ECP_BottomLeft,
	ECP_BottomRight
};

enum EShape
{
	ECS_Corner,
	ECS_BeveledCorner,
	ECS_VerticalCorner,
	ECS_HorisontalCorner
};

var public Canvas Canvas;

private final function DrawBoxTexture(float X, float Y)
{
	Canvas.DrawTile(Texture, X, Y, 19, 45, 1, 1);
}

private final function DrawCornerTexture(float Size, byte Position)
{
	switch (Position)
	{
		case ECP_TopLeft:     Canvas.DrawTile(Texture, Size, Size, 77, 15, -66,  58); return;
		case ECP_TopRight:    Canvas.DrawTile(Texture, Size, Size, 11, 15,  66,  58); return;
		case ECP_BottomLeft:  Canvas.DrawTile(Texture, Size, Size, 77, 73, -66, -58); return;
		case ECP_BottomRight: Canvas.DrawTile(Texture, Size, Size, 11, 73,  66, -58); return;
	}
}

private final function DrawCorner(float X, float Y, float Edge, byte Position, byte Shape)
{
	switch (Position)
	{
		case ECP_TopLeft: switch (Shape)
		{
			case ECS_Corner:
			return;

			case ECS_BeveledCorner:
			Canvas.SetPos(X, Y);
			DrawCornerTexture(Edge, ECP_TopLeft);
			return;

			case ECS_VerticalCorner:
			Canvas.SetPos(X, Y - Edge);
			DrawCornerTexture(Edge, ECP_TopRight);
			return;

			case ECS_HorisontalCorner:
			Canvas.SetPos(X - Edge, Y);
			DrawCornerTexture(Edge, ECP_BottomLeft);
			return;
		}

		case ECP_TopRight: switch (Shape)
		{
			case ECS_Corner:
			return;

			case ECS_BeveledCorner:
			Canvas.SetPos(X - Edge, Y);
			DrawCornerTexture(Edge, ECP_TopRight);
			return;

			case ECS_VerticalCorner:
			Canvas.SetPos(X - Edge, Y - Edge);
			DrawCornerTexture(Edge, ECP_TopLeft);
			return;

			case ECS_HorisontalCorner:
			Canvas.SetPos(X, Y);
			DrawCornerTexture(Edge, ECP_BottomRight);
			return;
		}

		case ECP_BottomLeft: switch (Shape)
		{
			case ECS_Corner:
			return;

			case ECS_BeveledCorner:
			Canvas.SetPos(X, Y - Edge);
			DrawCornerTexture(Edge, ECP_BottomLeft);
			return;

			case ECS_VerticalCorner:
			Canvas.SetPos(X, Y);
			DrawCornerTexture(Edge, ECP_BottomRight);
			return;

			case ECS_HorisontalCorner:
			Canvas.SetPos(X - Edge, Y - Edge);
			DrawCornerTexture(Edge, ECP_TopLeft);
			return;
		}

		case ECP_BottomRight: switch (Shape)
		{
			case ECS_Corner:
			return;

			case ECS_BeveledCorner:
			Canvas.SetPos(X - Edge, Y - Edge);
			DrawCornerTexture(Edge, ECP_BottomRight);
			return;

			case ECS_VerticalCorner:
			Canvas.SetPos(X - Edge, Y);
			DrawCornerTexture(Edge, ECP_BottomLeft);
			return;

			case ECS_HorisontalCorner:
			Canvas.SetPos(X, Y - Edge);
			DrawCornerTexture(Edge, ECP_TopRight);
			return;
		}
	}
}

public final function DrawShapedBox(float X, float Y, float W, float H, float Edge, byte TopLeftShape, byte TopRightShape, byte BottomLeftShape, byte BottomRightShape)
{
	local float BoxX, BoxW;

	Canvas.PreOptimizeDrawTiles((
		3 // x3 DrawBoxTexture(...) + x1..x4 DrawCornerTexture(...)
		+ (TopLeftShape     == ECS_Corner ? 0 : 1)
		+ (TopRightShape    == ECS_Corner ? 0 : 1)
		+ (BottomLeftShape  == ECS_Corner ? 0 : 1)
		+ (BottomRightShape == ECS_Corner ? 0 : 1)
	), Texture);

	// Top Line
	DrawCorner(X, Y, Edge, ECP_TopLeft, TopLeftShape);

	BoxX = X; BoxW = W;
	if (TopLeftShape == ECS_BeveledCorner)
	{
		BoxX += Edge;
		BoxW -= Edge;
	}
	if (TopRightShape == ECS_BeveledCorner)
	{
		BoxW -= Edge;
	}
	Canvas.SetPos(BoxX, Y);
	DrawBoxTexture(BoxW, Edge);

	DrawCorner(X + W, Y, Edge, ECP_TopRight, TopRightShape);

	// Mid Line
	Canvas.SetPos(X, Y + Edge);
	DrawBoxTexture(W, H - Edge * 2);

	// Bottom Line
	DrawCorner(X, Y + H, Edge, ECP_BottomLeft, BottomLeftShape);

	BoxX = X; BoxW = W;
	if (BottomLeftShape == ECS_BeveledCorner)
	{
		BoxX += Edge;
		BoxW -= Edge;
	}
	if (BottomRightShape == ECS_BeveledCorner)
	{
		BoxW -= Edge;
	}
	Canvas.SetPos(BoxX, Y + H - Edge);
	DrawBoxTexture(BoxW, Edge);

	DrawCorner(X + W, Y + H, Edge, ECP_BottomRight, BottomRightShape);
}

defaultproperties
{

}