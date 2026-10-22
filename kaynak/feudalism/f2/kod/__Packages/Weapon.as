class Weapon
{
   var CRIT;
   var HIT;
   var TYPE;
   var aspd_bonus;
   var c_type;
   var dmg;
   var enchant;
   var frame;
   var rnd;
   var rng;
   function Weapon(wpn, skill_lv, str, dex)
   {
      this.TYPE = wpn.rng <= 0 ? "Melee" : "Ranged";
      this.dmg = wpn.dmg + wpn.REFINE * 3;
      switch(this.TYPE)
      {
         case "Melee":
            this.dmg + Math.floor(str / 2);
            break;
         case "Ranged":
            this.dmg + Math.floor(dex / 2);
      }
      this.rnd = Math.ceil(wpn.rnd * (1 + 0.1 * wpn.REFINE));
      this.rng = wpn.rng;
      this.HIT = skill_lv;
      this.CRIT = wpn.crit;
      this.c_type = wpn.TYPE;
      this.aspd_bonus = wpn.aspd_bonus;
      this.frame = wpn.getFrame();
      if(wpn.ENCH_ID != null)
      {
         this.enchant = new Enchant(wpn.ENCH_ID);
      }
   }
   function isTwohanded()
   {
      return WeaponClass.isTwohandedType(this.c_type);
   }
   function setDmgDataMods(target, dmg_data)
   {
      if(this.enchant)
      {
         this.enchant.operate(target,dmg_data);
      }
   }
}
