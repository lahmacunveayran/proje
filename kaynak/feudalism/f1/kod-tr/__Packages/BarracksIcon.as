class BarracksIcon extends MovieClip
{
   var anim;
   var is_user;
   var pos;
   var unit = null;
   function BarracksIcon()
   {
      super();
      this.is_user = this._name.substr(0,4) != "unit";
      this.stop();
   }
   function setUnit(unit_ref)
   {
      this.anim.removeMovieClip();
      this.unit = unit_ref;
      var _loc2_ = this.unit.getUnit();
      if(unit_ref == undefined || unit_ref == null || _loc2_.NAME == undefined)
      {
         this.enabled = false;
         return undefined;
      }
      this.enabled = true;
      this.attachMovie(_loc2_.HORSE != null ? "Horseman" : "Human","anim",1,{_x:0,_y:0});
      this.anim._xscale = 45;
      this.anim._yscale = 45;
      this.anim.light_circle._visible = false;
      this.anim._x = 0;
      this.anim._y = 0;
      this.anim.onEnterFrame = null;
      this.anim.initUnit(_loc2_);
   }
   function setUnitClass(unit_ref)
   {
      this.anim.removeMovieClip();
      if(unit_ref == undefined && unit_ref == null)
      {
         this.enabled = false;
         return undefined;
      }
      this.enabled = true;
      this.unit = unit_ref.getUnitInfo();
      this.attachMovie(unit_ref.HORSE != null ? "Horseman" : "Human","anim",1,{_x:0,_y:0});
      this.anim._xscale = 45;
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
      this._parent.unit_name_txt.text = this.anim.unit_ref.NAME;
      this._parent.unit_stats_txt.text = "Can: " + this.anim.MAX_HP + "\n";
      this._parent.unit_stats_txt.text += "Savunma: " + this.anim.DEF + "\n";
      this._parent.unit_stats_txt.text += "Kaçınma: %" + this.anim.FLEE + (this.anim.SHIELD_FLEE <= 0 ? "" : " +%" + this.anim.SHIELD_FLEE + " (kalkan)") + "\n";
      this._parent.unit_stats_txt.text += "Hasar: " + this.anim.wpn.dmg + "-" + (this.anim.wpn.dmg + this.anim.wpn.rnd) + "\n";
      this._parent.unit_stats_txt.text += "Saldırı hızı: " + String(Math.round(100 / (this.anim.wpn.t_bef + this.anim.wpn.t_aft) * 100) / 100).split(".").join(",") + "\n";
      if(this.anim.wpn.rng > 0)
      {
         this._parent.unit_stats_txt.text += "Menzil: " + this.anim.wpn.rng + "\n";
      }
      this._parent.unit_stats_txt.text += "İsabet: %" + this.anim.wpn.HIT + "\n";
      this._parent.unit_stats_txt.text += "Kritik: %" + this.anim.wpn.CRIT + "\n\n";
      this._parent.unit_stats_txt.text += "Fiyat: " + this.anim.unit_ref.price + " altın";
   }
   function onPress()
   {
      if(this.unit == null)
      {
         return undefined;
      }
      if(!this.is_user && this.anim.unit_ref.price > _global.GOLD)
      {
         this._parent.unit_name_txt.text = "Altının yetmiyor!";
         this._parent.unit_stats_txt.text = "";
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
      var _loc4_ = "NONE";
      var _loc3_ = 0;
      while(_loc3_ < 8)
      {
         if(this._parent["unit_" + _loc3_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
         {
            _loc4_ = "unit_" + _loc3_;
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      if(_loc4_ == "NONE")
      {
         _loc3_ = 0;
         while(_loc3_ < 10)
         {
            if(this._parent["army_" + _loc3_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
            {
               _loc4_ = "army_" + _loc3_;
               break;
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_ == "NONE")
         {
            _loc3_ = 0;
            while(_loc3_ < 8)
            {
               if(this._parent["reserve_" + _loc3_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
               {
                  _loc4_ = "reserve_" + _loc3_;
                  break;
               }
               _loc3_ = _loc3_ + 1;
            }
         }
      }
      var _loc5_;
      if(_loc4_ != "NONE")
      {
         if(this.is_user)
         {
            if(!this._parent[_loc4_].is_user)
            {
               _global.GOLD += Math.floor(this.anim.unit_ref.price / 4);
               _global.FRIENDS.splice(this.pos,1);
            }
            else
            {
               _loc5_ = _global.FRIENDS[this.pos];
               _global.FRIENDS[this.pos] = _global.FRIENDS[this._parent[_loc4_].pos];
               _global.FRIENDS[this._parent[_loc4_].pos] = _loc5_;
            }
         }
         else if(this._parent[_loc4_].is_user && this.anim.unit_ref.price <= _global.GOLD)
         {
            _global.GOLD -= this.anim.unit_ref.price;
            if(_global.FRIENDS[this._parent[_loc4_].pos])
            {
               _global.FRIENDS.splice(this._parent[_loc4_].pos,0,this.unit.getUnit());
            }
            else
            {
               _global.FRIENDS[this._parent[_loc4_].pos] = this.unit.getUnit();
            }
         }
      }
      this._parent.money_txt.text = _global.GOLD + " altın";
      this._parent._parent.barracksShowUser();
      this._parent._parent.dragUnitOff();
   }
   function onRollOut()
   {
      this._parent.unit_name_txt.text = "";
      this._parent.unit_stats_txt.text = "";
   }
}
