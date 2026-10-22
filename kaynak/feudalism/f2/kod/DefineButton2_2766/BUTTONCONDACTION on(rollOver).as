on(rollOver){
   item_name_txt.text = _global.MAIN_HERO.NAME + " Level " + _global.MAIN_HERO.LEVEL;
   item_stats_txt.text = "Hit Pionts: " + hero_ico.anim.MAX_HP + "\n";
   item_stats_txt.text += "Defence: " + hero_ico.anim.DEF + " ";
   item_stats_txt.text += "Dodge: " + hero_ico.anim.FLEE + "%" + (hero_ico.anim.SHIELD_FLEE <= 0 ? "" : "+" + hero_ico.anim.SHIELD_FLEE + "% (Shield)") + "\n";
   item_stats_txt.text += "Damage: " + hero_ico.anim.wpn.dmg + "-" + (hero_ico.anim.wpn.dmg + hero_ico.anim.wpn.rnd) + "\n";
   item_stats_txt.text += "Attack Speed: " + Math.round(100 / (hero_ico.anim.wpn.t_bef + hero_ico.anim.wpn.t_aft) * 100) / 100 + "\n";
   if(this.anim.wpn.rng > 0)
   {
      item_stats_txt.text += "Range: " + hero_ico.anim.wpn.rng + "\n";
   }
   item_stats_txt.text += "Hit rate: " + hero_ico.anim.wpn.HIT + "%\n";
   item_stats_txt.text += "Crit Rate: " + hero_ico.anim.wpn.CRIT + "%\n";
}
