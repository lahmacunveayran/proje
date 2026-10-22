class SelectBorder extends MovieClip
{
   var XX;
   var YY;
   function SelectBorder()
   {
      super();
      this.XX = _root._xmouse;
      this.YY = _root._ymouse;
      this._width = 0;
      this._height = 0;
   }
   function onMouseMove()
   {
      var _loc3_ = _root._xmouse - this.XX;
      var _loc4_ = _root._ymouse - this.YY;
      if(_loc3_ >= 0)
      {
         this._x = this.XX;
         this._width = _loc3_;
      }
      else
      {
         this._x = _root._xmouse;
         this._width = - _loc3_;
      }
      if(_loc4_ >= 0)
      {
         this._y = this.YY;
         this._height = _loc4_;
      }
      else
      {
         this._y = _root._ymouse;
         this._height = - _loc4_;
      }
   }
   function onMouseUp()
   {
      var _loc4_;
      if(this._width > 10 || this._height > 10)
      {
         _root.deselectUnits();
         _loc4_ = 1;
         while(_loc4_ < _global.HERO)
         {
            if(_root["hero" + _loc4_].team == 0 && _root["hero" + _loc4_].HP > 0 && this.hitTest(_root["hero" + _loc4_]._x,_root["hero" + _loc4_]._y,false))
            {
               _global.SELECTED.push(_root["hero" + _loc4_]);
               _root["hero" + _loc4_].borders._visible = true;
            }
            _loc4_ = _loc4_ + 1;
         }
         _root.scr.reloadPortrait(_global.SELECTED.length > 0);
      }
      this.play();
   }
}
