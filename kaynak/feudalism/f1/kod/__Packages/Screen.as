class Screen extends MovieClip
{
   var control_shower;
   var control_wall;
   var hint;
   var hp_bottle;
   var hp_txt;
   var portrait;
   var potion_1_txt;
   var potion_2_txt;
   var potion_3_txt;
   var rage_anim;
   var rage_timer;
   var scroll_1_txt;
   var scroll_2_txt;
   var scroll_3_txt;
   var unit_hp_txt;
   function Screen()
   {
      super();
      this.rage_timer = 0;
      this.rage_anim._visible = false;
      this.portrait._visible = false;
      this.hint._xscale = 130;
      this.hint._yscale = 130;
      this.potion_1_txt.text = _global.POTION_HealSmall;
      this.potion_2_txt.text = _global.POTION_HealMedium;
      this.potion_3_txt.text = _global.POTION_HealBig;
      this.scroll_1_txt.text = _global.SCROLL_AllHealSmall;
      this.scroll_2_txt.text = _global.SCROLL_AllHealBig;
      this.scroll_3_txt.text = _global.SCROLL_Rage;
      this.reinitArrowStorm();
   }
   function makeThemGo(xx, yy)
   {
      var _loc2_ = 0;
      while(_loc2_ < _global.SELECTED.length)
      {
         _global.SELECTED[_loc2_].mustMoveOut = true;
         _global.SELECTED[_loc2_].gox = xx;
         _global.SELECTED[_loc2_].goy = yy;
         _loc2_ = _loc2_ + 1;
      }
   }
   function makeThemAttack(xx, yy)
   {
      var _loc3_ = _global.field[xx][yy].who;
      var _loc2_ = 0;
      while(_loc2_ < _global.SELECTED.length)
      {
         _global.SELECTED[_loc2_].attacking = _loc3_;
         _global.SELECTED[_loc2_].gox = null;
         _global.SELECTED[_loc2_].goy = null;
         _loc2_ = _loc2_ + 1;
      }
   }
   function screenOnPress()
   {
      switch(_root.cursor._currentframe)
      {
         case 1:
            _root.attachMovie("SelectBorder","select_border",6001,{_x:_root._xmouse,_y:_root._ymouse});
            return undefined;
         case 2:
            this.makeArrowShower(_root.getX(_root._xmouse),_root.getY(_root._ymouse));
            _root.cursor.gotoAndStop(1);
            this.control_shower.gotoAndPlay(1);
            return undefined;
         case 3:
            this.makeArrowWall(_root.getX(_root._xmouse),_root.getY(_root._ymouse));
            _root.cursor.gotoAndStop(1);
            this.control_wall.gotoAndPlay(1);
            return undefined;
         default:
            return;
      }
   }
   function screenOnRelease()
   {
      var _loc5_;
      var _loc4_;
      if(_root.select_border == undefined | (_root.select_border._width <= 10 && _root.select_border._height <= 10))
      {
         _loc5_ = _root.getX(_root._xmouse);
         _loc4_ = _root.getY(_root._ymouse);
         if(_global.field[_loc5_][_loc4_].free)
         {
            if(_global.field[_loc5_][_loc4_].empty)
            {
               this.makeThemGo(_loc5_,_loc4_);
            }
            else if(_global.field[_loc5_][_loc4_].who.HP > 0 && _global.field[_loc5_][_loc4_].who._name != "hero0")
            {
               if(_global.field[_loc5_][_loc4_].who.team == 0)
               {
                  _root.deselectUnits();
                  _global.SELECTED[0] = _global.field[_loc5_][_loc4_].who;
                  _global.field[_loc5_][_loc4_].who.borders._visible = true;
                  this.reloadPortrait(true);
               }
               else
               {
                  this.makeThemAttack(_loc5_,_loc4_);
               }
            }
         }
      }
   }
   function reloadPortrait(option)
   {
      if(option)
      {
         this.portrait.head.gotoAndStop(_global.SELECTED[0].body.head._currentframe);
         this.portrait.head.armor._visible = _global.SELECTED[0].body.head.armor._visible;
         this.portrait.head.armor.gotoAndStop(_global.SELECTED[0].body.head.armor._currentframe);
         this.portrait._visible = true;
      }
      else
      {
         this.portrait._visible = false;
      }
   }
   function onEnterFrame()
   {
      if(_global.SELECTED.length > 0 && _global.SELECTED[0].HP > 0)
      {
         this.unit_hp_txt.text = _global.SELECTED[0].HP + "/" + _global.SELECTED[0].MAX_HP;
      }
      else
      {
         this.unit_hp_txt.text = "";
      }
      this.hp_txt.text = _root.hero0.HP + "/" + _root.hero0.MAX_HP;
      this.hp_bottle.hp_bar._yscale = _root.hero0.HP / _root.hero0.MAX_HP * 100;
      if(_global.times == 0)
      {
         if(this.rage_timer > 0)
         {
            this.rage_timer = this.rage_timer - 1;
            if(this.rage_timer == 0)
            {
               this.rage_anim._visible = false;
               _global.RAGE[0] = false;
            }
         }
      }
   }
   function makeThemHoldPosition()
   {
      var _loc3_ = !_global.SELECTED[0].holdPosition;
      var _loc2_ = 0;
      while(_loc2_ < _global.SELECTED.length)
      {
         _global.SELECTED[_loc2_].holdPosition = _loc3_;
         _loc2_ = _loc2_ + 1;
      }
   }
   function makeThemSwapWeapons()
   {
      var _loc2_ = 0;
      while(_loc2_ < _global.SELECTED.length)
      {
         if(_global.SELECTED[_loc2_].secAtkAnim != "No")
         {
            _global.SELECTED[_loc2_].mustMoveOut = false;
            _global.SELECTED[_loc2_].gox = null;
            _global.SELECTED[_loc2_].goy = null;
            _global.SELECTED[_loc2_].attacking = null;
            _global.SELECTED[_loc2_].mustSwapGuns = true;
            _global.SELECTED[_loc2_].preferRanged = !_global.SELECTED[_loc2_].preferRanged;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function makeThemStop()
   {
      var _loc2_ = 0;
      while(_loc2_ < _global.SELECTED.length)
      {
         _global.SELECTED[_loc2_].mustMoveOut = false;
         _global.SELECTED[_loc2_].gox = null;
         _global.SELECTED[_loc2_].goy = null;
         _global.SELECTED[_loc2_].attacking = null;
         _loc2_ = _loc2_ + 1;
      }
   }
   function makeThemHealHero(heal_amount)
   {
      if(_global.mana[0] >= _global.PRICES.SPELL_HealHero && _root.hero0.HP < _root.hero0.MAX_HP)
      {
         _global.mana[0] -= _global.PRICES.SPELL_HealHero;
         _root.hero0.HP += heal_amount;
         if(_root.hero0.HP > _root.hero0.MAX_HP)
         {
            _root.hero0.HP = _root.hero0.MAX_HP;
         }
         _root.hero0.redrawHealthBar();
         _root.hero0.attachMovie("HealAnim","anim",1);
      }
   }
   function makeThemHealUnits(amount)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.HERO)
      {
         if(_root["hero" + _loc3_].HP > 0 && _root["hero" + _loc3_].team == 0)
         {
            _root["hero" + _loc3_].HP += Math.round(_root["hero" + _loc3_].MAX_HP * amount);
            if(_root["hero" + _loc3_].HP > _root["hero" + _loc3_].MAX_HP)
            {
               _root["hero" + _loc3_].HP = _root["hero" + _loc3_].MAX_HP;
            }
            _root["hero" + _loc3_].attachMovie("HealAnim","anim",1);
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function makeThemRage()
   {
      this.rage_anim._visible = true;
      _global.RAGE[0] = true;
      this.rage_timer = 60;
   }
   function makeArrowShower(xx, yy)
   {
      var _loc6_ = 0;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < _global.FRIENDS.length)
      {
         if(_global.FRIENDS[_loc3_].WEAPON_PRI.TYPE == "Bow")
         {
            _loc6_ = _loc6_ + 1;
            _loc4_ = _global.FRIENDS[_loc3_].WEAPON_PRI.dmg + _root.dice(_global.FRIENDS[_loc3_].WEAPON_PRI.rnd);
            _loc5_ = _root.percent(_global.FRIENDS[_loc3_].WEAPON_PRI.crit);
            _root.addArrowShower(xx + _root.dd(2),yy + _root.dd(2),_loc4_,_loc5_);
            _root.addArrowShower(xx + _root.dd(2),yy + _root.dd(2),_loc4_,_loc5_);
            if(_loc6_ >= 8)
            {
               break;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function makeArrowWall(xx, yy)
   {
      var _loc6_ = 0;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < _global.FRIENDS.length)
      {
         if(_global.FRIENDS[_loc3_].WEAPON_PRI.TYPE == "Crossbow")
         {
            _loc6_ = _loc6_ + 1;
            _loc4_ = _global.FRIENDS[_loc3_].WEAPON_PRI.dmg + _root.dice(_global.FRIENDS[_loc3_].WEAPON_PRI.rnd);
            _loc5_ = _root.percent(_global.FRIENDS[_loc3_].WEAPON_PRI.crit);
            _root.addArrowWall(xx,yy + _root.dd(2),_loc4_,_loc5_);
            if(_loc6_ >= 5)
            {
               break;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function reinitArrowStorm()
   {
      var _loc5_ = 0;
      var _loc6_ = 0;
      var _loc4_ = _global.MAX_UNIT_AMOUNT - _root.getTeamCount(0);
      while(_loc4_ < _global.FRIENDS.length)
      {
         if(_global.FRIENDS[_loc4_].WEAPON_PRI.TYPE == "Bow")
         {
            _loc5_ = _loc5_ + 1;
         }
         if(_global.FRIENDS[_loc4_].WEAPON_PRI.TYPE == "Crossbow")
         {
            _loc6_ = _loc6_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      if(_loc5_ == 0)
      {
         this.control_shower.gotoAndStop(46);
      }
      if(_loc6_ == 0)
      {
         this.control_wall.gotoAndStop(66);
      }
   }
}
