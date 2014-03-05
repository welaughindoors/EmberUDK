package CustomClasses 
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.system.fscommand;
	
	public class Main extends MovieClip
	{
		trace ('Main Class is functional.');
			private var cursor:cursor_mc;
			
		public function Main() 
		{
			trace ('Main constructor is functional.');
				FixCursor(true);
			stop();
		}
		private function DisplayMainMenu():void
		{
			gotoAndStop('Main Menu');
			subMenu_btn.addEventListener(MouseEvent.CLICK, clickSubMenu);
			exit_btn.addEventListener(MouseEvent.CLICK, clickExit);
				FixCursor();
		}
		private function DisplaySubMenu():void
		{
			gotoAndStop('Sub Menu');
			play_btn.addEventListener(MouseEvent.CLICK, clickPlay);
			back_btn.addEventListener(MouseEvent.CLICK, clickBack);
				FixCursor();
		}
		private function clickSubMenu(e:MouseEvent):void
		{
			trace('Clicked Sub Menu Button');
			DisplaySubMenu();
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
			if(newCursor)
			{
				trace('Creating a new cursor...')
				cursor = new cursor_mc();
			}
			else
			{
				trace('Fixing existing cursor...')
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
