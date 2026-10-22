class Projectile extends MovieClip
{
   var X;
   var Y;
   var dstX;
   var dstY;
   var moving;
   var plusX;
   var plusY;
   var speed;
   var is_throwing = false;
   var pierce = 0;
   function Projectile()
   {
      super();
      this._xscale = 50;
      this._yscale = 50;
      this.moving = true;
      if(this.dstX == undefined || this.dstY == undefined)
      {
         this.dstX = this.X;
         this.dstY = this.Y;
      }
   }
   function init()
   {
      var _loc2_ = Math.atan2(this.dstY - this.Y,this.dstX - this.X);
      this.plusX = this.speed * Math.cos(_loc2_);
      this.plusY = this.speed * Math.sin(_loc2_);
   }
   function endMove()
   {
   }
   function moveOn()
   {
      this._x += this.plusX;
      this._y += this.plusY / 1.6;
      var _loc5_ = _root.getX(this._x);
      var _loc4_ = _root.getY(this._y);
      if(_loc5_ != this.X || _loc4_ != this.Y)
      {
         if(_loc5_ < 0 || _loc5_ >= _global.F_WIDTH || _loc4_ < 0 || _loc4_ >= _global.F_HEIGHT)
         {
            this.removeMovieClip();
            return true;
         }
         this.X = _loc5_;
         this.Y = _loc4_;
         this.swapDepths(_root.getDepthMan(_loc5_,_loc4_) + 2);
         if(_loc5_ == this.dstX && _loc4_ == this.dstY)
         {
            this.endMove();
         }
         return true;
      }
      return false;
   }
}
