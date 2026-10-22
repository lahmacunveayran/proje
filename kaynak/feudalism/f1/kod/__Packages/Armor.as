class Armor extends Item
{
   var FRAME;
   var LEVEL;
   var NAME;
   var NATION;
   var TYPE;
   var getFrame;
   var initEnchant;
   var price;
   var require_param;
   var require_value;
   var value;
   function Armor(tp, nt, lv, ei)
   {
      super();
      this.TYPE = tp;
      this.NATION = nt;
      this.LEVEL = lv;
      this.FRAME = this.getFrame();
      this["Armor" + tp + nt + lv]();
      this.initEnchant(ei);
   }
   function ArmorClothesViz1()
   {
      this.NAME = "Leather Armor";
      this.value = 5;
      this.require_param = "CON";
      this.require_value = 25;
      this.price = 100;
   }
   function ArmorClothesGer1()
   {
      this.NAME = "Tunic";
      this.value = 2;
      this.require_param = "CON";
      this.require_value = 15;
      this.price = 20;
   }
   function ArmorClothesRus1()
   {
      this.NAME = "Dark Leather Armor";
      this.value = 4;
      this.require_param = "STR";
      this.require_value = 25;
      this.price = 50;
   }
   function ArmorClothesJap1()
   {
      this.NAME = "Kimono";
      this.value = 1;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 5;
   }
   function ArmorClothesViz2()
   {
      this.NAME = "Bronze Leather Armor";
      this.value = 9;
      this.require_param = "CON";
      this.require_value = 35;
      this.price = 200;
   }
   function ArmorClothesGer2()
   {
      this.NAME = "Footman Armor";
      this.value = 12;
      this.require_param = "CON";
      this.require_value = 40;
      this.price = 250;
   }
   function ArmorClothesRus2()
   {
      this.NAME = "Hard Leather Armor";
      this.value = 7;
      this.require_param = "STR";
      this.require_value = 35;
      this.price = 150;
   }
   function ArmorClothesJap2()
   {
      this.NAME = "Hard Kimono";
      this.value = 5;
      this.require_param = "DEX";
      this.require_value = 25;
      this.price = 50;
   }
   function ArmorClothesViz3()
   {
      this.NAME = "Phalax Armor";
      this.value = 16;
      this.require_param = "CON";
      this.require_value = 45;
      this.price = 300;
   }
   function ArmorClothesGer3()
   {
      this.NAME = "Long Chainmail";
      this.value = 19;
      this.require_param = "CON";
      this.require_value = 50;
      this.price = 380;
   }
   function ArmorClothesRus3()
   {
      this.NAME = "Short Chainmail";
      this.value = 14;
      this.require_param = "STR";
      this.require_value = 45;
      this.price = 250;
   }
   function ArmorClothesJap3()
   {
      this.NAME = "Ninja Armor";
      this.value = 11;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 200;
   }
   function ArmorClothesViz4()
   {
      this.NAME = "Centurion Armor";
      this.value = 24;
      this.require_param = "CON";
      this.require_value = 60;
      this.price = 450;
   }
   function ArmorClothesGer4()
   {
      this.NAME = "Crusader Chainmail";
      this.value = 29;
      this.require_param = "CON";
      this.require_value = 65;
      this.price = 590;
   }
   function ArmorClothesRus4()
   {
      this.NAME = "Warrior Chainmail";
      this.value = 21;
      this.require_param = "STR";
      this.require_value = 60;
      this.price = 400;
   }
   function ArmorClothesJap4()
   {
      this.NAME = "Gold Ninja Armor";
      this.value = 23;
      this.require_param = "DEX";
      this.require_value = 60;
      this.price = 500;
   }
   function ArmorClothesViz5()
   {
      this.NAME = "Curasis";
      this.value = 35;
      this.require_param = "CON";
      this.require_value = 75;
      this.price = 700;
   }
   function ArmorClothesGer5()
   {
      this.NAME = "Full Plate of Holy Light";
      this.value = 38;
      this.require_param = "CON";
      this.require_value = 80;
      this.price = 900;
   }
   function ArmorClothesRus5()
   {
      this.NAME = "Guardian Full Plate";
      this.value = 32;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 620;
   }
   function ArmorClothesJap5()
   {
      this.NAME = "Gold Samurai Armor";
      this.value = 33;
      this.require_param = "DEX";
      this.require_value = 78;
      this.price = 850;
   }
   function ArmorClothesViz6()
   {
      this.NAME = "Shining Armor";
      this.value = 45;
      this.require_param = "CON";
      this.require_value = 85;
      this.price = 1100;
   }
   function ArmorClothesGer6()
   {
      this.NAME = "Redeemer Full Plate";
      this.value = 55;
      this.require_param = "CON";
      this.require_value = 90;
      this.price = 1500;
   }
   function ArmorClothesRus6()
   {
      this.NAME = "Hero Full Plate";
      this.value = 40;
      this.require_param = "STR";
      this.require_value = 100;
      this.price = 1000;
   }
   function ArmorClothesJap6()
   {
      this.NAME = "Black Samurai Armor";
      this.value = 50;
      this.require_param = "DEX";
      this.require_value = 85;
      this.price = 2500;
   }
   function ArmorHelmetViz1()
   {
      this.NAME = "Light Helmet";
      this.value = 3;
      this.require_param = "CON";
      this.require_value = 32;
      this.price = 70;
   }
   function ArmorHelmetGer1()
   {
      this.NAME = "Footman Helmet";
      this.value = 5;
      this.require_param = "CON";
      this.require_value = 37;
      this.price = 90;
   }
   function ArmorHelmetRus1()
   {
      this.NAME = "Leather Helmet";
      this.value = 2;
      this.require_param = "STR";
      this.require_value = 32;
      this.price = 50;
   }
   function ArmorHelmetJap1()
   {
      this.NAME = "Bandana";
      this.value = 1;
      this.require_param = "DEX";
      this.require_value = 22;
      this.price = 4;
   }
   function ArmorHelmetViz2()
   {
      this.NAME = "Chivalery Helmet";
      this.value = 8;
      this.require_param = "CON";
      this.require_value = 50;
      this.price = 250;
   }
   function ArmorHelmetGer2()
   {
      this.NAME = "Knight Helmet";
      this.value = 10;
      this.require_param = "CON";
      this.require_value = 55;
      this.price = 320;
   }
   function ArmorHelmetRus2()
   {
      this.NAME = "Guardian Helmet";
      this.value = 7;
      this.require_param = "STR";
      this.require_value = 50;
      this.price = 210;
   }
   function ArmorHelmetJap2()
   {
      this.NAME = "Hood";
      this.value = 4;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 40;
   }
   function ArmorHelmetViz3()
   {
      this.NAME = "Leader Helmet";
      this.value = 14;
      this.require_param = "CON";
      this.require_value = 75;
      this.price = 600;
   }
   function ArmorHelmetGer3()
   {
      this.NAME = "Crusader Helmet";
      this.value = 17;
      this.require_param = "CON";
      this.require_value = 80;
      this.price = 900;
   }
   function ArmorHelmetRus3()
   {
      this.NAME = "Hero Helmet";
      this.value = 12;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 500;
   }
   function ArmorHelmetJap3()
   {
      this.NAME = "Samurai Mask";
      this.value = 15;
      this.require_param = "DEX";
      this.require_value = 75;
      this.price = 1800;
   }
}
