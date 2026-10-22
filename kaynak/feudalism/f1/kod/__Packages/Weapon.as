class Weapon
{
   var CRIT;
   var HIT;
   var TYPE;
   var dmg;
   var rnd;
   var rng;
   var t_aft;
   var t_bef;
   function Weapon(tp, dm, rd, rn, hi, crt, tbef, taft)
   {
      this.TYPE = tp;
      this.dmg = dm;
      this.rnd = rd;
      this.rng = rn;
      this.HIT = hi;
      this.CRIT = crt;
      this.t_bef = tbef;
      this.t_aft = taft;
   }
}
