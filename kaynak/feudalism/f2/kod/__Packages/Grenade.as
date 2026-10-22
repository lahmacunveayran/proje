class Grenade extends Projectile
{
   var X;
   var Y;
   var _x;
   var _y;
   var dmg_data;
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
   var speed;
   function Grenade()
   {
      super();
      this.speed = 10;
      this.init();
      this.gren.gotoAndStop(231);
      this.dst_x = _root.stgX(this.dstX);
      this.dst_y = _root.stgY(this.dstY);
      this.len = Math.sqrt((this._x - this.dst_x) * (this._x - this.dst_x) + (this._y - this.dst_y) * (this._y - this.dst_y));
   }
   function endMove()
   {
      this.moving = false;
      this.explode();
      this.gotoAndPlay(2);
   }
   function explode()
   {
      this.dmg_data.hit = 100;
      this.dmg_data.damage *= 2;
      var _loc4_ = this.X - 2;
      var _loc3_;
      while(_loc4_ <= this.X + 2)
      {
         _loc3_ = this.Y - 2;
         while(_loc3_ <= this.Y + 2)
         {
            if(_global.field[_loc4_][_loc3_].who != null)
            {
               _global.field[_loc4_][_loc3_].who.takeDamage(this.dmg_data,null);
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
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
