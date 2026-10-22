on(release){
   if(_global.SHIP_LOCATION == "none")
   {
      if(_global.GOLD >= _global.SHIP_PRICE)
      {
         _global.GOLD -= _global.SHIP_PRICE;
         _global.SHIP_LOCATION = _global.CURR_TOWN;
      }
      else
      {
         quest_txt.text = "Not enough money!\n\nShips\'s price is " + _global.SHIP_PRICE + " gp.";
      }
   }
   else
   {
      _global.SAILING_SHIP = true;
      _parent.leaveTown();
   }
   _parent.harborShow();
}
