on(release){
   delete _global.MAIN_HERO;
   _global.MAIN_HERO = new Hero();
   _global.MAIN_HERO.heroAraMale();
   delete _global.INVENTORY;
   _global.INVENTORY = new Array();
   _global.INVENTORY.push(new ItemInfo("WeaponClass","TwohandedSword","Ara",1));
   delete _global.IS_CAPTURED;
   _global.IS_CAPTURED = new Array();
   _global.IS_CAPTURED.Curia = false;
   _global.IS_CAPTURED.Risby = false;
   _global.IS_CAPTURED.Elki = false;
   _global.IS_CAPTURED.Nara = false;
   _global.IS_CAPTURED.Neath = false;
   _global.IS_CAPTURED.Aden = true;
   _global.CURR_TOWN = "Aden";
   delete _global.FRIENDS;
   _global.FRIENDS = new Array();
   var i = 0;
   while(i < 5)
   {
      _global.FRIENDS.push(new Unit("Ara","dual",0));
      i++;
   }
   choose_mark._visible = true;
   choose_mark._x = AraM_btn._x;
}
