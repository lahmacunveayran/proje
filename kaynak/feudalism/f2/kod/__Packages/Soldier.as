class Soldier extends Creature
{
   var HP;
   var MAX_SP;
   var SP;
   var X;
   var Y;
   var active_skills;
   var aspd_delay;
   var aspd_timer;
   var atkAnim;
   var attacking;
   var auraOn;
   var aura_skills;
   var body;
   var borders;
   var gox;
   var goy;
   var holdPosition;
   var isSwitchingWeapons;
   var light_circle;
   var moveX;
   var moveY;
   var mustMoveOut;
   var mustSwapGuns;
   var preferRanged;
   var skills_available;
   var team;
   var unit_ref;
   var wpnPri;
   function Soldier()
   {
      super();
      this.CreatureInit();
      this.light_circle.gotoAndStop(this.team + 1);
      this.light_circle._visible = _global.HIGHLIGHT_TROOPS;
      this.skills_available = new Array();
      this.holdPosition = false;
      this.borders._visible = false;
      this.mustSwapGuns = false;
      this.mustMoveOut = false;
      this.auraOn = false;
   }
   function readyForAction()
   {
      return this.moveX == 0 && this.moveY == 0 && this.aspd_timer == 0;
   }
   function chooseEnemyRanged()
   {
      var _loc5_ = this.getNearestCreatureInSight(false);
      var _loc4_;
      if(_loc5_ == null)
      {
         _loc4_ = 0;
         while(_loc4_ < _global.HERO)
         {
            if(_root["hero" + _loc4_].HP > 0 && _root["hero" + _loc4_].team != this.team)
            {
               _loc5_ = _root["hero" + _loc4_];
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      this.attacking = _loc5_;
   }
   function chooseEnemyMelee()
   {
      if(this.preferRanged)
      {
         this.switchWeapons();
         return undefined;
      }
      var _loc9_ = null;
      var _loc8_ = 10000;
      var _loc4_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc5_;
      while(_loc4_ < _global.HERO)
      {
         _loc6_ = _root["hero" + _loc4_].X - 1 >= 0 && _global.field[_root["hero" + _loc4_].X - 1][_root["hero" + _loc4_].Y].empty || _root["hero" + _loc4_].X - 1 == this.X && _root["hero" + _loc4_].Y == this.Y;
         _loc7_ = _root["hero" + _loc4_].X + 1 < _global.F_WIDTH && _global.field[_root["hero" + _loc4_].X + 1][_root["hero" + _loc4_].Y].empty || _root["hero" + _loc4_].X + 1 == this.X && _root["hero" + _loc4_].Y == this.Y;
         if(_root["hero" + _loc4_].HP > 0 && _root["hero" + _loc4_].team != this.team && (_loc6_ || _loc7_))
         {
            _loc5_ = this.dist(_root["hero" + _loc4_]);
            if(_loc5_ < _loc8_)
            {
               _loc9_ = _root["hero" + _loc4_];
               _loc8_ = _loc5_;
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      this.attacking = _loc9_;
   }
   function comeCloserRanged()
   {
      var _loc5_ = Math.abs((this.X - this.attacking.X) / (this.Y - this.attacking.Y)) >= _global.S_ANGLE;
      var _loc4_ = this.dist(this.attacking) <= this.wpnPri.rng;
      if(_loc5_ && _loc4_)
      {
         if(Math.abs(this.attacking.X - this.X) >= 1)
         {
            this.moveX = _root.znak(this.attacking.X - this.X);
         }
         if(this.attacking.Y - this.Y != 0)
         {
            this.moveY = _root.znak(this.attacking.Y - this.Y);
         }
      }
      else
      {
         if(!_loc5_)
         {
            this.moveY = _root.znak(this.attacking.Y - this.Y);
         }
         if(!_loc4_)
         {
            if(Math.abs(this.attacking.X - this.X) >= 1)
            {
               this.moveX = _root.znak(this.attacking.X - this.X);
            }
         }
      }
   }
   function comeCloserMelee()
   {
      if(Math.abs(this.attacking.X - this.X) >= 1)
      {
         this.moveX = _root.znak(this.attacking.X - this.X);
      }
      if(this.attacking.Y - this.Y != 0)
      {
         this.moveY = _root.znak(this.attacking.Y - this.Y);
      }
   }
   function attackEnemy()
   {
      this.body._xscale = _root.znak(this.X - this.attacking.X) * 100;
      var _loc6_ = !_global.RAGE[this.team] ? this.getAttackDelay() : this.getAttackDelay() - this.aspd_delay + 1;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this.skills_available.length)
      {
         _loc5_ = Skill.getCostSP(this.atkAnim,this.skills_available[_loc4_].rf);
         if(this.SP >= _loc5_ && _root.percent(this.skills_available[_loc4_].ch))
         {
            this.SP -= _loc5_;
            this.aspd_timer = _loc6_ + 10;
            this.body.gotoAndPlay(this.atkAnim + "_" + this.skills_available[_loc4_].rf);
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
      this.aspd_timer = _loc6_;
      this.body.play();
   }
   function moveOnDestination()
   {
      if(this.gox != null && this.goy != null)
      {
         if(this.gox != this.X)
         {
            this.moveX = _root.znak(this.gox - this.X);
         }
         if(this.goy != this.Y)
         {
            this.moveY = _root.znak(this.goy - this.Y);
         }
         if(this.gox == this.X && this.goy == this.Y)
         {
            this.gox = null;
            this.goy = null;
         }
      }
      else if(this.attacking != null && this.attacking.HP > 0)
      {
         if(this["canHit" + this.wpnPri.TYPE](this.attacking))
         {
            this.moveX = 0;
            this.moveY = 0;
         }
         else if(!this.holdPosition)
         {
            this["comeCloser" + this.wpnPri.TYPE]();
         }
         else
         {
            this.moveX = 0;
            this.moveY = 0;
         }
      }
      else
      {
         this.moveX = 0;
         this.moveY = 0;
      }
   }
   function moveOn()
   {
      this.moveOnX();
      this.moveOnY();
      this.moveNewStep();
      if(this.moveComplete())
      {
         if(this.gox != null && this.goy != null && !_global.field[this.gox][this.goy].empty && this.dist({X:this.gox,Y:this.goy}) == 1)
         {
            this.stopMove();
            return undefined;
         }
         this.moveX = 0;
         this.moveY = 0;
         this.moveOnDestination();
         if(this.moveX != 0 || this.moveY != 0)
         {
            if(this.moveY == 0 && _global.field[this.X + this.moveX][this.Y].who != null && _global.field[this.X + this.moveX][this.Y].who.team != this.team)
            {
               this.attacking = _global.field[this.X + this.moveX][this.Y].who;
               _global.field[this.X + this.moveX][this.Y].who.attacking = this;
               this.stopMove();
               return undefined;
            }
            if(!this.continueMove())
            {
               this.findMove();
               this.continueMove();
            }
         }
         else
         {
            this.stopMove();
         }
      }
   }
   function findMove()
   {
      var _loc6_ = 6;
      var _loc5_ = 0;
      var _loc8_;
      var _loc7_;
      var _loc4_ = -1;
      var _loc3_;
      while(_loc4_ <= 1)
      {
         _loc3_ = -1;
         while(_loc3_ <= 1)
         {
            if(_global.field[this.X + _loc4_][this.Y + _loc3_].empty && _global.field[this.X + _loc4_][this.Y + _loc3_].free)
            {
               _loc5_ = Math.abs(_loc4_ - this.moveX) + Math.abs(_loc3_ - this.moveY);
               if(_loc5_ < _loc6_)
               {
                  _loc6_ = _loc5_;
                  _loc8_ = _loc4_;
                  _loc7_ = _loc3_;
               }
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      this.moveX = _loc8_;
      this.moveY = _loc7_;
   }
   function AI()
   {
      if(this.isSwitchingWeapons)
      {
         return undefined;
      }
      if(this.readyForAction())
      {
         if(this.mustMoveOut)
         {
            this.mustMoveOut = false;
            this.moveOnDestination();
            if(!this.startMove())
            {
               this.findMove();
               this.startMove();
            }
            return undefined;
         }
         if(this.mustSwapGuns)
         {
            this.mustSwapGuns = false;
            this.switchWeapons();
            return undefined;
         }
         if(this.attacking != null)
         {
            if(this.attacking.HP <= 0)
            {
               this.attacking = null;
               return undefined;
            }
            if(this.wpnPri.TYPE == "Ranged" && this.canHitMelee(this.attacking))
            {
               this.switchWeapons();
               return undefined;
            }
            if(this["canHit" + this.wpnPri.TYPE](this.attacking))
            {
               this.attackEnemy();
            }
            else if(!this.holdPosition)
            {
               this["comeCloser" + this.wpnPri.TYPE]();
               if(!this.startMove())
               {
                  this.findMove();
                  this.startMove();
               }
            }
         }
         else
         {
            this.checkAura();
            this["chooseEnemy" + this.wpnPri.TYPE]();
         }
      }
      else if(this.moveX == 0 && this.moveY == 0)
      {
         this.aspd_timer = this.aspd_timer - 1;
      }
      else
      {
         this.moveOn();
      }
   }
   function onEnterFrame()
   {
      if(this.HP > 0)
      {
         this.AI();
      }
   }
   function initSkills()
   {
      delete this.skills_available;
      this.skills_available = new Array();
      if(!this.active_skills[this.atkAnim])
      {
         return undefined;
      }
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this.active_skills[this.atkAnim].length)
      {
         if(this.active_skills[this.atkAnim][_loc2_] > 0)
         {
            _loc3_ = 50 - Skill.getCostSP(this.atkAnim,_loc2_ + 1) / this.MAX_SP * 50;
            this.skills_available.push({ch:_loc3_,rf:_loc2_ + 1});
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function checkAura()
   {
      if(this.aura_skills.length > 0)
      {
         if(this.unit_ref != _global.EVIL_HERO)
         {
            this.holdPosition = this.startAura(1);
         }
         else
         {
            this.startAura(1);
         }
      }
   }
}
