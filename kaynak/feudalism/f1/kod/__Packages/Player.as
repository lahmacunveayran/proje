class Player extends Creature
{
   var HP;
   var X;
   var Y;
   var _x;
   var _y;
   var atkAnim;
   var body;
   var isBusy;
   var moveX;
   var moveY;
   var nextX;
   var nextY;
   var secAtkAnim;
   var t_aft;
   var t_bef;
   var team;
   var wpn;
   function Player()
   {
      super();
      this.team = 0;
      this.Creature();
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
      return !this.isBusy && this.t_bef == 0 && this.t_aft <= this.wpn.t_aft - _global.MIN_ATTACK_TIME[this.atkAnim];
   }
   function readyForAction()
   {
      return !this.isBusy && this.t_bef == 0 && this.t_aft == 0 && this.moveX == 0 && this.moveY == 0;
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
         _loc4_ = - _root.znak(this.body._xscale);
         if(this.noEnemy(this.X + _loc4_,this.Y) && this.noEnemy(this.X + _loc4_,this.Y - 1) && this.noEnemy(this.X + _loc4_,this.Y + 1) && this.noEnemy(this.X + _loc4_ * 2,this.Y) && !(this.noEnemy(this.X - _loc4_,this.Y) && this.noEnemy(this.X - _loc4_,this.Y - 1) && this.noEnemy(this.X - _loc4_,this.Y + 1) && this.noEnemy(this.X - _loc4_ * 2,this.Y)))
         {
            this.body._xscale *= -1;
         }
         this.t_aft = this.wpn.t_aft;
         this.body.play();
      }
      else if(Key.isDown(_global.CO_SWITCH) && this.secAtkAnim != "No")
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
      this["hit" + this.wpn.TYPE](useSecondWeapon);
   }
   function hitMelee(useSecondWeapon)
   {
      if(_global.field[this.X - this.body._xscale / 100][this.Y].who != null)
      {
         this.strike(_global.field[this.X - this.body._xscale / 100][this.Y].who,useSecondWeapon);
      }
      else if(_global.field[this.X - this.body._xscale / 100][this.Y - 1].who != null)
      {
         this.strike(_global.field[this.X - this.body._xscale / 100][this.Y - 1].who,useSecondWeapon);
      }
      else if(_global.field[this.X - this.body._xscale / 100][this.Y + 1].who != null)
      {
         this.strike(_global.field[this.X - this.body._xscale / 100][this.Y + 1].who,useSecondWeapon);
      }
      else if(_global.field[this.X - this.body._xscale / 50][this.Y].who != null)
      {
         this.strike(_global.field[this.X - this.body._xscale / 50][this.Y].who,useSecondWeapon);
      }
   }
   function hitRanged(mod, useSecondWeapon)
   {
      var _loc3_ = this.body._xscale <= 0 ? 1 : -1;
      var _loc2_ = !useSecondWeapon ? this.body.weapL._currentframe : this.body.weapR._currentframe;
      var _loc4_ = !(_loc2_ == 134 || _loc2_ == 135) ? 12 : 6;
      this.strike({X:this.X + _loc4_ * _loc3_,Y:this.Y},useSecondWeapon);
   }
   function onEnterFrame()
   {
      if(this.HP > 0)
      {
         if(this.t_aft > 0)
         {
            this.t_aft = this.t_aft - 1;
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
}
