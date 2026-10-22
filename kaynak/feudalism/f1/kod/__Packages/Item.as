class Item extends Object
{
   var ENCH_ID;
   var FRAME;
   var LEVEL;
   var NAME;
   var NATION;
   var TYPE;
   var price;
   function Item()
   {
      super();
   }
   function initEnchant(ei)
   {
      var _loc2_;
      if(ei)
      {
         _loc2_ = new Enchant(ei);
         this.ENCH_ID = ei;
         this.NAME += _loc2_.suffix;
         this.NAME = _loc2_.prefix + this.NAME;
         this.price = Math.round(this.price * _loc2_.price_bonus);
      }
      else
      {
         this.ENCH_ID = 0;
      }
   }
   function getFrame()
   {
      var _loc3_ = _root.getNationNumber(this.NATION) - 1;
      var _loc4_ = this.NATION == "Rog";
      switch(this.TYPE)
      {
         case "OnehandedSword":
            return !_loc4_ ? 2 + this.LEVEL + _loc3_ * 5 : 0 + this.LEVEL;
         case "TwohandedSword":
            return !_loc4_ ? 19 + this.LEVEL + _loc3_ * 5 : 17 + this.LEVEL;
         case "OnehandedAxe":
            return !_loc4_ ? 36 + this.LEVEL + _loc3_ * 4 : 34 + this.LEVEL;
         case "TwohandedAxe":
            return !_loc4_ ? 50 + this.LEVEL + _loc3_ * 4 : 48 + this.LEVEL;
         case "OnehandedMace":
            return !_loc4_ ? 64 + this.LEVEL + _loc3_ * 4 : 62 + this.LEVEL;
         case "TwohandedMace":
            return !_loc4_ ? 78 + this.LEVEL + _loc3_ * 4 : 76 + this.LEVEL;
         case "Staff":
            return 90 + this.LEVEL;
         case "NinjaTo":
            return !_loc4_ ? 98 + this.LEVEL : 96 + this.LEVEL;
         case "Katana":
            return !_loc4_ ? 106 + this.LEVEL : 104 + this.LEVEL;
         case "Spear":
            return 112 + this.LEVEL + _loc3_ * 3;
         case "Dagger":
            return 121 + this.LEVEL;
         case "Throwing":
            switch(this.NATION)
            {
               case "Viz":
                  return 133 + this.LEVEL;
               case "Ger":
                  return 125 + this.LEVEL;
               case "Rus":
                  return 129 + this.LEVEL;
               case "Jap":
                  return 135 + this.LEVEL;
               default:
                  return;
            }
            break;
         case "Bow":
            return 140 + this.LEVEL + _loc3_ * 2;
         case "Shield":
            return 150 + this.LEVEL + _loc3_ * 3;
         case "Crossbow":
            return 159 + this.LEVEL + _loc3_ * 3;
         case "Clothes":
            return _loc3_ + 1 + (this.LEVEL - 1) * 4;
         case "Helmet":
            return _loc3_ + 1 + (this.LEVEL - 1) * 4;
         default:
            return this.LEVEL;
      }
   }
   function getIconFrame()
   {
      var _loc2_ = 0;
      switch(this.TYPE)
      {
         case "Clothes":
            _loc2_ = 168;
            break;
         case "Helmet":
            _loc2_ = 192;
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
         default:
            _loc2_ = "WeaponClass";
      }
      return new ItemInfo(_loc2_,this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID);
   }
}
