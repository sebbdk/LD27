package dk.sebb.tiled
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class InfoBox extends Sprite
	{
		public var field:TextField;
		public var bg:Sprite = new Sprite();
		private var format:TextFormat;
		
		public var hasConvo:Boolean = false;
		
		public var currentConvo:String = "";
		public var currentConvoIndex:int = 0;
		
		public function InfoBox()
		{
			super();

			addChild(bg);
			
			format = new TextFormat();
			format.size = 14;
			format.font = "courier";
			field = new TextField();
			field.text = "";
			field.setTextFormat(format);
			field.multiline = true;
			field.y = 23;
			field.x = 20;
			field.width = 740;
			addChild(field);
			
			x = 10;
		}

		
		/**
		 * Loads a conversation
		 * 
		 * id: the name of the conversation to load from the conversation resource file
		 * pause: wether or not to pause the game while the conversation takes place
		 * */
		public function convo(id:String, pause:Boolean = true):void {
			if(Level.data.conversations[id]) {
				hasConvo = true;
				visible = true;
				currentConvo = id;
				currentConvoIndex = 0;
				Level.pause();

				convoNext();
			} else {
				trace('tried to init none existant conversation "' + id + '"');	
			}
			
			
			/*
			return;
			trace('Initiate convo with id:', id, pause);
			if(Level.data.conversations && Level.data.conversations[id] && id != currentConvo) {
				trace("OPEN INFO!");
				var lines:String = "";
				for each(var stmtnt:Object in Level.data.conversations[id].statements) {
					lines += Level.data.people[stmtnt.person].name + ": " + stmtnt.text + "\n";
				}
				
				Level.pause();
				write(lines);
				currentConvo = id;
			} else {
				currentConvo = "";
				Level.unPause();
				visible = false;
			}
			*/
		}
		
		public function convoNext():void {
			if(currentConvo !== "" && Level.data.conversations[currentConvo]) {
				var stmtnt:Object = Level.data.conversations[currentConvo].statements[currentConvoIndex];
				if(stmtnt) {
					hasConvo = true;
					write(Level.data.people[stmtnt.person].name + ": " + stmtnt.text + "\n");
					currentConvoIndex++;
				} else {
					hasConvo = false;
					visible = false;
					currentConvo = "";
					currentConvoIndex = 0;
					Level.unPause();
				}
			}
		}
		
		public function write(text:String):void {
			visible = true;
			var lineCount:int = text.split('\n').length;
			
			field.text = text;
			field.setTextFormat(format);
			
			var height:int = field.textHeight + 45;
			
			bg.graphics.clear();
			bg.graphics.lineStyle(3,0x929191);
			bg.graphics.beginFill(0xD7D5D5);
			bg.graphics.drawRect(0, 0, 780, height);
			bg.graphics.endFill();
			
			
			y = 600 - height - 10
		}
	}
}