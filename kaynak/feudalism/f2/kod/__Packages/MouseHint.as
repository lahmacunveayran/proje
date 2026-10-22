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
      this.stats_txt.text = "STR: " + _loc3_.STR + "\nDEX: " + _loc3_.DEX + "\nCON: " + _loc3_.CON + "\nSPR: " + _loc3_.SPR;
      if(_loc3_.price > 0)
      {
         this.stats_txt.text += "\n\nPrice: " + _loc3_.price;
      }
      this.descr_txt.text = "HP: " + unit_mc.MAX_HP + " SP: " + unit_mc.MAX_SP + "\n";
      this.descr_txt.text += "Defense: " + unit_mc.DEF + " Dodge: " + Math.floor(unit_mc.DODGE) + "\n";
      this.descr_txt.text += "Damage: " + unit_mc.wpnPri.dmg + "-" + (unit_mc.wpnPri.dmg + unit_mc.wpnPri.rnd) + " (" + unit_mc.wpnPri.CRIT + "% crit)\n";
      this.descr_txt.text += "Attack speed: " + Math.round(12000 / unit_mc.aspd_delay) / 100 + "\n";
      if(_loc3_.primary_skill)
      {
         this.descr_txt.text += _loc3_.primary_skill + " mastery: " + _loc3_.SKILL[_loc3_.primary_skill] + "\n";
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
            this.type_txt.text = "Armor";
            this.descr_txt.text = "Defense: " + _loc2_.value + "\n";
            if(_loc2_.HP_mod != 0)
            {
               this.descr_txt.text += "HP " + (_loc2_.HP_mod < 0 ? "- " : "+ ") + Math.abs(_loc2_.HP_mod) + "\n";
            }
            if(_loc2_.SP_mod != 0)
            {
               this.descr_txt.text += "SP " + (_loc2_.SP_mod < 0 ? "- " : "+ ") + Math.abs(_loc2_.SP_mod) + "\n";
            }
            break;
         case "Rune":
            this.type_txt.text = "Enchant Rune";
            this.descr_txt.text = Rune.getRuneDescription(_loc2_.ENCH_ID);
            break;
         default:
            this.type_txt.text = _loc2_.TYPE;
            if(_loc2_.TYPE == "Shield")
            {
               this.descr_txt.text = "Block chance: " + _loc2_.crit + "\n";
               break;
            }
            this.descr_txt.text = "Damage: " + _loc2_.dmg + "-" + (_loc2_.dmg + _loc2_.rnd) + "\n";
            this.descr_txt.text += "Critical rate: " + _loc2_.crit + "\n";
            if(_loc2_.aspd_bonus != 0)
            {
               this.descr_txt.text += "Attack speed +" + _loc2_.aspd_bonus + "%\n";
            }
      }
      if(_loc2_.require_param)
      {
         this.descr_txt.text += "Requires " + _loc2_.require_value + " " + _loc2_.require_param + "\n";
      }
      this.descr_txt.text += "\nPrice: " + _loc2_.price;
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
         this.cost_txt.text = "SP cost: " + Aura.getCostSP(skill_name) + " per second";
         this.descr_txt.text = Aura.getDescription(skill_name);
         this.type_mc.gotoAndStop("aura");
      }
      else
      {
         if(skill_id == 0)
         {
            this.type_txt.text = "Passive skill";
            this.cost_txt.text = "";
            this.type_mc.gotoAndStop("passive");
         }
         else
         {
            this.type_txt.text = "Active skill";
            this.cost_txt.text = "SP cost: " + Skill.getCostSP(skill_name,skill_id);
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
