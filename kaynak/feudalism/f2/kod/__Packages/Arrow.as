class Arrow extends Projectile
{
   var X;
   var Y;
   var dmg_data;
   var dstX;
   var dstY;
   var init;
   var is_throwing;
   var moveOn;
   var moving;
   var pierce;
   var removeMovieClip;
   var speed;
   var team;
   function Arrow()
   {
      super();
      this.speed = 20;
      this.init();
   }
   function endMove()
   {
      if(!this.pierce)
      {
         this.moving = false;
         this.checkHit();
         this.removeMovieClip();
      }
   }
   function checkHit()
   {
      var _loc3_ = _global.field[this.X][this.Y].who;
      var _loc4_;
      if(_loc3_ != null && _loc3_.HP > 0 && _loc3_.team != this.team)
      {
         _loc3_.takeDamage(this.dmg_data,null);
         if(this.pierce == 0)
         {
            this.moving = false;
            this.removeMovieClip();
            return undefined;
         }
         if(this.is_throwing)
         {
            _loc4_ = _loc3_.getNearestCreatureInSight(true,true);
            if(!_loc4_)
            {
               this.moving = false;
               this.removeMovieClip();
               return undefined;
            }
            this.dstX = _loc4_.X;
            this.dstY = _loc4_.Y;
            this.init();
         }
         else
         {
            this.dstX = null;
            this.dstY = null;
            this.dmg_data.damage *= 0.7;
         }
         this.pierce = this.pierce - 1;
      }
      if(!_global.field[this.X][this.Y].free)
      {
         this.removeMovieClip();
      }
   }
   function onEnterFrame()
   {
      if(this.moving && this.moveOn())
      {
         this.checkHit();
      }
   }
}
