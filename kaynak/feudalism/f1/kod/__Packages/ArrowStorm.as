class ArrowStorm extends MovieClip
{
   var crit;
   var dmg;
   var play_count;
   function ArrowStorm()
   {
      super();
      this.play_count = 0;
      this.dmg = new Array();
      this.crit = new Array();
   }
   function addDamage(dm, cr)
   {
      this.dmg.push(dm);
      this.crit.push(cr);
   }
}
