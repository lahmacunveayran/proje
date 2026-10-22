class ItemInfo extends Object
{
   var CATEGORY;
   var COUNT;
   var ENCH_ID;
   var LEVEL;
   var NATION;
   var TYPE;
   function ItemInfo(ct, tp, nt, lv, ei)
   {
      super();
      this.CATEGORY = ct;
      this.TYPE = tp;
      this.NATION = nt;
      this.LEVEL = lv;
      this.COUNT = 1;
      this.ENCH_ID = !ei ? 0 : ei;
   }
   function getItem()
   {
      switch(this.CATEGORY)
      {
         case "WeaponClass":
            return new WeaponClass(this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID);
         case "Armor":
            return new Armor(this.TYPE,this.NATION,this.LEVEL,this.ENCH_ID);
         default:
            return;
      }
   }
}
