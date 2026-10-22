on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 900 * mult)
   {
      _global.GOLD -= 900 * mult;
      _global.POTION_HealBig += mult;
      money_txt.text = _global.GOLD + " altın";
      potion_3_txt.text = _global.POTION_HealBig;
   }
   else
   {
      item_name_txt.text = "Paran yetmiyor!";
      item_stats_txt.text = "";
   }
}
