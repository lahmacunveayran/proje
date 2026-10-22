class Unit extends Hero
{
   var ARMOR;
   var CON;
   var DEX;
   var GENDER;
   var HELMET;
   var HORSE;
   var ID;
   var INT;
   var NAME;
   var NATION;
   var SKILL;
   var STR;
   var WEAPON_PRI;
   var WEAPON_SEC;
   var price;
   var primary_skill;
   var secondary_skill;
   function Unit(tp, nt, lv)
   {
      super();
      this.ID = lv;
      this.INT = 10;
      var _loc4_;
      if(nt != "Rog")
      {
         this.NATION = nt;
         this.GENDER = !_root.percent(70) ? "f" : "m";
      }
      else
      {
         _loc4_ = ["Viz","Ger","Rus","Jap"];
         this.NATION = _loc4_[_root.dice(4)];
         this.GENDER = "m";
      }
      this["Unit" + tp + nt + lv]();
   }
   function getUnitInfo()
   {
      return new UnitInfo(this.WEAPON_PRI.rng <= 0 ? "Melee" : "Ranged",this.NATION,this.ID);
   }
   function UnitMeleeViz1()
   {
      this.NAME = "Caravan Guard";
      this.STR = 23;
      this.DEX = 5;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",1);
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Sword";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 50;
   }
   function UnitMeleeViz2()
   {
      this.NAME = "Town Guard";
      this.STR = 48;
      this.DEX = 20;
      this.CON = 25;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Viz",2);
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",1);
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 50;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 180;
   }
   function UnitMeleeViz3()
   {
      this.NAME = "Line Infantry";
      this.STR = 35;
      this.DEX = 30;
      this.CON = 30;
      this.WEAPON_PRI = new WeaponClass("Spear","Viz",2);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",1);
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.primary_skill = "Spear";
      this.secondary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 20;
      this.price = 220;
   }
   function UnitMeleeViz4()
   {
      this.NAME = "Legionary";
      this.STR = 45;
      this.DEX = 10;
      this.CON = 45;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",2);
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",2);
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",2);
      this.HORSE = null;
      this.primary_skill = "Sword";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 60;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 350;
   }
   function UnitMeleeViz5()
   {
      this.NAME = "Moon Warrior";
      this.STR = 90;
      this.DEX = 60;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",4);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",2);
      this.ARMOR = new Armor("Clothes","Viz",4);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Sword";
      this.secondary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 75;
      this.SKILL[this.secondary_skill] = 50;
      this.price = 500;
   }
   function UnitMeleeViz6()
   {
      this.NAME = "Light Chivalery";
      this.STR = 55;
      this.DEX = 10;
      this.CON = 45;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",3);
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",1);
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = new Horse("any",15,1,5,0);
      this.primary_skill = "Sword";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 450;
   }
   function UnitMeleeViz7()
   {
      this.NAME = "Blademaster";
      this.STR = 80;
      this.DEX = 50;
      this.CON = 60;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",4);
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",4);
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Viz",2);
      this.HORSE = null;
      this.primary_skill = "Sword";
      this.secondary_skill = "Dual";
      this.SKILL[this.primary_skill] = 80;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 600;
   }
   function UnitMeleeViz8()
   {
      this.NAME = "Golden Rider";
      this.STR = 100;
      this.DEX = 45;
      this.CON = 75;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",5);
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",2);
      this.ARMOR = new Armor("Clothes","Viz",6);
      this.HELMET = new Armor("Helmet","Viz",3);
      this.HORSE = new Horse("white",200,10,2,0);
      this.primary_skill = "Sword";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 55;
      this.price = 1500;
   }
   function UnitMeleeViz9()
   {
      this.NAME = "Asassin";
      this.STR = 70;
      this.DEX = 70;
      this.CON = 40;
      this.WEAPON_PRI = new WeaponClass("Dagger","Viz",4);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",2);
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "Dagger";
      this.secondary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 95;
      this.SKILL[this.secondary_skill] = 70;
      this.price = 750;
   }
   function UnitRangedViz9()
   {
      this.NAME = "Silent Killer";
      this.STR = 60;
      this.DEX = 95;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",3);
      this.WEAPON_SEC = new WeaponClass("Dagger","Viz",3);
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 90;
      this.price = 850;
   }
   function UnitRangedViz1()
   {
      this.NAME = "Bowman";
      this.STR = 10;
      this.DEX = 20;
      this.CON = 5;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",1);
      this.WEAPON_SEC = new WeaponClass("Dagger","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 55;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 40;
   }
   function UnitRangedViz2()
   {
      this.NAME = "Crossbowman";
      this.STR = 10;
      this.DEX = 35;
      this.CON = 5;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",1);
      this.WEAPON_SEC = new WeaponClass("Dagger","Viz",2);
      this.ARMOR = new Armor("Clothes","Viz",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 65;
      this.SKILL[this.secondary_skill] = 55;
      this.price = 100;
   }
   function UnitRangedViz3()
   {
      this.NAME = "Elite Archer";
      this.STR = 30;
      this.DEX = 70;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",1);
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 300;
   }
   function UnitRangedViz4()
   {
      this.NAME = "Sniper";
      this.STR = 30;
      this.DEX = 65;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",1);
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.SKILL[this.secondary_skill] = 50;
      this.price = 400;
   }
   function UnitRangedViz5()
   {
      this.NAME = "Elite Sniper";
      this.STR = 50;
      this.DEX = 90;
      this.CON = 30;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",3);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",2);
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 70;
      this.price = 750;
   }
   function UnitRangedViz6()
   {
      this.NAME = "Chivalery Archer";
      this.STR = 65;
      this.DEX = 65;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",3);
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = new Horse("any",35,2,5,0);
      this.primary_skill = "Bow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 70;
      this.price = 500;
   }
   function UnitRangedViz7()
   {
      this.NAME = "Fire Thrower";
      this.STR = 50;
      this.DEX = 10;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Throwing","Viz",1);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Throwing";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 70;
      this.price = 1000;
   }
   function UnitRangedViz8()
   {
      this.NAME = "Demolisher";
      this.STR = 70;
      this.DEX = 30;
      this.CON = 60;
      this.WEAPON_PRI = new WeaponClass("Throwing","Viz",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Viz",3);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Throwing";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 60;
      this.SKILL[this.secondary_skill] = 90;
      this.price = 1500;
   }
   function UnitMeleeGer1()
   {
      this.NAME = "Acolyte";
      this.STR = 25;
      this.DEX = 25;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ger",1);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Sword";
      this.secondary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 50;
      this.SKILL[this.secondary_skill] = 20;
      this.price = 70;
   }
   function UnitMeleeGer2()
   {
      this.NAME = "Priest";
      this.STR = 5;
      this.DEX = 5;
      this.CON = 45;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",1);
      this.WEAPON_SEC = null;
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Mace";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 65;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 120;
   }
   function UnitMeleeGer3()
   {
      this.NAME = "Maceman";
      this.STR = 15;
      this.DEX = 5;
      this.CON = 35;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",1);
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.primary_skill = "Mace";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 50;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 180;
   }
   function UnitMeleeGer4()
   {
      this.NAME = "Town Guard";
      this.STR = 60;
      this.DEX = 15;
      this.CON = 50;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Ger",2);
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",3);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 20;
      this.price = 250;
   }
   function UnitMeleeGer5()
   {
      this.NAME = "Footman";
      this.STR = 20;
      this.DEX = 15;
      this.CON = 30;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",1);
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.primary_skill = "Spear";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 230;
   }
   function UnitMeleeGer6()
   {
      this.NAME = "Grey Infantry";
      this.STR = 40;
      this.DEX = 15;
      this.CON = 50;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",2);
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",3);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.primary_skill = "Spear";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 75;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 420;
   }
   function UnitMeleeGer7()
   {
      this.NAME = "Elite Infantry";
      this.STR = 75;
      this.DEX = 15;
      this.CON = 65;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",3);
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.primary_skill = "Spear";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 630;
   }
   function UnitMeleeGer8()
   {
      this.NAME = "Paladin";
      this.STR = 80;
      this.DEX = 25;
      this.CON = 80;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ger",4);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",5);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.primary_skill = "Sword";
      this.secondary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 20;
      this.price = 550;
   }
   function UnitMeleeGer9()
   {
      this.NAME = "Heavy Maceman";
      this.STR = 20;
      this.DEX = 5;
      this.CON = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",4);
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",2);
      this.ARMOR = new Armor("Clothes","Ger",5);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.primary_skill = "Mace";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 630;
   }
   function UnitMeleeGer10()
   {
      this.NAME = "Knight";
      this.STR = 50;
      this.DEX = 5;
      this.CON = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",4);
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",2);
      this.ARMOR = new Armor("Clothes","Ger",5);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = new Horse("white",250,12,1,0);
      this.primary_skill = "Mace";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 1200;
   }
   function UnitMeleeGer11()
   {
      this.NAME = "Crusader";
      this.STR = 90;
      this.DEX = 20;
      this.CON = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ger",5);
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",3);
      this.ARMOR = new Armor("Clothes","Ger",6);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = new Horse("black",250,8,2,0);
      this.primary_skill = "Sword";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 1700;
   }
   function UnitMeleeGer12()
   {
      this.NAME = "Macemaster";
      this.STR = 40;
      this.DEX = 40;
      this.CON = 90;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",4);
      this.WEAPON_SEC = new WeaponClass("OnehandedMace","Ger",4);
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.primary_skill = "Mace";
      this.secondary_skill = "Dual";
      this.SKILL[this.primary_skill] = 80;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 600;
   }
   function UnitRangedGer1()
   {
      this.NAME = "Hunter";
      this.STR = 25;
      this.DEX = 15;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Bow","Ger",1);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "Mace";
      this.SKILL[this.primary_skill] = 55;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 60;
   }
   function UnitRangedGer2()
   {
      this.NAME = "Castle Defender";
      this.STR = 32;
      this.DEX = 30;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Ger",1);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 60;
      this.SKILL[this.secondary_skill] = 30;
      this.price = 70;
   }
   function UnitRangedGer3()
   {
      this.NAME = "St. Bowmen";
      this.STR = 60;
      this.DEX = 50;
      this.CON = 12;
      this.WEAPON_PRI = new WeaponClass("Bow","Ger",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Ger",2);
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "Mace";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 50;
      this.price = 300;
   }
   function UnitRangedGer4()
   {
      this.NAME = "Castle Keeper";
      this.STR = 75;
      this.DEX = 75;
      this.CON = 40;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Ger",3);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Ger",3);
      this.ARMOR = new Armor("Clothes","Ger",3);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 50;
      this.price = 560;
   }
   function UnitRangedGer5()
   {
      this.NAME = "Recon";
      this.STR = 23;
      this.DEX = 30;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Throwing","Ger",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Throwing";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 80;
      this.SKILL[this.secondary_skill] = 45;
      this.price = 250;
   }
   function UnitRangedGer6()
   {
      this.NAME = "Master Recon";
      this.STR = 23;
      this.DEX = 40;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("Throwing","Ger",3);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = new Horse("any",10,0,4,0);
      this.primary_skill = "Throwing";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 55;
      this.price = 300;
   }
   function UnitRangedGer7()
   {
      this.NAME = "Inquisitor";
      this.STR = 30;
      this.DEX = 50;
      this.CON = 80;
      this.WEAPON_PRI = new WeaponClass("Throwing","Ger",4);
      this.WEAPON_SEC = new WeaponClass("TwohandedMace","Ger",3);
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = new Horse("black",100,5,1,0);
      this.primary_skill = "Throwing";
      this.secondary_skill = "Mace";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 80;
      this.price = 700;
   }
   function UnitMeleeRus1()
   {
      this.NAME = "Militia";
      this.STR = 30;
      this.DEX = 5;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",1);
      this.WEAPON_SEC = null;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 40;
   }
   function UnitMeleeRus2()
   {
      this.NAME = "Militia Commander";
      this.STR = 32;
      this.DEX = 5;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",1);
      this.WEAPON_SEC = null;
      this.ARMOR = null;
      this.HELMET = new Armor("Helmet","Rus",1);
      this.HORSE = new Horse("white",25,1,1,0);
      this.primary_skill = "Axe";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 60;
   }
   function UnitMeleeRus3()
   {
      this.NAME = "Warrior";
      this.STR = 40;
      this.DEX = 5;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",1);
      this.WEAPON_SEC = new WeaponClass("Shield","Rus",1);
      this.ARMOR = new Armor("Clothes","Rus",1);
      this.HELMET = new Armor("Helmet","Rus",1);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 50;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 100;
   }
   function UnitMeleeRus4()
   {
      this.NAME = "Veteran Warrior";
      this.STR = 55;
      this.DEX = 5;
      this.CON = 30;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",2);
      this.WEAPON_SEC = new WeaponClass("Shield","Rus",2);
      this.ARMOR = new Armor("Clothes","Rus",3);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 65;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 150;
   }
   function UnitMeleeRus5()
   {
      this.NAME = "Elite Warrior";
      this.STR = 70;
      this.DEX = 5;
      this.CON = 40;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",3);
      this.WEAPON_SEC = new WeaponClass("Shield","Rus",2);
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 80;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 300;
   }
   function UnitMeleeRus6()
   {
      this.NAME = "Axemaster";
      this.STR = 60;
      this.DEX = 5;
      this.CON = 60;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",2);
      this.WEAPON_SEC = new WeaponClass("OnehandedAxe","Rus",2);
      this.ARMOR = new Armor("Clothes","Rus",3);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "Dual";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 70;
      this.price = 500;
   }
   function UnitMeleeRus7()
   {
      this.NAME = "Berserker";
      this.STR = 95;
      this.DEX = 5;
      this.CON = 90;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",4);
      this.WEAPON_SEC = new WeaponClass("OnehandedAxe","Rus",4);
      this.ARMOR = new Armor("Clothes","Rus",5);
      this.HELMET = new Armor("Helmet","Rus",3);
      this.HORSE = null;
      this.primary_skill = "Axe";
      this.secondary_skill = "Dual";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 90;
      this.price = 650;
   }
   function UnitMeleeRus8()
   {
      this.NAME = "Light Rider";
      this.STR = 50;
      this.DEX = 30;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Spear","Rus",2);
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",1);
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = new Horse("any",75,3,4,0);
      this.primary_skill = "Spear";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 250;
   }
   function UnitMeleeRus9()
   {
      this.NAME = "Elite Guard";
      this.STR = 100;
      this.DEX = 30;
      this.CON = 100;
      this.WEAPON_PRI = new WeaponClass("Spear","Rus",3);
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",1);
      this.ARMOR = new Armor("Clothes","Rus",5);
      this.HELMET = new Armor("Helmet","Rus",3);
      this.HORSE = new Horse("white",100,10,3,0);
      this.primary_skill = "Spear";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 1200;
   }
   function UnitMeleeRus10()
   {
      this.NAME = "Great Hero";
      this.STR = 160;
      this.DEX = 40;
      this.CON = 160;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",4);
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",1);
      this.ARMOR = new Armor("Clothes","Rus",6);
      this.HELMET = new Armor("Helmet","Rus",3);
      this.HORSE = new Horse("white",200,10,4,0);
      this.primary_skill = "Axe";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 100;
      this.price = 1500;
   }
   function UnitRangedRus1()
   {
      this.NAME = "Forest Guard";
      this.STR = 20;
      this.DEX = 30;
      this.CON = 5;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",1);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Rus",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 35;
      this.price = 70;
   }
   function UnitRangedRus2()
   {
      this.NAME = "Forest Keeper";
      this.STR = 70;
      this.DEX = 95;
      this.CON = 40;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Rus",4);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 500;
   }
   function UnitRangedRus3()
   {
      this.NAME = "Crossbow Master";
      this.STR = 65;
      this.DEX = 40;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Rus",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",2);
      this.ARMOR = new Armor("Clothes","Rus",2);
      this.HELMET = new Armor("Helmet","Rus",1);
      this.HORSE = null;
      this.primary_skill = "Crossbow";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 55;
      this.price = 250;
   }
   function UnitRangedRus4()
   {
      this.NAME = "Axe Thrower";
      this.STR = 35;
      this.DEX = 5;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Throwing","Rus",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",1);
      this.ARMOR = new Armor("Clothes","Rus",2);
      this.HELMET = new Armor("Helmet","Rus",1);
      this.HORSE = null;
      this.primary_skill = "Throwing";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 55;
      this.price = 150;
   }
   function UnitRangedRus5()
   {
      this.NAME = "Elite Axe Thrower";
      this.STR = 75;
      this.DEX = 40;
      this.CON = 70;
      this.WEAPON_PRI = new WeaponClass("Throwing","Rus",4);
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",3);
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.primary_skill = "Throwing";
      this.secondary_skill = "Axe";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 500;
   }
   function UnitRangedRus6()
   {
      this.NAME = "Elder";
      this.STR = 25;
      this.DEX = 95;
      this.CON = 90;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedMace","Rus",4);
      this.ARMOR = new Armor("Clothes","Rus",1);
      this.HELMET = null;
      this.HORSE = new Horse("white",150,12,2,0);
      this.primary_skill = "Bow";
      this.secondary_skill = "Sword";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 60;
      this.price = 1100;
   }
   function UnitMeleeJap1()
   {
      this.NAME = "Taekwon";
      this.STR = 25;
      this.DEX = 30;
      this.CON = 5;
      this.WEAPON_PRI = null;
      this.WEAPON_SEC = null;
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Fist";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 50;
   }
   function UnitMeleeJap2()
   {
      this.NAME = "Apprentice";
      this.STR = 30;
      this.DEX = 35;
      this.CON = 5;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",1);
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",1);
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "Staff";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 30;
      this.price = 90;
   }
   function UnitMeleeJap3()
   {
      this.NAME = "High Apprentice";
      this.STR = 40;
      this.DEX = 45;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",3);
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",2);
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.primary_skill = "Staff";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 80;
      this.SKILL[this.secondary_skill] = 30;
      this.price = 120;
   }
   function UnitMeleeJap4()
   {
      this.NAME = "Shogun Guard";
      this.STR = 60;
      this.DEX = 60;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",4);
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",3);
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.primary_skill = "Staff";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 85;
      this.SKILL[this.secondary_skill] = 30;
      this.price = 450;
   }
   function UnitMeleeJap5()
   {
      this.NAME = "Elite Shogun Guard";
      this.STR = 90;
      this.DEX = 90;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",6);
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",3);
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "Staff";
      this.secondary_skill = "Bow";
      this.SKILL[this.primary_skill] = 85;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 750;
   }
   function UnitMeleeJap6()
   {
      this.NAME = "Ninja";
      this.STR = 50;
      this.DEX = 50;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",2);
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",1);
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 250;
   }
   function UnitMeleeJap7()
   {
      this.NAME = "Elite Ninja";
      this.STR = 75;
      this.DEX = 75;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",3);
      this.WEAPON_SEC = new WeaponClass("NinjaTo","Jap",3);
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "Dual";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 80;
      this.price = 500;
   }
   function UnitMeleeJap8()
   {
      this.NAME = "Master Ninja";
      this.STR = 95;
      this.DEX = 95;
      this.CON = 25;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",5);
      this.WEAPON_SEC = new WeaponClass("NinjaTo","Jap",5);
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "Dual";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 100;
      this.price = 950;
   }
   function UnitMeleeJap9()
   {
      this.NAME = "Rhonin";
      this.STR = 70;
      this.DEX = 85;
      this.CON = 20;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",4);
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",3);
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 90;
      this.SKILL[this.secondary_skill] = 50;
      this.price = 900;
   }
   function UnitMeleeJap10()
   {
      this.NAME = "Samurai";
      this.STR = 100;
      this.DEX = 100;
      this.CON = 25;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",5);
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",4);
      this.ARMOR = new Armor("Clothes","Jap",5);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 80;
      this.price = 1300;
   }
   function UnitMeleeJap11()
   {
      this.NAME = "Black Samurai";
      this.STR = 120;
      this.DEX = 120;
      this.CON = 40;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",6);
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",5);
      this.ARMOR = new Armor("Clothes","Jap",6);
      this.HELMET = new Armor("Helmet","Jap",3);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 100;
      this.price = 5000;
   }
   function UnitRangedJap1()
   {
      this.NAME = "Shuriken Thrower";
      this.STR = 10;
      this.DEX = 20;
      this.CON = 5;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",1);
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "Staff";
      this.SKILL[this.primary_skill] = 60;
      this.SKILL[this.secondary_skill] = 35;
      this.price = 60;
   }
   function UnitRangedJap2()
   {
      this.NAME = "Shuriken Master";
      this.STR = 15;
      this.DEX = 30;
      this.CON = 10;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",2);
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",2);
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "Staff";
      this.SKILL[this.primary_skill] = 70;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 120;
   }
   function UnitRangedJap3()
   {
      this.NAME = "Elite Shuriken Thrower";
      this.STR = 20;
      this.DEX = 60;
      this.CON = 12;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",4);
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",3);
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "Staff";
      this.SKILL[this.primary_skill] = 85;
      this.SKILL[this.secondary_skill] = 50;
      this.price = 500;
   }
   function UnitRangedJap4()
   {
      this.NAME = "Black Shuriken Thrower";
      this.STR = 40;
      this.DEX = 80;
      this.CON = 25;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",5);
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",5);
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "FarEast";
      this.secondary_skill = "Staff";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 75;
      this.price = 710;
   }
   function UnitRangedJap5()
   {
      this.NAME = "Shadow Bowman";
      this.STR = 20;
      this.DEX = 60;
      this.CON = 12;
      this.WEAPON_PRI = new WeaponClass("Bow","Jap",2);
      this.WEAPON_SEC = new WeaponClass("Katana","Jap",1);
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 80;
      this.SKILL[this.secondary_skill] = 55;
      this.price = 250;
   }
   function UnitRangedJap6()
   {
      this.NAME = "Ghost Bowman";
      this.STR = 55;
      this.DEX = 85;
      this.CON = 15;
      this.WEAPON_PRI = new WeaponClass("Bow","Jap",4);
      this.WEAPON_SEC = new WeaponClass("Katana","Jap",4);
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.primary_skill = "Bow";
      this.secondary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 100;
      this.SKILL[this.secondary_skill] = 80;
      this.price = 550;
   }
   function UnitMeleeRog1()
   {
      this.NAME = "Shield Rogue";
      this.STR = 20;
      this.DEX = 1;
      this.CON = 15;
      var _loc3_ = ["Viz","Ger","Rus","Jap"];
      var _loc4_ = ["OnehandedSword","OnehandedAxe","OnehandedMace"];
      this.WEAPON_PRI = new WeaponClass(_loc4_[_root.dice(3)],"Rog",_root.d(2));
      this.WEAPON_SEC = new WeaponClass("Shield",_loc3_[_root.dice(3)],1);
      this.ARMOR = _root.dice(2) != 0 ? null : new Armor("Clothes",_loc3_[_root.dice(4)],1);
      this.HELMET = _root.dice(4) != 0 ? null : new Armor("Helmet",_loc3_[_root.dice(4)],1);
      this.HORSE = _root.dice(7) != 0 ? null : new Horse("any",10,0,1,0);
      this.primary_skill = this.WEAPON_PRI.skill;
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 15;
   }
   function UnitMeleeRog2()
   {
      this.NAME = "Twohanded Rogue";
      this.STR = 22;
      this.DEX = 1;
      this.CON = 12;
      var _loc3_ = ["Viz","Ger","Rus","Jap"];
      var _loc4_ = ["TwohandedSword","TwohandedAxe","TwohandedMace"];
      this.WEAPON_PRI = _root.dice(4) != 0 ? new WeaponClass(_loc4_[_root.dice(3)],"Rog",_root.d(2)) : new WeaponClass("Spear",_loc3_[_root.dice(3)],1);
      this.WEAPON_SEC = null;
      this.ARMOR = _root.dice(2) != 0 ? null : new Armor("Clothes",_loc3_[_root.dice(4)],1);
      this.HELMET = _root.dice(4) != 0 ? null : new Armor("Helmet",_loc3_[_root.dice(4)],1);
      this.HORSE = _root.dice(7) != 0 ? null : new Horse("any",10,0,1,0);
      this.primary_skill = this.WEAPON_PRI.skill;
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 10;
   }
   function UnitMeleeRog3()
   {
      this.NAME = "DEX Rogue";
      this.STR = 5;
      this.DEX = 40;
      this.CON = 3;
      var _loc3_ = ["Viz","Ger","Rus","Jap"];
      var _loc4_ = ["Staff","Katana"];
      this.WEAPON_PRI = _root.dice(2) != 0 ? new WeaponClass("Staff","Jap",1) : new WeaponClass("Katana","Rog",_root.d(2));
      this.WEAPON_SEC = null;
      this.ARMOR = _root.dice(2) != 0 ? null : new Armor("Clothes",_loc3_[_root.dice(4)],1);
      this.HELMET = _root.dice(4) != 0 ? null : new Armor("Helmet",_loc3_[_root.dice(4)],1);
      this.HORSE = null;
      this.primary_skill = this.WEAPON_PRI.skill;
      this.secondary_skill = "none";
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 0;
      this.price = 12;
   }
   function UnitRangedRog1()
   {
      this.NAME = "Bow Rogue";
      this.STR = 1;
      this.DEX = 20;
      this.CON = 4;
      var _loc3_ = ["Viz","Ger","Rus","Jap"];
      this.WEAPON_PRI = new WeaponClass("Bow",_loc3_[_root.dice(4)],1);
      this.WEAPON_SEC = _root.dice(2) != 0 ? null : new WeaponClass("Dagger","Viz",1);
      this.ARMOR = _root.dice(2) != 0 ? null : new Armor("Clothes",_loc3_[_root.dice(4)],1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = this.WEAPON_PRI.skill;
      this.secondary_skill = this.WEAPON_SEC.skill;
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 30;
      this.price = 8;
   }
   function UnitRangedRog2()
   {
      this.NAME = "Crossbow Rogue";
      this.STR = 1;
      this.DEX = 20;
      this.CON = 4;
      var _loc3_ = ["Viz","Ger","Rus","Jap"];
      this.WEAPON_PRI = new WeaponClass("Crossbow",_loc3_[_root.dice(3)],1);
      this.WEAPON_SEC = _root.dice(2) != 0 ? null : new WeaponClass("Dagger","Viz",1);
      this.ARMOR = _root.dice(2) != 0 ? null : new Armor("Clothes",_loc3_[_root.dice(4)],1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = this.WEAPON_PRI.skill;
      this.secondary_skill = this.WEAPON_SEC.skill;
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 25;
      this.price = 10;
   }
   function UnitRangedRog3()
   {
      this.NAME = "Throwing Rogue";
      this.STR = 20;
      this.DEX = 20;
      this.CON = 1;
      var _loc3_ = ["Ger","Rus","Jap","Viz"];
      this.WEAPON_PRI = new WeaponClass("Throwing",_loc3_[_root.dice(3)],1);
      this.WEAPON_SEC = _root.dice(2) != 0 ? null : new WeaponClass("Staff","Jap",1);
      this.ARMOR = _root.dice(3) != 0 ? null : new Armor("Clothes",_loc3_[_root.dice(4)],1);
      this.HELMET = null;
      this.HORSE = null;
      this.primary_skill = this.WEAPON_PRI.skill;
      this.secondary_skill = this.WEAPON_SEC.skill;
      this.SKILL[this.primary_skill] = 40;
      this.SKILL[this.secondary_skill] = 40;
      this.price = 12;
   }
}
