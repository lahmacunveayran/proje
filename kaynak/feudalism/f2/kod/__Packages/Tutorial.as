class Tutorial extends MovieClip
{
   var added_things;
   var curr_lesson;
   var old_friends;
   var wnd;
   function Tutorial()
   {
      super();
      this.added_things = new Array();
      this.swapDepths(7010);
      this.curr_lesson = 1;
      this.old_friends = _global.FRIENDS;
      _global.FRIENDS = new Array();
      var _loc7_ = new Unit("Mon","bow",0);
      var _loc6_ = 0;
      while(_loc6_ < 15)
      {
         _global.FRIENDS.push(_loc7_);
         _loc6_ = _loc6_ + 1;
      }
      _global.HERO = 1;
      delete _global.LOOT;
      _global.LOOT = new Array();
      _global.AURAS = new Array();
      _global.EXP_GOT = 0;
      _global.GOLD_GOT = 0;
      _root.attachMovie("BattleCursor","_cursor",7001,{_x:this._xmouse,_y:this._ymouse});
      _root.attachMovie("Screen","scr",6002,{_x:0,_y:0});
      _loc6_ = 0;
      var _loc5_;
      while(_loc6_ < _global.F_WIDTH)
      {
         _loc5_ = 0;
         while(_loc5_ < _global.F_HEIGHT)
         {
            _global.field[_loc6_][_loc5_].empty = true;
            _global.field[_loc6_][_loc5_].free = true;
            _global.field[_loc6_][_loc5_].who = null;
            _loc5_ = _loc5_ + 1;
         }
         _loc6_ = _loc6_ + 1;
      }
      _root._quality = _global.SAVED_QUALITY;
      _root.onEnterFrame = _root.tutorialEnterFrame;
      var _loc8_ = new Hero();
      _loc8_.playerTutorialDummy();
      _root.addHero(22,415,_loc8_,0);
      this.lessonStart1();
   }
   function showMsg(msg)
   {
      this.wnd.msg_txt.text = msg;
   }
   function endTutorial()
   {
      _root.unloadMap();
      var _loc4_ = 0;
      while(_loc4_ < this.added_things.length)
      {
         this.added_things[_loc4_].removeMovieClip();
         _loc4_ = _loc4_ + 1;
      }
      _global.FRIENDS = this.old_friends;
      _root.gotoAndStop("TOWN_SCREEN");
      this.removeMovieClip();
   }
   function addPositionMark(xx, yy)
   {
      var _loc3_ = _root.getDepthDown(xx,yy);
      this.added_things.push(_root.attachMovie("Position mark","dw_" + _loc3_,_loc3_,{_x:_root.stgX(xx),_y:_root.stgY(yy)}));
   }
   function addDummy(xx, yy, tm)
   {
      if(_root.hero0.X == xx && _root.hero0.Y == yy)
      {
         return false;
      }
      var _loc2_ = new Hero();
      _loc2_.enemyTutorialDummy();
      _root.addUnit(_root.stgX(xx),_root.stgY(yy),_loc2_,tm);
      return true;
   }
   function delPositionMark(xx, yy)
   {
      var _loc2_ = _root.getDepthDown(xx,yy);
      _root["dw_" + _loc2_].removeMovieClip();
   }
   function lessonStart1()
   {
      this.addPositionMark(3,3);
      this.showMsg("Move your hero with WASD or arrow keys. Come to this spot.");
   }
   function lessonStart2()
   {
      this.delPositionMark(3,3);
      this.addDummy(19,4,1);
      _root.hero1.holdPosition = true;
      this.showMsg("Attack with space. Come closer to enemy and shoot him with your bow.");
   }
   function lessonStart3()
   {
      _root.hero1.die();
      this.showMsg("Switch weapons with Shift. Press Shift to switch to take sword.");
   }
   function lessonStart4()
   {
      this.showMsg("You also can use skills instead of normal attack if you\'ve mastered them. To switch to skill, click on its icon at the bottom of screen. Or press hotkey - 1.");
   }
   function lessonStart5()
   {
      var _loc3_ = new Hero();
      _loc3_.enemyTutorialDummy();
      if(!this.addDummy(19,3,1))
      {
         this.addDummy(19,5,1);
      }
      _root.hero2.holdPosition = true;
      this.showMsg("To use chosen skill press space. Now come close to enemy and hit him with the skill attack. You\'ll see that the damage is increased greately.");
   }
   function lessonStart6()
   {
      this.showMsg("If you have some men with bows or crossbows in your reserve, it\'s possblie to order them to shoot at enemy position. Now Click on Arrow Shower icon and then click on ground.");
   }
   function lessonStart7()
   {
      if(_root.hero2.HP > 0)
      {
         _root.hero2.die();
      }
      var _loc3_ = 0;
      while(_loc3_ < 5)
      {
         this.addDummy(19,_loc3_,1);
         this.addDummy(0,_loc3_,0);
         this.addDummy(4,_loc3_,0);
         _loc3_ = _loc3_ + 1;
      }
      this.showMsg("You will not fight alone - your army is a great help in battle. But you\'d better help them a little too.");
   }
   function lessonStart8()
   {
      this.showMsg("Great, you\'ve finished with tutorial. Good luck on your journey!");
      this.gotoAndStop(2);
   }
   function lessonCheck1()
   {
      return _root.hero0.X == 3 && _root.hero0.Y == 3;
   }
   function lessonCheck2()
   {
      return _root.hero1.HP < _root.hero1.MAX_HP;
   }
   function lessonCheck3()
   {
      return _root.hero0.atkAnim == "2H_sword";
   }
   function lessonCheck4()
   {
      return _root.hero0.curr_skill != 0;
   }
   function lessonCheck5()
   {
      return _root.hero0.SP < _root.hero0.MAX_SP;
   }
   function lessonCheck6()
   {
      return !_root.scr.control_shower.is_ready;
   }
   function lessonCheck7()
   {
      return _root.getTeamCount(1) == 0;
   }
   function onEnterFrame()
   {
      if(this["lessonCheck" + this.curr_lesson]())
      {
         this.curr_lesson = this.curr_lesson + 1;
         this["lessonStart" + this.curr_lesson]();
      }
   }
}
