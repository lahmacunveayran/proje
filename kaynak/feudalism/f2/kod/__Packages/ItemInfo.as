class ItemInfo extends Object
{
   var CATEGORY;
   var COUNT;
   var ENCH_ID;
   var LEVEL;
   var NATION;
   var REFINE;
   var TYPE;
   function ItemInfo(ct, tp, nt, lv, ei, rf)
   {
      super();
      this.CATEGORY = ct;
      this.TYPE = tp;
      this.NATION = nt;
      this.LEVEL = lv;
      this.COUNT = 1;
      this.ENCH_ID = !ei ? null : ei;
      this.REFINE = !rf ? 0 : rf;
   }
   function getItem()
   {
      switch(this.CATEGORY)
      {
         case "WeaponClass":
            return new WeaponClass(this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID,this.REFINE);
         case "Armor":
            return new Armor(this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID,this.REFINE);
         case "Rune":
            return new Rune(this.ENCH_ID,this.REFINE);
         default:
            return;
      }
   }
   function getCopy()
   {
      var _loc2_ = this.getSingleCopy();
      _loc2_.COUNT = this.COUNT;
      return _loc2_;
   }
   function getSingleCopy()
   {
      return new ItemInfo(this.CATEGORY,this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID,this.REFINE);
   }
}
