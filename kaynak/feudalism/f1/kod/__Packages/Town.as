class Town extends Object
{
   var ID;
   var NAME;
   var NATION;
   var adv_defenders;
   var barn;
   var barracks;
   var defenders;
   var forge;
   function Town(townID)
   {
      super();
      this.barracks = new Array();
      this.forge = new Array();
      this.barn = new Array();
      this.defenders = new Array();
      this.adv_defenders = new Array();
      this.ID = townID;
      this["Town" + townID]();
   }
   function getDefenders()
   {
      delete _global.ENEMIES;
      _global.ENEMIES = new Array();
      var _loc4_ = 0;
      var _loc3_;
      while(_loc4_ < this.defenders.length)
      {
         _loc3_ = 0;
         while(_loc3_ < this.defenders[_loc4_].COUNT)
         {
            _global.ENEMIES.push(this.defenders[_loc4_].getUnit());
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function getAdvDefenders()
   {
      delete _global.ENEMIES;
      _global.ENEMIES = new Array();
      var _loc4_ = 0;
      var _loc3_;
      while(_loc4_ < this.adv_defenders.length)
      {
         _loc3_ = 0;
         while(_loc3_ < this.adv_defenders[_loc4_].COUNT)
         {
            _global.ENEMIES.push(this.adv_defenders[_loc4_].getUnit());
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function setBattleMap()
   {
      switch(this.ID)
      {
         case "Trapezus":
         case "Lutetia":
         case "Arretium":
         case "Ravenna":
         case "Lacrimosa":
            _global.BATTLE_MAP = 20;
            break;
         case "Caesaria":
         case "Carthage":
         case "Alexandria":
            _global.BATTLE_MAP = 16;
            break;
         case "Jana":
         case "Konstanz":
         case "Gerlitz":
         case "Hoffen":
         case "Endem":
            _global.BATTLE_MAP = 4;
            break;
         case "Sturmburg":
         case "Braunburg":
         case "Wanderburg":
            _global.BATTLE_MAP = 0;
            break;
         case "Dubkee":
         case "Dalnevodye":
         case "Losevo":
         case "Medvedevo":
         case "Grouzeno":
            _global.BATTLE_MAP = 12;
            break;
         case "Dobrov":
         case "Zlatograd":
         case "RaGorod":
            _global.BATTLE_MAP = 8;
            break;
         case "Omi":
         case "Kozuke":
         case "Fukushima":
         case "Echigo":
         case "Suo":
            _global.BATTLE_MAP = 28;
            break;
         case "Matsuyama":
         case "Izumo":
         case "Nagoya":
            _global.BATTLE_MAP = 24;
      }
      _global.BATTLE_MAP += _root.d(4);
   }
   function TownTrapezus()
   {
      this.NATION = "Viz";
      this.NAME = "Trapezus";
      this.barracks.push(new UnitInfo("Melee","Viz",1));
      this.barracks.push(new UnitInfo("Ranged","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",1));
      this.defenders.push(new UnitInfo("Melee","Viz",1,4));
      this.defenders.push(new UnitInfo("Ranged","Viz",1,1));
      this.defenders.push(new UnitInfo("Melee","Viz",2,1));
      this.defenders.push(new UnitInfo("Ranged","Viz",1,1));
   }
   function TownLutetia()
   {
      this.NATION = "Viz";
      this.NAME = "Lutetia";
      this.barracks.push(new UnitInfo("Melee","Viz",1));
      this.barracks.push(new UnitInfo("Melee","Viz",2));
      this.barracks.push(new UnitInfo("Ranged","Viz",1));
      this.barracks.push(new UnitInfo("Ranged","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",1));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",1));
      this.defenders.push(new UnitInfo("Melee","Viz",1,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",1,5));
      this.defenders.push(new UnitInfo("Melee","Viz",2,2));
      this.defenders.push(new UnitInfo("Ranged","Viz",2,2));
   }
   function TownArretium()
   {
      this.NATION = "Viz";
      this.NAME = "Arretium";
      this.barracks.push(new UnitInfo("Melee","Viz",1));
      this.barracks.push(new UnitInfo("Melee","Viz",2));
      this.barracks.push(new UnitInfo("Melee","Viz",3));
      this.barracks.push(new UnitInfo("Ranged","Viz",1));
      this.barracks.push(new UnitInfo("Ranged","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",2));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",1));
      this.defenders.push(new UnitInfo("Melee","Viz",2,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",2,5));
      this.defenders.push(new UnitInfo("Melee","Viz",3,3));
   }
   function TownRavenna()
   {
      this.NATION = "Viz";
      this.NAME = "Ravenna";
      this.barracks.push(new UnitInfo("Melee","Viz",2));
      this.barracks.push(new UnitInfo("Melee","Viz",3));
      this.barracks.push(new UnitInfo("Melee","Viz",4));
      this.barracks.push(new UnitInfo("Ranged","Viz",2));
      this.barracks.push(new UnitInfo("Ranged","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",3));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",2));
      this.barn.push(new Horse("brown",50,1,4,700));
      this.barn.push(new Horse("grey",100,2,3,900));
      this.defenders.push(new UnitInfo("Melee","Viz",3,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",3,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",3,6));
      this.defenders.push(new UnitInfo("Ranged","Viz",4,3));
   }
   function TownLacrimosa()
   {
      this.NATION = "Viz";
      this.NAME = "Lacrimosa";
      this.barracks.push(new UnitInfo("Melee","Viz",3));
      this.barracks.push(new UnitInfo("Melee","Viz",4));
      this.barracks.push(new UnitInfo("Melee","Viz",5));
      this.barracks.push(new UnitInfo("Melee","Viz",6));
      this.barracks.push(new UnitInfo("Ranged","Viz",3));
      this.barracks.push(new UnitInfo("Ranged","Viz",4));
      this.barracks.push(new UnitInfo("Ranged","Viz",6));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",4));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",2));
      this.defenders.push(new UnitInfo("Melee","Viz",4,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",4,5));
      this.defenders.push(new UnitInfo("Melee","Viz",5,2));
      this.defenders.push(new UnitInfo("Ranged","Viz",6,4));
      this.defenders.push(new UnitInfo("Melee","Viz",6,2));
   }
   function TownCaesaria()
   {
      this.NATION = "Viz";
      this.NAME = "Caesaria";
      this.barracks.push(new UnitInfo("Melee","Viz",3));
      this.barracks.push(new UnitInfo("Melee","Viz",4));
      this.barracks.push(new UnitInfo("Melee","Viz",5));
      this.barracks.push(new UnitInfo("Melee","Viz",6));
      this.barracks.push(new UnitInfo("Melee","Viz",9));
      this.barracks.push(new UnitInfo("Ranged","Viz",9));
      this.barracks.push(new UnitInfo("Ranged","Viz",3));
      this.barracks.push(new UnitInfo("Ranged","Viz",4));
      this.barracks.push(new UnitInfo("Ranged","Viz",5));
      this.barracks.push(new UnitInfo("Ranged","Viz",6));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",2));
      this.barn.push(new Horse("brown",90,2,5,900));
      this.barn.push(new Horse("grey",200,5,3,1300));
      this.barn.push(new Horse("red",150,2,3,850));
      this.barn.push(new Horse("white",200,6,2,1700));
      this.defenders.push(new UnitInfo("Melee","Viz",6,2));
      this.defenders.push(new UnitInfo("Melee","Viz",5,3));
      this.defenders.push(new UnitInfo("Ranged","Viz",6,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",5,4));
      this.defenders.push(new UnitInfo("Melee","Viz",9,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",9,5));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",7,8));
      this.adv_defenders.push(new UnitInfo("Ranged","Viz",7,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",9,5));
   }
   function TownCarthage()
   {
      this.NATION = "Viz";
      this.NAME = "Carthage";
      this.barracks.push(new UnitInfo("Melee","Viz",3));
      this.barracks.push(new UnitInfo("Melee","Viz",4));
      this.barracks.push(new UnitInfo("Melee","Viz",5));
      this.barracks.push(new UnitInfo("Melee","Viz",6));
      this.barracks.push(new UnitInfo("Melee","Viz",7));
      this.barracks.push(new UnitInfo("Melee","Viz",9));
      this.barracks.push(new UnitInfo("Ranged","Viz",9));
      this.barracks.push(new UnitInfo("Ranged","Viz",3));
      this.barracks.push(new UnitInfo("Ranged","Viz",4));
      this.barracks.push(new UnitInfo("Ranged","Viz",5));
      this.barracks.push(new UnitInfo("Ranged","Viz",6));
      this.barracks.push(new UnitInfo("Ranged","Viz",7));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Viz",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",3));
      this.barn.push(new Horse("brown",100,3,6,1100));
      this.barn.push(new Horse("grey",250,5,3,1550));
      this.barn.push(new Horse("red",190,2,5,950));
      this.barn.push(new Horse("white",260,7,2,1800));
      this.barn.push(new Horse("black",300,7,2,2000));
      this.defenders.push(new UnitInfo("Melee","Viz",6,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",5,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",7,2));
      this.defenders.push(new UnitInfo("Melee","Viz",7,4));
      this.defenders.push(new UnitInfo("Ranged","Viz",7,2));
      this.defenders.push(new UnitInfo("Melee","Viz",9,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Viz",5,5));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",9,3));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,2));
   }
   function TownAlexandria()
   {
      this.NATION = "Viz";
      this.NAME = "Alexandria";
      this.barracks.push(new UnitInfo("Melee","Viz",3));
      this.barracks.push(new UnitInfo("Melee","Viz",4));
      this.barracks.push(new UnitInfo("Melee","Viz",5));
      this.barracks.push(new UnitInfo("Melee","Viz",6));
      this.barracks.push(new UnitInfo("Melee","Viz",7));
      this.barracks.push(new UnitInfo("Melee","Viz",8));
      this.barracks.push(new UnitInfo("Melee","Viz",9));
      this.barracks.push(new UnitInfo("Ranged","Viz",9));
      this.barracks.push(new UnitInfo("Ranged","Viz",3));
      this.barracks.push(new UnitInfo("Ranged","Viz",4));
      this.barracks.push(new UnitInfo("Ranged","Viz",5));
      this.barracks.push(new UnitInfo("Ranged","Viz",6));
      this.barracks.push(new UnitInfo("Ranged","Viz",7));
      this.barracks.push(new UnitInfo("Ranged","Viz",8));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Viz",5));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Viz",5));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Dagger","Viz",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Viz",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Viz",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Viz",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Viz",6));
      this.forge.push(new ItemInfo("Armor","Helmet","Viz",3));
      this.barn.push(new Horse("brown",150,4,6,1500));
      this.barn.push(new Horse("grey",300,6,3,1700));
      this.barn.push(new Horse("red",200,3,6,1100));
      this.barn.push(new Horse("white",350,6,5,2200));
      this.barn.push(new Horse("black",500,8,1,2500));
      this.defenders.push(new UnitInfo("Melee","Viz",7,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",7,2));
      this.defenders.push(new UnitInfo("Ranged","Viz",5,3));
      this.defenders.push(new UnitInfo("Melee","Viz",9,4));
      this.defenders.push(new UnitInfo("Ranged","Viz",8,2));
      this.defenders.push(new UnitInfo("Ranged","Viz",9,5));
      this.defenders.push(new UnitInfo("Ranged","Viz",8,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Viz",5,5));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,1));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,1));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,1));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,2));
      this.adv_defenders.push(new UnitInfo("Melee","Viz",8,1));
   }
   function TownJana()
   {
      this.NATION = "Ger";
      this.NAME = "Jana";
      this.barracks.push(new UnitInfo("Melee","Ger",1));
      this.barracks.push(new UnitInfo("Melee","Ger",2));
      this.barracks.push(new UnitInfo("Ranged","Ger",1));
      this.barracks.push(new UnitInfo("Ranged","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",1));
      this.defenders.push(new UnitInfo("Melee","Ger",2,1));
      this.defenders.push(new UnitInfo("Melee","Ger",1,3));
      this.defenders.push(new UnitInfo("Melee","Ger",2,1));
      this.defenders.push(new UnitInfo("Ranged","Ger",1,1));
      this.defenders.push(new UnitInfo("Ranged","Ger",2,3));
      this.defenders.push(new UnitInfo("Ranged","Ger",1,1));
   }
   function TownKonstanz()
   {
      this.NATION = "Ger";
      this.NAME = "Konstanz";
      this.barracks.push(new UnitInfo("Melee","Ger",1));
      this.barracks.push(new UnitInfo("Melee","Ger",2));
      this.barracks.push(new UnitInfo("Melee","Ger",3));
      this.barracks.push(new UnitInfo("Melee","Ger",5));
      this.barracks.push(new UnitInfo("Ranged","Ger",1));
      this.barracks.push(new UnitInfo("Ranged","Ger",2));
      this.barracks.push(new UnitInfo("Ranged","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",1));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",1));
      this.defenders.push(new UnitInfo("Melee","Ger",2,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",2,5));
      this.defenders.push(new UnitInfo("Melee","Ger",3,3));
      this.defenders.push(new UnitInfo("Ranged","Ger",3,1));
      this.defenders.push(new UnitInfo("Melee","Ger",5,1));
   }
   function TownGerlitz()
   {
      this.NATION = "Ger";
      this.NAME = "Gerlitz";
      this.barracks.push(new UnitInfo("Melee","Ger",2));
      this.barracks.push(new UnitInfo("Melee","Ger",3));
      this.barracks.push(new UnitInfo("Melee","Ger",4));
      this.barracks.push(new UnitInfo("Melee","Ger",5));
      this.barracks.push(new UnitInfo("Melee","Ger",6));
      this.barracks.push(new UnitInfo("Ranged","Ger",2));
      this.barracks.push(new UnitInfo("Ranged","Ger",3));
      this.barracks.push(new UnitInfo("Ranged","Ger",5));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",2));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",1));
      this.defenders.push(new UnitInfo("Melee","Ger",3,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",3,5));
      this.defenders.push(new UnitInfo("Melee","Ger",4,2));
      this.defenders.push(new UnitInfo("Ranged","Ger",5,2));
      this.defenders.push(new UnitInfo("Melee","Ger",6,3));
   }
   function TownSturmburg()
   {
      this.NATION = "Ger";
      this.NAME = "Sturmburg";
      this.barracks.push(new UnitInfo("Melee","Ger",3));
      this.barracks.push(new UnitInfo("Melee","Ger",4));
      this.barracks.push(new UnitInfo("Melee","Ger",5));
      this.barracks.push(new UnitInfo("Melee","Ger",6));
      this.barracks.push(new UnitInfo("Melee","Ger",7));
      this.barracks.push(new UnitInfo("Melee","Ger",12));
      this.barracks.push(new UnitInfo("Ranged","Ger",3));
      this.barracks.push(new UnitInfo("Ranged","Ger",5));
      this.barracks.push(new UnitInfo("Ranged","Ger",6));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",3));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",2));
      this.barn.push(new Horse("grey",50,1,4,700));
      this.barn.push(new Horse("white",60,1,4,800));
      this.defenders.push(new UnitInfo("Melee","Ger",4,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",5,5));
      this.defenders.push(new UnitInfo("Melee","Ger",7,2));
      this.defenders.push(new UnitInfo("Ranged","Ger",6,4));
      this.defenders.push(new UnitInfo("Melee","Ger",12,4));
      this.adv_defenders.push(new UnitInfo("Melee","Ger",8,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Ger",6,5));
      this.adv_defenders.push(new UnitInfo("Melee","Ger",8,3));
      this.adv_defenders.push(new UnitInfo("Ranged","Ger",7,2));
   }
   function TownHoffen()
   {
      this.NATION = "Ger";
      this.NAME = "Hoffen";
      this.barracks.push(new UnitInfo("Melee","Ger",4));
      this.barracks.push(new UnitInfo("Melee","Ger",6));
      this.barracks.push(new UnitInfo("Melee","Ger",7));
      this.barracks.push(new UnitInfo("Melee","Ger",8));
      this.barracks.push(new UnitInfo("Melee","Ger",12));
      this.barracks.push(new UnitInfo("Ranged","Ger",5));
      this.barracks.push(new UnitInfo("Ranged","Ger",6));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",2));
      this.defenders.push(new UnitInfo("Melee","Ger",12,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",6,5));
      this.defenders.push(new UnitInfo("Melee","Ger",8,8));
   }
   function TownEndem()
   {
      this.NATION = "Ger";
      this.NAME = "Endem";
      this.barracks.push(new UnitInfo("Melee","Ger",3));
      this.barracks.push(new UnitInfo("Melee","Ger",5));
      this.barracks.push(new UnitInfo("Melee","Ger",6));
      this.barracks.push(new UnitInfo("Melee","Ger",7));
      this.barracks.push(new UnitInfo("Melee","Ger",8));
      this.barracks.push(new UnitInfo("Melee","Ger",12));
      this.barracks.push(new UnitInfo("Ranged","Ger",3));
      this.barracks.push(new UnitInfo("Ranged","Ger",6));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",2));
      this.defenders.push(new UnitInfo("Melee","Ger",7,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",3,5));
      this.defenders.push(new UnitInfo("Melee","Ger",8,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",3,4));
   }
   function TownBraunburg()
   {
      this.NATION = "Ger";
      this.NAME = "Braunburg";
      this.barracks.push(new UnitInfo("Melee","Ger",4));
      this.barracks.push(new UnitInfo("Melee","Ger",6));
      this.barracks.push(new UnitInfo("Melee","Ger",7));
      this.barracks.push(new UnitInfo("Melee","Ger",10));
      this.barracks.push(new UnitInfo("Melee","Ger",12));
      this.barracks.push(new UnitInfo("Ranged","Ger",5));
      this.barracks.push(new UnitInfo("Ranged","Ger",6));
      this.barracks.push(new UnitInfo("Ranged","Ger",7));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",4));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",2));
      this.barn.push(new Horse("grey",100,1,4,900));
      this.barn.push(new Horse("red",90,1,5,950));
      this.barn.push(new Horse("brown",150,3,2,1000));
      this.barn.push(new Horse("white",250,4,1,1500));
      this.defenders.push(new UnitInfo("Melee","Ger",7,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",6,5));
      this.defenders.push(new UnitInfo("Melee","Ger",12,4));
      this.defenders.push(new UnitInfo("Ranged","Ger",7,3));
      this.defenders.push(new UnitInfo("Melee","Ger",10,3));
      this.adv_defenders.push(new UnitInfo("Melee","Ger",10,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Ger",3,5));
      this.adv_defenders.push(new UnitInfo("Melee","Ger",11,2));
      this.adv_defenders.push(new UnitInfo("Ranged","Ger",3,4));
   }
   function TownWanderburg()
   {
      this.NATION = "Ger";
      this.NAME = "Wanderburg";
      this.barracks.push(new UnitInfo("Melee","Ger",4));
      this.barracks.push(new UnitInfo("Melee","Ger",6));
      this.barracks.push(new UnitInfo("Melee","Ger",7));
      this.barracks.push(new UnitInfo("Melee","Ger",8));
      this.barracks.push(new UnitInfo("Melee","Ger",9));
      this.barracks.push(new UnitInfo("Melee","Ger",10));
      this.barracks.push(new UnitInfo("Melee","Ger",11));
      this.barracks.push(new UnitInfo("Melee","Ger",12));
      this.barracks.push(new UnitInfo("Ranged","Ger",3));
      this.barracks.push(new UnitInfo("Ranged","Ger",4));
      this.barracks.push(new UnitInfo("Ranged","Ger",5));
      this.barracks.push(new UnitInfo("Ranged","Ger",6));
      this.barracks.push(new UnitInfo("Ranged","Ger",7));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Ger",5));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Ger",5));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Ger",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Ger",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Ger",3));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Ger",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Ger",6));
      this.forge.push(new ItemInfo("Armor","Helmet","Ger",3));
      this.barn.push(new Horse("grey",250,3,5,1700));
      this.barn.push(new Horse("red",200,2,6,1600));
      this.barn.push(new Horse("brown",350,4,4,1800));
      this.barn.push(new Horse("white",400,5,6,3500));
      this.barn.push(new Horse("black",700,9,0,5000));
      this.defenders.push(new UnitInfo("Melee","Ger",10,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",4,5));
      this.defenders.push(new UnitInfo("Ranged","Ger",7,2));
      this.defenders.push(new UnitInfo("Melee","Ger",11,4));
      this.defenders.push(new UnitInfo("Ranged","Ger",7,3));
      this.adv_defenders.push(new UnitInfo("Melee","Ger",11,6));
      this.adv_defenders.push(new UnitInfo("Ranged","Ger",4,5));
   }
   function TownDubkee()
   {
      this.NATION = "Rus";
      this.NAME = "Dubkee";
      this.barracks.push(new UnitInfo("Melee","Rus",1));
      this.barracks.push(new UnitInfo("Melee","Rus",2));
      this.barracks.push(new UnitInfo("Ranged","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",1));
      this.barn.push(new Horse("grey",30,0,3,300));
      this.defenders.push(new UnitInfo("Melee","Rus",1,2));
      this.defenders.push(new UnitInfo("Melee","Rus",2,1));
      this.defenders.push(new UnitInfo("Melee","Rus",1,2));
      this.defenders.push(new UnitInfo("Ranged","Rus",1,5));
   }
   function TownDalnevodye()
   {
      this.NATION = "Rus";
      this.NAME = "Dalnevodye";
      this.barracks.push(new UnitInfo("Melee","Rus",1));
      this.barracks.push(new UnitInfo("Melee","Rus",2));
      this.barracks.push(new UnitInfo("Melee","Rus",3));
      this.barracks.push(new UnitInfo("Ranged","Rus",1));
      this.barracks.push(new UnitInfo("Ranged","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",1));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",1));
      this.barn.push(new Horse("grey",40,0,3,350));
      this.defenders.push(new UnitInfo("Melee","Rus",2,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",1,5));
      this.defenders.push(new UnitInfo("Melee","Rus",3,4));
      this.defenders.push(new UnitInfo("Ranged","Rus",3,2));
   }
   function TownLosevo()
   {
      this.NATION = "Rus";
      this.NAME = "Losevo";
      this.barracks.push(new UnitInfo("Melee","Rus",1));
      this.barracks.push(new UnitInfo("Melee","Rus",2));
      this.barracks.push(new UnitInfo("Melee","Rus",3));
      this.barracks.push(new UnitInfo("Melee","Rus",4));
      this.barracks.push(new UnitInfo("Melee","Rus",8));
      this.barracks.push(new UnitInfo("Ranged","Rus",1));
      this.barracks.push(new UnitInfo("Ranged","Rus",3));
      this.barracks.push(new UnitInfo("Ranged","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",2));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",1));
      this.barn.push(new Horse("grey",50,0,4,500));
      this.defenders.push(new UnitInfo("Melee","Rus",3,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",3,5));
      this.defenders.push(new UnitInfo("Melee","Rus",4,4));
      this.defenders.push(new UnitInfo("Ranged","Rus",4,3));
      this.defenders.push(new UnitInfo("Melee","Rus",8,2));
   }
   function TownDobrov()
   {
      this.NATION = "Rus";
      this.NAME = "Dobrov";
      this.barracks.push(new UnitInfo("Melee","Rus",1));
      this.barracks.push(new UnitInfo("Melee","Rus",2));
      this.barracks.push(new UnitInfo("Melee","Rus",3));
      this.barracks.push(new UnitInfo("Melee","Rus",4));
      this.barracks.push(new UnitInfo("Melee","Rus",5));
      this.barracks.push(new UnitInfo("Melee","Rus",8));
      this.barracks.push(new UnitInfo("Ranged","Rus",1));
      this.barracks.push(new UnitInfo("Ranged","Rus",2));
      this.barracks.push(new UnitInfo("Ranged","Rus",3));
      this.barracks.push(new UnitInfo("Ranged","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",3));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",1));
      this.barn.push(new Horse("grey",50,1,4,700));
      this.barn.push(new Horse("red",20,0,6,600));
      this.defenders.push(new UnitInfo("Melee","Rus",8,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",4,5));
      this.defenders.push(new UnitInfo("Melee","Rus",5,3));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.adv_defenders.push(new UnitInfo("Melee","Rus",5,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.adv_defenders.push(new UnitInfo("Melee","Rus",6,3));
   }
   function TownZlatograd()
   {
      this.NATION = "Rus";
      this.NAME = "Zlatograd";
      this.barracks.push(new UnitInfo("Melee","Rus",3));
      this.barracks.push(new UnitInfo("Melee","Rus",4));
      this.barracks.push(new UnitInfo("Melee","Rus",5));
      this.barracks.push(new UnitInfo("Melee","Rus",6));
      this.barracks.push(new UnitInfo("Melee","Rus",8));
      this.barracks.push(new UnitInfo("Ranged","Rus",2));
      this.barracks.push(new UnitInfo("Ranged","Rus",3));
      this.barracks.push(new UnitInfo("Ranged","Rus",4));
      this.barracks.push(new UnitInfo("Ranged","Rus",5));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",1));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",4));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",2));
      this.barn.push(new Horse("grey",150,2,4,950));
      this.barn.push(new Horse("red",100,1,6,900));
      this.barn.push(new Horse("brown",200,3,2,1000));
      this.barn.push(new Horse("white",250,3,3,1200));
      this.defenders.push(new UnitInfo("Melee","Rus",5,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.defenders.push(new UnitInfo("Melee","Rus",6,3));
      this.defenders.push(new UnitInfo("Ranged","Rus",5,5));
      this.defenders.push(new UnitInfo("Melee","Rus",6,3));
      this.adv_defenders.push(new UnitInfo("Melee","Rus",6,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.adv_defenders.push(new UnitInfo("Melee","Rus",7,4));
      this.adv_defenders.push(new UnitInfo("Ranged","Rus",5,3));
   }
   function TownMedvedevo()
   {
      this.NATION = "Rus";
      this.NAME = "Medvedevo";
      this.barracks.push(new UnitInfo("Melee","Rus",3));
      this.barracks.push(new UnitInfo("Melee","Rus",4));
      this.barracks.push(new UnitInfo("Melee","Rus",5));
      this.barracks.push(new UnitInfo("Melee","Rus",6));
      this.barracks.push(new UnitInfo("Melee","Rus",7));
      this.barracks.push(new UnitInfo("Melee","Rus",8));
      this.barracks.push(new UnitInfo("Ranged","Rus",2));
      this.barracks.push(new UnitInfo("Ranged","Rus",3));
      this.barracks.push(new UnitInfo("Ranged","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",2));
      this.defenders.push(new UnitInfo("Melee","Rus",6,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.defenders.push(new UnitInfo("Melee","Rus",7,6));
   }
   function TownGrouzeno()
   {
      this.NATION = "Rus";
      this.NAME = "Grouzeno";
      this.barracks.push(new UnitInfo("Melee","Rus",10));
      this.barracks.push(new UnitInfo("Melee","Rus",9));
      this.barracks.push(new UnitInfo("Ranged","Rus",1));
      this.barracks.push(new UnitInfo("Ranged","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",6));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",3));
      this.barn.push(new Horse("black",1000,10,6,20000));
      this.barn.push(new Horse("white",1000,10,6,20000));
      this.defenders.push(new UnitInfo("Melee","Rus",8,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.defenders.push(new UnitInfo("Melee","Rus",10,3));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,2));
      this.defenders.push(new UnitInfo("Melee","Rus",10,3));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,2));
   }
   function TownRaGorod()
   {
      this.NATION = "Rus";
      this.NAME = "Ra-Gorod";
      this.barracks.push(new UnitInfo("Melee","Rus",3));
      this.barracks.push(new UnitInfo("Melee","Rus",4));
      this.barracks.push(new UnitInfo("Melee","Rus",5));
      this.barracks.push(new UnitInfo("Melee","Rus",6));
      this.barracks.push(new UnitInfo("Melee","Rus",7));
      this.barracks.push(new UnitInfo("Melee","Rus",8));
      this.barracks.push(new UnitInfo("Melee","Rus",9));
      this.barracks.push(new UnitInfo("Ranged","Rus",2));
      this.barracks.push(new UnitInfo("Ranged","Rus",3));
      this.barracks.push(new UnitInfo("Ranged","Rus",4));
      this.barracks.push(new UnitInfo("Ranged","Rus",5));
      this.barracks.push(new UnitInfo("Ranged","Rus",6));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedSword","Rus",5));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedAxe","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","OnehandedMace","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedSword","Rus",5));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedAxe","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","TwohandedMace","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Rus",2));
      this.forge.push(new ItemInfo("WeaponClass","Crossbow","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Rus",4));
      this.forge.push(new ItemInfo("WeaponClass","Spear","Rus",3));
      this.forge.push(new ItemInfo("WeaponClass","Shield","Rus",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Rus",6));
      this.forge.push(new ItemInfo("Armor","Helmet","Rus",3));
      this.barn.push(new Horse("grey",350,4,3,1400));
      this.barn.push(new Horse("red",300,3,6,1400));
      this.barn.push(new Horse("brown",400,5,4,1500));
      this.barn.push(new Horse("white",500,5,6,2200));
      this.barn.push(new Horse("black",600,7,1,3000));
      this.defenders.push(new UnitInfo("Melee","Rus",7,5));
      this.defenders.push(new UnitInfo("Ranged","Rus",2,5));
      this.defenders.push(new UnitInfo("Melee","Rus",9,4));
      this.defenders.push(new UnitInfo("Ranged","Rus",6,2));
      this.defenders.push(new UnitInfo("Melee","Rus",9,4));
      this.defenders.push(new UnitInfo("Ranged","Rus",6,2));
      this.adv_defenders.push(new UnitInfo("Melee","Rus",9,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Rus",6,5));
      this.adv_defenders.push(new UnitInfo("Melee","Rus",10,3));
      this.adv_defenders.push(new UnitInfo("Ranged","Rus",2,4));
   }
   function TownOmi()
   {
      this.NATION = "Jap";
      this.NAME = "Omi";
      this.barracks.push(new UnitInfo("Melee","Jap",1));
      this.barracks.push(new UnitInfo("Melee","Jap",2));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",1));
      this.defenders.push(new UnitInfo("Melee","Jap",1,10));
      this.defenders.push(new UnitInfo("Melee","Jap",2,5));
   }
   function TownKozuke()
   {
      this.NATION = "Jap";
      this.NAME = "Kozuke";
      this.barracks.push(new UnitInfo("Melee","Jap",1));
      this.barracks.push(new UnitInfo("Melee","Jap",2));
      this.barracks.push(new UnitInfo("Melee","Jap",3));
      this.barracks.push(new UnitInfo("Ranged","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",1));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",1));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",1));
      this.defenders.push(new UnitInfo("Melee","Jap",2,10));
      this.defenders.push(new UnitInfo("Ranged","Jap",1,3));
      this.defenders.push(new UnitInfo("Melee","Jap",3,5));
   }
   function TownMatsuyama()
   {
      this.NATION = "Jap";
      this.NAME = "Matsuyama";
      this.barracks.push(new UnitInfo("Melee","Jap",1));
      this.barracks.push(new UnitInfo("Melee","Jap",2));
      this.barracks.push(new UnitInfo("Melee","Jap",3));
      this.barracks.push(new UnitInfo("Melee","Jap",4));
      this.barracks.push(new UnitInfo("Ranged","Jap",1));
      this.barracks.push(new UnitInfo("Ranged","Jap",2));
      this.barracks.push(new UnitInfo("Ranged","Jap",5));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",2));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",2));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",2));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",1));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",2));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",1));
      this.defenders.push(new UnitInfo("Melee","Jap",3,5));
      this.defenders.push(new UnitInfo("Ranged","Jap",1,5));
      this.defenders.push(new UnitInfo("Melee","Jap",4,2));
      this.defenders.push(new UnitInfo("Ranged","Jap",2,2));
      this.defenders.push(new UnitInfo("Melee","Jap",4,2));
      this.defenders.push(new UnitInfo("Ranged","Jap",5,3));
      this.adv_defenders.push(new UnitInfo("Melee","Jap",4,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Jap",5,5));
   }
   function TownFukushima()
   {
      this.NATION = "Jap";
      this.NAME = "Fukushima";
      this.barracks.push(new UnitInfo("Melee","Jap",1));
      this.barracks.push(new UnitInfo("Melee","Jap",2));
      this.barracks.push(new UnitInfo("Melee","Jap",3));
      this.barracks.push(new UnitInfo("Melee","Jap",4));
      this.barracks.push(new UnitInfo("Melee","Jap",6));
      this.barracks.push(new UnitInfo("Ranged","Jap",1));
      this.barracks.push(new UnitInfo("Ranged","Jap",2));
      this.barracks.push(new UnitInfo("Ranged","Jap",5));
      this.barracks.push(new UnitInfo("Ranged","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",3));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",3));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",3));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",2));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",3));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",2));
      this.defenders.push(new UnitInfo("Melee","Jap",4,5));
      this.defenders.push(new UnitInfo("Ranged","Jap",5,5));
      this.defenders.push(new UnitInfo("Melee","Jap",6,5));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,3));
   }
   function TownIzumo()
   {
      this.NATION = "Jap";
      this.NAME = "Izumo";
      this.barracks.push(new UnitInfo("Melee","Jap",1));
      this.barracks.push(new UnitInfo("Melee","Jap",2));
      this.barracks.push(new UnitInfo("Melee","Jap",3));
      this.barracks.push(new UnitInfo("Melee","Jap",4));
      this.barracks.push(new UnitInfo("Melee","Jap",6));
      this.barracks.push(new UnitInfo("Melee","Jap",7));
      this.barracks.push(new UnitInfo("Ranged","Jap",1));
      this.barracks.push(new UnitInfo("Ranged","Jap",2));
      this.barracks.push(new UnitInfo("Ranged","Jap",5));
      this.barracks.push(new UnitInfo("Ranged","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",4));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",4));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",4));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",2));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",4));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",2));
      this.defenders.push(new UnitInfo("Melee","Jap",6,5));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,5));
      this.defenders.push(new UnitInfo("Melee","Jap",7,3));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,4));
      this.defenders.push(new UnitInfo("Melee","Jap",7,1));
      this.adv_defenders.push(new UnitInfo("Melee","Jap",7,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Jap",6,5));
      this.adv_defenders.push(new UnitInfo("Melee","Jap",8,1));
   }
   function TownSuo()
   {
      this.NATION = "Jap";
      this.NAME = "Suo";
      this.barracks.push(new UnitInfo("Melee","Jap",2));
      this.barracks.push(new UnitInfo("Melee","Jap",3));
      this.barracks.push(new UnitInfo("Melee","Jap",4));
      this.barracks.push(new UnitInfo("Melee","Jap",5));
      this.barracks.push(new UnitInfo("Melee","Jap",6));
      this.barracks.push(new UnitInfo("Melee","Jap",7));
      this.barracks.push(new UnitInfo("Melee","Jap",9));
      this.barracks.push(new UnitInfo("Ranged","Jap",2));
      this.barracks.push(new UnitInfo("Ranged","Jap",3));
      this.barracks.push(new UnitInfo("Ranged","Jap",5));
      this.barracks.push(new UnitInfo("Ranged","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",4));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",4));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",5));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",3));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",3));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",2));
      this.defenders.push(new UnitInfo("Melee","Jap",7,5));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,5));
      this.defenders.push(new UnitInfo("Melee","Jap",9,3));
      this.defenders.push(new UnitInfo("Ranged","Jap",3,2));
      this.defenders.push(new UnitInfo("Melee","Jap",9,3));
      this.defenders.push(new UnitInfo("Ranged","Jap",3,4));
   }
   function TownNagoya()
   {
      this.NATION = "Jap";
      this.NAME = "Nagoya";
      this.barracks.push(new UnitInfo("Melee","Jap",3));
      this.barracks.push(new UnitInfo("Melee","Jap",4));
      this.barracks.push(new UnitInfo("Melee","Jap",5));
      this.barracks.push(new UnitInfo("Melee","Jap",6));
      this.barracks.push(new UnitInfo("Melee","Jap",7));
      this.barracks.push(new UnitInfo("Melee","Jap",8));
      this.barracks.push(new UnitInfo("Melee","Jap",9));
      this.barracks.push(new UnitInfo("Melee","Jap",10));
      this.barracks.push(new UnitInfo("Ranged","Jap",2));
      this.barracks.push(new UnitInfo("Ranged","Jap",3));
      this.barracks.push(new UnitInfo("Ranged","Jap",5));
      this.barracks.push(new UnitInfo("Ranged","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",5));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",5));
      this.forge.push(new ItemInfo("WeaponClass","Staff","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","Bow","Jap",4));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",4));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",5));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",3));
      this.defenders.push(new UnitInfo("Melee","Jap",9,5));
      this.defenders.push(new UnitInfo("Ranged","Jap",3,5));
      this.defenders.push(new UnitInfo("Melee","Jap",10,4));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,3));
      this.defenders.push(new UnitInfo("Melee","Jap",10,4));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,3));
      this.defenders.push(new UnitInfo("Melee","Jap",10,4));
      this.defenders.push(new UnitInfo("Ranged","Jap",6,3));
      this.adv_defenders.push(new UnitInfo("Melee","Jap",8,5));
      this.adv_defenders.push(new UnitInfo("Ranged","Jap",6,5));
      this.adv_defenders.push(new UnitInfo("Melee","Jap",10,3));
      this.adv_defenders.push(new UnitInfo("Ranged","Jap",3,3));
      this.adv_defenders.push(new UnitInfo("Melee","Jap",11,1));
   }
   function TownEchigo()
   {
      this.NATION = "Jap";
      this.NAME = "Echigo";
      this.barracks.push(new UnitInfo("Melee","Jap",11));
      this.forge.push(new ItemInfo("WeaponClass","Katana","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","NinjaTo","Jap",6));
      this.forge.push(new ItemInfo("WeaponClass","Throwing","Jap",5));
      this.forge.push(new ItemInfo("Armor","Clothes","Jap",6));
      this.forge.push(new ItemInfo("Armor","Helmet","Jap",3));
      this.defenders.push(new UnitInfo("Melee","Jap",11,8));
   }
}
