on(rollOver){
   if(_global.MAIN_HERO.HORSE != null)
   {
      unit_stats_txt.text = "Hit Pionts bonus: " + _global.MAIN_HERO.HORSE.bonus_HP + "\n";
      unit_stats_txt.text += "Defence bonus: " + _global.MAIN_HERO.HORSE.bonus_DEF + "\n";
      unit_stats_txt.text += "Speed bonus: " + _global.MAIN_HERO.HORSE.bonus_speed + "\n\n";
      unit_stats_txt.text += "Cost " + _global.MAIN_HERO.HORSE.price + " gp.";
   }
}
