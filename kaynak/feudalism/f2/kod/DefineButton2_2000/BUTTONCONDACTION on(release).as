on(release){
   delete _global.MAIN_HERO;
   _global.MAIN_HERO = new Hero();
   _global.MAIN_HERO.heroGerFemale();
   delete _global.INVENTORY;
   _global.INVENTORY = new Array();
   _global.INVENTORY.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",1));
   delete _global.IS_CAPTURED;
   _global.IS_CAPTURED = new Array();
   _global.IS_CAPTURED.Curia = false;
   _global.IS_CAPTURED.Risby = true;
   _global.IS_CAPTURED.Elki = false;
   _global.IS_CAPTURED.Nara = false;
   _global.IS_CAPTURED.Neath = false;
   _global.IS_CAPTURED.Aden = false;
   _global.CURR_TOWN = "Risby";
   delete _global.FRIENDS;
   _global.FRIENDS = new Array();
   var i = 0;
   while(i < 5)
   {
      _global.FRIENDS.push(new Unit("Ger","2H_axe",1));
      i++;
   }
   choose_mark._visible = true;
   choose_mark._x = GerF_btn._x;
}
