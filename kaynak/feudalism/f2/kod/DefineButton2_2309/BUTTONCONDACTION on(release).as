on(release){
   _global.MAIN_HERO.NAME = name_txt.text;
   _global.MAIN_HERO.LEVEL = 1;
   _global.MAIN_HERO.STR = 1;
   _global.MAIN_HERO.DEX = 1;
   _global.MAIN_HERO.CON = 1;
   _global.MAIN_HERO.SPR = 1;
   _global.MAIN_HERO.stat_points = 350;
   _global.MAIN_HERO.skill_points = 1;
   var i = 0;
   while(i < 3)
   {
      _global.MAIN_HERO.ACTIVE_SKILLS[this["active_" + i].curr_value] = [0,0,0];
      _global.MAIN_HERO.AURA_SKILLS.push([this["aura_" + i].curr_value,0]);
      i++;
   }
   trace(_global.MAIN_HERO.ACTIVE_SKILLS);
   var i = 0;
   while(i < 6)
   {
      _global.MAIN_HERO.PASSIVE_SKILLS.push([this["passive_" + i].curr_value,0]);
      i++;
   }
   switch(_global.MAIN_HERO.NATION)
   {
      case "Viz":
         delete _global.IS_CAPTURED;
         _global.IS_CAPTURED = new Array();
         _global.IS_CAPTURED.Curia = true;
         _global.IS_CAPTURED.Risby = false;
         _global.IS_CAPTURED.Elki = false;
         _global.IS_CAPTURED.Nara = false;
         _global.IS_CAPTURED.Neath = false;
         _global.IS_CAPTURED.Aden = false;
         _global.CURR_TOWN = "Curia";
         delete _global.FRIENDS;
         _global.FRIENDS = new Array();
         var i = 0;
         while(i < 5)
         {
            _global.FRIENDS.push(new Unit("Viz","shield",0));
            i++;
         }
         break;
      case "Ger":
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
            _global.FRIENDS.push(new Unit("Ger","2H_sword",0));
            i++;
         }
         break;
      case "Rus":
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
         break;
      case "Jap":
         delete _global.IS_CAPTURED;
         _global.IS_CAPTURED = new Array();
         _global.IS_CAPTURED.Curia = false;
         _global.IS_CAPTURED.Risby = false;
         _global.IS_CAPTURED.Elki = false;
         _global.IS_CAPTURED.Nara = true;
         _global.IS_CAPTURED.Neath = false;
         _global.IS_CAPTURED.Aden = false;
         _global.CURR_TOWN = "Nara";
         delete _global.FRIENDS;
         _global.FRIENDS = new Array();
         var i = 0;
         while(i < 5)
         {
            _global.FRIENDS.push(new Unit("Jap","fists",1));
            i++;
         }
         break;
      case "Mon":
         delete _global.IS_CAPTURED;
         _global.IS_CAPTURED = new Array();
         _global.IS_CAPTURED.Curia = false;
         _global.IS_CAPTURED.Risby = false;
         _global.IS_CAPTURED.Elki = false;
         _global.IS_CAPTURED.Nara = false;
         _global.IS_CAPTURED.Neath = true;
         _global.IS_CAPTURED.Aden = false;
         _global.CURR_TOWN = "Neath";
         delete _global.FRIENDS;
         _global.FRIENDS = new Array();
         var i = 0;
         while(i < 5)
         {
            _global.FRIENDS.push(new Unit("Mon","2H_sword",0));
            i++;
         }
         break;
      case "Ara":
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
   }
   gotoAndStop("diff");
}
