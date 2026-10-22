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
      this.NAME = "Deri Zırh";
      this.value = 5;
      this.require_param = "CON";
      this.require_value = 25;
      this.price = 100;
   }
   function ArmorClothesGer1()
   {
      this.NAME = "Tunik";
      this.value = 2;
      this.require_param = "CON";
      this.require_value = 15;
      this.price = 20;
   }
   function ArmorClothesRus1()
   {
      this.NAME = "Koyu Deri Zırh";
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
      this.NAME = "Bronz Deri Zırh";
      this.value = 9;
      this.require_param = "CON";
      this.require_value = 35;
      this.price = 200;
   }
   function ArmorClothesGer2()
   {
      this.NAME = "Yaya Zırhı";
      this.value = 12;
      this.require_param = "CON";
      this.require_value = 40;
      this.price = 250;
   }
   function ArmorClothesRus2()
   {
      this.NAME = "Sert Deri Zırh";
      this.value = 7;
      this.require_param = "STR";
      this.require_value = 35;
      this.price = 150;
   }
   function ArmorClothesJap2()
   {
      this.NAME = "Sert Kimono";
      this.value = 5;
      this.require_param = "DEX";
      this.require_value = 25;
      this.price = 50;
   }
   function ArmorClothesViz3()
   {
      this.NAME = "Falanks Zırhı";
      this.value = 16;
      this.require_param = "CON";
      this.require_value = 45;
      this.price = 300;
   }
   function ArmorClothesGer3()
   {
      this.NAME = "Uzun Zincir Zırh";
      this.value = 19;
      this.require_param = "CON";
      this.require_value = 50;
      this.price = 380;
   }
   function ArmorClothesRus3()
   {
      this.NAME = "Kısa Zincir Zırh";
      this.value = 14;
      this.require_param = "STR";
      this.require_value = 45;
      this.price = 250;
   }
   function ArmorClothesJap3()
   {
      this.NAME = "Ninja Zırhı";
      this.value = 11;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 200;
   }
   function ArmorClothesViz4()
   {
      this.NAME = "Yüzbaşı Zırhı";
      this.value = 24;
      this.require_param = "CON";
      this.require_value = 60;
      this.price = 450;
   }
   function ArmorClothesGer4()
   {
      this.NAME = "Haçlı Zincir Zırhı";
      this.value = 29;
      this.require_param = "CON";
      this.require_value = 65;
      this.price = 590;
   }
   function ArmorClothesRus4()
   {
      this.NAME = "Savaşçı Zincir Zırhı";
      this.value = 21;
      this.require_param = "STR";
      this.require_value = 60;
      this.price = 400;
   }
   function ArmorClothesJap4()
   {
      this.NAME = "Altın Ninja Zırhı";
      this.value = 23;
      this.require_param = "DEX";
      this.require_value = 60;
      this.price = 500;
   }
   function ArmorClothesViz5()
   {
      this.NAME = "Göğüslük";
      this.value = 35;
      this.require_param = "CON";
      this.require_value = 75;
      this.price = 700;
   }
   function ArmorClothesGer5()
   {
      this.NAME = "Kutsal Işık Zırhı";
      this.value = 38;
      this.require_param = "CON";
      this.require_value = 80;
      this.price = 900;
   }
   function ArmorClothesRus5()
   {
      this.NAME = "Koruyucu Plaka Zırhı";
      this.value = 32;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 620;
   }
   function ArmorClothesJap5()
   {
      this.NAME = "Altın Samuray Zırhı";
      this.value = 33;
      this.require_param = "DEX";
      this.require_value = 78;
      this.price = 850;
   }
   function ArmorClothesViz6()
   {
      this.NAME = "Parlak Zırh";
      this.value = 45;
      this.require_param = "CON";
      this.require_value = 85;
      this.price = 1100;
   }
   function ArmorClothesGer6()
   {
      this.NAME = "Kurtarıcı Plaka Zırhı";
      this.value = 55;
      this.require_param = "CON";
      this.require_value = 90;
      this.price = 1500;
   }
   function ArmorClothesRus6()
   {
      this.NAME = "Kahraman Plaka Zırhı";
      this.value = 40;
      this.require_param = "STR";
      this.require_value = 100;
      this.price = 1000;
   }
   function ArmorClothesJap6()
   {
      this.NAME = "Kara Samuray Zırhı";
      this.value = 50;
      this.require_param = "DEX";
      this.require_value = 85;
      this.price = 2500;
   }
   function ArmorHelmetViz1()
   {
      this.NAME = "Hafif Miğfer";
      this.value = 3;
      this.require_param = "CON";
      this.require_value = 32;
      this.price = 70;
   }
   function ArmorHelmetGer1()
   {
      this.NAME = "Yaya Miğferi";
      this.value = 5;
      this.require_param = "CON";
      this.require_value = 37;
      this.price = 90;
   }
   function ArmorHelmetRus1()
   {
      this.NAME = "Deri Miğfer";
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
      this.NAME = "Süvari Miğferi";
      this.value = 8;
      this.require_param = "CON";
      this.require_value = 50;
      this.price = 250;
   }
   function ArmorHelmetGer2()
   {
      this.NAME = "Şövalye Miğferi";
      this.value = 10;
      this.require_param = "CON";
      this.require_value = 55;
      this.price = 320;
   }
   function ArmorHelmetRus2()
   {
      this.NAME = "Koruyucu Miğferi";
      this.value = 7;
      this.require_param = "STR";
      this.require_value = 50;
      this.price = 210;
   }
   function ArmorHelmetJap2()
   {
      this.NAME = "Kukuleta";
      this.value = 4;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 40;
   }
   function ArmorHelmetViz3()
   {
      this.NAME = "Önder Miğferi";
      this.value = 14;
      this.require_param = "CON";
      this.require_value = 75;
      this.price = 600;
   }
   function ArmorHelmetGer3()
   {
      this.NAME = "Haçlı Miğferi";
      this.value = 17;
      this.require_param = "CON";
      this.require_value = 80;
      this.price = 900;
   }
   function ArmorHelmetRus3()
   {
      this.NAME = "Kahraman Miğferi";
      this.value = 12;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 500;
   }
   function ArmorHelmetJap3()
   {
      this.NAME = "Samuray Maskesi";
      this.value = 15;
      this.require_param = "DEX";
      this.require_value = 75;
      this.price = 1800;
   }
}
