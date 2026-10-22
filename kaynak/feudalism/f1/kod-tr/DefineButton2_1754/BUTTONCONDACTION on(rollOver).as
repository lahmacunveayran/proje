on(rollOver){
   item_name_txt.text = _global.MAIN_HERO.NAME + " Seviye " + _global.MAIN_HERO.LEVEL;
   item_stats_txt.text = "Can: " + hero_ico.anim.MAX_HP + "\n";
   item_stats_txt.text += "Savunma: " + hero_ico.anim.DEF + " ";
   item_stats_txt.text += "Kaçınma: %" + hero_ico.anim.FLEE + (hero_ico.anim.SHIELD_FLEE <= 0 ? "" : " +%" + hero_ico.anim.SHIELD_FLEE + " (kalkan)") + "\n";
   item_stats_txt.text += "Hasar: " + hero_ico.anim.wpn.dmg + "-" + (hero_ico.anim.wpn.dmg + hero_ico.anim.wpn.rnd) + "\n";
   item_stats_txt.text += "Saldırı hızı: " + String(Math.round(100 / (hero_ico.anim.wpn.t_bef + hero_ico.anim.wpn.t_aft) * 100) / 100).split(".").join(",") + "\n";
   if(this.anim.wpn.rng > 0)
   {
      item_stats_txt.text += "Menzil: " + hero_ico.anim.wpn.rng + "\n";
   }
   item_stats_txt.text += "İsabet: %" + hero_ico.anim.wpn.HIT + "\n";
   item_stats_txt.text += "Kritik: %" + hero_ico.anim.wpn.CRIT + "\n";
}
