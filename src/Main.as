package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Vu Nguyen
	 */
	public class Main extends Sprite 
	{
		[Embed(source="../lib/bar.jpg")]
		public var Bar:Class;
		
		[Embed(source="../lib/pall_clear.png")]
		public var Ball:Class;
		
		[Embed(source="../lib/button_play.png")]
		public var PlayBitmap:Class;
		
		[Embed(source="../lib/button_restart.png")]
		public var RestartBitmap:Class;
		
		private var state:String;
		
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			startGame();
		}
		
		private function startGame():void {
			state = "start";
			var playBitmap:Bitmap = new PlayBitmap();
			var playButton:MovieClip = new MovieClip();
			playButton.addChild(playBitmap);
			playButton.buttonMode = true;
			playButton.addEventListener(MouseEvent.CLICK, playGame);
			this.addChild(playButton);
			
			function playGame():void {
				playButton.parent.removeChild(playButton);
				gamePlay();
			}
		}
		
		private function gamePlay():void {
			state = "play";
			var bar1:Bitmap = new Bar();
			var bar2:Bitmap = new Bar();
			var b:Bitmap = new Ball();
			var txt1:TextField = new TextField();
			var txt2:TextField = new TextField();
			
			// variable held the states of the game
			var p1UpKey:Boolean = false;
			var p1DownKey:Boolean = false;
			var p2UpKey:Boolean = false;
			var p2DownKey:Boolean = false;
			
			var ballSpeedX:Number = 0;
			var ballSpeedY:Number = 0;
			var INITIAL_X:Number = 5;
			var INITIAL_Y:Number = 5;
			var VERTICAL_SPEED:Number = 20;
			var DISTANCE_WALL_PADDLE:Number = 80;
			
			var player1Score:int = 0;
			var player2Score:int = 0;
			
			var p1:MovieClip = new MovieClip();
			p1.addChild(bar1);
			
			var p2:MovieClip = new MovieClip();
			p2.addChild(bar2);
			
			var ball:MovieClip = new MovieClip();
			ball.addChild(b);
			
			this.addChild(p1);
			this.addChild(p2);
			this.addChild(ball);
			this.addChild(txt1);
			this.addChild(txt2);
			
			// align all the elements
			setUpUI();
			
			// initial the ball direction
			ballSpeedX = startBall(INITIAL_X);
			ballSpeedY = startBall(INITIAL_Y);
			
			// asign event listener to move ball
			ball.addEventListener(Event.ENTER_FRAME, moveBall);
			p1.addEventListener(Event.ENTER_FRAME, movePaddle1);
			p2.addEventListener(Event.ENTER_FRAME, movePaddle2);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, checkKeyUp);
			
			
			// helper functions
			
			function setUpUI():void {
				// align ball
				ball.x = stage.stageWidth/2 - ball.width / 2;
				ball.y = stage.stageHeight / 2 - ball.height / 2;
				
				// align player 1
				p1.x = DISTANCE_WALL_PADDLE;
				p1.y = stage.stageHeight / 2 - p1.height / 2;
				
				// align player 2
				p2.x = stage.stageWidth - DISTANCE_WALL_PADDLE - p2.width;
				p2.y = stage.stageHeight / 2 - p2.height / 2;
				
				// align text fields
				txt1.x = DISTANCE_WALL_PADDLE;
				txt1.y = 10;				
				txt2.x = stage.stageWidth - DISTANCE_WALL_PADDLE - p2.width;
				txt2.y = 10;

				// display scores
				displayScore(player1Score, player2Score);
			}
			
			function startBall(iniSpeed:Number):Number {
				if (Math.random() < 0.5) {
					trace("Initial:" + (-iniSpeed));
					return -iniSpeed;
				}
				trace("Initial:" + iniSpeed);
				return iniSpeed;
			}
		
			function moveBall(event:Event):void {
				if (state == "play") {
					ball.x += ballSpeedX;
					ball.y += ballSpeedY;
					
					// check to see it hits the paddles or the wall
					checkBallState();
				}
			}
			
			function checkBallState():void {
				
				if (ball.x <= (p1.width + DISTANCE_WALL_PADDLE) && ball.x >= (DISTANCE_WALL_PADDLE - ball.width)
					&& ball.y <= (p1.y + p1.height) && ball.y >= (p1.y - ball.height)) {
					// hit paddle 1
					if (ballSpeedX < 0) {
						ball.x = p1.width + DISTANCE_WALL_PADDLE;
					} else {
						ball.x = DISTANCE_WALL_PADDLE - ball.width;
					}
					
					/*if (ball.y == (p1.y + p1.height) || ball.y == (p1.y - ball.height)) {
						// increase speed by 2
						ballSpeedX = (ballSpeedX > 0)? -ballSpeedX - 2: -ballSpeedX + 2;
						if (ball.y == p1.y + p1.height) {
							// hit the bottom corner of p1
							// increase ballSpeedY by 2
							ballSpeedY = (ballSpeedY > 0)? -ballSpeedY - 2: -ballSpeedY + 2;
						} else {
							// hit the top corner of p2
							// decrease ballSpeedY by 2
							ballSpeedY = (ballSpeedY > 0)? -ballSpeedY + 2: -ballSpeedY - 2;
						}
					} else {
						ballSpeedX = (ballSpeedX > 0)? -ballSpeedX - 1: -ballSpeedX + 1;
					}*/
					ballSpeedX = -ballSpeedX;
					return;
				}
				
				if (ball.x >= (stage.stageWidth - DISTANCE_WALL_PADDLE - p2.width - ball.width) && ball.x <= (stage.stageWidth - DISTANCE_WALL_PADDLE - ball.width)
					&& ball.y <= (p2.y + p2.height) && ball.y >= (p2.y - ball.height)) {
					// hit paddle 2
					if (ballSpeedX > 0) {
						ball.x = stage.stageWidth - DISTANCE_WALL_PADDLE - p2.width - ball.width;
					} else {
						ball.x = stage.stageWidth - DISTANCE_WALL_PADDLE;
					}
					
					/*if (ball.y == (p2.y + p2.height) || ball.y == (p2.y - ball.height)) {
						// increase speed by 2
						ballSpeedX = (ballSpeedX > 0)? -ballSpeedX - 2: -ballSpeedX + 2;
						if (ball.y == p2.y + p2.height) {
							// hit the bottom corner of p2
							// increase ballSpeedY by 2
							ballSpeedY = (ballSpeedY > 0)? -ballSpeedY - 2: -ballSpeedY + 2;
						} else {
							// hit the top corner of p2
							// decrease ballSpeedY by 2
							ballSpeedY = (ballSpeedY > 0)? -ballSpeedY + 2: -ballSpeedY - 2;
						}
					} else {
						ballSpeedX = (ballSpeedX > 0)? -ballSpeedX - 1: -ballSpeedX + 1;
					}*/
					ballSpeedX = -ballSpeedX;
					return;
				}
				
				if (ball.x <= 0 || ball.x >= (stage.stageWidth - ball.width)) {
					// hit left wall OR right wall
					ballSpeedX = -ballSpeedX;
					if (ball.x <= 0) {
						// add score for p2
						ball.x = 0;
						player2Score++;
					} else {
						// add score for p1
						ball.x = stage.stageWidth - ball.width;
						player1Score++;
					}
					displayScore(player1Score, player2Score);
					return;
				}
				
				if (ball.y <= 0 || ball.y >= (stage.stageHeight - ball.height)) {
					// hit top wall OR bottom wall
					ballSpeedY = -ballSpeedY;
					if (ball.y <= 0) {
						ball.y = 0;
					} else {
						ball.y = stage.stageHeight - ball.height;
					}
					return;
				}
			}
			
			function checkKeyDown(event:KeyboardEvent):void {
				if (event.keyCode == 38) {
					// up arrow
					p2UpKey = true;
				}
				
				if (event.keyCode == 40) {
					// down arrow
					p2DownKey = true;
				}
				
				if (event.keyCode == 87) {
					// W key
					p1UpKey = true;
				}
				
				if (event.keyCode == 83) {
					// S key
					p1DownKey = true;
				}
				
				
			}
			
			function checkKeyUp(event:KeyboardEvent):void {
				if (event.keyCode == 38) {
					// up arrow
					p2UpKey = false;
				}
				
				if (event.keyCode == 40) {
					// down arrow
					p2DownKey = false;
				}
				
				if (event.keyCode == 87) {
					// W key
					p1UpKey = false;
				}
				
				if (event.keyCode == 83) {
					// S key
					p1DownKey = false;
				}
			}
			
			function movePaddle1(event:Event):void {
				if (state == "play") {
					if (p1UpKey) {
						p1.y -= VERTICAL_SPEED;
						if (p1.y < 0) {
							p1.y = 0;
						}
					}
					
					if (p1DownKey) {
						p1.y += VERTICAL_SPEED;
						if (p1.y > stage.stageHeight - p1.height) {
							p1.y = stage.stageHeight - p1.height;
						}
					}
				}
			}
			
			function movePaddle2(event:Event):void {
				if (state == "play") {
					if (p2UpKey) {
						p2.y -= VERTICAL_SPEED;
						if (p2.y < 0) {
							p2.y = 0;
						}
					}
						
					if (p2DownKey) {
						p2.y += VERTICAL_SPEED;
						if (p2.y > stage.stageHeight - p2.height) {
							p2.y = stage.stageHeight - p2.height;
						}
					}
				}
			}
			
			function displayScore(s1:int, s2:int):void {
				if (state == "play") {
					txt1.text = "Player 1: " + s1;
					txt2.text = "Player 2: " + s2;
					var f1:TextFormat = new TextFormat();
					f1.color = 0xff0066;
					f1.font = "Arial";
					f1.size = 18;
					txt1.setTextFormat(f1);
					
					var f2:TextFormat = new TextFormat();
					f2.color = 0x00cc00;
					f2.font = "Arial";
					f2.size = 18;
					txt2.setTextFormat(f2);
					
					if (s1 >= 1 || s2 >= 1) {
						// remove all children in the stage
						ball.parent.removeChild(ball);
						p1.parent.removeChild(p1);
						p2.parent.removeChild(p2);
						txt1.parent.removeChild(txt1);
						txt2.parent.removeChild(txt2);
						endGame();
					}
				}
			}
		}
		
		private function endGame():void {
			state = "end";
			//stage.removeChildren();
			var restartB:Bitmap = new RestartBitmap();
			var restartButton:MovieClip = new MovieClip();
			restartButton.addChild(restartB);
			restartButton.buttonMode = true;
			restartButton.addEventListener(MouseEvent.CLICK, onClick);
			restartButton.x = 0;
			restartButton.y = 0;
			this.addChild(restartButton);
			trace("End");
			function onClick():void {
				restartButton.parent.removeChild(restartButton);
				gamePlay();
			}
		}
		
	}
	
}