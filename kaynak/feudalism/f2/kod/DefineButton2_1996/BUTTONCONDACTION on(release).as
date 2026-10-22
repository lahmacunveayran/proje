on(release){
   delete _global.MAIN_HERO;
   _global.MAIN_HERO = new Hero();
   _global.MAIN_HERO.heroRusMale();
   delete _global.INVENTORY;
   _global.INVENTORY = new Array();
   _global.INVENTORY.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",1));
   delete _global.IS_CAPTURED;
   _global.IS_CAPTURED = new Array();
   _global.IS_CAPTURED.Curia = false;
   _global.IS_CAPTURED.Risby = false;
   _global.IS_CAPTURED.Elki = true;
   _global.IS_CAPTURED.Nara = false;
   _global.IS_CAPTURED.Neath = false;
   _global.IS_CAPTURED.Aden = false;
   _global.CURR_TOWN = "Elki";
   delete _global.FRIENDS;
   _global.FRIENDS = new Array();
   var i = 0;
   while(i < 5)
   {
      _global.FRIENDS.push(new Unit("Rus","2H_axe",0));
      i++;
   }
   choose_mark._visible = true;
   choose_mark._x = RusM_btn._x;
}
