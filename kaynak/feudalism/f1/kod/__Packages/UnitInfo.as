class UnitInfo extends Object
{
   var COUNT;
   var ID;
   var NATION;
   var TYPE;
   function UnitInfo(tp, nt, id, cn)
   {
      super();
      this.TYPE = tp;
      this.NATION = nt;
      this.ID = id;
      this.COUNT = cn != undefined ? cn : 1;
   }
   function getUnit(gender)
   {
      return new Unit(this.TYPE,this.NATION,this.ID);
   }
}
