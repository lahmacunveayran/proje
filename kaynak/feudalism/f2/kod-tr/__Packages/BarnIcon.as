class BarnIcon extends MovieClip
{
   var anim;
   var horse;
   var is_user;
   function BarnIcon()
   {
      super();
      this.is_user = this._name.substr(0,4) != "unit";
      this.stop();
   }
   function setHorse(horse_ref)
   {
      this.anim.removeMovieClip();
      if(horse_ref == undefined && horse_ref == null)
      {
         this.enabled = false;
         this.anim._visible = false;
         return undefined;
      }
      this.enabled = true;
      this.anim._visible = true;
      this.horse = horse_ref;
      this.anim.horse.gotoAndStop(this.horse.skin_color);
      this.anim.morda.gotoAndStop(this.horse.skin_color);
      this.anim.lgL1.gotoAndStop(this.horse.skin_color);
      this.anim.lgL2.gotoAndStop(this.horse.skin_color);
      this.anim.lgR1.gotoAndStop(this.horse.skin_color);
      this.anim.lgR2.gotoAndStop(this.horse.skin_color);
      this.anim.ftL1.gotoAndStop(this.horse.skin_color);
      this.anim.ftL2.gotoAndStop(this.horse.skin_color);
      this.anim.ftR1.gotoAndStop(this.horse.skin_color);
      this.anim.ftR2.gotoAndStop(this.horse.skin_color);
   }
   function onRollOver()
   {
      this._parent.unit_stats_txt.text = "Can bonusu: " + this.horse.bonus_HP + "\n";
      this._parent.unit_stats_txt.text += "Savunma bonusu: " + this.horse.bonus_DEF + "\n";
      this._parent.unit_stats_txt.text += "Hız bonusu: " + this.horse.bonus_speed + "\n\n";
      this._parent.unit_stats_txt.text += "Fiyat: " + this.horse.price + " altın";
   }
   function onRelease()
   {
      var _loc4_;
      var _loc3_;
      if(_global.GOLD >= this.horse.price)
      {
         _loc4_ = _global.MAIN_HERO.HORSE == null ? 0 : _global.MAIN_HERO.HORSE.price;
         _loc3_ = _global.MAIN_HERO.equipHorse(this.horse);
         if(_loc3_ == "OK")
         {
            _global.GOLD -= this.horse.price - Math.round(_loc4_ / 3);
         }
         else
         {
            this._parent.error_txt.text = _loc3_;
         }
      }
      this._parent._parent.barnShowTrader();
   }
}
