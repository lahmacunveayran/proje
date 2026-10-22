class UnitInfo extends Object
{
   var COUNT;
   var ID;
   var NATION;
   var TYPE;
   function UnitInfo(nt, tp, id, cn)
   {
      super();
      this.TYPE = tp;
      this.NATION = nt;
      this.ID = id;
      this.COUNT = cn != undefined ? cn : 1;
   }
   function getUnit(gender)
   {
      var _loc2_ = new Unit(this.NATION,this.TYPE,this.ID);
      if(gender != undefined)
      {
         _loc2_.GENDER = gender;
      }
      return _loc2_;
   }
   function toString()
   {
      return this.NATION + "_" + this.TYPE + "_" + this.ID + "(" + this.COUNT + ")";
   }
}
