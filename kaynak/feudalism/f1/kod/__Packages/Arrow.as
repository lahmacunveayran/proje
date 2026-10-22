class Arrow extends Projectile
{
   var X;
   var Y;
   var _xscale;
   var crit;
   var dmg;
   var init;
   var moveOn;
   var moving;
   var removeMovieClip;
   var rnd;
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
      this.moving = false;
      this.checkHit();
      this.removeMovieClip();
   }
   function checkHit()
   {
      var _loc4_ = _global.field[this.X][this.Y].who;
      var _loc6_;
      var _loc5_;
      if(_loc4_ != null && _loc4_.HP > 0 && _loc4_.team != this.team)
      {
         _loc6_ = this._xscale > 0 == _loc4_.body._xscale > 0 ? 0 : _loc4_.SHIELD_FLEE;
         _loc5_ = 100 - (_loc4_.FLEE + _loc6_) * 0.8;
         if(_root.percent(_loc5_))
         {
            _loc4_.takeDamage(this.dmg + _root.d(this.rnd),null,this.crit);
            this.moving = false;
            this.removeMovieClip();
         }
      }
   }
   function onEnterFrame()
   {
      if(this.moving)
      {
         this.checkHit();
         this.moveOn();
         if(!_global.field[this.X][this.Y].free)
         {
            this.removeMovieClip();
         }
      }
   }
}
