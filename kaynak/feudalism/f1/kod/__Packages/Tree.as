class Tree extends MovieClip
{
   function Tree()
   {
      super();
   }
   function init()
   {
      var _loc5_ = _root.getX(this._x);
      var _loc4_ = _root.getY(this._y);
      this.swapDepths(_root.getDepthMan(_loc5_,_loc4_));
      this._x = _root.stgX(_loc5_);
      this._y = _root.stgY(_loc4_);
      _global.field[_loc5_][_loc4_].free = false;
      _global.field[_loc5_][_loc4_].who = this;
   }
}
