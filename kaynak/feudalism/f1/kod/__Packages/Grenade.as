class Grenade extends Projectile
{
   var X;
   var Y;
   var _x;
   var _y;
   var crit;
   var dmg;
   var dstX;
   var dstY;
   var dst_x;
   var dst_y;
   var gotoAndPlay;
   var gren;
   var init;
   var len;
   var moveOn;
   var moving;
   var rnd;
   var speed;
   function Grenade()
   {
      super();
      this.speed = 10;
      this.init();
      this.dst_x = _root.stgX(this.dstX);
      this.dst_y = _root.stgY(this.dstY);
      this.len = Math.sqrt((this._x - this.dst_x) * (this._x - this.dst_x) + (this._y - this.dst_y) * (this._y - this.dst_y));
   }
   function endMove()
   {
      this.moving = false;
      this.gotoAndPlay(2);
   }
   function explode()
   {
      var _loc5_ = this.X - 2;
      var _loc4_;
      while(_loc5_ <= this.X + 2)
      {
         _loc4_ = this.Y - 2;
         while(_loc4_ <= this.Y + 2)
         {
            if(_global.field[_loc5_][_loc4_].who != null)
            {
               _global.field[_loc5_][_loc4_].who.takeDamage(this.dmg + _root.d(this.rnd),null,this.crit);
            }
            _loc4_ = _loc4_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function onEnterFrame()
   {
      var _loc2_;
      if(this.moving)
      {
         this.gren._rotation += 2;
         _loc2_ = Math.sqrt((this._x - this.dst_x) * (this._x - this.dst_x) + (this._y - this.dst_y) * (this._y - this.dst_y)) / this.len * 100;
         _loc2_ -= 50;
         this.gren._y = Math.abs(_loc2_) * 3 - 230;
         this.moveOn();
      }
   }
}
