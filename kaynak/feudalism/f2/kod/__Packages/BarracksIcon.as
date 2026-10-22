class BarracksIcon extends MovieClip
{
   var anim;
   var is_user;
   var pos;
   var unit = null;
   static var MAX_ARMY = 30;
   function BarracksIcon()
   {
      super();
      this.is_user = this._name.substr(0,4) != "unit";
      this.enabled = false;
      this.stop();
   }
   function setUnit(unit_ref)
   {
      this.unit = unit_ref;
      this.setUnitView(unit_ref.getUnit(),false);
      this.enabled = true;
   }
   function setUnitClass(unit_ref)
   {
      this.unit = unit_ref.getUnitInfo();
      this.setUnitView(unit_ref,false);
      this.enabled = true;
   }
   function setUnitView(unit_ref, look_right)
   {
      this.anim.removeMovieClip();
      if(unit_ref == undefined && unit_ref == null)
      {
         this.enabled = false;
         return undefined;
      }
      var _loc3_ = !look_right ? 1 : -1;
      this.attachMovie(unit_ref.HORSE != null ? "Horseman" : "Human","anim",1,{_x:0,_y:0});
      this.anim._xscale = 45 * _loc3_;
      this.anim._yscale = 45;
      this.anim.light_circle._visible = false;
      this.anim._x = 0;
      this.anim._y = 0;
      this.anim.onEnterFrame = null;
      this.anim.initUnit(unit_ref);
   }
   function setHero(hero_ref)
   {
      this.anim.removeMovieClip();
      this.enabled = false;
      if(hero_ref == undefined && hero_ref == null)
      {
         return undefined;
      }
      this.unit = null;
      this.attachMovie(hero_ref.HORSE != null ? "Horseman" : "Human","anim",1,{_x:0,_y:0});
      this.anim._xscale = 45;
      this.anim._yscale = 45;
      this.anim.light_circle._visible = false;
      this.anim._x = 0;
      this.anim._y = 0;
      this.anim.onEnterFrame = null;
      this.anim.initUnit(hero_ref);
   }
   function onRollOver()
   {
      if(this.unit)
      {
         this._parent._parent.showUnitDescription(this.anim);
      }
   }
   function onPress()
   {
      this._parent._parent.removeDescription();
      if(this.unit == null)
      {
         return undefined;
      }
      if(!this.is_user)
      {
         if(this.anim.unit_ref.price > _global.GOLD)
         {
            this._parent.unit_name_txt.text = "Not enough gold!";
         }
         else if(_root.getSoldiersAmount() >= BarracksIcon.MAX_ARMY)
         {
            this._parent.unit_name_txt.text = "Your army is too big!";
         }
         else
         {
            this._parent._parent.dragUnitOn(this);
         }
      }
      else
      {
         this._parent._parent.dragUnitOn(this);
      }
   }
   function onRelease()
   {
      this._parent._parent.dragUnitOff();
   }
   function onReleaseOutside()
   {
      if(!this.unit)
      {
         return undefined;
      }
      var _loc5_ = "NONE";
      var _loc4_ = 0;
      while(_loc4_ < 8)
      {
         if(this._parent["unit_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
         {
            _loc5_ = "unit_" + _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      if(_loc5_ == "NONE")
      {
         _loc4_ = 0;
         while(_loc4_ < 10)
         {
            if(this._parent["army_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
            {
               _loc5_ = "army_" + _loc4_;
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_loc5_ == "NONE")
         {
            _loc4_ = 0;
            while(_loc4_ < 8)
            {
               if(this._parent["reserve_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
               {
                  _loc5_ = "reserve_" + _loc4_;
                  break;
               }
               _loc4_ = _loc4_ + 1;
            }
         }
      }
      var _loc6_;
      if(_loc5_ != "NONE")
      {
         if(this.is_user)
         {
            if(!this._parent[_loc5_].is_user)
            {
               _global.GOLD += Math.floor(this.anim.unit_ref.price / 4);
               _global.FRIENDS.splice(this.pos,1);
            }
            else
            {
               _loc6_ = _global.FRIENDS[this.pos];
               _global.FRIENDS[this.pos] = _global.FRIENDS[this._parent[_loc5_].pos];
               _global.FRIENDS[this._parent[_loc5_].pos] = _loc6_;
            }
         }
         else
         {
            if(_global.EASY_MODE)
            {
               BarracksIcon.MAX_ARMY = 1000;
            }
            if(this._parent[_loc5_].is_user && this.anim.unit_ref.price <= _global.GOLD && _root.getSoldiersAmount() < BarracksIcon.MAX_ARMY)
            {
               _global.GOLD -= this.anim.unit_ref.price;
               if(_global.FRIENDS[this._parent[_loc5_].pos])
               {
                  _global.FRIENDS.splice(this._parent[_loc5_].pos,0,this.unit.getUnit());
               }
               else
               {
                  _global.FRIENDS[this._parent[_loc5_].pos] = this.unit.getUnit();
               }
            }
         }
      }
      this._parent.money_txt.text = _global.GOLD + " gold";
      this._parent._parent.barracksShowUser();
      this._parent._parent.dragUnitOff();
   }
   function onRollOut()
   {
   }
}
