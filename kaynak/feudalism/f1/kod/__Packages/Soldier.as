class Soldier extends Creature
{
   var HP;
   var X;
   var Y;
   var atkAnim;
   var attacking;
   var body;
   var borders;
   var gox;
   var goy;
   var holdPosition;
   var isBusy;
   var light_circle;
   var moveX;
   var moveY;
   var mustMoveOut;
   var mustSwapGuns;
   var preferRanged;
   var t_aft;
   var t_bef;
   var team;
   var wpn;
   function Soldier()
   {
      super();
      this.Creature();
      this.light_circle.gotoAndStop(this.team + 1);
      this.light_circle._visible = _global.HIGHLIGHT_TROOPS;
      this.holdPosition = false;
      this.borders._visible = false;
      this.mustSwapGuns = false;
      this.mustMoveOut = false;
   }
   function readyForAction()
   {
      return this.moveX == 0 && this.moveY == 0 && !this.isBusy && this.t_bef == 0 && this.t_aft == 0;
   }
   function chooseEnemyRanged()
   {
      var _loc8_ = null;
      var _loc6_ = 10000;
      var _loc7_ = false;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _global.HERO)
      {
         if(_root["hero" + _loc4_].HP > 0 && _root["hero" + _loc4_].team != this.team)
         {
            if(_loc7_ == this.canHitRanged(_root["hero" + _loc4_]))
            {
               _loc5_ = this.dist(_root["hero" + _loc4_]);
               if(_loc5_ < _loc6_)
               {
                  _loc8_ = _root["hero" + _loc4_];
                  _loc6_ = _loc5_;
               }
            }
            else if(!_loc7_)
            {
               _loc7_ = true;
               _loc8_ = _root["hero" + _loc4_];
               _loc6_ = this.dist(_root["hero" + _loc4_]);
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      this.attacking = _loc8_;
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
   function canHitRanged(man)
   {
      var _loc8_ = this.dist(man);
      if(_loc8_ == 1)
      {
         this.switchWeapons();
         return true;
      }
      var _loc5_;
      var _loc7_;
      var _loc4_;
      if(Math.abs((this.X - man.X) / (this.Y - man.Y)) >= _global.S_ANGLE)
      {
         if(_loc8_ <= this.wpn.rng)
         {
            _loc5_ = _root.znak(man.X - this.X);
            _loc7_ = (this.X - man.X) / (this.Y - man.Y);
            _loc4_ = this.X + _loc5_;
            while(_loc4_ != man.X)
            {
               if(!_global.field[_loc4_][this.Y + Math.round((_loc4_ - this.X + _loc5_) / _loc7_)].free)
               {
                  return false;
               }
               _loc4_ += _loc5_;
            }
            return true;
         }
      }
      return false;
   }
   function canHitMelee(man)
   {
      if(man.Y == this.Y && Math.abs(this.X - man.X) == 1)
      {
         this.body._xscale = (this.X - man.X) * 100;
         return true;
      }
      if(man.nextY == this.Y && Math.abs(this.X - man.nextX) == 1)
      {
         this.body._xscale = (this.X - man.X) * 100;
         return true;
      }
      var _loc5_ = _global.field[this.X - _root.znak(this.body._xscale)][this.Y].who;
      if(_loc5_ != null && _loc5_.HP > 0 && _loc5_.team != this.team)
      {
         this.attacking = _loc5_;
         return true;
      }
      if(this.preferRanged && this.dist(this.attacking) > 1)
      {
         this.switchWeapons();
         return true;
      }
      return false;
   }
   function comeCloserRanged()
   {
      var _loc5_ = Math.abs((this.X - this.attacking.X) / (this.Y - this.attacking.Y)) >= _global.S_ANGLE;
      var _loc4_ = this.dist(this.attacking) <= this.wpn.rng;
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
      if(!_global.RAGE[this.team])
      {
         this.t_bef = this.wpn.t_bef;
      }
      else
      {
         this.t_bef = 1;
      }
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
         if(this["canHit" + this.wpn.TYPE](this.attacking))
         {
            this.moveX = 0;
            this.moveY = 0;
         }
         else if(!this.holdPosition)
         {
            this["comeCloser" + this.wpn.TYPE]();
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
   function waitForFire()
   {
      if(this.t_aft > 0)
      {
         this.t_aft = this.t_aft - 1;
      }
      else
      {
         if(this.t_bef == 1)
         {
            if(!_global.RAGE[this.team])
            {
               this.t_aft = this.wpn.t_aft;
            }
            else
            {
               this.t_aft = _global.MIN_ATTACK_TIME[this.atkAnim];
            }
            this.body.play();
         }
         this.t_bef = this.t_bef - 1;
      }
   }
   function directHit(useSecondWeapon)
   {
      if(useSecondWeapon == undefined)
      {
         useSecondWeapon = false;
      }
      this.strike(this.attacking,useSecondWeapon);
   }
   function AI()
   {
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
            if(this["canHit" + this.wpn.TYPE](this.attacking))
            {
               this.attackEnemy();
            }
            else if(!this.holdPosition)
            {
               this["comeCloser" + this.wpn.TYPE]();
               if(!this.startMove())
               {
                  this.findMove();
                  this.startMove();
               }
            }
         }
         else
         {
            this["chooseEnemy" + this.wpn.TYPE]();
         }
      }
      else if(!this.isBusy)
      {
         if(this.moveX == 0 && this.moveY == 0)
         {
            this.waitForFire();
         }
         else
         {
            this.moveOn();
         }
      }
   }
   function onEnterFrame()
   {
      if(this.HP > 0)
      {
         this.AI();
      }
   }
}
