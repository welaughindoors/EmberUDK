package CustomClasses
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.fscommand;

	public class Main extends MovieClip
	{
		trace('Main Class is functional.');
		private var cursor:cursor_mc;

		public function Main()
		{
			trace('Main Constructor is functional.');
			FixCursor(true);
			DisplayMainMenu();
		}
		private function DisplayMainMenu():void
		{
			gotoAndStop('Main Menu');
			emberPlay_btn.addEventListener(MouseEvent.CLICK, clickPlayMenu);
			emberQuit_btn.addEventListener(MouseEvent.CLICK, clickExit);
			FixCursor();
		}
		private function DisplayPlayMenu():void
		{
			gotoAndStop('Play Menu');
			emberLaunch_btn.addEventListener(MouseEvent.CLICK, clickPlay);
			emberMap_btn.addEventListener(MouseEvent.CLICK, clickMapMenu);
			back_btn.addEventListener(MouseEvent.CLICK, clickBack);
			FixCursor();
		}
		private function DisplayMapMenu():void
		{
			gotoAndStop('Map Menu');
			back2_btn.addEventListener(MouseEvent.CLICK, clickBack2);
			FixCursor();
		}
		private function clickMapMenu(e:MouseEvent):void
		{
			trace('Clicked Map Menu button');
			DisplayMapMenu();
		}
		private function clickBack2(e:MouseEvent):void
		{
			trace('Clicked Map menu back button');
			DisplayPlayMenu();
		}
		private function clickPlayMenu(e:MouseEvent):void
		{
			trace('Clicked Play Menu Button');
			DisplayPlayMenu();
		}
		private function clickBack(e:MouseEvent):void
		{
			trace('Clicked Back Button');
			DisplayMainMenu();
		}
		private function clickExit(e:MouseEvent):void
		{
			trace('Clicked Exit Button');
			fscommand('ExitGame');
		}
		private function clickPlay(e:MouseEvent):void
		{
			trace('Clicked Play Button');
			fscommand('PlayMap');
		}
		private function FixCursor(newCursor:Boolean=false):void
		{
			if (newCursor)
			{
				trace('Creating a new cursor...');
				cursor = new cursor_mc();
			}
			else
			{
				trace('Fixing existing cursor...');
				removeChild(cursor);
			}
			addChild(cursor);
			cursor.x = mouseX;
			cursor.y = mouseY;
			cursor.startDrag();
			trace('Cursor Fixed.');
		}
	}
}