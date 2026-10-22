class Armor extends Item
{
   var FRAME;
   var HP_mod;
   var LEVEL;
   var NAME;
   var NATION;
   var SP_mod;
   var TYPE;
   var getFrame;
   var initEnchant;
   var price;
   var require_param;
   var require_value;
   var setRefine;
   var value;
   function Armor(tp, nt, lv, ei, rf)
   {
      super();
      this.TYPE = tp;
      this.NATION = nt;
      this.LEVEL = lv;
      this.FRAME = this.getFrame();
      this["Armor" + tp + nt + lv]();
      this.initEnchant(ei);
      this.setRefine(rf);
   }
   function ArmorClothesViz1()
   {
      this.NAME = "Deri Zırh";
      this.value = 8;
      this.require_param = "CON";
      this.require_value = 18;
      this.HP_mod = 8;
      this.SP_mod = -2;
      this.price = 288;
   }
   function ArmorHelmetViz1()
   {
      this.NAME = "Hafif Miğfer";
      this.value = 3;
      this.require_param = "CON";
      this.require_value = 18;
      this.HP_mod = 4;
      this.SP_mod = -1;
      this.price = 216;
   }
   function ArmorClothesViz2()
   {
      this.NAME = "Bronz-Deri Zırh";
      this.value = 10;
      this.require_param = "CON";
      this.require_value = 23;
      this.HP_mod = 16;
      this.SP_mod = -4;
      this.price = 460;
   }
   function ArmorHelmetViz2()
   {
      this.NAME = "Sert Miğfer";
      this.value = 3;
      this.require_param = "CON";
      this.require_value = 23;
      this.HP_mod = 8;
      this.SP_mod = -2;
      this.price = 276;
   }
   function ArmorClothesViz3()
   {
      this.NAME = "Falanks Zırhı";
      this.value = 14;
      this.require_param = "CON";
      this.require_value = 29;
      this.HP_mod = 24;
      this.SP_mod = -6;
      this.price = 812;
   }
   function ArmorHelmetViz3()
   {
      this.NAME = "Falanks Miğferi";
      this.value = 5;
      this.require_param = "CON";
      this.require_value = 29;
      this.HP_mod = 12;
      this.SP_mod = -3;
      this.price = 580;
   }
   function ArmorClothesViz4()
   {
      this.NAME = "Yüzbaşı Zincir Zırhı";
      this.value = 19;
      this.require_param = "CON";
      this.require_value = 36;
      this.HP_mod = 32;
      this.SP_mod = -8;
      this.price = 1368;
   }
   function ArmorHelmetViz4()
   {
      this.NAME = "Yüzbaşı Miğferi";
      this.value = 6;
      this.require_param = "CON";
      this.require_value = 36;
      this.HP_mod = 16;
      this.SP_mod = -4;
      this.price = 864;
   }
   function ArmorClothesViz5()
   {
      this.NAME = "Göğüslük";
      this.value = 26;
      this.require_param = "CON";
      this.require_value = 45;
      this.HP_mod = 40;
      this.SP_mod = -10;
      this.price = 2340;
   }
   function ArmorHelmetViz5()
   {
      this.NAME = "Süvari Miğferi";
      this.value = 9;
      this.require_param = "CON";
      this.require_value = 45;
      this.HP_mod = 20;
      this.SP_mod = -5;
      this.price = 1620;
   }
   function ArmorClothesViz6()
   {
      this.NAME = "Parlak Plaka Zırh";
      this.value = 36;
      this.require_param = "CON";
      this.require_value = 57;
      this.HP_mod = 48;
      this.SP_mod = -12;
      this.price = 4104;
   }
   function ArmorHelmetViz6()
   {
      this.NAME = "Önder Miğferi";
      this.value = 12;
      this.require_param = "CON";
      this.require_value = 57;
      this.HP_mod = 24;
      this.SP_mod = -6;
      this.price = 2736;
   }
   function ArmorClothesViz7()
   {
      this.NAME = "Komutanın Plaka Zırhı";
      this.value = 49;
      this.require_param = "CON";
      this.require_value = 72;
      this.HP_mod = 56;
      this.SP_mod = -14;
      this.price = 7056;
   }
   function ArmorHelmetViz7()
   {
      this.NAME = "Kanatlı Miğfer";
      this.value = 16;
      this.require_param = "CON";
      this.require_value = 72;
      this.HP_mod = 28;
      this.SP_mod = -7;
      this.price = 4608;
   }
   function ArmorClothesViz8()
   {
      this.NAME = "İmparatorun Plaka Zırhı";
      this.value = 66;
      this.require_param = "CON";
      this.require_value = 90;
      this.HP_mod = 64;
      this.SP_mod = -16;
      this.price = 11880;
   }
   function ArmorHelmetViz8()
   {
      this.NAME = "Altın Taç";
      this.value = 22;
      this.require_param = "CON";
      this.require_value = 90;
      this.HP_mod = 32;
      this.SP_mod = -8;
      this.price = 7920;
   }
   function ArmorClothesGer1()
   {
      this.NAME = "Tunik";
      this.value = 4;
      this.require_param = "CON";
      this.require_value = 20;
      this.HP_mod = 12;
      this.SP_mod = -4;
      this.price = 160;
   }
   function ArmorHelmetGer1()
   {
      this.NAME = "Piyade Miğferi";
      this.value = 1;
      this.require_param = "CON";
      this.require_value = 20;
      this.HP_mod = 6;
      this.SP_mod = -2;
      this.price = 80;
   }
   function ArmorClothesGer2()
   {
      this.NAME = "Yaya Zırhı";
      this.value = 11;
      this.require_param = "CON";
      this.require_value = 25;
      this.HP_mod = 24;
      this.SP_mod = -8;
      this.price = 550;
   }
   function ArmorHelmetGer2()
   {
      this.NAME = "Yaya Miğferi";
      this.value = 4;
      this.require_param = "CON";
      this.require_value = 25;
      this.HP_mod = 12;
      this.SP_mod = -4;
      this.price = 400;
   }
   function ArmorClothesGer3()
   {
      this.NAME = "Uzun Zincir Zırh";
      this.value = 16;
      this.require_param = "CON";
      this.require_value = 32;
      this.HP_mod = 36;
      this.SP_mod = -12;
      this.price = 1024;
   }
   function ArmorHelmetGer3()
   {
      this.NAME = "Şövalye Miğferi";
      this.value = 5;
      this.require_param = "CON";
      this.require_value = 32;
      this.HP_mod = 18;
      this.SP_mod = -6;
      this.price = 640;
   }
   function ArmorClothesGer4()
   {
      this.NAME = "Haçlı Zincir Zırhı";
      this.value = 21;
      this.require_param = "CON";
      this.require_value = 40;
      this.HP_mod = 48;
      this.SP_mod = -16;
      this.price = 1680;
   }
   function ArmorHelmetGer4()
   {
      this.NAME = "Çelik Miğfer";
      this.value = 7;
      this.require_param = "CON";
      this.require_value = 40;
      this.HP_mod = 24;
      this.SP_mod = -8;
      this.price = 1120;
   }
   function ArmorClothesGer5()
   {
      this.NAME = "Gümüş Plaka Zırh";
      this.value = 29;
      this.require_param = "CON";
      this.require_value = 50;
      this.HP_mod = 60;
      this.SP_mod = -20;
      this.price = 2900;
   }
   function ArmorHelmetGer5()
   {
      this.NAME = "Gümüş Miğfer";
      this.value = 10;
      this.require_param = "CON";
      this.require_value = 50;
      this.HP_mod = 30;
      this.SP_mod = -10;
      this.price = 2000;
   }
   function ArmorClothesGer6()
   {
      this.NAME = "Kurtarıcı Plaka Zırhı";
      this.value = 39;
      this.require_param = "CON";
      this.require_value = 63;
      this.HP_mod = 72;
      this.SP_mod = -24;
      this.price = 4914;
   }
   function ArmorHelmetGer6()
   {
      this.NAME = "Haçlı Miğferi";
      this.value = 13;
      this.require_param = "CON";
      this.require_value = 63;
      this.HP_mod = 36;
      this.SP_mod = -12;
      this.price = 3276;
   }
   function ArmorClothesGer7()
   {
      this.NAME = "Serafim Plaka Zırhı";
      this.value = 53;
      this.require_param = "CON";
      this.require_value = 79;
      this.HP_mod = 84;
      this.SP_mod = -28;
      this.price = 8374;
   }
   function ArmorHelmetGer7()
   {
      this.NAME = "Serafim Miğferi";
      this.value = 18;
      this.require_param = "CON";
      this.require_value = 79;
      this.HP_mod = 42;
      this.SP_mod = -14;
      this.price = 5688;
   }
   function ArmorClothesGer8()
   {
      this.NAME = "Cehennem Zırhı";
      this.value = 72;
      this.require_param = "CON";
      this.require_value = 100;
      this.HP_mod = 96;
      this.SP_mod = -32;
      this.price = 14400;
   }
   function ArmorHelmetGer8()
   {
      this.NAME = "Cehennem Miğferi";
      this.value = 24;
      this.require_param = "CON";
      this.require_value = 100;
      this.HP_mod = 48;
      this.SP_mod = -16;
      this.price = 9600;
   }
   function ArmorClothesRus1()
   {
      this.NAME = "Koyu Deri Zırh";
      this.value = 6;
      this.require_param = "STR";
      this.require_value = 20;
      this.HP_mod = 8;
      this.SP_mod = 6;
      this.price = 240;
   }
   function ArmorHelmetRus1()
   {
      this.NAME = "Deri Miğfer";
      this.value = 2;
      this.require_param = "STR";
      this.require_value = 20;
      this.HP_mod = 4;
      this.SP_mod = 3;
      this.price = 160;
   }
   function ArmorClothesRus2()
   {
      this.NAME = "Sert Deri Zırh";
      this.value = 9;
      this.require_param = "STR";
      this.require_value = 25;
      this.HP_mod = 16;
      this.SP_mod = 12;
      this.price = 450;
   }
   function ArmorHelmetRus2()
   {
      this.NAME = "Demir-Deri Miğfer";
      this.value = 3;
      this.require_param = "STR";
      this.require_value = 25;
      this.HP_mod = 8;
      this.SP_mod = 6;
      this.price = 300;
   }
   function ArmorClothesRus3()
   {
      this.NAME = "Kısa Zincir Zırh";
      this.value = 12;
      this.require_param = "STR";
      this.require_value = 32;
      this.HP_mod = 24;
      this.SP_mod = 18;
      this.price = 768;
   }
   function ArmorHelmetRus3()
   {
      this.NAME = "Koruyucu Miğferi";
      this.value = 4;
      this.require_param = "STR";
      this.require_value = 32;
      this.HP_mod = 12;
      this.SP_mod = 9;
      this.price = 512;
   }
   function ArmorClothesRus4()
   {
      this.NAME = "Savaşçı Zincir Zırhı";
      this.value = 16;
      this.require_param = "STR";
      this.require_value = 40;
      this.HP_mod = 32;
      this.SP_mod = 24;
      this.price = 1280;
   }
   function ArmorHelmetRus4()
   {
      this.NAME = "Savaşçı Miğferi";
      this.value = 5;
      this.require_param = "STR";
      this.require_value = 40;
      this.HP_mod = 16;
      this.SP_mod = 12;
      this.price = 800;
   }
   function ArmorClothesRus5()
   {
      this.NAME = "Koruyucu Plaka Zırhı";
      this.value = 22;
      this.require_param = "STR";
      this.require_value = 50;
      this.HP_mod = 40;
      this.SP_mod = 30;
      this.price = 2200;
   }
   function ArmorHelmetRus5()
   {
      this.NAME = "Gazi Miğferi";
      this.value = 7;
      this.require_param = "STR";
      this.require_value = 50;
      this.HP_mod = 20;
      this.SP_mod = 15;
      this.price = 1400;
   }
   function ArmorClothesRus6()
   {
      this.NAME = "Kahraman Plaka Zırhı";
      this.value = 29;
      this.require_param = "STR";
      this.require_value = 63;
      this.HP_mod = 48;
      this.SP_mod = 36;
      this.price = 3654;
   }
   function ArmorHelmetRus6()
   {
      this.NAME = "Kahraman Miğferi";
      this.value = 10;
      this.require_param = "STR";
      this.require_value = 63;
      this.HP_mod = 24;
      this.SP_mod = 18;
      this.price = 2520;
   }
   function ArmorClothesRus7()
   {
      this.NAME = "Orman Bekçisi Zırhı";
      this.value = 40;
      this.require_param = "STR";
      this.require_value = 79;
      this.HP_mod = 56;
      this.SP_mod = 42;
      this.price = 6320;
   }
   function ArmorHelmetRus7()
   {
      this.NAME = "Çılgın Savaşçı Miğferi";
      this.value = 13;
      this.require_param = "STR";
      this.require_value = 79;
      this.HP_mod = 28;
      this.SP_mod = 21;
      this.price = 4108;
   }
   function ArmorClothesRus8()
   {
      this.NAME = "Kutsal Plaka Zırh";
      this.value = 54;
      this.require_param = "STR";
      this.require_value = 100;
      this.HP_mod = 64;
      this.SP_mod = 48;
      this.price = 10800;
   }
   function ArmorHelmetRus8()
   {
      this.NAME = "Çar'ın Miğferi";
      this.value = 18;
      this.require_param = "STR";
      this.require_value = 100;
      this.HP_mod = 32;
      this.SP_mod = 24;
      this.price = 7200;
   }
   function ArmorClothesJap1()
   {
      this.NAME = "Kimono";
      this.value = 2;
      this.require_param = "DEX";
      this.require_value = 20;
      this.HP_mod = 0;
      this.SP_mod = 12;
      this.price = 80;
   }
   function ArmorHelmetJap1()
   {
      this.NAME = "Bandana";
      this.value = 1;
      this.require_param = "DEX";
      this.require_value = 20;
      this.HP_mod = 0;
      this.SP_mod = 6;
      this.price = 80;
   }
   function ArmorClothesJap2()
   {
      this.NAME = "Sert Kimono";
      this.value = 8;
      this.require_param = "DEX";
      this.require_value = 25;
      this.HP_mod = 0;
      this.SP_mod = 24;
      this.price = 400;
   }
   function ArmorHelmetJap2()
   {
      this.NAME = "Kukuleta";
      this.value = 3;
      this.require_param = "DEX";
      this.require_value = 25;
      this.HP_mod = 0;
      this.SP_mod = 12;
      this.price = 300;
   }
   function ArmorClothesJap3()
   {
      this.NAME = "Ninja Zırhı";
      this.value = 10;
      this.require_param = "DEX";
      this.require_value = 32;
      this.HP_mod = 0;
      this.SP_mod = 36;
      this.price = 640;
   }
   function ArmorHelmetJap3()
   {
      this.NAME = "Ninja Miğferi";
      this.value = 3;
      this.require_param = "DEX";
      this.require_value = 32;
      this.HP_mod = 0;
      this.SP_mod = 18;
      this.price = 384;
   }
   function ArmorClothesJap4()
   {
      this.NAME = "Altın Ninja Zırhı";
      this.value = 14;
      this.require_param = "DEX";
      this.require_value = 40;
      this.HP_mod = 0;
      this.SP_mod = 48;
      this.price = 1120;
   }
   function ArmorHelmetJap4()
   {
      this.NAME = "Kara Ninja Miğferi";
      this.value = 5;
      this.require_param = "DEX";
      this.require_value = 40;
      this.HP_mod = 0;
      this.SP_mod = 24;
      this.price = 800;
   }
   function ArmorClothesJap5()
   {
      this.NAME = "Altın Samuray Zırhı";
      this.value = 19;
      this.require_param = "DEX";
      this.require_value = 50;
      this.HP_mod = 0;
      this.SP_mod = 60;
      this.price = 1900;
   }
   function ArmorHelmetJap5()
   {
      this.NAME = "Samuray Maskesi";
      this.value = 6;
      this.require_param = "DEX";
      this.require_value = 50;
      this.HP_mod = 0;
      this.SP_mod = 30;
      this.price = 1200;
   }
   function ArmorClothesJap6()
   {
      this.NAME = "Kara Samuray Zırhı";
      this.value = 26;
      this.require_param = "DEX";
      this.require_value = 63;
      this.HP_mod = 0;
      this.SP_mod = 72;
      this.price = 3276;
   }
   function ArmorHelmetJap6()
   {
      this.NAME = "Kara Samuray Maskesi";
      this.value = 9;
      this.require_param = "DEX";
      this.require_value = 63;
      this.HP_mod = 0;
      this.SP_mod = 36;
      this.price = 2268;
   }
   function ArmorClothesJap7()
   {
      this.NAME = "Şogun Zırhı";
      this.value = 35;
      this.require_param = "DEX";
      this.require_value = 79;
      this.HP_mod = 0;
      this.SP_mod = 84;
      this.price = 5530;
   }
   function ArmorHelmetJap7()
   {
      this.NAME = "Şogun Maskesi";
      this.value = 12;
      this.require_param = "DEX";
      this.require_value = 79;
      this.HP_mod = 0;
      this.SP_mod = 42;
      this.price = 3792;
   }
   function ArmorClothesJap8()
   {
      this.NAME = "Kara Şogun Zırhı";
      this.value = 48;
      this.require_param = "DEX";
      this.require_value = 100;
      this.HP_mod = 0;
      this.SP_mod = 96;
      this.price = 9600;
   }
   function ArmorHelmetJap8()
   {
      this.NAME = "Kara Şogun Maskesi";
      this.value = 16;
      this.require_param = "DEX";
      this.require_value = 100;
      this.HP_mod = 0;
      this.SP_mod = 48;
      this.price = 6400;
   }
   function ArmorClothesMon1()
   {
      this.NAME = "Atlı Kaftanı";
      this.value = 5;
      this.require_param = "DEX";
      this.require_value = 17;
      this.HP_mod = 2;
      this.SP_mod = 8;
      this.price = 170;
   }
   function ArmorHelmetMon1()
   {
      this.NAME = "Atlı Şapkası";
      this.value = 2;
      this.require_param = "DEX";
      this.require_value = 17;
      this.HP_mod = 1;
      this.SP_mod = 4;
      this.price = 136;
   }
   function ArmorClothesMon2()
   {
      this.NAME = "Deri Ceket";
      this.value = 8;
      this.require_param = "DEX";
      this.require_value = 21;
      this.HP_mod = 4;
      this.SP_mod = 16;
      this.price = 336;
   }
   function ArmorHelmetMon2()
   {
      this.NAME = "Kürk Şapka";
      this.value = 3;
      this.require_param = "DEX";
      this.require_value = 21;
      this.HP_mod = 2;
      this.SP_mod = 8;
      this.price = 252;
   }
   function ArmorClothesMon3()
   {
      this.NAME = "Atlı Zincir Zırhı";
      this.value = 11;
      this.require_param = "DEX";
      this.require_value = 27;
      this.HP_mod = 6;
      this.SP_mod = 24;
      this.price = 594;
   }
   function ArmorHelmetMon3()
   {
      this.NAME = "Gezgin Şapkası";
      this.value = 4;
      this.require_param = "DEX";
      this.require_value = 27;
      this.HP_mod = 3;
      this.SP_mod = 12;
      this.price = 432;
   }
   function ArmorClothesMon4()
   {
      this.NAME = "Gezgin Zincir Zırhı";
      this.value = 15;
      this.require_param = "DEX";
      this.require_value = 34;
      this.HP_mod = 8;
      this.SP_mod = 32;
      this.price = 1020;
   }
   function ArmorHelmetMon4()
   {
      this.NAME = "Tilki Kuyruğu Şapka";
      this.value = 5;
      this.require_param = "DEX";
      this.require_value = 34;
      this.HP_mod = 4;
      this.SP_mod = 16;
      this.price = 680;
   }
   function ArmorClothesMon5()
   {
      this.NAME = "Atlı Plaka Zırhı";
      this.value = 20;
      this.require_param = "DEX";
      this.require_value = 43;
      this.HP_mod = 10;
      this.SP_mod = 40;
      this.price = 1720;
   }
   function ArmorHelmetMon5()
   {
      this.NAME = "Tilki Başı Miğfer";
      this.value = 7;
      this.require_param = "DEX";
      this.require_value = 43;
      this.HP_mod = 5;
      this.SP_mod = 20;
      this.price = 1204;
   }
   function ArmorClothesMon6()
   {
      this.NAME = "Gezgin Plaka Zırhı";
      this.value = 28;
      this.require_param = "DEX";
      this.require_value = 54;
      this.HP_mod = 12;
      this.SP_mod = 48;
      this.price = 3024;
   }
   function ArmorHelmetMon6()
   {
      this.NAME = "Altın Şapka";
      this.value = 9;
      this.require_param = "DEX";
      this.require_value = 54;
      this.HP_mod = 6;
      this.SP_mod = 24;
      this.price = 1944;
   }
   function ArmorClothesMon7()
   {
      this.NAME = "Kara Atlı Zırhı";
      this.value = 38;
      this.require_param = "DEX";
      this.require_value = 68;
      this.HP_mod = 14;
      this.SP_mod = 56;
      this.price = 5168;
   }
   function ArmorHelmetMon7()
   {
      this.NAME = "Seçkin Gezgin Miğferi";
      this.value = 13;
      this.require_param = "DEX";
      this.require_value = 68;
      this.HP_mod = 7;
      this.SP_mod = 28;
      this.price = 3536;
   }
   function ArmorClothesMon8()
   {
      this.NAME = "Han'ın Giysisi";
      this.value = 51;
      this.require_param = "DEX";
      this.require_value = 85;
      this.HP_mod = 16;
      this.SP_mod = 64;
      this.price = 8670;
   }
   function ArmorHelmetMon8()
   {
      this.NAME = "Han'ın Miğferi";
      this.value = 17;
      this.require_param = "DEX";
      this.require_value = 85;
      this.HP_mod = 8;
      this.SP_mod = 32;
      this.price = 5780;
   }
   function ArmorClothesAra1()
   {
      this.NAME = "Hafif Ceket";
      this.value = 7;
      this.require_param = "STR";
      this.require_value = 19;
      this.HP_mod = 4;
      this.SP_mod = 4;
      this.price = 266;
   }
   function ArmorHelmetAra1()
   {
      this.NAME = "Sarık";
      this.value = 2;
      this.require_param = "STR";
      this.require_value = 19;
      this.HP_mod = 2;
      this.SP_mod = 2;
      this.price = 152;
   }
   function ArmorClothesAra2()
   {
      this.NAME = "Tören Giysisi";
      this.value = 10;
      this.require_param = "STR";
      this.require_value = 24;
      this.HP_mod = 8;
      this.SP_mod = 8;
      this.price = 480;
   }
   function ArmorHelmetAra2()
   {
      this.NAME = "Tören Şapkası";
      this.value = 3;
      this.require_param = "STR";
      this.require_value = 24;
      this.HP_mod = 4;
      this.SP_mod = 4;
      this.price = 288;
   }
   function ArmorClothesAra3()
   {
      this.NAME = "Korsan Zincir Zırhı";
      this.value = 13;
      this.require_param = "STR";
      this.require_value = 30;
      this.HP_mod = 12;
      this.SP_mod = 12;
      this.price = 780;
   }
   function ArmorHelmetAra3()
   {
      this.NAME = "Suikastçı Maskesi";
      this.value = 4;
      this.require_param = "STR";
      this.require_value = 30;
      this.HP_mod = 6;
      this.SP_mod = 6;
      this.price = 480;
   }
   function ArmorClothesAra4()
   {
      this.NAME = "Yeniçeri Zincir Zırhı";
      this.value = 18;
      this.require_param = "STR";
      this.require_value = 38;
      this.HP_mod = 16;
      this.SP_mod = 16;
      this.price = 1368;
   }
   function ArmorHelmetAra4()
   {
      this.NAME = "Çöl Şapkası";
      this.value = 6;
      this.require_param = "STR";
      this.require_value = 38;
      this.HP_mod = 8;
      this.SP_mod = 8;
      this.price = 912;
   }
   function ArmorClothesAra5()
   {
      this.NAME = "Hafif Göğüslük";
      this.value = 24;
      this.require_param = "STR";
      this.require_value = 48;
      this.HP_mod = 20;
      this.SP_mod = 20;
      this.price = 2304;
   }
   function ArmorHelmetAra5()
   {
      this.NAME = "Komutan Sarığı";
      this.value = 8;
      this.require_param = "STR";
      this.require_value = 48;
      this.HP_mod = 10;
      this.SP_mod = 10;
      this.price = 1536;
   }
   function ArmorClothesAra6()
   {
      this.NAME = "Yeniçeri Göğüslüğü";
      this.value = 32;
      this.require_param = "STR";
      this.require_value = 60;
      this.HP_mod = 24;
      this.SP_mod = 24;
      this.price = 3840;
   }
   function ArmorHelmetAra6()
   {
      this.NAME = "Yeniçeri Börkü";
      this.value = 11;
      this.require_param = "STR";
      this.require_value = 60;
      this.HP_mod = 12;
      this.SP_mod = 12;
      this.price = 2640;
   }
   function ArmorClothesAra7()
   {
      this.NAME = "Yeniçeri Plaka Zırhı";
      this.value = 44;
      this.require_param = "STR";
      this.require_value = 75;
      this.HP_mod = 28;
      this.SP_mod = 28;
      this.price = 6600;
   }
   function ArmorHelmetAra7()
   {
      this.NAME = "Yeniçeri Miğferi";
      this.value = 15;
      this.require_param = "STR";
      this.require_value = 75;
      this.HP_mod = 14;
      this.SP_mod = 14;
      this.price = 4500;
   }
   function ArmorClothesAra8()
   {
      this.NAME = "Sultan Zırhı";
      this.value = 60;
      this.require_param = "STR";
      this.require_value = 95;
      this.HP_mod = 32;
      this.SP_mod = 32;
      this.price = 11400;
   }
   function ArmorHelmetAra8()
   {
      this.NAME = "Seçkin Yeniçeri Miğferi";
      this.value = 20;
      this.require_param = "STR";
      this.require_value = 95;
      this.HP_mod = 16;
      this.SP_mod = 16;
      this.price = 7600;
   }
}
