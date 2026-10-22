class ArrowStorm extends MovieClip
{
   var dmg;
   var play_count;
   function ArrowStorm()
   {
      super();
      this.play_count = 0;
      this.dmg = new Array();
   }
   function addDamage(dmg_data)
   {
      this.dmg.push(dmg_data);
   }
}
