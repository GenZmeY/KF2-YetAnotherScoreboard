class BoxPainter extends BoxPainterBase;

public final function DrawBox(float X, float Y, float Width, float Height, float Edge, optional byte Shape = 0)
{
	Edge = FMin(FMin(Edge, Width * 0.5), Height * 0.5);

	switch (Shape)
	{
		case 100:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 110:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 111:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 120:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\____/|
			ECS_VerticalCorner,   // TopLeft        //  |      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | ____ |
			ECS_VerticalCorner    // BottomRight    //  |/    \|
		);
		break;

		case 121:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  _______
			ECS_HorisontalCorner, // TopLeft        //  \     /
			ECS_HorisontalCorner, // TopRight       //  |     |
			ECS_HorisontalCorner, // BottomLeft     //  |     |
			ECS_HorisontalCorner  // BottomRight    //  /_____\
		);
		break;

		case 130:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 131:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 132:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 133:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 140:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 141:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 142:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 143:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 150:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | ____ |
			ECS_VerticalCorner    // BottomRight    //  |/    \|
		);
		break;

		case 151:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _______
			ECS_BeveledCorner,    // TopLeft        //  /      /
			ECS_HorisontalCorner, // TopRight       //  |     |
			ECS_BeveledCorner,    // BottomLeft     //  \______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 152:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\____/|
			ECS_VerticalCorner,   // TopLeft        //  |      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 153:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _______
			ECS_HorisontalCorner, // TopLeft        //   \      \
			ECS_BeveledCorner,    // TopRight       //   |      |
			ECS_HorisontalCorner, // BottomLeft     //   /______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 160:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /     /
			ECS_HorisontalCorner, // TopRight       //  |     |
			ECS_BeveledCorner,    // BottomLeft     //  \_____/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 161:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\_____
			ECS_VerticalCorner,   // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 162:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_HorisontalCorner, // BottomLeft     //  /______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 163:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \_____ |
			ECS_VerticalCorner    // BottomRight    //        \|
		);
		break;

		case 170:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 171:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _____/|
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 172:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  _______
			ECS_HorisontalCorner, // TopLeft        //  \      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 173:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | _____/
			ECS_BeveledCorner     // BottomRight    //  |/
		);
		break;

		case 180:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _______
			ECS_Corner,           // TopLeft        //  |      /
			ECS_HorisontalCorner, // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 181:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\_____
			ECS_VerticalCorner,   // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 182:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_HorisontalCorner, // BottomLeft     //  /______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 183:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |_____ |
			ECS_VerticalCorner    // BottomRight    //        \|
		);
		break;

		case 190:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 191:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _____/|
			ECS_Corner,           // TopLeft        //  |      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 192:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  _______
			ECS_HorisontalCorner, // TopLeft        //  \      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 193:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | _____|
			ECS_Corner            // BottomRight    //  |/
		);
		break;

		case 200:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | ____ |
			ECS_VerticalCorner    // BottomRight    //  |/    \|
		);
		break;

		case 201:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _______
			ECS_Corner,           // TopLeft        //  |      /
			ECS_HorisontalCorner, // TopRight       //  |     |
			ECS_Corner,           // BottomLeft     //  |______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 202:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\____/|
			ECS_VerticalCorner,   // TopLeft        //  |      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 203:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  _______
			ECS_HorisontalCorner, // TopLeft        //  \      |
			ECS_Corner,           // TopRight       //   |     |
			ECS_HorisontalCorner, // BottomLeft     //  /______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 210:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  ________
			ECS_HorisontalCorner, // TopLeft        //  \      /
			ECS_HorisontalCorner, // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 211:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\_____
			ECS_VerticalCorner,   // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | _____/
			ECS_BeveledCorner     // BottomRight    //  |/
		);
		break;

		case 212:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_HorisontalCorner, // BottomLeft     //  /______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 213:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _____/|
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \_____ |
			ECS_VerticalCorner    // BottomRight    //        \|
		);
		break;

		case 220:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  ________
			ECS_HorisontalCorner, // TopLeft        //  \      /
			ECS_HorisontalCorner, // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 221:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\_____
			ECS_VerticalCorner,   // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | _____|
			ECS_Corner            // BottomRight    //  |/
		);
		break;

		case 222:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_HorisontalCorner, // BottomLeft     //  /______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 223:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _____/|
			ECS_Corner,           // TopLeft        //  |      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |_____ |
			ECS_VerticalCorner    // BottomRight    //        \|
		);
		break;

		case 230:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _______
			ECS_BeveledCorner,    // TopLeft        //  /      /
			ECS_HorisontalCorner, // TopRight       //  |      |
			ECS_HorisontalCorner, // BottomLeft     //  /______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 231:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\_____
			ECS_VerticalCorner,   // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \_____ |
			ECS_VerticalCorner    // BottomRight    //        \|
		);
		break;

		case 232:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  _______
			ECS_HorisontalCorner, // TopLeft        //  \      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 233:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _____/|
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_VerticalCorner,   // TopRight       //  |      |
			ECS_VerticalCorner,   // BottomLeft     //  | _____/
			ECS_BeveledCorner     // BottomRight    //  |/
		);
		break;

		case 240:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _______
			ECS_Corner,           // TopLeft        //  |      /
			ECS_HorisontalCorner, // TopRight       //  |      |
			ECS_HorisontalCorner, // BottomLeft     //  /______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 241:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  |\_____
			ECS_VerticalCorner,   // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |_____ |
			ECS_VerticalCorner    // BottomRight    //        \|
		);
		break;

		case 242:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //  _______
			ECS_HorisontalCorner, // TopLeft        //  \      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______\
			ECS_HorisontalCorner  // BottomRight    //
		);
		break;

		case 243:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   _____/|
			ECS_Corner,            // TopLeft       //  |      |
			ECS_VerticalCorner,    // TopRight      //  |      |
			ECS_VerticalCorner,    // BottomLeft    //  | _____|
			ECS_Corner             // BottomRight   //  |/
		);
		break;

		case 250:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 251:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_BeveledCorner,    // TopLeft        //  /      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______|
			ECS_Corner            // BottomRight    //
		);
		break;

		case 252:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      |
			ECS_Corner,           // TopRight       //  |      |
			ECS_BeveledCorner,    // BottomLeft     //  \______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 253:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //   ______
			ECS_Corner,           // TopLeft        //  |      \
			ECS_BeveledCorner,    // TopRight       //  |      |
			ECS_Corner,           // BottomLeft     //  |______/
			ECS_BeveledCorner     // BottomRight    //
		);
		break;

		case 0:
		default:
		DrawShapedBox(
			X, Y, Width, Height, Edge,              //
			ECS_BeveledCorner,    // TopLeft        //   ______
			ECS_BeveledCorner,    // TopRight       //  /      \
			ECS_BeveledCorner,    // BottomLeft     //  |      |
			ECS_BeveledCorner     // BottomRight    //  \______/
		);
		break;
	}
}

defaultproperties
{

}