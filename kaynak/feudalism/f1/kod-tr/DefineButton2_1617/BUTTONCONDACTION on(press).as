on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 200 * mult)
   {
      _global.GOLD -= 200 * mult;
      _global.SCROLL_AllHealBig += mult;
      money_txt.text = _global.GOLD + " altın";
      scroll_2_txt.text = _global.SCROLL_AllHealBig;
   }
   else
   {
      item_name_txt.text = "Paran yetmiyor!";
      item_stats_txt.text = "";
   }
}
