on(rollOver){
   if(_global.MAIN_HERO.HORSE != null)
   {
      unit_stats_txt.text = "Can bonusu: " + _global.MAIN_HERO.HORSE.bonus_HP + "\n";
      unit_stats_txt.text += "Savunma bonusu: " + _global.MAIN_HERO.HORSE.bonus_DEF + "\n";
      unit_stats_txt.text += "Hız bonusu: " + _global.MAIN_HERO.HORSE.bonus_speed + "\n\n";
      unit_stats_txt.text += "Fiyat: " + _global.MAIN_HERO.HORSE.price + " altın";
   }
}
