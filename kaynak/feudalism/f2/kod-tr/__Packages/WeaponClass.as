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
   var getFrame;
   var initEnchant;
   var price;
   var require_param;
   var require_value;
   var rnd;
   var setRefine;
   var skill;
   var rng = 0;
   var aspd_bonus = 0;
   function WeaponClass(tp, nt, lv, ei, rf)
   {
      super();
      this.TYPE = tp;
      this.NATION = nt;
      this.LEVEL = lv;
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
      switch(tp)
      {
         case "OnehandedSword":
         case "TwohandedSword":
            this.skill = "Sword";
            break;
         case "OnehandedAxe":
         case "TwohandedAxe":
            this.skill = "Axe";
            break;
         case "OnehandedMace":
         case "TwohandedMace":
            this.skill = "Mace";
            break;
         case "Dagger":
            this.skill = "Dagger";
            break;
         case "Staff":
            this.skill = "Staff";
            break;
         case "Spear":
            this.skill = "Spear";
            break;
         case "NinjaTo":
         case "Katana":
            this.skill = "FarEast";
            break;
         case "Katar":
            this.skill = "Katar";
            break;
         case "Bow":
            this.skill = "Bow";
            break;
         case "Crossbow":
            this.skill = "Crossbow";
            break;
         case "Throwing":
            this.skill = "Throwing";
            break;
         case "Fists":
            this.skill = "Fists";
      }
      this.FRAME = this.getFrame();
      this["Weapon" + tp + nt + lv]();
      this.initEnchant(ei);
      this.setRefine(rf);
   }
   static function isTwohandedType(tp)
   {
      switch(tp)
      {
         case "OnehandedSword":
         case "OnehandedAxe":
         case "OnehandedMace":
         case "NinjaTo":
         case "Shield":
            return false;
         default:
            return true;
      }
   }
   static function getBaseDelay(tp)
   {
      switch(tp)
      {
         case "OnehandedSword":
         case "OnehandedAxe":
         case "OnehandedMace":
            return 40;
         case "Dagger":
            return 30;
         case "TwohandedSword":
         case "TwohandedAxe":
         case "TwohandedMace":
            return 40;
         case "Staff":
            return 30;
         case "Spear":
            return 60;
         case "NinjaTo":
         case "Katana":
            return "run_katana";
         case "Katar":
            return "run_katar";
         case "Bow":
            return "run_bow";
         case "Crossbow":
            return "run_crossbow";
         case "Throwing":
            return "run_suriken";
         case "Fists":
            return "run_double";
         default:
            return;
      }
   }
   function isTwohanded()
   {
      return WeaponClass.isTwohandedType(this.TYPE);
   }
   function WeaponFistsAll0()
   {
      this.NAME = "Çıplak eller";
      this.dmg = 0;
      this.rnd = 10;
      this.rng = 0;
      this.crit = 0;
      this.price = 0;
   }
   function WeaponOnehandedSwordViz1()
   {
      this.NAME = "Gladius";
      this.dmg = 13;
      this.rnd = 11;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 16;
      this.price = 950;
   }
   function WeaponOnehandedSwordViz2()
   {
      this.NAME = "Spatha";
      this.dmg = 17;
      this.rnd = 15;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 30;
      this.price = 1800;
   }
   function WeaponOnehandedSwordViz3()
   {
      this.NAME = "Süvari Spathası";
      this.dmg = 24;
      this.rnd = 20;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 44;
      this.price = 2600;
   }
   function WeaponOnehandedSwordViz4()
   {
      this.NAME = "Önder Kılıcı";
      this.dmg = 33;
      this.rnd = 28;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 57;
      this.price = 3400;
   }
   function WeaponOnehandedSwordViz5()
   {
      this.NAME = "Yıldız Işıltısı";
      this.dmg = 45;
      this.rnd = 38;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 71;
      this.price = 4250;
   }
   function WeaponOnehandedSwordViz6()
   {
      this.NAME = "Canavar Dişi";
      this.dmg = 61;
      this.rnd = 52;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 5100;
   }
   function WeaponOnehandedSwordViz7()
   {
      this.NAME = "Ejder Kılıcı";
      this.dmg = 84;
      this.rnd = 72;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 99;
      this.price = 5900;
   }
   function WeaponOnehandedSwordGer1()
   {
      this.NAME = "Kısa Kılıç";
      this.dmg = 10;
      this.rnd = 9;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 15;
      this.price = 900;
   }
   function WeaponOnehandedSwordGer2()
   {
      this.NAME = "Yaya Kılıcı";
      this.dmg = 14;
      this.rnd = 12;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 27;
      this.price = 1600;
   }
   function WeaponOnehandedSwordGer3()
   {
      this.NAME = "Uzun Kılıç";
      this.dmg = 20;
      this.rnd = 17;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 40;
      this.price = 2400;
   }
   function WeaponOnehandedSwordGer4()
   {
      this.NAME = "Melez Kılıç";
      this.dmg = 27;
      this.rnd = 23;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 52;
      this.price = 3100;
   }
   function WeaponOnehandedSwordGer5()
   {
      this.NAME = "Yıldız Getiren";
      this.dmg = 37;
      this.rnd = 32;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 65;
      this.price = 3900;
   }
   function WeaponOnehandedSwordGer6()
   {
      this.NAME = "Kemik Kılıç";
      this.dmg = 51;
      this.rnd = 44;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 77;
      this.price = 4600;
   }
   function WeaponOnehandedSwordGer7()
   {
      this.NAME = "Kafatası Kılıcı";
      this.dmg = 70;
      this.rnd = 60;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 90;
      this.price = 5400;
   }
   function WeaponOnehandedSwordRus1()
   {
      this.NAME = "Kesici";
      this.dmg = 9;
      this.rnd = 8;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 14;
      this.price = 800;
   }
   function WeaponOnehandedSwordRus2()
   {
      this.NAME = "Uzun Hançer";
      this.dmg = 13;
      this.rnd = 11;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 26;
      this.price = 1550;
   }
   function WeaponOnehandedSwordRus3()
   {
      this.NAME = "Satır";
      this.dmg = 18;
      this.rnd = 15;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 37;
      this.price = 2200;
   }
   function WeaponOnehandedSwordRus4()
   {
      this.NAME = "Koruyucu Kılıcı";
      this.dmg = 24;
      this.rnd = 21;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 49;
      this.price = 2900;
   }
   function WeaponOnehandedSwordRus5()
   {
      this.NAME = "Kara Lanet";
      this.dmg = 33;
      this.rnd = 29;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 61;
      this.price = 3650;
   }
   function WeaponOnehandedSwordRus6()
   {
      this.NAME = "İblis Avcısı";
      this.dmg = 46;
      this.rnd = 39;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 73;
      this.price = 4350;
   }
   function WeaponOnehandedSwordRus7()
   {
      this.NAME = "Kladenets";
      this.dmg = 63;
      this.rnd = 54;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 5100;
   }
   function WeaponOnehandedSwordMon1()
   {
      this.NAME = "Atlı Kılıcı";
      this.dmg = 8;
      this.rnd = 7;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 13;
      this.price = 750;
   }
   function WeaponOnehandedSwordMon2()
   {
      this.NAME = "Gezgin Kılıcı";
      this.dmg = 11;
      this.rnd = 9;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 24;
      this.price = 1400;
   }
   function WeaponOnehandedSwordMon3()
   {
      this.NAME = "Dengeli Kılıç";
      this.dmg = 15;
      this.rnd = 13;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 35;
      this.price = 2100;
   }
   function WeaponOnehandedSwordMon4()
   {
      this.NAME = "Atlı Eğri Kılıcı";
      this.dmg = 20;
      this.rnd = 17;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 47;
      this.price = 2800;
   }
   function WeaponOnehandedSwordMon5()
   {
      this.NAME = "Yuvarlak Eğri Kılıç";
      this.dmg = 28;
      this.rnd = 24;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 58;
      this.price = 3450;
   }
   function WeaponOnehandedSwordMon6()
   {
      this.NAME = "Kancalı Eğri Kılıç";
      this.dmg = 38;
      this.rnd = 33;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 69;
      this.price = 4100;
   }
   function WeaponOnehandedSwordMon7()
   {
      this.NAME = "Gezgin Eğri Kılıcı";
      this.dmg = 52;
      this.rnd = 45;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 80;
      this.price = 4800;
   }
   function WeaponOnehandedSwordAra1()
   {
      this.NAME = "Köle Kılıcı";
      this.dmg = 9;
      this.rnd = 8;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 14;
      this.price = 800;
   }
   function WeaponOnehandedSwordAra2()
   {
      this.NAME = "Göçebe Kılıcı";
      this.dmg = 13;
      this.rnd = 11;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 26;
      this.price = 1550;
   }
   function WeaponOnehandedSwordAra3()
   {
      this.NAME = "Pala";
      this.dmg = 18;
      this.rnd = 15;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 37;
      this.price = 2200;
   }
   function WeaponOnehandedSwordAra4()
   {
      this.NAME = "Göçebe Palası";
      this.dmg = 24;
      this.rnd = 21;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 49;
      this.price = 2900;
   }
   function WeaponOnehandedSwordAra5()
   {
      this.NAME = "Çöl Palası";
      this.dmg = 33;
      this.rnd = 29;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 61;
      this.price = 3650;
   }
   function WeaponOnehandedSwordAra6()
   {
      this.NAME = "Çöl Kralı";
      this.dmg = 46;
      this.rnd = 39;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 73;
      this.price = 4350;
   }
   function WeaponOnehandedSwordAra7()
   {
      this.NAME = "Ruh Ateşi";
      this.dmg = 63;
      this.rnd = 54;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 5100;
   }
   function WeaponTwohandedSwordViz1()
   {
      this.NAME = "Demir İki Elli Kılıç";
      this.dmg = 19;
      this.rnd = 16;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 16;
      this.price = 1400;
   }
   function WeaponTwohandedSwordViz2()
   {
      this.NAME = "Çelik İki Elli Kılıç";
      this.dmg = 26;
      this.rnd = 22;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 30;
      this.price = 2700;
   }
   function WeaponTwohandedSwordViz3()
   {
      this.NAME = "Kısa Pala";
      this.dmg = 36;
      this.rnd = 30;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 44;
      this.price = 3950;
   }
   function WeaponTwohandedSwordViz4()
   {
      this.NAME = "Ay Işığı";
      this.dmg = 49;
      this.rnd = 42;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 57;
      this.price = 5100;
   }
   function WeaponTwohandedSwordViz5()
   {
      this.NAME = "Ruh Kıran";
      this.dmg = 67;
      this.rnd = 57;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 71;
      this.price = 6350;
   }
   function WeaponTwohandedSwordViz6()
   {
      this.NAME = "Altın Pençe";
      this.dmg = 92;
      this.rnd = 79;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 7650;
   }
   function WeaponTwohandedSwordViz7()
   {
      this.NAME = "Ejder Başı";
      this.dmg = 126;
      this.rnd = 108;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 99;
      this.price = 8900;
   }
   function WeaponTwohandedSwordGer1()
   {
      this.NAME = "Hafif İki Elli Kılıç";
      this.dmg = 16;
      this.rnd = 14;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 15;
      this.price = 1350;
   }
   function WeaponTwohandedSwordGer2()
   {
      this.NAME = "Şövalye İki Elli Kılıcı";
      this.dmg = 22;
      this.rnd = 19;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 27;
      this.price = 2400;
   }
   function WeaponTwohandedSwordGer3()
   {
      this.NAME = "Haçlı İki Elli Kılıcı";
      this.dmg = 30;
      this.rnd = 25;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 40;
      this.price = 3600;
   }
   function WeaponTwohandedSwordGer4()
   {
      this.NAME = "Claymore";
      this.dmg = 41;
      this.rnd = 35;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 52;
      this.price = 4650;
   }
   function WeaponTwohandedSwordGer5()
   {
      this.NAME = "Yarasa Yüreği";
      this.dmg = 56;
      this.rnd = 48;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 65;
      this.price = 5850;
   }
   function WeaponTwohandedSwordGer6()
   {
      this.NAME = "Kara Günah";
      this.dmg = 77;
      this.rnd = 66;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 77;
      this.price = 6900;
   }
   function WeaponTwohandedSwordGer7()
   {
      this.NAME = "Nekro Kılıç";
      this.dmg = 105;
      this.rnd = 90;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 90;
      this.price = 8100;
   }
   function WeaponTwohandedSwordRus1()
   {
      this.NAME = "Dövme İki Elli Kılıç";
      this.dmg = 14;
      this.rnd = 12;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 14;
      this.price = 1250;
   }
   function WeaponTwohandedSwordRus2()
   {
      this.NAME = "Uzun İki Elli Kılıç";
      this.dmg = 19;
      this.rnd = 17;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 26;
      this.price = 2300;
   }
   function WeaponTwohandedSwordRus3()
   {
      this.NAME = "Büyük İki Elli Kılıç";
      this.dmg = 27;
      this.rnd = 23;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 37;
      this.price = 3300;
   }
   function WeaponTwohandedSwordRus4()
   {
      this.NAME = "Koruyucu İki Elli Kılıcı";
      this.dmg = 37;
      this.rnd = 31;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 49;
      this.price = 4400;
   }
   function WeaponTwohandedSwordRus5()
   {
      this.NAME = "Kutsal İki Elli Kılıç";
      this.dmg = 50;
      this.rnd = 43;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 61;
      this.price = 5450;
   }
   function WeaponTwohandedSwordRus6()
   {
      this.NAME = "Kızgın Alev";
      this.dmg = 69;
      this.rnd = 59;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 73;
      this.price = 6550;
   }
   function WeaponTwohandedSwordRus7()
   {
      this.NAME = "Büyük Ezici";
      this.dmg = 94;
      this.rnd = 81;
      this.crit = 5;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 7650;
   }
   function WeaponTwohandedSwordMon1()
   {
      this.NAME = "İnce İki Elli Kılıç";
      this.dmg = 12;
      this.rnd = 10;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 13;
      this.price = 1150;
   }
   function WeaponTwohandedSwordMon2()
   {
      this.NAME = "Atlı İki Elli Kılıcı";
      this.dmg = 16;
      this.rnd = 14;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 24;
      this.price = 2150;
   }
   function WeaponTwohandedSwordMon3()
   {
      this.NAME = "Koruyucu";
      this.dmg = 22;
      this.rnd = 19;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 35;
      this.price = 3150;
   }
   function WeaponTwohandedSwordMon4()
   {
      this.NAME = "İki Elli Eğri Kılıç";
      this.dmg = 30;
      this.rnd = 26;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 47;
      this.price = 4200;
   }
   function WeaponTwohandedSwordMon5()
   {
      this.NAME = "Yuvarlak İki Elli Kılıç";
      this.dmg = 42;
      this.rnd = 36;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 58;
      this.price = 5200;
   }
   function WeaponTwohandedSwordMon6()
   {
      this.NAME = "Gezgin Ağır Eğri Kılıcı";
      this.dmg = 57;
      this.rnd = 49;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 69;
      this.price = 6200;
   }
   function WeaponTwohandedSwordMon7()
   {
      this.NAME = "Han'ın Ağır Eğri Kılıcı";
      this.dmg = 79;
      this.rnd = 68;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.require_param = "DEX";
      this.require_value = 80;
      this.price = 7200;
   }
   function WeaponTwohandedSwordAra1()
   {
      this.NAME = "Köle İki Elli Kılıcı";
      this.dmg = 14;
      this.rnd = 12;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 14;
      this.price = 1250;
   }
   function WeaponTwohandedSwordAra2()
   {
      this.NAME = "Uzun Göçebe Kesicisi";
      this.dmg = 19;
      this.rnd = 17;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 26;
      this.price = 2300;
   }
   function WeaponTwohandedSwordAra3()
   {
      this.NAME = "İki Elli Pala";
      this.dmg = 27;
      this.rnd = 23;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 37;
      this.price = 3300;
   }
   function WeaponTwohandedSwordAra4()
   {
      this.NAME = "Savaş Palası";
      this.dmg = 37;
      this.rnd = 31;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 49;
      this.price = 4400;
   }
   function WeaponTwohandedSwordAra5()
   {
      this.NAME = "Dikenli Pala";
      this.dmg = 50;
      this.rnd = 43;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 61;
      this.price = 5450;
   }
   function WeaponTwohandedSwordAra6()
   {
      this.NAME = "Ay Huzmesi";
      this.dmg = 69;
      this.rnd = 59;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 73;
      this.price = 6550;
   }
   function WeaponTwohandedSwordAra7()
   {
      this.NAME = "Güneş Alevi";
      this.dmg = 94;
      this.rnd = 81;
      this.crit = 10;
      this.aspd_bonus = 5;
      this.require_param = "STR";
      this.require_value = 85;
      this.price = 7650;
   }
   function WeaponOnehandedAxeViz1()
   {
      this.NAME = "Ayin Baltası";
      this.dmg = 12;
      this.rnd = 7;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 13;
      this.price = 550;
   }
   function WeaponOnehandedAxeViz2()
   {
      this.NAME = "Rahip Baltası";
      this.dmg = 18;
      this.rnd = 10;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 26;
      this.price = 1150;
   }
   function WeaponOnehandedAxeViz3()
   {
      this.NAME = "Yuvarlak Balta";
      this.dmg = 26;
      this.rnd = 15;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 40;
      this.price = 1750;
   }
   function WeaponOnehandedAxeViz4()
   {
      this.NAME = "Kıran Balta";
      this.dmg = 38;
      this.rnd = 21;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 53;
      this.price = 2350;
   }
   function WeaponOnehandedAxeViz5()
   {
      this.NAME = "Tuhaf Balta";
      this.dmg = 56;
      this.rnd = 31;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 67;
      this.price = 3000;
   }
   function WeaponOnehandedAxeViz6()
   {
      this.NAME = "Seçkin Balta";
      this.dmg = 81;
      this.rnd = 46;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 80;
      this.price = 3550;
   }
   function WeaponOnehandedAxeGer1()
   {
      this.NAME = "Küçük Balta";
      this.dmg = 15;
      this.rnd = 9;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 15;
      this.price = 650;
   }
   function WeaponOnehandedAxeGer2()
   {
      this.NAME = "Piyade Baltası";
      this.dmg = 22;
      this.rnd = 13;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 30;
      this.price = 1300;
   }
   function WeaponOnehandedAxeGer3()
   {
      this.NAME = "Geniş Balta";
      this.dmg = 32;
      this.rnd = 18;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 45;
      this.price = 2000;
   }
   function WeaponOnehandedAxeGer4()
   {
      this.NAME = "Ağır Balta";
      this.dmg = 47;
      this.rnd = 27;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 60;
      this.price = 2650;
   }
   function WeaponOnehandedAxeGer5()
   {
      this.NAME = "Kasap";
      this.dmg = 69;
      this.rnd = 39;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 75;
      this.price = 3350;
   }
   function WeaponOnehandedAxeGer6()
   {
      this.NAME = "Kutsal Umut";
      this.dmg = 101;
      this.rnd = 57;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 90;
      this.price = 4000;
   }
   function WeaponOnehandedAxeRus1()
   {
      this.NAME = "Milis Baltası";
      this.dmg = 18;
      this.rnd = 10;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 16;
      this.price = 700;
   }
   function WeaponOnehandedAxeRus2()
   {
      this.NAME = "Uzun Balta";
      this.dmg = 27;
      this.rnd = 15;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 33;
      this.price = 1450;
   }
   function WeaponOnehandedAxeRus3()
   {
      this.NAME = "Muhafız Baltası";
      this.dmg = 39;
      this.rnd = 22;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 49;
      this.price = 2200;
   }
   function WeaponOnehandedAxeRus4()
   {
      this.NAME = "Kutsal Balta";
      this.dmg = 57;
      this.rnd = 32;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 66;
      this.price = 2950;
   }
   function WeaponOnehandedAxeRus5()
   {
      this.NAME = "Parlak Balta";
      this.dmg = 83;
      this.rnd = 47;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 82;
      this.price = 3650;
   }
   function WeaponOnehandedAxeRus6()
   {
      this.NAME = "Çar'ın Baltası";
      this.dmg = 122;
      this.rnd = 69;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 99;
      this.price = 4450;
   }
   function WeaponTwohandedAxeViz1()
   {
      this.NAME = "Hafif İki Elli Balta";
      this.dmg = 18;
      this.rnd = 10;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 13;
      this.price = 850;
   }
   function WeaponTwohandedAxeViz2()
   {
      this.NAME = "Yuvarlak İki Elli Balta";
      this.dmg = 27;
      this.rnd = 15;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 26;
      this.price = 1750;
   }
   function WeaponTwohandedAxeViz3()
   {
      this.NAME = "Deniz Dalgası";
      this.dmg = 39;
      this.rnd = 22;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 40;
      this.price = 2650;
   }
   function WeaponTwohandedAxeViz4()
   {
      this.NAME = "Altın İki Elli Balta";
      this.dmg = 57;
      this.rnd = 32;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 53;
      this.price = 3550;
   }
   function WeaponTwohandedAxeViz5()
   {
      this.NAME = "Seçkin İki Elli Balta";
      this.dmg = 83;
      this.rnd = 47;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 67;
      this.price = 4500;
   }
   function WeaponTwohandedAxeViz6()
   {
      this.NAME = "Ejder Kanatları";
      this.dmg = 122;
      this.rnd = 69;
      this.crit = 6;
      this.require_param = "STR";
      this.require_value = 80;
      this.price = 5350;
   }
   function WeaponTwohandedAxeGer1()
   {
      this.NAME = "Çelik İki Elli Balta";
      this.dmg = 23;
      this.rnd = 13;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 15;
      this.price = 1000;
   }
   function WeaponTwohandedAxeGer2()
   {
      this.NAME = "Ağır İki Elli Balta";
      this.dmg = 33;
      this.rnd = 19;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 30;
      this.price = 2000;
   }
   function WeaponTwohandedAxeGer3()
   {
      this.NAME = "Gümüş İki Elli Balta";
      this.dmg = 49;
      this.rnd = 27;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 45;
      this.price = 3000;
   }
   function WeaponTwohandedAxeGer4()
   {
      this.NAME = "Tanrı'nın Pençesi";
      this.dmg = 71;
      this.rnd = 40;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 60;
      this.price = 4000;
   }
   function WeaponTwohandedAxeGer5()
   {
      this.NAME = "Giyotin";
      this.dmg = 104;
      this.rnd = 59;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 75;
      this.price = 5050;
   }
   function WeaponTwohandedAxeGer6()
   {
      this.NAME = "Savaş Haçı";
      this.dmg = 152;
      this.rnd = 86;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 90;
      this.price = 6050;
   }
   function WeaponTwohandedAxeRus1()
   {
      this.NAME = "Köylü İki Elli Baltası";
      this.dmg = 27;
      this.rnd = 15;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 16;
      this.price = 1050;
   }
   function WeaponTwohandedAxeRus2()
   {
      this.NAME = "Cellat";
      this.dmg = 40;
      this.rnd = 23;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 33;
      this.price = 2200;
   }
   function WeaponTwohandedAxeRus3()
   {
      this.NAME = "Muhafız İki Elli Baltası";
      this.dmg = 58;
      this.rnd = 33;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 49;
      this.price = 3300;
   }
   function WeaponTwohandedAxeRus4()
   {
      this.NAME = "Seçkin İki Elli Balta";
      this.dmg = 85;
      this.rnd = 48;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 66;
      this.price = 4450;
   }
   function WeaponTwohandedAxeRus5()
   {
      this.NAME = "Melek Kanatları";
      this.dmg = 125;
      this.rnd = 70;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 82;
      this.price = 5500;
   }
   function WeaponTwohandedAxeRus6()
   {
      this.NAME = "Kutsal Yeniden Doğuş";
      this.dmg = 183;
      this.rnd = 103;
      this.crit = 3;
      this.require_param = "STR";
      this.require_value = 99;
      this.price = 6650;
   }
   function WeaponOnehandedMaceViz1()
   {
      this.NAME = "Bronz Sopa";
      this.dmg = 7;
      this.rnd = 3;
      this.crit = 35;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 13;
      this.price = 500;
   }
   function WeaponOnehandedMaceViz2()
   {
      this.NAME = "Ayin Topuzu";
      this.dmg = 10;
      this.rnd = 4;
      this.crit = 39;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 26;
      this.price = 1000;
   }
   function WeaponOnehandedMaceViz3()
   {
      this.NAME = "Kaba Topuz";
      this.dmg = 15;
      this.rnd = 6;
      this.crit = 43;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 40;
      this.price = 1600;
   }
   function WeaponOnehandedMaceViz4()
   {
      this.NAME = "Parlak Topuz";
      this.dmg = 21;
      this.rnd = 9;
      this.crit = 47;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 53;
      this.price = 2100;
   }
   function WeaponOnehandedMaceViz5()
   {
      this.NAME = "Kıran Yıldız";
      this.dmg = 31;
      this.rnd = 14;
      this.crit = 51;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 67;
      this.price = 2650;
   }
   function WeaponOnehandedMaceViz6()
   {
      this.NAME = "Seçkin Çekiç";
      this.dmg = 46;
      this.rnd = 20;
      this.crit = 55;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 80;
      this.price = 3200;
   }
   function WeaponOnehandedMaceGer1()
   {
      this.NAME = "Dikenli Topuz";
      this.dmg = 10;
      this.rnd = 5;
      this.crit = 35;
      this.require_param = "CON";
      this.require_value = 16;
      this.price = 600;
   }
   function WeaponOnehandedMaceGer2()
   {
      this.NAME = "Hafif Topuz";
      this.dmg = 15;
      this.rnd = 7;
      this.crit = 39;
      this.require_param = "CON";
      this.require_value = 33;
      this.price = 1300;
   }
   function WeaponOnehandedMaceGer3()
   {
      this.NAME = "Barış Bekçisi";
      this.dmg = 22;
      this.rnd = 10;
      this.crit = 43;
      this.require_param = "CON";
      this.require_value = 49;
      this.price = 1950;
   }
   function WeaponOnehandedMaceGer4()
   {
      this.NAME = "Ölümcül Dikenler";
      this.dmg = 32;
      this.rnd = 14;
      this.crit = 47;
      this.require_param = "CON";
      this.require_value = 66;
      this.price = 2600;
   }
   function WeaponOnehandedMaceGer5()
   {
      this.NAME = "Kapı Kıran";
      this.dmg = 47;
      this.rnd = 21;
      this.crit = 51;
      this.require_param = "CON";
      this.require_value = 82;
      this.price = 3250;
   }
   function WeaponOnehandedMaceGer6()
   {
      this.NAME = "Aziz Gücü";
      this.dmg = 69;
      this.rnd = 30;
      this.crit = 55;
      this.require_param = "CON";
      this.require_value = 99;
      this.price = 3950;
   }
   function WeaponOnehandedMaceRus1()
   {
      this.NAME = "Dikenli Tahta Sopa";
      this.dmg = 9;
      this.rnd = 4;
      this.crit = 35;
      this.require_param = "CON";
      this.require_value = 15;
      this.price = 600;
   }
   function WeaponOnehandedMaceRus2()
   {
      this.NAME = "Zırh Kıran";
      this.dmg = 13;
      this.rnd = 6;
      this.crit = 39;
      this.require_param = "CON";
      this.require_value = 30;
      this.price = 1200;
   }
   function WeaponOnehandedMaceRus3()
   {
      this.NAME = "Ağır Sopa";
      this.dmg = 18;
      this.rnd = 8;
      this.crit = 43;
      this.require_param = "CON";
      this.require_value = 45;
      this.price = 1800;
   }
   function WeaponOnehandedMaceRus4()
   {
      this.NAME = "Altın Kirpi";
      this.dmg = 27;
      this.rnd = 12;
      this.crit = 47;
      this.require_param = "CON";
      this.require_value = 60;
      this.price = 2400;
   }
   function WeaponOnehandedMaceRus5()
   {
      this.NAME = "Kıyım";
      this.dmg = 39;
      this.rnd = 17;
      this.crit = 51;
      this.require_param = "CON";
      this.require_value = 75;
      this.price = 3000;
   }
   function WeaponOnehandedMaceRus6()
   {
      this.NAME = "Büyük Kıyım";
      this.dmg = 57;
      this.rnd = 25;
      this.crit = 55;
      this.require_param = "CON";
      this.require_value = 90;
      this.price = 3600;
   }
   function WeaponTwohandedMaceViz1()
   {
      this.NAME = "Bronz İki Elli Topuz";
      this.dmg = 10;
      this.rnd = 5;
      this.crit = 35;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 13;
      this.price = 750;
   }
   function WeaponTwohandedMaceViz2()
   {
      this.NAME = "Ayin İki Elli Topuzu";
      this.dmg = 15;
      this.rnd = 7;
      this.crit = 39;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 26;
      this.price = 1550;
   }
   function WeaponTwohandedMaceViz3()
   {
      this.NAME = "Ayin Çekici";
      this.dmg = 22;
      this.rnd = 10;
      this.crit = 43;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 40;
      this.price = 2400;
   }
   function WeaponTwohandedMaceViz4()
   {
      this.NAME = "Altın Çekiç";
      this.dmg = 32;
      this.rnd = 14;
      this.crit = 47;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 53;
      this.price = 3150;
   }
   function WeaponTwohandedMaceViz5()
   {
      this.NAME = "Büyük Sersemletici";
      this.dmg = 47;
      this.rnd = 21;
      this.crit = 51;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 67;
      this.price = 4000;
   }
   function WeaponTwohandedMaceViz6()
   {
      this.NAME = "Ejder Dişleri";
      this.dmg = 69;
      this.rnd = 30;
      this.crit = 55;
      this.aspd_bonus = 1;
      this.require_param = "CON";
      this.require_value = 80;
      this.price = 4800;
   }
   function WeaponTwohandedMaceGer1()
   {
      this.NAME = "Savaş Çekici";
      this.dmg = 15;
      this.rnd = 7;
      this.crit = 35;
      this.require_param = "CON";
      this.require_value = 16;
      this.price = 950;
   }
   function WeaponTwohandedMaceGer2()
   {
      this.NAME = "Çelik İki Elli Topuz";
      this.dmg = 23;
      this.rnd = 10;
      this.crit = 39;
      this.require_param = "CON";
      this.require_value = 33;
      this.price = 1950;
   }
   function WeaponTwohandedMaceGer3()
   {
      this.NAME = "Dikenli İki Elli Topuz";
      this.dmg = 33;
      this.rnd = 15;
      this.crit = 43;
      this.require_param = "CON";
      this.require_value = 49;
      this.price = 2900;
   }
   function WeaponTwohandedMaceGer4()
   {
      this.NAME = "Kutsal Yıldız";
      this.dmg = 48;
      this.rnd = 21;
      this.crit = 47;
      this.require_param = "CON";
      this.require_value = 66;
      this.price = 3950;
   }
   function WeaponTwohandedMaceGer5()
   {
      this.NAME = "Kutsal İntikamcı";
      this.dmg = 71;
      this.rnd = 31;
      this.crit = 51;
      this.require_param = "CON";
      this.require_value = 82;
      this.price = 4900;
   }
   function WeaponTwohandedMaceGer6()
   {
      this.NAME = "Yüce Kurtarıcı";
      this.dmg = 103;
      this.rnd = 45;
      this.crit = 55;
      this.require_param = "CON";
      this.require_value = 99;
      this.price = 5900;
   }
   function WeaponTwohandedMaceRus1()
   {
      this.NAME = "Hantal İki Elli Topuz";
      this.dmg = 13;
      this.rnd = 6;
      this.crit = 35;
      this.require_param = "CON";
      this.require_value = 15;
      this.price = 900;
   }
   function WeaponTwohandedMaceRus2()
   {
      this.NAME = "Bronz İki Elli Topuz";
      this.dmg = 19;
      this.rnd = 8;
      this.crit = 39;
      this.require_param = "CON";
      this.require_value = 30;
      this.price = 1800;
   }
   function WeaponTwohandedMaceRus3()
   {
      this.NAME = "Ağır İki Elli Topuz";
      this.dmg = 28;
      this.rnd = 12;
      this.crit = 43;
      this.require_param = "CON";
      this.require_value = 45;
      this.price = 2700;
   }
   function WeaponTwohandedMaceRus4()
   {
      this.NAME = "Kahraman İki Elli Topuzu";
      this.dmg = 40;
      this.rnd = 18;
      this.crit = 47;
      this.require_param = "CON";
      this.require_value = 60;
      this.price = 3600;
   }
   function WeaponTwohandedMaceRus5()
   {
      this.NAME = "Parlayan Işık";
      this.dmg = 59;
      this.rnd = 26;
      this.crit = 51;
      this.require_param = "CON";
      this.require_value = 75;
      this.price = 4500;
   }
   function WeaponTwohandedMaceRus6()
   {
      this.NAME = "Medusa";
      this.dmg = 86;
      this.rnd = 38;
      this.crit = 55;
      this.require_param = "CON";
      this.require_value = 90;
      this.price = 5400;
   }
   function WeaponDaggerViz1()
   {
      this.NAME = "Bıçak";
      this.dmg = 6;
      this.rnd = 7;
      this.crit = 58;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 600;
   }
   function WeaponDaggerViz2()
   {
      this.NAME = "Hançer";
      this.dmg = 9;
      this.rnd = 10;
      this.crit = 63;
      this.require_param = "DEX";
      this.require_value = 28;
      this.price = 1100;
   }
   function WeaponDaggerViz3()
   {
      this.NAME = "Şiş Hançer";
      this.dmg = 12;
      this.rnd = 13;
      this.crit = 67;
      this.require_param = "DEX";
      this.require_value = 41;
      this.price = 1600;
   }
   function WeaponDaggerViz4()
   {
      this.NAME = "Şam Çeliği";
      this.dmg = 17;
      this.rnd = 18;
      this.crit = 72;
      this.require_param = "DEX";
      this.require_value = 55;
      this.price = 2200;
   }
   function WeaponDaggerViz5()
   {
      this.NAME = "Buz Sarkıtı";
      this.dmg = 23;
      this.rnd = 25;
      this.crit = 76;
      this.require_param = "DEX";
      this.require_value = 68;
      this.price = 2700;
   }
   function WeaponDaggerViz6()
   {
      this.NAME = "Tüy";
      this.dmg = 31;
      this.rnd = 34;
      this.crit = 81;
      this.require_param = "DEX";
      this.require_value = 81;
      this.price = 3200;
   }
   function WeaponDaggerViz7()
   {
      this.NAME = "Kara Ruh";
      this.dmg = 43;
      this.rnd = 46;
      this.crit = 85;
      this.require_param = "DEX";
      this.require_value = 94;
      this.price = 3750;
   }
   function WeaponDaggerMon1()
   {
      this.NAME = "Et Bıçağı";
      this.dmg = 5;
      this.rnd = 5;
      this.crit = 65;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 13;
      this.price = 500;
   }
   function WeaponDaggerMon2()
   {
      this.NAME = "Yuvarlak Hançer";
      this.dmg = 6;
      this.rnd = 7;
      this.crit = 70;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 24;
      this.price = 950;
   }
   function WeaponDaggerMon3()
   {
      this.NAME = "Kama";
      this.dmg = 9;
      this.rnd = 9;
      this.crit = 75;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 35;
      this.price = 1400;
   }
   function WeaponDaggerMon4()
   {
      this.NAME = "Savaş Hançeri";
      this.dmg = 12;
      this.rnd = 13;
      this.crit = 80;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 47;
      this.price = 1850;
   }
   function WeaponDaggerMon5()
   {
      this.NAME = "Ayin Bıçağı";
      this.dmg = 17;
      this.rnd = 18;
      this.crit = 85;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 58;
      this.price = 2300;
   }
   function WeaponDaggerMon6()
   {
      this.NAME = "Azap";
      this.dmg = 23;
      this.rnd = 24;
      this.crit = 90;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 69;
      this.price = 2750;
   }
   function WeaponDaggerMon7()
   {
      this.NAME = "Nefret";
      this.dmg = 31;
      this.rnd = 34;
      this.crit = 95;
      this.aspd_bonus = 5;
      this.require_param = "DEX";
      this.require_value = 80;
      this.price = 3200;
   }
   function WeaponStaffJap1()
   {
      this.NAME = "Çırak Asası";
      this.dmg = 5;
      this.rnd = 2;
      this.crit = 30;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 500;
   }
   function WeaponStaffJap2()
   {
      this.NAME = "Usta Asası";
      this.dmg = 6;
      this.rnd = 3;
      this.crit = 32;
      this.require_param = "DEX";
      this.require_value = 25;
      this.price = 850;
   }
   function WeaponStaffJap3()
   {
      this.NAME = "Dikenli Asa";
      this.dmg = 8;
      this.rnd = 4;
      this.crit = 34;
      this.require_param = "DEX";
      this.require_value = 36;
      this.price = 1250;
   }
   function WeaponStaffJap4()
   {
      this.NAME = "Naginata";
      this.dmg = 11;
      this.rnd = 5;
      this.crit = 36;
      this.require_param = "DEX";
      this.require_value = 47;
      this.price = 1600;
   }
   function WeaponStaffJap5()
   {
      this.NAME = "Altın Asa";
      this.dmg = 14;
      this.rnd = 7;
      this.crit = 38;
      this.require_param = "DEX";
      this.require_value = 57;
      this.price = 1950;
   }
   function WeaponStaffJap6()
   {
      this.NAME = "Altın Naginata";
      this.dmg = 19;
      this.rnd = 9;
      this.crit = 40;
      this.require_param = "DEX";
      this.require_value = 68;
      this.price = 2350;
   }
   function WeaponStaffJap7()
   {
      this.NAME = "Kılıçbalığı";
      this.dmg = 24;
      this.rnd = 12;
      this.crit = 42;
      this.require_param = "DEX";
      this.require_value = 79;
      this.price = 2750;
   }
   function WeaponStaffJap8()
   {
      this.NAME = "Kara Yılan";
      this.dmg = 32;
      this.rnd = 16;
      this.crit = 44;
      this.require_param = "DEX";
      this.require_value = 90;
      this.price = 3100;
   }
   function WeaponSpearViz1()
   {
      this.NAME = "Piyade Mızrağı";
      this.dmg = 23;
      this.rnd = 8;
      this.crit = 56;
      this.require_param = "STR";
      this.require_value = 16;
      this.price = 800;
   }
   function WeaponSpearViz2()
   {
      this.NAME = "Gelişmiş Mızrak";
      this.dmg = 37;
      this.rnd = 13;
      this.crit = 60;
      this.require_param = "STR";
      this.require_value = 37;
      this.price = 1850;
   }
   function WeaponSpearViz3()
   {
      this.NAME = "Süvari Mızrağı";
      this.dmg = 59;
      this.rnd = 21;
      this.crit = 64;
      this.require_param = "STR";
      this.require_value = 57;
      this.price = 2850;
   }
   function WeaponSpearViz4()
   {
      this.NAME = "Altın Yaprak";
      this.dmg = 95;
      this.rnd = 34;
      this.crit = 68;
      this.require_param = "STR";
      this.require_value = 78;
      this.price = 3900;
   }
   function WeaponSpearViz5()
   {
      this.NAME = "Yonca Diken";
      this.dmg = 153;
      this.rnd = 54;
      this.crit = 72;
      this.require_param = "STR";
      this.require_value = 99;
      this.price = 4950;
   }
   function WeaponSpearGer1()
   {
      this.NAME = "Milis Mızrağı";
      this.dmg = 19;
      this.rnd = 7;
      this.crit = 70;
      this.require_param = "STR";
      this.require_value = 15;
      this.price = 750;
   }
   function WeaponSpearGer2()
   {
      this.NAME = "Yaya Mızrağı";
      this.dmg = 31;
      this.rnd = 11;
      this.crit = 75;
      this.require_param = "STR";
      this.require_value = 33;
      this.price = 1650;
   }
   function WeaponSpearGer3()
   {
      this.NAME = "Şövalye Mızrağı";
      this.dmg = 49;
      this.rnd = 17;
      this.crit = 80;
      this.require_param = "STR";
      this.require_value = 52;
      this.price = 2600;
   }
   function WeaponSpearGer4()
   {
      this.NAME = "Köpekbalığı";
      this.dmg = 79;
      this.rnd = 28;
      this.crit = 85;
      this.require_param = "STR";
      this.require_value = 71;
      this.price = 3550;
   }
   function WeaponSpearGer5()
   {
      this.NAME = "Haçlı Mızrağı";
      this.dmg = 127;
      this.rnd = 45;
      this.crit = 90;
      this.require_param = "STR";
      this.require_value = 90;
      this.price = 4500;
   }
   function WeaponSpearRus1()
   {
      this.NAME = "Bronz Mızrak";
      this.dmg = 15;
      this.rnd = 5;
      this.crit = 77;
      this.require_param = "STR";
      this.require_value = 13;
      this.price = 650;
   }
   function WeaponSpearRus2()
   {
      this.NAME = "Kuşatma Mızrağı";
      this.dmg = 25;
      this.rnd = 9;
      this.crit = 83;
      this.require_param = "STR";
      this.require_value = 30;
      this.price = 1500;
   }
   function WeaponSpearRus3()
   {
      this.NAME = "Kutsal Mızrak";
      this.dmg = 40;
      this.rnd = 14;
      this.crit = 88;
      this.require_param = "STR";
      this.require_value = 47;
      this.price = 2350;
   }
   function WeaponSpearRus4()
   {
      this.NAME = "Delici Dokunuş";
      this.dmg = 63;
      this.rnd = 22;
      this.crit = 94;
      this.require_param = "STR";
      this.require_value = 64;
      this.price = 3200;
   }
   function WeaponSpearRus5()
   {
      this.NAME = "Kalkan Kıran";
      this.dmg = 102;
      this.rnd = 36;
      this.crit = 99;
      this.require_param = "STR";
      this.require_value = 80;
      this.price = 4000;
   }
   function WeaponNinjaToJap1()
   {
      this.NAME = "Kısa Ninja-To";
      this.dmg = 4;
      this.rnd = 19;
      this.crit = 15;
      this.require_param = "DEX";
      this.require_value = 16;
      this.price = 1100;
   }
   function WeaponNinjaToJap2()
   {
      this.NAME = "Çırak Ninja-To'su";
      this.dmg = 5;
      this.rnd = 25;
      this.crit = 18;
      this.require_param = "DEX";
      this.require_value = 28;
      this.price = 1950;
   }
   function WeaponNinjaToJap3()
   {
      this.NAME = "Asker Ninja-To'su";
      this.dmg = 7;
      this.rnd = 32;
      this.crit = 21;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 2750;
   }
   function WeaponNinjaToJap4()
   {
      this.NAME = "Ronin Ninja-To'su";
      this.dmg = 9;
      this.rnd = 43;
      this.crit = 24;
      this.require_param = "DEX";
      this.require_value = 51;
      this.price = 3550;
   }
   function WeaponNinjaToJap5()
   {
      this.NAME = "Kutsal Ninja-To";
      this.dmg = 12;
      this.rnd = 56;
      this.crit = 27;
      this.require_param = "DEX";
      this.require_value = 63;
      this.price = 4400;
   }
   function WeaponNinjaToJap6()
   {
      this.NAME = "Kara Kahraman";
      this.dmg = 16;
      this.rnd = 73;
      this.crit = 30;
      this.require_param = "DEX";
      this.require_value = 75;
      this.price = 5200;
   }
   function WeaponNinjaToJap7()
   {
      this.NAME = "Kızıl Ninja-To";
      this.dmg = 21;
      this.rnd = 96;
      this.crit = 33;
      this.require_param = "DEX";
      this.require_value = 87;
      this.price = 6050;
   }
   function WeaponNinjaToJap8()
   {
      this.NAME = "Yıldız Ninja-To'su";
      this.dmg = 27;
      this.rnd = 126;
      this.crit = 36;
      this.require_param = "DEX";
      this.require_value = 99;
      this.price = 6900;
   }
   function WeaponKatanaJap1()
   {
      this.NAME = "Kısa Katana";
      this.dmg = 6;
      this.rnd = 28;
      this.crit = 15;
      this.require_param = "DEX";
      this.require_value = 16;
      this.price = 1650;
   }
   function WeaponKatanaJap2()
   {
      this.NAME = "Çırak Katanası";
      this.dmg = 8;
      this.rnd = 37;
      this.crit = 18;
      this.require_param = "DEX";
      this.require_value = 28;
      this.price = 2900;
   }
   function WeaponKatanaJap3()
   {
      this.NAME = "Asker Katanası";
      this.dmg = 10;
      this.rnd = 49;
      this.crit = 21;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 4150;
   }
   function WeaponKatanaJap4()
   {
      this.NAME = "Ronin Katanası";
      this.dmg = 14;
      this.rnd = 64;
      this.crit = 24;
      this.require_param = "DEX";
      this.require_value = 51;
      this.price = 5350;
   }
   function WeaponKatanaJap5()
   {
      this.NAME = "Kutsal Katana";
      this.dmg = 18;
      this.rnd = 84;
      this.crit = 27;
      this.require_param = "DEX";
      this.require_value = 63;
      this.price = 6600;
   }
   function WeaponKatanaJap6()
   {
      this.NAME = "Karanlık";
      this.dmg = 24;
      this.rnd = 110;
      this.crit = 30;
      this.require_param = "DEX";
      this.require_value = 75;
      this.price = 7850;
   }
   function WeaponKatanaJap7()
   {
      this.NAME = "Kızıl Katana";
      this.dmg = 31;
      this.rnd = 144;
      this.crit = 33;
      this.require_param = "DEX";
      this.require_value = 87;
      this.price = 9100;
   }
   function WeaponKatanaJap8()
   {
      this.NAME = "Tutulma";
      this.dmg = 41;
      this.rnd = 189;
      this.crit = 36;
      this.require_param = "DEX";
      this.require_value = 99;
      this.price = 10350;
   }
   function WeaponKatarAra1()
   {
      this.NAME = "Jur";
      this.dmg = 7;
      this.rnd = 14;
      this.crit = 20;
      this.require_param = "DEX";
      this.require_value = 16;
      this.price = 1250;
   }
   function WeaponKatarAra2()
   {
      this.NAME = "Kesen Jur";
      this.dmg = 10;
      this.rnd = 20;
      this.crit = 23;
      this.require_param = "DEX";
      this.require_value = 33;
      this.price = 2600;
   }
   function WeaponKatarAra3()
   {
      this.NAME = "Katar";
      this.dmg = 15;
      this.rnd = 30;
      this.crit = 26;
      this.require_param = "DEX";
      this.require_value = 49;
      this.price = 3900;
   }
   function WeaponKatarAra4()
   {
      this.NAME = "Gece Gölgesi";
      this.dmg = 22;
      this.rnd = 44;
      this.crit = 29;
      this.require_param = "DEX";
      this.require_value = 66;
      this.price = 5250;
   }
   function WeaponKatarAra5()
   {
      this.NAME = "Suikastçı Jur";
      this.dmg = 32;
      this.rnd = 64;
      this.crit = 32;
      this.require_param = "DEX";
      this.require_value = 82;
      this.price = 6550;
   }
   function WeaponKatarAra6()
   {
      this.NAME = "Suikastçının Gücü";
      this.dmg = 47;
      this.rnd = 93;
      this.crit = 35;
      this.require_param = "DEX";
      this.require_value = 99;
      this.price = 7900;
   }
   function WeaponBowViz1()
   {
      this.NAME = "Uzun Yay";
      this.dmg = 13;
      this.rnd = 14;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 1100;
   }
   function WeaponBowViz2()
   {
      this.NAME = "Kaliteli Yay";
      this.dmg = 24;
      this.rnd = 26;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 3000;
   }
   function WeaponBowViz3()
   {
      this.NAME = "Akrep";
      this.dmg = 45;
      this.rnd = 48;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 65;
      this.price = 4850;
   }
   function WeaponBowViz4()
   {
      this.NAME = "Çift Yay";
      this.dmg = 85;
      this.rnd = 91;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 90;
      this.price = 6750;
   }
   function WeaponBowGer1()
   {
      this.NAME = "Piyade Yayı";
      this.dmg = 10;
      this.rnd = 11;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 13;
      this.price = 950;
   }
   function WeaponBowGer2()
   {
      this.NAME = "Dövme Yay";
      this.dmg = 19;
      this.rnd = 21;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 35;
      this.price = 2600;
   }
   function WeaponBowGer3()
   {
      this.NAME = "Kemik Yay";
      this.dmg = 36;
      this.rnd = 39;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 58;
      this.price = 4350;
   }
   function WeaponBowGer4()
   {
      this.NAME = "Altın Kemikler";
      this.dmg = 68;
      this.rnd = 73;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 80;
      this.price = 6000;
   }
   function WeaponBowRus1()
   {
      this.NAME = "Muhafız Yayı";
      this.dmg = 15;
      this.rnd = 16;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 16;
      this.price = 1200;
   }
   function WeaponBowRus2()
   {
      this.NAME = "Kutsal Yay";
      this.dmg = 29;
      this.rnd = 31;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 44;
      this.price = 3300;
   }
   function WeaponBowRus3()
   {
      this.NAME = "Antilop";
      this.dmg = 54;
      this.rnd = 58;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 71;
      this.price = 5300;
   }
   function WeaponBowRus4()
   {
      this.NAME = "Bıçaklı Yay";
      this.dmg = 101;
      this.rnd = 109;
      this.crit = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 99;
      this.price = 7400;
   }
   function WeaponBowJap1()
   {
      this.NAME = "Avcı Yayı";
      this.dmg = 11;
      this.rnd = 12;
      this.crit = 15;
      this.aspd_bonus = 5;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 14;
      this.price = 1050;
   }
   function WeaponBowJap2()
   {
      this.NAME = "Asker Yayı";
      this.dmg = 21;
      this.rnd = 23;
      this.crit = 15;
      this.aspd_bonus = 5;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 37;
      this.price = 2750;
   }
   function WeaponBowJap3()
   {
      this.NAME = "Ninja Yayı";
      this.dmg = 40;
      this.rnd = 44;
      this.crit = 15;
      this.aspd_bonus = 5;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 61;
      this.price = 4550;
   }
   function WeaponBowJap4()
   {
      this.NAME = "Samuray Yayı";
      this.dmg = 76;
      this.rnd = 82;
      this.crit = 15;
      this.aspd_bonus = 5;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 85;
      this.price = 6350;
   }
   function WeaponBowMon1()
   {
      this.NAME = "Tahta Yay";
      this.dmg = 14;
      this.rnd = 15;
      this.crit = 20;
      this.aspd_bonus = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 1100;
   }
   function WeaponBowMon2()
   {
      this.NAME = "Atlı Yayı";
      this.dmg = 26;
      this.rnd = 28;
      this.crit = 20;
      this.aspd_bonus = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 41;
      this.price = 3050;
   }
   function WeaponBowMon3()
   {
      this.NAME = "Gezgin Yayı";
      this.dmg = 49;
      this.rnd = 53;
      this.crit = 20;
      this.aspd_bonus = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 68;
      this.price = 5100;
   }
   function WeaponBowMon4()
   {
      this.NAME = "Han'ın Yayı";
      this.dmg = 93;
      this.rnd = 100;
      this.crit = 20;
      this.aspd_bonus = 10;
      this.rng = 14;
      this.require_param = "DEX";
      this.require_value = 94;
      this.price = 7050;
   }
   function WeaponCrossbowViz1()
   {
      this.NAME = "Hafif Arbalet";
      this.dmg = 18;
      this.rnd = 36;
      this.crit = 72;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 16;
      this.price = 1400;
   }
   function WeaponCrossbowViz2()
   {
      this.NAME = "Orta Arbalet";
      this.dmg = 34;
      this.rnd = 68;
      this.crit = 83;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 44;
      this.price = 3950;
   }
   function WeaponCrossbowViz3()
   {
      this.NAME = "Seçkin Arbalet";
      this.dmg = 64;
      this.rnd = 128;
      this.crit = 94;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 71;
      this.price = 6350;
   }
   function WeaponCrossbowViz4()
   {
      this.NAME = "Dikenli Arbalet";
      this.dmg = 120;
      this.rnd = 240;
      this.crit = 105;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 99;
      this.price = 8900;
   }
   function WeaponCrossbowGer1()
   {
      this.NAME = "Uzun Arbalet";
      this.dmg = 15;
      this.rnd = 30;
      this.crit = 65;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 1300;
   }
   function WeaponCrossbowGer2()
   {
      this.NAME = "Çelik Arbalet";
      this.dmg = 28;
      this.rnd = 56;
      this.crit = 75;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 3550;
   }
   function WeaponCrossbowGer3()
   {
      this.NAME = "Dövme Arbalet";
      this.dmg = 53;
      this.rnd = 106;
      this.crit = 85;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 65;
      this.price = 5800;
   }
   function WeaponCrossbowGer4()
   {
      this.NAME = "Ölü Arbalet";
      this.dmg = 100;
      this.rnd = 200;
      this.crit = 95;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 90;
      this.price = 8050;
   }
   function WeaponCrossbowRus1()
   {
      this.NAME = "Avcı Arbaleti";
      this.dmg = 12;
      this.rnd = 24;
      this.crit = 52;
      this.aspd_bonus = 5;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 13;
      this.price = 1150;
   }
   function WeaponCrossbowRus2()
   {
      this.NAME = "Asker Arbaleti";
      this.dmg = 23;
      this.rnd = 45;
      this.crit = 60;
      this.aspd_bonus = 5;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 35;
      this.price = 3100;
   }
   function WeaponCrossbowRus3()
   {
      this.NAME = "Muhafız Arbaleti";
      this.dmg = 43;
      this.rnd = 85;
      this.crit = 68;
      this.aspd_bonus = 5;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 58;
      this.price = 5200;
   }
   function WeaponCrossbowRus4()
   {
      this.NAME = "Parlak Arbalet";
      this.dmg = 80;
      this.rnd = 160;
      this.crit = 76;
      this.aspd_bonus = 5;
      this.rng = 18;
      this.require_param = "DEX";
      this.require_value = 80;
      this.price = 7150;
   }
   function WeaponThrowingViz1()
   {
      this.NAME = "Yanıcı Yağ";
      this.dmg = 43;
      this.rnd = 58;
      this.crit = 20;
      this.aspd_bonus = -20;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 45;
      this.price = 2900;
   }
   function WeaponThrowingViz2()
   {
      this.NAME = "Rum Ateşi";
      this.dmg = 59;
      this.rnd = 79;
      this.crit = 20;
      this.aspd_bonus = -20;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 82;
      this.price = 5300;
   }
   function WeaponThrowingGer1()
   {
      this.NAME = "Çelik Atma Bıçağı";
      this.dmg = 16;
      this.rnd = 22;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 950;
   }
   function WeaponThrowingGer2()
   {
      this.NAME = "Gümüş Atma Bıçağı";
      this.dmg = 22;
      this.rnd = 30;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 27;
      this.price = 1750;
   }
   function WeaponThrowingGer3()
   {
      this.NAME = "Günahkârlar";
      this.dmg = 30;
      this.rnd = 41;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 2550;
   }
   function WeaponThrowingGer4()
   {
      this.NAME = "Kutsal Dokunuşlar";
      this.dmg = 42;
      this.rnd = 56;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 52;
      this.price = 3350;
   }
   function WeaponThrowingGer5()
   {
      this.NAME = "Kutsal Dikenler";
      this.dmg = 57;
      this.rnd = 77;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 65;
      this.price = 4200;
   }
   function WeaponThrowingGer6()
   {
      this.NAME = "Aziz Dikenleri";
      this.dmg = 79;
      this.rnd = 105;
      this.crit = 15;
      this.aspd_bonus = 10;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 77;
      this.price = 5000;
   }
   function WeaponThrowingRus1()
   {
      this.NAME = "Küçük Atma Baltası";
      this.dmg = 22;
      this.rnd = 29;
      this.crit = 2;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 15;
      this.price = 950;
   }
   function WeaponThrowingRus2()
   {
      this.NAME = "Yuvarlak Atma Baltası";
      this.dmg = 30;
      this.rnd = 40;
      this.crit = 2;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 27;
      this.price = 1750;
   }
   function WeaponThrowingRus3()
   {
      this.NAME = "Tomahavklar";
      this.dmg = 41;
      this.rnd = 54;
      this.crit = 2;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 40;
      this.price = 2550;
   }
   function WeaponThrowingRus4()
   {
      this.NAME = "Kutsal Yumruklar";
      this.dmg = 56;
      this.rnd = 74;
      this.crit = 2;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 52;
      this.price = 3350;
   }
   function WeaponThrowingRus5()
   {
      this.NAME = "Testere Atma Baltası";
      this.dmg = 77;
      this.rnd = 102;
      this.crit = 2;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 65;
      this.price = 4200;
   }
   function WeaponThrowingRus6()
   {
      this.NAME = "Ayı Pençeleri";
      this.dmg = 105;
      this.rnd = 140;
      this.crit = 2;
      this.rng = 8;
      this.require_param = "STR";
      this.require_value = 77;
      this.price = 5000;
   }
   function WeaponThrowingJap1()
   {
      this.NAME = "Şuriken";
      this.dmg = 14;
      this.rnd = 19;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 15;
      this.price = 950;
   }
   function WeaponThrowingJap2()
   {
      this.NAME = "Gümüş Şuriken";
      this.dmg = 19;
      this.rnd = 26;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 27;
      this.price = 1750;
   }
   function WeaponThrowingJap3()
   {
      this.NAME = "Ronin Şurikeni";
      this.dmg = 26;
      this.rnd = 35;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 40;
      this.price = 2550;
   }
   function WeaponThrowingJap4()
   {
      this.NAME = "Parlak Şuriken";
      this.dmg = 36;
      this.rnd = 48;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 52;
      this.price = 3350;
   }
   function WeaponThrowingJap5()
   {
      this.NAME = "Kara Ruhlar";
      this.dmg = 50;
      this.rnd = 66;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 65;
      this.price = 4200;
   }
   function WeaponThrowingJap6()
   {
      this.NAME = "Fırtına Ruhları";
      this.dmg = 68;
      this.rnd = 91;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 77;
      this.price = 5000;
   }
   function WeaponThrowingJap7()
   {
      this.NAME = "Beyaz Hayaletler";
      this.dmg = 94;
      this.rnd = 125;
      this.crit = 25;
      this.aspd_bonus = 20;
      this.rng = 8;
      this.require_param = "DEX";
      this.require_value = 90;
      this.price = 5800;
   }
   function WeaponOnehandedSwordRog1()
   {
      this.NAME = "Ucuz Kılıç";
      this.dmg = 7;
      this.rnd = 6;
      this.crit = 4;
      this.price = 20;
   }
   function WeaponOnehandedSwordRog2()
   {
      this.NAME = "Paslı Kılıç";
      this.dmg = 8;
      this.rnd = 7;
      this.crit = 4;
      this.price = 20;
   }
   function WeaponTwohandedSwordRog1()
   {
      this.NAME = "Ucuz İki Elli Kılıç";
      this.dmg = 10;
      this.rnd = 9;
      this.crit = 4;
      this.price = 20;
   }
   function WeaponTwohandedSwordRog2()
   {
      this.NAME = "Paslı İki Elli Kılıç";
      this.dmg = 13;
      this.rnd = 11;
      this.crit = 4;
      this.price = 20;
   }
   function WeaponOnehandedAxeRog1()
   {
      this.NAME = "Ucuz Balta";
      this.dmg = 10;
      this.rnd = 6;
      this.crit = 3;
      this.price = 20;
   }
   function WeaponOnehandedAxeRog2()
   {
      this.NAME = "Bronz Balta";
      this.dmg = 12;
      this.rnd = 7;
      this.crit = 2;
      this.price = 20;
   }
   function WeaponTwohandedAxeRog1()
   {
      this.NAME = "Yarıcı";
      this.dmg = 15;
      this.rnd = 8;
      this.crit = 3;
      this.price = 20;
   }
   function WeaponTwohandedAxeRog2()
   {
      this.NAME = "Paslı İki Elli Balta";
      this.dmg = 18;
      this.rnd = 10;
      this.crit = 2;
      this.price = 20;
   }
   function WeaponOnehandedMaceRog1()
   {
      this.NAME = "Tahta Sopa";
      this.dmg = 6;
      this.rnd = 2;
      this.crit = 30;
      this.price = 20;
   }
   function WeaponOnehandedMaceRog2()
   {
      this.NAME = "Ucuz Sopa";
      this.dmg = 7;
      this.rnd = 3;
      this.crit = 25;
      this.price = 20;
   }
   function WeaponTwohandedMaceRog1()
   {
      this.NAME = "Paslı İki Elli Topuz";
      this.dmg = 8;
      this.rnd = 4;
      this.crit = 30;
      this.price = 20;
   }
   function WeaponTwohandedMaceRog2()
   {
      this.NAME = "Tahta İki Elli Sopa";
      this.dmg = 10;
      this.rnd = 5;
      this.crit = 25;
      this.price = 20;
   }
   function WeaponNinjaToRog1()
   {
      this.NAME = "Paslı Ninja-To";
      this.dmg = 3;
      this.rnd = 12;
      this.crit = 13;
      this.price = 20;
   }
   function WeaponNinjaToRog2()
   {
      this.NAME = "Ucuz Ninja-To";
      this.dmg = 3;
      this.rnd = 15;
      this.crit = 11;
      this.price = 20;
   }
   function WeaponKatanaRog1()
   {
      this.NAME = "Paslı Katana";
      this.dmg = 4;
      this.rnd = 18;
      this.crit = 13;
      this.price = 20;
   }
   function WeaponKatanaRog2()
   {
      this.NAME = "Ucuz Katana";
      this.dmg = 5;
      this.rnd = 23;
      this.crit = 11;
      this.price = 20;
   }
   function WeaponShieldViz1()
   {
      this.NAME = "Muhafız";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 15;
      this.crit = 10;
      this.price = 200;
   }
   function WeaponShieldViz2()
   {
      this.NAME = "Piyade Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 35;
      this.crit = 15;
      this.price = 450;
   }
   function WeaponShieldViz3()
   {
      this.NAME = "Süvari Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 55;
      this.crit = 20;
      this.price = 900;
   }
   function WeaponShieldViz4()
   {
      this.NAME = "Komutan Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 75;
      this.crit = 25;
      this.price = 2000;
   }
   function WeaponShieldGer1()
   {
      this.NAME = "Küçük Kalkancık";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 25;
      this.crit = 12;
      this.price = 250;
   }
   function WeaponShieldGer2()
   {
      this.NAME = "Yaya Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 45;
      this.crit = 17;
      this.price = 600;
   }
   function WeaponShieldGer3()
   {
      this.NAME = "Şövalye Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 85;
      this.crit = 22;
      this.price = 1500;
   }
   function WeaponShieldGer4()
   {
      this.NAME = "Haçlı Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 95;
      this.crit = 27;
      this.price = 2500;
   }
   function WeaponShieldRus1()
   {
      this.NAME = "Ahşap Kalkancık";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 10;
      this.crit = 8;
      this.price = 100;
   }
   function WeaponShieldRus2()
   {
      this.NAME = "Demir Kalkancık";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 28;
      this.crit = 13;
      this.price = 300;
   }
   function WeaponShieldRus3()
   {
      this.NAME = "Kahraman Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 70;
      this.crit = 21;
      this.price = 1300;
   }
   function WeaponShieldRus4()
   {
      this.NAME = "Kutsal Kalkan";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "CON";
      this.require_value = 100;
      this.crit = 30;
      this.price = 10000;
   }
   function WeaponShieldMon1()
   {
      this.NAME = "Demir Kalkancık";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "DEX";
      this.require_value = 12;
      this.crit = 9;
      this.price = 100;
   }
   function WeaponShieldMon2()
   {
      this.NAME = "Sağlam Kalkancık";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "DEX";
      this.require_value = 24;
      this.crit = 14;
      this.price = 300;
   }
   function WeaponShieldMon3()
   {
      this.NAME = "Atlı Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "DEX";
      this.require_value = 50;
      this.crit = 21;
      this.price = 1300;
   }
   function WeaponShieldMon4()
   {
      this.NAME = "Gezgin Kalkanı";
      this.dmg = 0;
      this.rnd = 0;
      this.rng = 0;
      this.skill = "none";
      this.require_param = "DEX";
      this.require_value = 80;
      this.crit = 24;
      this.price = 10000;
   }
}
