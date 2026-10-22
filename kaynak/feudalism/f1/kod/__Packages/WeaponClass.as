class WeaponClass extends Item
{
   var FRAME;
   var LEVEL;
   var NAME;
   var NATION;
   var TYPE;
   var canBeMounted;
   var crit;
   var dmg;
   var price;
   var require_param;
   var require_value;
   var rnd;
   var rng;
   var skill;
   var t_aft;
   var t_bef;
   var twohanded;
   function WeaponClass(tp, nt, lv, ei)
   {
      super();
      this.TYPE = tp;
      this.NATION = nt;
      this.LEVEL = lv;
      switch(tp)
      {
         case "TwohandedSword":
         case "TwohandedAxe":
         case "TwohandedMace":
         case "Staff":
         case "Katana":
         case "Spear":
         case "Throwing":
         case "Bow":
         case "Dagger":
         case "Fists":
         case "Crossbow":
            this.twohanded = true;
            break;
         default:
            this.twohanded = false;
      }
      switch(tp)
      {
         case "Dagger":
         case "Staff":
         case "Katana":
         case "NinjaTo":
            this.canBeMounted = false;
            break;
         default:
            this.canBeMounted = true;
      }
      this.FRAME = this.getFrame();
      this["Weapon" + tp + nt + lv]();
      this.initEnchant(ei);
   }
   function WeaponOnehandedSwordRog1()
   {
      this.NAME = "Cheap Sword";
      this.dmg = 3;
      this.rnd = 2;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 10;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 5;
      this.crit = 1;
      this.price = 12;
   }
   function WeaponOnehandedSwordRog2()
   {
      this.NAME = "Rusty Sabre";
      this.dmg = 2;
      this.rnd = 1;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 5;
      this.t_aft = 50;
      this.require_param = null;
      this.require_value = 0;
      this.crit = 1;
      this.price = 10;
   }
   function WeaponOnehandedSwordViz1()
   {
      this.NAME = "Gladius";
      this.dmg = 6;
      this.rnd = 5;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 25;
      this.crit = 5;
      this.price = 30;
   }
   function WeaponOnehandedSwordViz2()
   {
      this.NAME = "Spatha";
      this.dmg = 13;
      this.rnd = 14;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 40;
      this.crit = 5;
      this.price = 120;
   }
   function WeaponOnehandedSwordViz3()
   {
      this.NAME = "Chivallery Spatha";
      this.dmg = 25;
      this.rnd = 22;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 55;
      this.crit = 5;
      this.price = 400;
   }
   function WeaponOnehandedSwordViz4()
   {
      this.NAME = "Leader Sword";
      this.dmg = 35;
      this.rnd = 30;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "STR";
      this.require_value = 75;
      this.crit = 5;
      this.price = 650;
   }
   function WeaponOnehandedSwordViz5()
   {
      this.NAME = "Starshine";
      this.dmg = 50;
      this.rnd = 45;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "STR";
      this.require_value = 95;
      this.crit = 5;
      this.price = 1000;
   }
   function WeaponOnehandedSwordGer1()
   {
      this.NAME = "Short Sword";
      this.dmg = 5;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 18;
      this.crit = 5;
      this.price = 20;
   }
   function WeaponOnehandedSwordGer2()
   {
      this.NAME = "Footman Sword";
      this.dmg = 11;
      this.rnd = 12;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 36;
      this.crit = 5;
      this.price = 80;
   }
   function WeaponOnehandedSwordGer3()
   {
      this.NAME = "Long Sword";
      this.dmg = 22;
      this.rnd = 18;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 50;
      this.crit = 5;
      this.price = 300;
   }
   function WeaponOnehandedSwordGer4()
   {
      this.NAME = "Bastard Sword";
      this.dmg = 39;
      this.rnd = 19;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 68;
      this.crit = 5;
      this.price = 500;
   }
   function WeaponOnehandedSwordGer5()
   {
      this.NAME = "Starbringer";
      this.dmg = 60;
      this.rnd = 50;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 85;
      this.crit = 5;
      this.price = 750;
   }
   function WeaponOnehandedSwordRus1()
   {
      this.NAME = "Cutter";
      this.dmg = 3;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 15;
      this.crit = 5;
      this.price = 15;
   }
   function WeaponOnehandedSwordRus2()
   {
      this.NAME = "Long Dagger";
      this.dmg = 9;
      this.rnd = 10;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 30;
      this.crit = 5;
      this.price = 60;
   }
   function WeaponOnehandedSwordRus3()
   {
      this.NAME = "Cleaver";
      this.dmg = 18;
      this.rnd = 17;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 45;
      this.crit = 5;
      this.price = 250;
   }
   function WeaponOnehandedSwordRus4()
   {
      this.NAME = "Guardian Sword";
      this.dmg = 30;
      this.rnd = 38;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "STR";
      this.require_value = 60;
      this.crit = 5;
      this.price = 400;
   }
   function WeaponOnehandedSwordRus5()
   {
      this.NAME = "Black Curse";
      this.dmg = 40;
      this.rnd = 50;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "STR";
      this.require_value = 75;
      this.crit = 5;
      this.price = 690;
   }
   function WeaponOnehandedAxeRog1()
   {
      this.NAME = "Cheap Axe";
      this.dmg = 4;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 10;
      this.t_aft = 75;
      this.require_param = "STR";
      this.require_value = 5;
      this.crit = 0;
      this.price = 12;
   }
   function WeaponOnehandedAxeRog2()
   {
      this.NAME = "Bronze Axe";
      this.dmg = 3;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 10;
      this.t_aft = 65;
      this.require_param = null;
      this.require_value = 0;
      this.crit = 0;
      this.price = 10;
   }
   function WeaponOnehandedAxeViz1()
   {
      this.NAME = "Ritual Axe";
      this.dmg = 6;
      this.rnd = 5;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 23;
      this.crit = 3;
      this.price = 45;
   }
   function WeaponOnehandedAxeViz2()
   {
      this.NAME = "Priest Axe";
      this.dmg = 21;
      this.rnd = 16;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 40;
      this.crit = 3;
      this.price = 170;
   }
   function WeaponOnehandedAxeViz3()
   {
      this.NAME = "Rounded Axe";
      this.dmg = 28;
      this.rnd = 39;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 50;
      this.crit = 3;
      this.price = 320;
   }
   function WeaponOnehandedAxeViz4()
   {
      this.NAME = "Breaking Axe";
      this.dmg = 45;
      this.rnd = 40;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 70;
      this.crit = 3;
      this.price = 660;
   }
   function WeaponOnehandedAxeGer1()
   {
      this.NAME = "Small Axe";
      this.dmg = 8;
      this.rnd = 7;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 26;
      this.crit = 3;
      this.price = 70;
   }
   function WeaponOnehandedAxeGer2()
   {
      this.NAME = "Infantry Axe";
      this.dmg = 27;
      this.rnd = 21;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 50;
      this.crit = 3;
      this.price = 220;
   }
   function WeaponOnehandedAxeGer3()
   {
      this.NAME = "Broad Axe";
      this.dmg = 35;
      this.rnd = 48;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 65;
      this.crit = 3;
      this.price = 430;
   }
   function WeaponOnehandedAxeGer4()
   {
      this.NAME = "Heavy Axe";
      this.dmg = 60;
      this.rnd = 45;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 85;
      this.crit = 3;
      this.price = 750;
   }
   function WeaponOnehandedAxeRus1()
   {
      this.NAME = "Militia Axe";
      this.dmg = 9;
      this.rnd = 8;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 30;
      this.crit = 3;
      this.price = 80;
   }
   function WeaponOnehandedAxeRus2()
   {
      this.NAME = "Long Axe";
      this.dmg = 30;
      this.rnd = 25;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 55;
      this.crit = 3;
      this.price = 250;
   }
   function WeaponOnehandedAxeRus3()
   {
      this.NAME = "Guard Axe";
      this.dmg = 40;
      this.rnd = 55;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 70;
      this.crit = 3;
      this.price = 500;
   }
   function WeaponOnehandedAxeRus4()
   {
      this.NAME = "Holy Axe";
      this.dmg = 70;
      this.rnd = 60;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 95;
      this.crit = 3;
      this.price = 880;
   }
   function WeaponOnehandedMaceRog1()
   {
      this.NAME = "Wooden Club";
      this.dmg = 2;
      this.rnd = 2;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 10;
      this.t_aft = 70;
      this.require_param = "CON";
      this.require_value = 10;
      this.crit = 15;
      this.price = 12;
   }
   function WeaponOnehandedMaceRog2()
   {
      this.NAME = "Cheap Club";
      this.dmg = 1;
      this.rnd = 2;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 5;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 5;
      this.crit = 15;
      this.price = 10;
   }
   function WeaponOnehandedMaceViz1()
   {
      this.NAME = "Bronze Club";
      this.dmg = 2;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 22;
      this.crit = 30;
      this.price = 40;
   }
   function WeaponOnehandedMaceViz2()
   {
      this.NAME = "Ritual Bludgeon";
      this.dmg = 8;
      this.rnd = 9;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "CON";
      this.require_value = 35;
      this.crit = 30;
      this.price = 200;
   }
   function WeaponOnehandedMaceViz3()
   {
      this.NAME = "Rough Bludgeon";
      this.dmg = 12;
      this.rnd = 19;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "CON";
      this.require_value = 47;
      this.crit = 40;
      this.price = 310;
   }
   function WeaponOnehandedMaceViz4()
   {
      this.NAME = "Shining Bludgeon";
      this.dmg = 25;
      this.rnd = 40;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "CON";
      this.require_value = 68;
      this.crit = 50;
      this.price = 630;
   }
   function WeaponOnehandedMaceGer1()
   {
      this.NAME = "Morningstar";
      this.dmg = 4;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 30;
      this.crit = 50;
      this.price = 75;
   }
   function WeaponOnehandedMaceGer2()
   {
      this.NAME = "Light Bludgeon";
      this.dmg = 15;
      this.rnd = 12;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "CON";
      this.require_value = 55;
      this.crit = 55;
      this.price = 240;
   }
   function WeaponOnehandedMaceGer3()
   {
      this.NAME = "Deadly Spikes";
      this.dmg = 22;
      this.rnd = 27;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "CON";
      this.require_value = 70;
      this.crit = 60;
      this.price = 470;
   }
   function WeaponOnehandedMaceGer4()
   {
      this.NAME = "Peacekeeper";
      this.dmg = 45;
      this.rnd = 30;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "CON";
      this.require_value = 95;
      this.crit = 70;
      this.price = 850;
   }
   function WeaponOnehandedMaceRus1()
   {
      this.NAME = "Spiked Wooden Club";
      this.dmg = 3;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 25;
      this.crit = 50;
      this.price = 60;
   }
   function WeaponOnehandedMaceRus2()
   {
      this.NAME = "Armor Breaker";
      this.dmg = 12;
      this.rnd = 10;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "CON";
      this.require_value = 45;
      this.crit = 55;
      this.price = 220;
   }
   function WeaponOnehandedMaceRus3()
   {
      this.NAME = "Heavy Club";
      this.dmg = 18;
      this.rnd = 21;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "CON";
      this.require_value = 60;
      this.crit = 60;
      this.price = 350;
   }
   function WeaponOnehandedMaceRus4()
   {
      this.NAME = "Golden Hedgehog";
      this.dmg = 30;
      this.rnd = 50;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "CON";
      this.require_value = 80;
      this.crit = 65;
      this.price = 700;
   }
   function WeaponTwohandedSwordRog1()
   {
      this.NAME = "Cheap Twohanded Sword";
      this.dmg = 5;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 10;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 7;
      this.crit = 1;
      this.price = 18;
   }
   function WeaponTwohandedSwordRog2()
   {
      this.NAME = "Rusty Twohanded Sword";
      this.dmg = 3;
      this.rnd = 2;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 5;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 4;
      this.crit = 1;
      this.price = 12;
   }
   function WeaponTwohandedSwordViz1()
   {
      this.NAME = "Iron Twohanded Sword";
      this.dmg = 9;
      this.rnd = 8;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 29;
      this.crit = 5;
      this.price = 45;
   }
   function WeaponTwohandedSwordViz2()
   {
      this.NAME = "Steel Twohanded Sword";
      this.dmg = 20;
      this.rnd = 21;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 48;
      this.crit = 5;
      this.price = 180;
   }
   function WeaponTwohandedSwordViz3()
   {
      this.NAME = "Falcion";
      this.dmg = 38;
      this.rnd = 33;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 65;
      this.crit = 5;
      this.price = 600;
   }
   function WeaponTwohandedSwordViz4()
   {
      this.NAME = "Moonlight";
      this.dmg = 65;
      this.rnd = 50;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 88;
      this.crit = 5;
      this.price = 1100;
   }
   function WeaponTwohandedSwordViz5()
   {
      this.NAME = "Soul Braker";
      this.dmg = 75;
      this.rnd = 70;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 100;
      this.crit = 5;
      this.price = 1300;
   }
   function WeaponTwohandedSwordGer1()
   {
      this.NAME = "Light Twohanded Sword";
      this.dmg = 8;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 23;
      this.crit = 5;
      this.price = 30;
   }
   function WeaponTwohandedSwordGer2()
   {
      this.NAME = "Crusader Twohanded Sword";
      this.dmg = 17;
      this.rnd = 18;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 44;
      this.crit = 5;
      this.price = 120;
   }
   function WeaponTwohandedSwordGer3()
   {
      this.NAME = "Knight Twohanded Sword";
      this.dmg = 33;
      this.rnd = 27;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 60;
      this.crit = 5;
      this.price = 450;
   }
   function WeaponTwohandedSwordGer4()
   {
      this.NAME = "Claymore";
      this.dmg = 59;
      this.rnd = 29;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 75;
      this.crit = 5;
      this.price = 750;
   }
   function WeaponTwohandedSwordGer5()
   {
      this.NAME = "Heart of Bat";
      this.dmg = 85;
      this.rnd = 90;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 95;
      this.crit = 5;
      this.price = 1080;
   }
   function WeaponTwohandedSwordRus1()
   {
      this.NAME = "Forged Twohanded Sword";
      this.dmg = 5;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 20;
      this.crit = 5;
      this.price = 20;
   }
   function WeaponTwohandedSwordRus2()
   {
      this.NAME = "Long Twohanded Sword";
      this.dmg = 14;
      this.rnd = 15;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 38;
      this.crit = 5;
      this.price = 90;
   }
   function WeaponTwohandedSwordRus3()
   {
      this.NAME = "Large Twohanded Sword";
      this.dmg = 27;
      this.rnd = 25;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 52;
      this.crit = 5;
      this.price = 370;
   }
   function WeaponTwohandedSwordRus4()
   {
      this.NAME = "Guardian Twohanded Sword";
      this.dmg = 50;
      this.rnd = 60;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 65;
      this.crit = 5;
      this.price = 900;
   }
   function WeaponTwohandedSwordRus5()
   {
      this.NAME = "Holy Twohanded Sword";
      this.dmg = 60;
      this.rnd = 75;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 85;
      this.crit = 5;
      this.price = 1000;
   }
   function WeaponTwohandedAxeRog1()
   {
      this.NAME = "Splitter";
      this.dmg = 6;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 10;
      this.t_aft = 85;
      this.require_param = "STR";
      this.require_value = 10;
      this.crit = 0;
      this.price = 16;
   }
   function WeaponTwohandedAxeRog2()
   {
      this.NAME = "Rusty Twohanded Axe";
      this.dmg = 4;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Sword";
      this.t_bef = 10;
      this.t_aft = 70;
      this.require_param = null;
      this.require_value = 0;
      this.crit = 0;
      this.price = 12;
   }
   function WeaponTwohandedAxeViz1()
   {
      this.NAME = "Light Twohanded Axe";
      this.dmg = 9;
      this.rnd = 7;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 70;
      this.require_param = "STR";
      this.require_value = 27;
      this.crit = 3;
      this.price = 65;
   }
   function WeaponTwohandedAxeViz2()
   {
      this.NAME = "Rounded Twohanded Axe";
      this.dmg = 31;
      this.rnd = 24;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 48;
      this.crit = 3;
      this.price = 250;
   }
   function WeaponTwohandedAxeViz3()
   {
      this.NAME = "Sea Wave";
      this.dmg = 42;
      this.rnd = 59;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 59;
      this.crit = 3;
      this.price = 480;
   }
   function WeaponTwohandedAxeViz4()
   {
      this.NAME = "Golden Twohanded Axe";
      this.dmg = 75;
      this.rnd = 60;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 43;
      this.require_param = "STR";
      this.require_value = 80;
      this.crit = 3;
      this.price = 990;
   }
   function WeaponTwohandedAxeGer1()
   {
      this.NAME = "Steel Twohanded Axe";
      this.dmg = 12;
      this.rnd = 11;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 70;
      this.require_param = "STR";
      this.require_value = 32;
      this.crit = 3;
      this.price = 105;
   }
   function WeaponTwohandedAxeGer2()
   {
      this.NAME = "Butcher";
      this.dmg = 41;
      this.rnd = 31;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 60;
      this.crit = 3;
      this.price = 330;
   }
   function WeaponTwohandedAxeGer3()
   {
      this.NAME = "Heavy Twohanded Axe";
      this.dmg = 53;
      this.rnd = 62;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 75;
      this.crit = 3;
      this.price = 680;
   }
   function WeaponTwohandedAxeGer4()
   {
      this.NAME = "God\'s Claw";
      this.dmg = 90;
      this.rnd = 68;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 95;
      this.crit = 3;
      this.price = 1050;
   }
   function WeaponTwohandedAxeRus1()
   {
      this.NAME = "Peasant Twohanded Axe";
      this.dmg = 14;
      this.rnd = 12;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 70;
      this.require_param = "STR";
      this.require_value = 37;
      this.crit = 3;
      this.price = 120;
   }
   function WeaponTwohandedAxeRus2()
   {
      this.NAME = "Executioner";
      this.dmg = 45;
      this.rnd = 38;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 65;
      this.crit = 3;
      this.price = 350;
   }
   function WeaponTwohandedAxeRus3()
   {
      this.NAME = "Guard Twohanded Axe";
      this.dmg = 60;
      this.rnd = 82;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 85;
      this.crit = 3;
      this.price = 750;
   }
   function WeaponTwohandedAxeRus4()
   {
      this.NAME = "Elite Twohanded Axe";
      this.dmg = 110;
      this.rnd = 90;
      this.rng = 0;
      this.skill = "Axe";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 120;
      this.crit = 3;
      this.price = 1400;
   }
   function WeaponTwohandedMaceRog1()
   {
      this.NAME = "Rusty Twohanded Bludgeon";
      this.dmg = 3;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 10;
      this.t_aft = 80;
      this.require_param = "CON";
      this.require_value = 13;
      this.crit = 20;
      this.price = 14;
   }
   function WeaponTwohandedMaceRog2()
   {
      this.NAME = "Wooden Twohanded Club";
      this.dmg = 1;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 5;
      this.t_aft = 75;
      this.require_param = "CON";
      this.require_value = 7;
      this.crit = 20;
      this.price = 11;
   }
   function WeaponTwohandedMaceViz1()
   {
      this.NAME = "Bronze Twohanded Bludgeon";
      this.dmg = 3;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 75;
      this.require_param = "CON";
      this.require_value = 25;
      this.crit = 40;
      this.price = 60;
   }
   function WeaponTwohandedMaceViz2()
   {
      this.NAME = "Ritual Twohanded Bludgeon";
      this.dmg = 12;
      this.rnd = 13;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 39;
      this.crit = 40;
      this.price = 300;
   }
   function WeaponTwohandedMaceViz3()
   {
      this.NAME = "Ritual Hammer";
      this.dmg = 18;
      this.rnd = 29;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "CON";
      this.require_value = 65;
      this.crit = 45;
      this.price = 470;
   }
   function WeaponTwohandedMaceViz4()
   {
      this.NAME = "Golden Hammer";
      this.dmg = 25;
      this.rnd = 40;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "CON";
      this.require_value = 82;
      this.crit = 50;
      this.price = 630;
   }
   function WeaponTwohandedMaceGer1()
   {
      this.NAME = "Battle Hammer";
      this.dmg = 6;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 70;
      this.require_param = "CON";
      this.require_value = 42;
      this.crit = 50;
      this.price = 110;
   }
   function WeaponTwohandedMaceGer2()
   {
      this.NAME = "Steel Twohanded Bludgeon";
      this.dmg = 24;
      this.rnd = 18;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 60;
      this.crit = 60;
      this.price = 370;
   }
   function WeaponTwohandedMaceGer3()
   {
      this.NAME = "Spiked Twohanded Bludgeon";
      this.dmg = 33;
      this.rnd = 41;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "CON";
      this.require_value = 78;
      this.crit = 65;
      this.price = 720;
   }
   function WeaponTwohandedMaceGer4()
   {
      this.NAME = "Holy Star";
      this.dmg = 68;
      this.rnd = 45;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "CON";
      this.require_value = 110;
      this.crit = 75;
      this.price = 1200;
   }
   function WeaponTwohandedMaceRus1()
   {
      this.NAME = "Rude Twohanded Bludgeon";
      this.dmg = 4;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 70;
      this.require_param = "CON";
      this.require_value = 37;
      this.crit = 50;
      this.price = 90;
   }
   function WeaponTwohandedMaceRus2()
   {
      this.NAME = "Bronze Hammer";
      this.dmg = 18;
      this.rnd = 15;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "CON";
      this.require_value = 55;
      this.crit = 55;
      this.price = 330;
   }
   function WeaponTwohandedMaceRus3()
   {
      this.NAME = "Heavy Twohanded Bludgeon";
      this.dmg = 28;
      this.rnd = 31;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "CON";
      this.require_value = 72;
      this.crit = 60;
      this.price = 550;
   }
   function WeaponTwohandedMaceRus4()
   {
      this.NAME = "Hero\'s Twohanded Bludgeon";
      this.dmg = 45;
      this.rnd = 75;
      this.rng = 0;
      this.skill = "Mace";
      this.t_bef = 1;
      this.t_aft = 75;
      this.require_param = "CON";
      this.require_value = 90;
      this.crit = 65;
      this.price = 1050;
   }
   function WeaponStaffJap1()
   {
      this.NAME = "Apprentice Staff";
      this.dmg = 4;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Staff";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "DEX";
      this.require_value = 20;
      this.crit = 50;
      this.price = 10;
   }
   function WeaponStaffJap2()
   {
      this.NAME = "Master Staff";
      this.dmg = 8;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "Staff";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "DEX";
      this.require_value = 30;
      this.crit = 55;
      this.price = 70;
   }
   function WeaponStaffJap3()
   {
      this.NAME = "Spiked Staff";
      this.dmg = 16;
      this.rnd = 14;
      this.rng = 0;
      this.skill = "Staff";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "DEX";
      this.require_value = 45;
      this.crit = 65;
      this.price = 180;
   }
   function WeaponStaffJap4()
   {
      this.NAME = "Naginata";
      this.dmg = 20;
      this.rnd = 52;
      this.rng = 0;
      this.skill = "Staff";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 60;
      this.crit = 10;
      this.price = 350;
   }
   function WeaponStaffJap5()
   {
      this.NAME = "Golden Staff";
      this.dmg = 32;
      this.rnd = 40;
      this.rng = 0;
      this.skill = "Staff";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "DEX";
      this.require_value = 75;
      this.crit = 80;
      this.price = 500;
   }
   function WeaponStaffJap6()
   {
      this.NAME = "Golden Naginata";
      this.dmg = 40;
      this.rnd = 90;
      this.rng = 0;
      this.skill = "Staff";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "DEX";
      this.require_value = 90;
      this.crit = 15;
      this.price = 850;
   }
   function WeaponNinjaToRog1()
   {
      this.NAME = "Rusty Ninja-To";
      this.dmg = 3;
      this.rnd = 2;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 5;
      this.t_aft = 50;
      this.require_param = "DEX";
      this.require_value = 10;
      this.crit = 5;
      this.price = 15;
   }
   function WeaponNinjaToRog2()
   {
      this.NAME = "Cheap Ninja-To";
      this.dmg = 1;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 5;
      this.t_aft = 45;
      this.require_param = "DEX";
      this.require_value = 15;
      this.crit = 5;
      this.price = 15;
   }
   function WeaponNinjaToJap1()
   {
      this.NAME = "Short Ninja-To";
      this.dmg = 2;
      this.rnd = 7;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "DEX";
      this.require_value = 25;
      this.crit = 10;
      this.price = 25;
   }
   function WeaponNinjaToJap2()
   {
      this.NAME = "Apprentiece Ninja-To";
      this.dmg = 6;
      this.rnd = 16;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 40;
      this.crit = 10;
      this.price = 110;
   }
   function WeaponNinjaToJap3()
   {
      this.NAME = "Soldier Ninja-To";
      this.dmg = 12;
      this.rnd = 28;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "DEX";
      this.require_value = 55;
      this.crit = 10;
      this.price = 380;
   }
   function WeaponNinjaToJap4()
   {
      this.NAME = "Rhonin Ninja-To";
      this.dmg = 15;
      this.rnd = 42;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 75;
      this.crit = 10;
      this.price = 600;
   }
   function WeaponNinjaToJap5()
   {
      this.NAME = "Holy Ninja-To";
      this.dmg = 20;
      this.rnd = 50;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 25;
      this.require_param = "DEX";
      this.require_value = 95;
      this.crit = 15;
      this.price = 900;
   }
   function WeaponNinjaToJap6()
   {
      this.NAME = "Black Hero";
      this.dmg = 25;
      this.rnd = 75;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 25;
      this.require_param = "DEX";
      this.require_value = 110;
      this.crit = 20;
      this.price = 1400;
   }
   function WeaponKatanaRog1()
   {
      this.NAME = "Rusty Katana";
      this.dmg = 3;
      this.rnd = 4;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 5;
      this.t_aft = 50;
      this.require_param = "DEX";
      this.require_value = 12;
      this.crit = 7;
      this.price = 17;
   }
   function WeaponKatanaRog2()
   {
      this.NAME = "Cheap Katana";
      this.dmg = 1;
      this.rnd = 6;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 5;
      this.t_aft = 45;
      this.require_param = "DEX";
      this.require_value = 18;
      this.crit = 7;
      this.price = 20;
   }
   function WeaponKatanaJap1()
   {
      this.NAME = "Short Katana";
      this.dmg = 2;
      this.rnd = 14;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "DEX";
      this.require_value = 30;
      this.crit = 15;
      this.price = 50;
   }
   function WeaponKatanaJap2()
   {
      this.NAME = "Apprentiece Katana";
      this.dmg = 6;
      this.rnd = 32;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 50;
      this.crit = 15;
      this.price = 170;
   }
   function WeaponKatanaJap3()
   {
      this.NAME = "Soldier Katana";
      this.dmg = 12;
      this.rnd = 60;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "DEX";
      this.require_value = 70;
      this.crit = 15;
      this.price = 430;
   }
   function WeaponKatanaJap4()
   {
      this.NAME = "Rhonin Katana";
      this.dmg = 15;
      this.rnd = 85;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 85;
      this.crit = 15;
      this.price = 900;
   }
   function WeaponKatanaJap5()
   {
      this.NAME = "Holy Katana";
      this.dmg = 20;
      this.rnd = 110;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 25;
      this.require_param = "DEX";
      this.require_value = 100;
      this.crit = 20;
      this.price = 1300;
   }
   function WeaponKatanaJap6()
   {
      this.NAME = "Darkness";
      this.dmg = 20;
      this.rnd = 180;
      this.rng = 0;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 25;
      this.require_param = "DEX";
      this.require_value = 120;
      this.crit = 25;
      this.price = 2000;
   }
   function WeaponSpearViz1()
   {
      this.NAME = "Infantry Spear";
      this.dmg = 15;
      this.rnd = 5;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 15;
      this.crit = 80;
      this.price = 10;
   }
   function WeaponSpearViz2()
   {
      this.NAME = "Improved Spear";
      this.dmg = 45;
      this.rnd = 15;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 35;
      this.crit = 85;
      this.price = 100;
   }
   function WeaponSpearViz3()
   {
      this.NAME = "Chivalery Spear";
      this.dmg = 75;
      this.rnd = 25;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 45;
      this.require_param = "STR";
      this.require_value = 65;
      this.crit = 90;
      this.price = 500;
   }
   function WeaponSpearGer1()
   {
      this.NAME = "Militia Spear";
      this.dmg = 20;
      this.rnd = 5;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 75;
      this.require_param = "STR";
      this.require_value = 20;
      this.crit = 85;
      this.price = 10;
   }
   function WeaponSpearGer2()
   {
      this.NAME = "Footman Spear";
      this.dmg = 60;
      this.rnd = 15;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 40;
      this.crit = 90;
      this.price = 100;
   }
   function WeaponSpearGer3()
   {
      this.NAME = "Knight Spear";
      this.dmg = 95;
      this.rnd = 25;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 70;
      this.crit = 95;
      this.price = 500;
   }
   function WeaponSpearRus1()
   {
      this.NAME = "Bronze Spear";
      this.dmg = 5;
      this.rnd = 15;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 10;
      this.crit = 85;
      this.price = 50;
   }
   function WeaponSpearRus2()
   {
      this.NAME = "Siege Spear";
      this.dmg = 15;
      this.rnd = 45;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 30;
      this.crit = 90;
      this.price = 450;
   }
   function WeaponSpearRus3()
   {
      this.NAME = "Holy Spear";
      this.dmg = 25;
      this.rnd = 75;
      this.rng = 0;
      this.skill = "Spear";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "STR";
      this.require_value = 60;
      this.crit = 95;
      this.price = 1200;
   }
   function WeaponDaggerViz1()
   {
      this.NAME = "Knife";
      this.dmg = 1;
      this.rnd = 3;
      this.rng = 0;
      this.skill = "Dagger";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 15;
      this.crit = 60;
      this.price = 6;
   }
   function WeaponDaggerViz2()
   {
      this.NAME = "Dagger";
      this.dmg = 4;
      this.rnd = 12;
      this.rng = 0;
      this.skill = "Dagger";
      this.t_bef = 1;
      this.t_aft = 25;
      this.require_param = "DEX";
      this.require_value = 35;
      this.crit = 75;
      this.price = 120;
   }
   function WeaponDaggerViz3()
   {
      this.NAME = "Stiletto";
      this.dmg = 6;
      this.rnd = 34;
      this.rng = 0;
      this.skill = "Dagger";
      this.t_bef = 1;
      this.t_aft = 20;
      this.require_param = "DEX";
      this.require_value = 60;
      this.crit = 95;
      this.price = 360;
   }
   function WeaponDaggerViz4()
   {
      this.NAME = "Damascus";
      this.dmg = 15;
      this.rnd = 40;
      this.rng = 0;
      this.skill = "Dagger";
      this.t_bef = 1;
      this.t_aft = 20;
      this.require_param = "DEX";
      this.require_value = 85;
      this.crit = 85;
      this.price = 700;
   }
   function WeaponThrowingViz1()
   {
      this.NAME = "Oil";
      this.dmg = 30;
      this.rnd = 80;
      this.rng = 12;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 80;
      this.require_param = "STR";
      this.require_value = 50;
      this.crit = 100;
      this.price = 700;
   }
   function WeaponThrowingViz2()
   {
      this.NAME = "Greek Fire";
      this.dmg = 50;
      this.rnd = 150;
      this.rng = 10;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 50;
      this.require_param = "STR";
      this.require_value = 70;
      this.crit = 100;
      this.price = 1600;
   }
   function WeaponThrowingGer1()
   {
      this.NAME = "Steel Throwing Knife";
      this.dmg = 10;
      this.rnd = 30;
      this.rng = 8;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 20;
      this.crit = 20;
      this.price = 20;
   }
   function WeaponThrowingGer2()
   {
      this.NAME = "Silver Throwing Knife";
      this.dmg = 20;
      this.rnd = 45;
      this.rng = 8;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "DEX";
      this.require_value = 30;
      this.crit = 25;
      this.price = 200;
   }
   function WeaponThrowingGer3()
   {
      this.NAME = "Sinners";
      this.dmg = 30;
      this.rnd = 70;
      this.rng = 10;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 40;
      this.crit = 30;
      this.price = 500;
   }
   function WeaponThrowingGer4()
   {
      this.NAME = "Holy Touches";
      this.dmg = 40;
      this.rnd = 100;
      this.rng = 10;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 50;
      this.crit = 33;
      this.price = 1500;
   }
   function WeaponThrowingRus1()
   {
      this.NAME = "Small Throwing Axe";
      this.dmg = 45;
      this.rnd = 15;
      this.rng = 6;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 65;
      this.require_param = "STR";
      this.require_value = 20;
      this.crit = 5;
      this.price = 8;
   }
   function WeaponThrowingRus2()
   {
      this.NAME = "Rounded Throwing Axe";
      this.dmg = 55;
      this.rnd = 30;
      this.rng = 6;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 60;
      this.require_param = "STR";
      this.require_value = 35;
      this.crit = 5;
      this.price = 80;
   }
   function WeaponThrowingRus3()
   {
      this.NAME = "Tomahawks";
      this.dmg = 70;
      this.rnd = 35;
      this.rng = 6;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 55;
      this.crit = 5;
      this.price = 450;
   }
   function WeaponThrowingRus4()
   {
      this.NAME = "Golden Punches";
      this.dmg = 80;
      this.rnd = 60;
      this.rng = 5;
      this.skill = "Throwing";
      this.t_bef = 1;
      this.t_aft = 55;
      this.require_param = "STR";
      this.require_value = 75;
      this.crit = 5;
      this.price = 950;
   }
   function WeaponThrowingJap1()
   {
      this.NAME = "Shuriken";
      this.dmg = 10;
      this.rnd = 20;
      this.rng = 7;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 20;
      this.crit = 15;
      this.price = 10;
   }
   function WeaponThrowingJap2()
   {
      this.NAME = "Silver Shuriken";
      this.dmg = 10;
      this.rnd = 40;
      this.rng = 8;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = "DEX";
      this.require_value = 30;
      this.crit = 15;
      this.price = 90;
   }
   function WeaponThrowingJap3()
   {
      this.NAME = "Rhonin Shuriken";
      this.dmg = 25;
      this.rnd = 60;
      this.rng = 9;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 45;
      this.crit = 15;
      this.price = 200;
   }
   function WeaponThrowingJap4()
   {
      this.NAME = "Shining Shuriken";
      this.dmg = 40;
      this.rnd = 110;
      this.rng = 10;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 60;
      this.crit = 17;
      this.price = 500;
   }
   function WeaponThrowingJap5()
   {
      this.NAME = "Black Spirits";
      this.dmg = 70;
      this.rnd = 160;
      this.rng = 11;
      this.skill = "FarEast";
      this.t_bef = 1;
      this.t_aft = 30;
      this.require_param = "DEX";
      this.require_value = 80;
      this.crit = 20;
      this.price = 900;
   }
   function WeaponBowViz1()
   {
      this.NAME = "Long Bow";
      this.dmg = 12;
      this.rnd = 20;
      this.rng = 12;
      this.skill = "Bow";
      this.t_bef = 10;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 20;
      this.crit = 5;
      this.price = 40;
   }
   function WeaponBowViz2()
   {
      this.NAME = "Fine Bow";
      this.dmg = 30;
      this.rnd = 50;
      this.rng = 14;
      this.skill = "Bow";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 70;
      this.crit = 5;
      this.price = 1010;
   }
   function WeaponBowGer1()
   {
      this.NAME = "Infantry Bow";
      this.dmg = 10;
      this.rnd = 18;
      this.rng = 12;
      this.skill = "Bow";
      this.t_bef = 10;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 15;
      this.crit = 5;
      this.price = 30;
   }
   function WeaponBowGer2()
   {
      this.NAME = "Forged Bow";
      this.dmg = 25;
      this.rnd = 45;
      this.rng = 14;
      this.skill = "Bow";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 50;
      this.crit = 5;
      this.price = 850;
   }
   function WeaponBowRus1()
   {
      this.NAME = "Guard Bow";
      this.dmg = 15;
      this.rnd = 25;
      this.rng = 13;
      this.skill = "Bow";
      this.t_bef = 10;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 30;
      this.crit = 5;
      this.price = 50;
   }
   function WeaponBowRus2()
   {
      this.NAME = "Holy Bow";
      this.dmg = 35;
      this.rnd = 55;
      this.rng = 15;
      this.skill = "Bow";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 95;
      this.crit = 5;
      this.price = 1150;
   }
   function WeaponBowJap1()
   {
      this.NAME = "Hunter Bow";
      this.dmg = 5;
      this.rnd = 10;
      this.rng = 12;
      this.skill = "Bow";
      this.t_bef = 20;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 10;
      this.crit = 5;
      this.price = 5;
   }
   function WeaponBowJap2()
   {
      this.NAME = "Soldier Bow";
      this.dmg = 15;
      this.rnd = 20;
      this.rng = 13;
      this.skill = "Bow";
      this.t_bef = 10;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 25;
      this.crit = 5;
      this.price = 50;
   }
   function WeaponBowJap3()
   {
      this.NAME = "Ninja Bow";
      this.dmg = 20;
      this.rnd = 40;
      this.rng = 14;
      this.skill = "Bow";
      this.t_bef = 5;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 45;
      this.crit = 10;
      this.price = 450;
   }
   function WeaponBowJap4()
   {
      this.NAME = "Samurai Bow";
      this.dmg = 30;
      this.rnd = 50;
      this.rng = 15;
      this.skill = "Bow";
      this.t_bef = 1;
      this.t_aft = 40;
      this.require_param = "DEX";
      this.require_value = 85;
      this.crit = 10;
      this.price = 1100;
   }
   function WeaponCrossbowViz1()
   {
      this.NAME = "Light Crossbow";
      this.dmg = 30;
      this.rnd = 40;
      this.rng = 18;
      this.skill = "Crossbow";
      this.t_bef = 15;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 30;
      this.crit = 50;
      this.price = 80;
   }
   function WeaponCrossbowViz2()
   {
      this.NAME = "Medium Crossbow";
      this.dmg = 40;
      this.rnd = 60;
      this.rng = 18;
      this.skill = "Crossbow";
      this.t_bef = 10;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 60;
      this.crit = 55;
      this.price = 650;
   }
   function WeaponCrossbowViz3()
   {
      this.NAME = "Elite Crossbow";
      this.dmg = 60;
      this.rnd = 100;
      this.rng = 19;
      this.skill = "Crossbow";
      this.t_bef = 5;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 90;
      this.crit = 60;
      this.price = 1300;
   }
   function WeaponCrossbowGer1()
   {
      this.NAME = "Long Crossbow";
      this.dmg = 24;
      this.rnd = 30;
      this.rng = 17;
      this.skill = "Crossbow";
      this.t_bef = 15;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 25;
      this.crit = 45;
      this.price = 60;
   }
   function WeaponCrossbowGer2()
   {
      this.NAME = "Steel Crossbow";
      this.dmg = 35;
      this.rnd = 55;
      this.rng = 17;
      this.skill = "Crossbow";
      this.t_bef = 10;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 50;
      this.crit = 50;
      this.price = 520;
   }
   function WeaponCrossbowGer3()
   {
      this.NAME = "Forged Crossbow";
      this.dmg = 50;
      this.rnd = 90;
      this.rng = 18;
      this.skill = "Crossbow";
      this.t_bef = 5;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 75;
      this.crit = 55;
      this.price = 1200;
   }
   function WeaponCrossbowRus1()
   {
      this.NAME = "Hunter Crossbow";
      this.dmg = 20;
      this.rnd = 20;
      this.rng = 17;
      this.skill = "Crossbow";
      this.t_bef = 10;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 20;
      this.crit = 25;
      this.price = 40;
   }
   function WeaponCrossbowRus2()
   {
      this.NAME = "Soldier Crossbow";
      this.dmg = 30;
      this.rnd = 45;
      this.rng = 18;
      this.skill = "Crossbow";
      this.t_bef = 5;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 40;
      this.crit = 30;
      this.price = 450;
   }
   function WeaponCrossbowRus3()
   {
      this.NAME = "Guard Crossbow";
      this.dmg = 40;
      this.rnd = 70;
      this.rng = 18;
      this.skill = "Crossbow";
      this.t_bef = 0;
      this.t_aft = 60;
      this.require_param = "DEX";
      this.require_value = 60;
      this.crit = 35;
      this.price = 900;
   }
   function WeaponShieldViz1()
   {
      this.NAME = "Guard";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 15;
      this.crit = 10;
      this.price = 100;
   }
   function WeaponShieldViz2()
   {
      this.NAME = "Infantry Shield";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 35;
      this.crit = 20;
      this.price = 250;
   }
   function WeaponShieldViz3()
   {
      this.NAME = "Chivalery Shield";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 55;
      this.crit = 30;
      this.price = 750;
   }
   function WeaponShieldGer1()
   {
      this.NAME = "Small Buckler";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 25;
      this.crit = 15;
      this.price = 180;
   }
   function WeaponShieldGer2()
   {
      this.NAME = "Footman Shield";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 45;
      this.crit = 25;
      this.price = 360;
   }
   function WeaponShieldGer3()
   {
      this.NAME = "Knight Shield";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 85;
      this.crit = 35;
      this.price = 1200;
   }
   function WeaponShieldRus1()
   {
      this.NAME = "Wooden Buckler";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 10;
      this.crit = 7;
      this.price = 20;
   }
   function WeaponShieldRus2()
   {
      this.NAME = "Iron Buckler";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 28;
      this.crit = 18;
      this.price = 170;
   }
   function WeaponShieldRus3()
   {
      this.NAME = "Hero Shield";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.t_bef = 1;
      this.t_aft = 0;
      this.require_param = "CON";
      this.require_value = 70;
      this.crit = 33;
      this.price = 1100;
   }
   function WeaponFistsAll0()
   {
      this.NAME = "Unarmed";
      this.dmg = 1;
      this.rnd = 2;
      this.rng = 0;
      this.skill = "Fist";
      this.t_bef = 1;
      this.t_aft = 35;
      this.require_param = null;
      this.require_value = 0;
      this.crit = 0;
      this.FRAME = 169;
      this.price = 0;
   }
}
