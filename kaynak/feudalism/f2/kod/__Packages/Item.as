class Item extends Object
{
   var FRAME;
   var NAME;
   var TYPE;
   var NATION = null;
   var LEVEL = 0;
   var REFINE = 0;
   var ENCH_ID = null;
   function Item()
   {
      super();
      this.FRAME = this.getFrame();
   }
   function initEnchant(ei)
   {
      var _loc3_;
      if(ei)
      {
         _loc3_ = new Enchant(ei);
         this.ENCH_ID = ei;
         this.NAME = Enchant.getPrefix(ei) + this.NAME;
         this.NAME += Enchant.getSuffix(ei);
      }
      else
      {
         this.ENCH_ID = null;
      }
   }
   function setRefine(refine_lv)
   {
      if(refine_lv)
      {
         this.REFINE = refine_lv;
         this.NAME += " +" + this.REFINE;
      }
   }
   function getFrame()
   {
      var _loc3_ = _root.getNationNumber(this.NATION) - 1;
      var _loc4_ = this.NATION == "Rog";
      loop0:
      switch(this.TYPE)
      {
         case "OnehandedSword":
            switch(this.NATION)
            {
               case "Rog":
                  return this.LEVEL;
               case "Viz":
               case "Ger":
               case "Rus":
                  return 2 + this.LEVEL + _loc3_ * 7;
               case "Mon":
               case "Ara":
                  return this.LEVEL + _loc3_ * 7 - 5;
            }
         case "TwohandedSword":
            switch(this.NATION)
            {
               case "Rog":
                  return 37 + this.LEVEL;
               case "Viz":
               case "Ger":
               case "Rus":
                  return 39 + this.LEVEL + _loc3_ * 7;
               case "Mon":
               case "Ara":
                  return 32 + this.LEVEL + _loc3_ * 7;
               default:
                  break loop0;
            }
         case "OnehandedAxe":
            break;
         case "TwohandedAxe":
            return 94 + (!_loc4_ ? 2 + this.LEVEL + _loc3_ * 6 : this.LEVEL);
         case "OnehandedMace":
            return 114 + (!_loc4_ ? 2 + this.LEVEL + _loc3_ * 6 : this.LEVEL);
         case "TwohandedMace":
            return 134 + (!_loc4_ ? 2 + this.LEVEL + _loc3_ * 6 : this.LEVEL);
         case "Staff":
            return 154 + this.LEVEL;
         case "NinjaTo":
            return 162 + (!_loc4_ ? 2 + this.LEVEL : this.LEVEL);
         case "Katana":
            return 172 + (!_loc4_ ? 2 + this.LEVEL : this.LEVEL);
         case "Spear":
            return 182 + this.LEVEL + _loc3_ * 5;
         case "Dagger":
            switch(this.NATION)
            {
               case "Viz":
                  return 197 + this.LEVEL;
               case "Mon":
                  return 204 + this.LEVEL;
            }
         case "Katar":
            return 211 + this.LEVEL;
         case "Throwing":
            switch(this.NATION)
            {
               case "Viz":
                  return 229 + this.LEVEL;
               case "Ger":
                  return 217 + this.LEVEL;
               case "Rus":
                  return 223 + this.LEVEL;
               case "Jap":
                  return 231 + this.LEVEL;
               default:
                  return;
            }
            break;
         case "Bow":
            return 238 + this.LEVEL + _loc3_ * 4;
         case "Shield":
            switch(this.NATION)
            {
               case "Viz":
               case "Ger":
               case "Rus":
                  return 258 + this.LEVEL + _loc3_ * 4;
               case "Mon":
                  return 270 + this.LEVEL;
               default:
                  return;
            }
            break;
         case "Crossbow":
            return 274 + this.LEVEL + _loc3_ * 4;
         case "Clothes":
            return _loc3_ + 1 + (this.LEVEL - 1) * 6;
         case "Helmet":
            return _loc3_ + 1 + (this.LEVEL - 1) * 6;
         case "Fists":
            return 287;
         case "Rune":
            return Enchant.getFrame(this.ENCH_ID);
         default:
            return this.LEVEL;
      }
      return 74 + (!_loc4_ ? 2 + this.LEVEL + _loc3_ * 6 : this.LEVEL);
   }
   function getIconFrame()
   {
      var _loc2_ = 0;
      switch(this.TYPE)
      {
         case "Clothes":
            _loc2_ = 286;
            break;
         case "Helmet":
            _loc2_ = 334;
            break;
         case "Rune":
            _loc2_ = 382;
      }
      return _loc2_ + this.FRAME;
   }
   function getItemInfo()
   {
      var _loc2_ = "";
      switch(this.TYPE)
      {
         case "Clothes":
         case "Helmet":
            _loc2_ = "Armor";
            break;
         case "Rune":
            _loc2_ = "Rune";
            break;
         default:
            _loc2_ = "WeaponClass";
      }
      return new ItemInfo(_loc2_,this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID,this.REFINE);
   }
   function getMaxLevel()
   {
      switch(this.TYPE)
      {
         case "OnehandedSword":
         case "TwohandedSword":
            return 7;
         case "OnehandedAxe":
         case "TwohandedAxe":
            return 6;
         case "OnehandedMace":
         case "TwohandedMace":
            return 6;
         case "NinjaTo":
         case "Katana":
            return 8;
         case "Spear":
            return 5;
         case "Dagger":
            return 7;
         case "Staff":
            return 8;
         case "Katar":
            return 6;
         case "Bow":
            return 4;
         case "Crossbow":
            return 4;
         case "Throwing":
            return 7;
         case "Shield":
            return 4;
         case "Clothes":
         case "Helmet":
            return 8;
         case "Rune":
            return 0;
         default:
            return;
      }
   }
   function getRequireLevel()
   {
      if(this.NATION == "Rog")
      {
         return 1;
      }
      return 1 + Math.floor(40 * (this.LEVEL - 1) / (this.getMaxLevel() - 1));
   }
}
