class MouseHint extends MovieClip
{
   var aura_mc;
   var cost_txt;
   var descr_txt;
   var name_txt;
   var nation_mc;
   var stats_txt;
   var type_mc;
   var type_txt;
   var no_moving = false;
   function MouseHint()
   {
      super();
      if(this.getDepth() < 0)
      {
         this.no_moving = true;
      }
      else
      {
         this._x = this._parent._xmouse;
         this._y = this._parent._ymouse;
         if(this._x + this._width > 800)
         {
            this._x = 800 - this._width;
         }
         if(this._y + this._height > 600)
         {
            this._y = 600 - this._height;
         }
      }
   }
   function showUnitInfo(unit_mc)
   {
      this.gotoAndStop("unit_descr");
      var _loc3_ = unit_mc.unit_ref;
      this.name_txt.text = _loc3_.NAME;
      this.stats_txt.text = "GÜÇ: " + _loc3_.STR + "\nÇEV: " + _loc3_.DEX + "\nDAY: " + _loc3_.CON + "\nRUH: " + _loc3_.SPR;
      if(_loc3_.price > 0)
      {
         this.stats_txt.text += "\n\nFiyat: " + _loc3_.price;
      }
      this.descr_txt.text = "Can: " + unit_mc.MAX_HP + " RP: " + unit_mc.MAX_SP + "\n";
      this.descr_txt.text += "Savunma: " + unit_mc.DEF + " Kaçınma: " + Math.floor(unit_mc.DODGE) + "\n";
      this.descr_txt.text += "Hasar: " + unit_mc.wpnPri.dmg + "-" + (unit_mc.wpnPri.dmg + unit_mc.wpnPri.rnd) + " (%" + unit_mc.wpnPri.CRIT + " kritik)\n";
      this.descr_txt.text += "Saldırı hızı: " + String(Math.round(12000 / unit_mc.aspd_delay) / 100).split(".").join(",") + "\n";
      if(_loc3_.primary_skill)
      {
         this.descr_txt.text += ({Sword:"Kılıç",Axe:"Balta",Mace:"Topuz",Spear:"Mızrak",Dagger:"Hançer",Staff:"Asa",FarEast:"Uzak Doğu",Dual:"Çift silah",Bow:"Yay",Crossbow:"Arbalet",Throwing:"Fırlatma",Katar:"Katar",Fists:"Yumruk"}[_loc3_.primary_skill] || _loc3_.primary_skill) + " ustalığı: " + _loc3_.SKILL[_loc3_.primary_skill] + "\n";
      }
      this.nation_mc.gotoAndStop(_loc3_.NATION);
      var _loc2_ = 0;
      while(_loc2_ < 3)
      {
         if(_loc3_.ACTIVE_SKILLS[unit_mc.atkAnim][_loc2_] > 0)
         {
            this["skill_" + (_loc2_ + 1)]._visible = true;
            this["skill_" + (_loc2_ + 1)].gotoAndStop(Skill.getActiveSkillFrame(unit_mc.atkAnim,_loc2_ + 1));
            this["skill_" + (_loc2_ + 1)].amount_txt.text = _loc3_.ACTIVE_SKILLS[unit_mc.atkAnim][_loc2_];
            this["skill_" + (_loc2_ + 1)].shade.gotoAndStop(3);
         }
         else
         {
            this["skill_" + (_loc2_ + 1)]._visible = false;
         }
         _loc2_ = _loc2_ + 1;
      }
      if(_loc3_.AURA_SKILLS[0] && _loc3_.AURA_SKILLS[0][1] > 0)
      {
         this.aura_mc._visible = true;
         this.aura_mc.gotoAndStop(Aura.getFrame(_loc3_.AURA_SKILLS[0][0]));
         this.aura_mc.amount_txt.text = _loc3_.AURA_SKILLS[0][1];
         this.aura_mc.shade.gotoAndStop(3);
      }
      else
      {
         this.aura_mc._visible = false;
      }
   }
   function showItemInfo(item_info)
   {
      this.gotoAndStop("item_descr");
      var _loc2_ = item_info.getItem();
      this.name_txt.text = _loc2_.NAME;
      switch(_loc2_.TYPE)
      {
         case "Clothes":
         case "Helmet":
            this.type_txt.text = "Zırh";
            this.descr_txt.text = "Savunma: " + _loc2_.value + "\n";
            if(_loc2_.HP_mod != 0)
            {
               this.descr_txt.text += "Can " + (_loc2_.HP_mod < 0 ? "- " : "+ ") + Math.abs(_loc2_.HP_mod) + "\n";
            }
            if(_loc2_.SP_mod != 0)
            {
               this.descr_txt.text += "RP " + (_loc2_.SP_mod < 0 ? "- " : "+ ") + Math.abs(_loc2_.SP_mod) + "\n";
            }
            break;
         case "Rune":
            this.type_txt.text = "Büyü Rünü";
            this.descr_txt.text = Rune.getRuneDescription(_loc2_.ENCH_ID);
            break;
         default:
            var __tur = {OnehandedSword:"Tek elli kılıç",TwohandedSword:"İki elli kılıç",OnehandedAxe:"Tek elli balta",TwohandedAxe:"İki elli balta",OnehandedMace:"Tek elli topuz",TwohandedMace:"İki elli topuz",Spear:"Mızrak",Dagger:"Hançer",Staff:"Asa",Katana:"Katana",NinjaTo:"Ninja-to",Katar:"Katar",Bow:"Yay",Crossbow:"Arbalet",Throwing:"Fırlatma silahı",Shield:"Kalkan",Fists:"Yumruk"}[_loc2_.TYPE];
            this.type_txt.text = __tur != undefined ? __tur : _loc2_.TYPE;
            if(_loc2_.TYPE == "Shield")
            {
               this.descr_txt.text = "Engelleme şansı: " + _loc2_.crit + "\n";
               break;
            }
            this.descr_txt.text = "Hasar: " + _loc2_.dmg + "-" + (_loc2_.dmg + _loc2_.rnd) + "\n";
            this.descr_txt.text += "Kritik oran: " + _loc2_.crit + "\n";
            if(_loc2_.aspd_bonus != 0)
            {
               this.descr_txt.text += "Saldırı hızı +%" + _loc2_.aspd_bonus + "\n";
            }
      }
      if(_loc2_.require_param)
      {
         this.descr_txt.text += "Gereken: " + _loc2_.require_value + " " + {STR:"GÜÇ",DEX:"ÇEV",CON:"DAY",SPR:"RUH",INT:"ZEK"}[_loc2_.require_param] + "\n";
      }
      this.descr_txt.text += "\nFiyat: " + _loc2_.price;
      var _loc4_;
      var _loc3_;
      if(_loc2_.NATION)
      {
         this.nation_mc.gotoAndStop(_loc2_.NATION);
         _loc4_ = _loc2_.getMaxLevel();
         if(_loc2_.NATION == "Rog")
         {
            _loc3_ = 1;
            while(_loc3_ <= 8)
            {
               this["star_" + _loc3_]._visible = false;
               _loc3_ = _loc3_ + 1;
            }
         }
         else
         {
            _loc3_ = 1;
            while(_loc3_ <= 8)
            {
               if(_loc3_ > _loc4_)
               {
                  this["star_" + _loc3_]._visible = false;
               }
               else
               {
                  this["star_" + _loc3_]._visible = true;
                  this["star_" + _loc3_].gotoAndStop(_loc3_ > _loc2_.LEVEL ? "off" : "on");
               }
               _loc3_ = _loc3_ + 1;
            }
         }
      }
      else
      {
         this.nation_mc.gotoAndStop("none");
         _loc3_ = 1;
         while(_loc3_ <= 8)
         {
            this["star_" + _loc3_]._visible = false;
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function showSkillInfo(skill_name, skill_id)
   {
      this.gotoAndStop("skill_descr");
      if(skill_id < 0)
      {
         this.name_txt.text = Aura.getName(skill_name);
         this.type_txt.text = "Aura";
         this.cost_txt.text = "RP bedeli: " + Aura.getCostSP(skill_name) + " / saniye";
         this.descr_txt.text = Aura.getDescription(skill_name);
         this.type_mc.gotoAndStop("aura");
      }
      else
      {
         if(skill_id == 0)
         {
            this.type_txt.text = "Pasif beceri";
            this.cost_txt.text = "";
            this.type_mc.gotoAndStop("passive");
         }
         else
         {
            this.type_txt.text = "Aktif beceri";
            this.cost_txt.text = "RP bedeli: " + Skill.getCostSP(skill_name,skill_id);
            this.type_mc.gotoAndStop(skill_name);
         }
         this.name_txt.text = Skill.getSkillName(skill_name,skill_id);
         this.descr_txt.text = Skill.getSkillDescription(skill_name,skill_id);
      }
   }
   function showSmallDescr(msg)
   {
      this.gotoAndStop("small_descr");
      this.descr_txt.text = msg;
   }
   function onEnterFrame()
   {
      if(!this.no_moving)
      {
         this._x = this._parent._xmouse;
         this._y = this._parent._ymouse;
         if(this._x + this._width > 800)
         {
            this._x = 800 - this._width;
         }
         if(this._y + this._height > 600)
         {
            this._y = 600 - this._height;
         }
      }
   }
}
