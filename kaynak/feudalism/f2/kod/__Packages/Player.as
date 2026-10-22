class Player extends Creature
{
   var HP;
   var SP;
   var X;
   var Y;
   var _x;
   var _y;
   var active_skills;
   var agi_delay;
   var aspd_delay;
   var aspd_timer;
   var atkAnim;
   var attacking;
   var aura_skills;
   var body;
   var isHorseman;
   var isSwitchingWeapons;
   var moveX;
   var moveY;
   var nextX;
   var nextY;
   var speed;
   var team;
   var wpnPri;
   var curr_skill = 0;
   function Player()
   {
      super();
      this.team = 0;
      this.CreatureInit();
      this.speed = 4;
   }
   function moveOnDestination()
   {
      if(Key.isDown(_global.CO_LEFT_1) || Key.isDown(_global.CO_LEFT_2))
      {
         this.moveX = -1;
      }
      if(Key.isDown(_global.CO_RIGHT_1) || Key.isDown(_global.CO_RIGHT_2))
      {
         this.moveX = 1;
      }
      if(Key.isDown(_global.CO_UP_1) || Key.isDown(_global.CO_UP_2))
      {
         this.moveY = -1;
      }
      if(Key.isDown(_global.CO_DOWN_1) || Key.isDown(_global.CO_DOWN_2))
      {
         this.moveY = 1;
      }
   }
   function moveOn()
   {
      if(this.moveX == 0 && this.moveY == 0)
      {
         this.moveOnDestination();
         if(this.moveX != 0 || this.moveY != 0)
         {
            this.startMove();
         }
      }
      else
      {
         if(this.moveX != 0 && this.moveY == 0 && this.X != this.nextX)
         {
            if((Key.isDown(_global.CO_UP_1) || Key.isDown(_global.CO_UP_2)) && this.canGo(this.nextX,this.nextY - 1))
            {
               this.moveY = -1;
               _global.field[this.nextX][this.nextY].empty = true;
               this.nextY = this.Y + this.moveY;
               _global.field[this.nextX][this.nextY].empty = false;
               this._y -= Math.abs(_root.stgX(this.X) - this._x) / (_global.CAGE_W / _global.CAGE_H);
            }
            if((Key.isDown(_global.CO_DOWN_1) || Key.isDown(_global.CO_DOWN_2)) && this.canGo(this.nextX,this.nextY + 1))
            {
               this.moveY = 1;
               _global.field[this.nextX][this.nextY].empty = true;
               this.nextY = this.Y + this.moveY;
               _global.field[this.nextX][this.nextY].empty = false;
               this._y += Math.abs(_root.stgX(this.X) - this._x) / (_global.CAGE_W / _global.CAGE_H);
            }
         }
         if(this.moveY != 0 && this.moveX == 0 && this.Y != this.nextY)
         {
            if((Key.isDown(_global.CO_LEFT_1) || Key.isDown(_global.CO_LEFT_2)) && this.canGo(this.nextX - 1,this.nextY))
            {
               this.moveX = -1;
               _global.field[this.nextX][this.nextY].empty = true;
               this.nextX = this.X + this.moveX;
               _global.field[this.nextX][this.nextY].empty = false;
               this._x -= Math.abs(_root.stgY(this.Y) - this._y) / (_global.CAGE_H / _global.CAGE_W);
            }
            if((Key.isDown(_global.CO_RIGHT_1) || Key.isDown(_global.CO_RIGHT_2)) && this.canGo(this.nextX + 1,this.nextY))
            {
               this.moveX = 1;
               _global.field[this.nextX][this.nextY].empty = true;
               this.nextX = this.X + this.moveX;
               _global.field[this.nextX][this.nextY].empty = false;
               this._x += Math.abs(_root.stgY(this.Y) - this._y) / (_global.CAGE_H / _global.CAGE_W);
            }
         }
         this.moveOnX();
         this.moveOnY();
         this.moveNewStep();
         if(this.moveComplete())
         {
            this.moveX = 0;
            this.moveY = 0;
            this.moveOnDestination();
            if(this.moveX != 0 || this.moveY != 0)
            {
               if(!this.continueMove())
               {
                  this.stopMove();
               }
            }
            else
            {
               this.stopMove();
            }
         }
      }
   }
   function readyToGo()
   {
      return !this.isSwitchingWeapons && this.aspd_timer <= this.agi_delay;
   }
   function readyForAction()
   {
      return !this.isSwitchingWeapons && this.aspd_timer == 0 && this.moveX == 0 && this.moveY == 0;
   }
   function noEnemy(i, j)
   {
      return _global.field[i][j].empty || _global.field[i][j].who.team == 0 || _global.field[i][j].who.HP <= 0;
   }
   function attack()
   {
      var _loc4_;
      if(Key.isDown(_global.CO_ATTACK_1) || Key.isDown(_global.CO_ATTACK_2))
      {
         this.attacking = this["getEnemy" + this.wpnPri.TYPE]();
         if(this.attacking != null)
         {
            this.body._xscale = _root.znak(this.X - this.attacking.X) * 100;
         }
         this.aspd_timer = this.aspd_delay;
         if(this.curr_skill != 0)
         {
            _loc4_ = Skill.getCostSP(this.atkAnim,this.curr_skill);
            if(this.SP >= _loc4_)
            {
               this.SP -= _loc4_;
               this.body.gotoAndPlay(this.atkAnim + "_" + this.curr_skill);
            }
            else
            {
               this.setCurrentSkill(0);
               this.body.gotoAndPlay(this.atkAnim);
            }
         }
         else
         {
            this.body.gotoAndPlay(this.atkAnim);
         }
      }
      else if(Key.isDown(_global.CO_SWITCH))
      {
         this.switchWeapons();
      }
   }
   function directHit(useSecondWeapon)
   {
      if(useSecondWeapon == undefined)
      {
         useSecondWeapon = false;
      }
      this["hit" + this.wpnPri.TYPE](useSecondWeapon);
   }
   function getEnemyMelee()
   {
      var _loc4_ = null;
      switch(true)
      {
         case _global.field[this.X - _root.znak(this.body._xscale)][this.Y].who != null:
            _loc4_ = _global.field[this.X - _root.znak(this.body._xscale)][this.Y].who;
            break;
         case _global.field[this.X + _root.znak(this.body._xscale)][this.Y].who != null:
            _loc4_ = _global.field[this.X + _root.znak(this.body._xscale)][this.Y].who;
            break;
         default:
            return null;
      }
      if(_loc4_ instanceof Creature)
      {
         return _loc4_;
      }
      return null;
   }
   function getEnemyRanged()
   {
      return this.getNearestCreatureInSight(false);
   }
   function onEnterFrame()
   {
      if(this.HP > 0)
      {
         if(this.aspd_timer > 0)
         {
            this.aspd_timer = this.aspd_timer - 1;
         }
         if(this.readyForAction())
         {
            this.attack();
         }
         if(this.readyToGo())
         {
            this.moveOn();
         }
      }
   }
   function initSkills()
   {
      var _loc3_ = 0;
      while(_loc3_ < 3)
      {
         _root.scr["aura_" + (_loc3_ + 1)].gotoAndStop(Aura.getFrame(this.aura_skills[_loc3_][0]));
         if(!this.aura_skills[_loc3_])
         {
            trace("Hero aura #" + _loc3_ + " is missing! - " + this.aura_skills[_loc3_]);
            return undefined;
         }
         if(this.aura_skills[_loc3_][1] > 0)
         {
            _root.scr["aura_" + (_loc3_ + 1)].shade.gotoAndStop(3);
            _root.scr["aura_" + (_loc3_ + 1)].amount_txt.text = this.aura_skills[_loc3_][1];
         }
         else
         {
            _root.scr["aura_" + (_loc3_ + 1)].shade.gotoAndStop(1);
            _root.scr["aura_" + (_loc3_ + 1)].amount_txt.text = "";
         }
         _loc3_ = _loc3_ + 1;
      }
      if(this.isHorseman && this.wpnPri.TYPE == "Melee")
      {
         _loc3_ = 1;
         while(_loc3_ <= 3)
         {
            _root.scr["active_" + _loc3_].shade.gotoAndStop(3);
            _root.scr["active_" + _loc3_].amount_txt.text = "";
            _root.scr["active_" + _loc3_].gotoAndStop("none");
            _loc3_ = _loc3_ + 1;
         }
         return undefined;
      }
      if(this.active_skills[this.atkAnim])
      {
         _loc3_ = 0;
         while(_loc3_ < this.active_skills[this.atkAnim].length)
         {
            _root.scr["active_" + (_loc3_ + 1)].gotoAndStop(Skill.getActiveSkillFrame(this.atkAnim,_loc3_ + 1));
            if(this.active_skills[this.atkAnim][_loc3_] > 0)
            {
               _root.scr["active_" + (_loc3_ + 1)].shade.gotoAndStop(3);
               _root.scr["active_" + (_loc3_ + 1)].amount_txt.text = this.active_skills[this.atkAnim][_loc3_];
            }
            else
            {
               _root.scr["active_" + (_loc3_ + 1)].shade.gotoAndStop(1);
               _root.scr["active_" + (_loc3_ + 1)].amount_txt.text = "";
            }
            _loc3_ = _loc3_ + 1;
         }
      }
      else
      {
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _root.scr["active_" + (_loc3_ + 1)].amount_txt.text = "";
            _root.scr["active_" + (_loc3_ + 1)].gotoAndStop("none");
            _root.scr["active_" + (_loc3_ + 1)].shade.gotoAndStop(3);
            _loc3_ = _loc3_ + 1;
         }
      }
      this.setCurrentSkill(0);
   }
   function setCurrentSkill(skill_id)
   {
      if(!this.active_skills[this.atkAnim])
      {
         return undefined;
      }
      if(skill_id != 0 && this.active_skills[this.atkAnim][skill_id - 1] <= 0)
      {
         return undefined;
      }
      if(this.isHorseman && this.wpnPri.TYPE == "Melee")
      {
         return undefined;
      }
      if(skill_id != this.curr_skill)
      {
         this.curr_skill = skill_id;
      }
      else
      {
         this.curr_skill = 0;
      }
      _root.scr.resetCurrSkill(this.curr_skill);
   }
   function clickAura(aura_id)
   {
      if(this.aura_skills[aura_id - 1][1] <= 0)
      {
         return undefined;
      }
      if(this.endAura(aura_id))
      {
         _root.scr.resetCurrAura(aura_id,false);
         return undefined;
      }
      this.startAura(aura_id);
      _root.scr.resetCurrAura(aura_id,true);
   }
}
