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
      this.NAME = "Ucuz Kılıç";
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
      this.NAME = "Paslı Kılıç";
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
      this.NAME = "Süvari Spathası";
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
      this.NAME = "Önder Kılıcı";
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
      this.NAME = "Yıldız Işıltısı";
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
      this.NAME = "Kısa Kılıç";
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
      this.NAME = "Yaya Kılıcı";
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
      this.NAME = "Uzun Kılıç";
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
      this.NAME = "Melez Kılıç";
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
      this.NAME = "Yıldız Getiren";
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
      this.NAME = "Kesici";
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
      this.NAME = "Uzun Hançer";
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
      this.NAME = "Satır";
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
      this.NAME = "Koruyucu Kılıcı";
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
      this.NAME = "Kara Lanet";
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
      this.NAME = "Ucuz Balta";
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
      this.NAME = "Bronz Balta";
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
      this.NAME = "Ayin Baltası";
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
      this.NAME = "Rahip Baltası";
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
      this.NAME = "Yuvarlak Balta";
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
      this.NAME = "Kıran Balta";
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
      this.NAME = "Küçük Balta";
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
      this.NAME = "Piyade Baltası";
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
      this.NAME = "Geniş Balta";
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
      this.NAME = "Ağır Balta";
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
      this.NAME = "Milis Baltası";
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
      this.NAME = "Uzun Balta";
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
      this.NAME = "Muhafız Baltası";
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
      this.NAME = "Kutsal Balta";
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
      this.NAME = "Tahta Sopa";
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
      this.NAME = "Ucuz Sopa";
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
      this.NAME = "Bronz Sopa";
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
      this.NAME = "Ayin Gürzü";
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
      this.NAME = "Kaba Gürz";
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
      this.NAME = "Parlak Gürz";
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
      this.NAME = "Dikenli Topuz";
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
      this.NAME = "Hafif Gürz";
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
      this.NAME = "Ölümcül Dikenler";
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
      this.NAME = "Barış Bekçisi";
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
      this.NAME = "Dikenli Tahta Sopa";
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
      this.NAME = "Zırh Kıran";
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
      this.NAME = "Ağır Sopa";
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
      this.NAME = "Altın Kirpi";
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
      this.NAME = "Ucuz İki Elli Kılıç";
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
      this.NAME = "Paslı İki Elli Kılıç";
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
      this.NAME = "Demir İki Elli Kılıç";
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
      this.NAME = "Çelik İki Elli Kılıç";
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
      this.NAME = "Pala";
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
      this.NAME = "Ay Işığı";
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
      this.NAME = "Ruh Kıran";
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
      this.NAME = "Hafif İki Elli Kılıç";
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
      this.NAME = "Haçlı İki Elli Kılıcı";
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
      this.NAME = "Şövalye İki Elli Kılıcı";
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
      this.NAME = "Yarasa Yüreği";
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
      this.NAME = "Dövme İki Elli Kılıç";
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
      this.NAME = "Uzun İki Elli Kılıç";
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
      this.NAME = "Büyük İki Elli Kılıç";
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
      this.NAME = "Koruyucu İki Elli Kılıcı";
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
      this.NAME = "Kutsal İki Elli Kılıç";
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
      this.NAME = "Yarıcı";
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
      this.NAME = "Paslı İki Elli Balta";
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
      this.NAME = "Hafif İki Elli Balta";
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
      this.NAME = "Yuvarlak İki Elli Balta";
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
      this.NAME = "Deniz Dalgası";
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
      this.NAME = "Altın İki Elli Balta";
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
      this.NAME = "Çelik İki Elli Balta";
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
      this.NAME = "Kasap";
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
      this.NAME = "Ağır İki Elli Balta";
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
      this.NAME = "Tanrı'nın Pençesi";
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
      this.NAME = "Köylü İki Elli Baltası";
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
      this.NAME = "Cellat";
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
      this.NAME = "Muhafız İki Elli Baltası";
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
      this.NAME = "Seçkin İki Elli Balta";
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
      this.NAME = "Paslı İki Elli Gürz";
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
      this.NAME = "Tahta İki Elli Sopa";
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
      this.NAME = "Bronz İki Elli Gürz";
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
      this.NAME = "Ayin İki Elli Gürzü";
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
      this.NAME = "Ayin Çekici";
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
      this.NAME = "Altın Çekiç";
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
      this.NAME = "Savaş Çekici";
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
      this.NAME = "Çelik İki Elli Gürz";
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
      this.NAME = "Dikenli İki Elli Gürz";
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
      this.NAME = "Kutsal Yıldız";
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
      this.NAME = "Hantal İki Elli Gürz";
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
      this.NAME = "Bronz Çekiç";
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
      this.NAME = "Ağır İki Elli Gürz";
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
      this.NAME = "Kahramanın İki Elli Gürzü";
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
      this.NAME = "Çırak Asası";
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
      this.NAME = "Usta Asası";
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
      this.NAME = "Dikenli Asa";
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
      this.NAME = "Altın Asa";
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
      this.NAME = "Altın Naginata";
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
      this.NAME = "Paslı Ninja-To";
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
      this.NAME = "Ucuz Ninja-To";
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
      this.NAME = "Kısa Ninja-To";
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
      this.NAME = "Çırak Ninja-To'su";
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
      this.NAME = "Asker Ninja-To'su";
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
      this.NAME = "Ronin Ninja-To'su";
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
      this.NAME = "Kutsal Ninja-To";
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
      this.NAME = "Kara Kahraman";
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
      this.NAME = "Paslı Katana";
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
      this.NAME = "Ucuz Katana";
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
      this.NAME = "Kısa Katana";
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
      this.NAME = "Çırak Katanası";
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
      this.NAME = "Asker Katanası";
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
      this.NAME = "Ronin Katanası";
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
      this.NAME = "Kutsal Katana";
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
      this.NAME = "Karanlık";
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
      this.NAME = "Piyade Mızrağı";
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
      this.NAME = "Gelişmiş Mızrak";
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
      this.NAME = "Süvari Mızrağı";
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
      this.NAME = "Milis Mızrağı";
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
      this.NAME = "Yaya Mızrağı";
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
      this.NAME = "Şövalye Mızrağı";
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
      this.NAME = "Bronz Mızrak";
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
      this.NAME = "Kuşatma Mızrağı";
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
      this.NAME = "Kutsal Mızrak";
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
      this.NAME = "Bıçak";
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
      this.NAME = "Hançer";
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
      this.NAME = "Şiş Hançer";
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
      this.NAME = "Şam Çeliği";
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
      this.NAME = "Yanıcı Yağ";
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
      this.NAME = "Rum Ateşi";
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
      this.NAME = "Çelik Atma Bıçağı";
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
      this.NAME = "Gümüş Atma Bıçağı";
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
      this.NAME = "Günahkârlar";
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
      this.NAME = "Kutsal Dokunuşlar";
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
      this.NAME = "Küçük Atma Baltası";
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
      this.NAME = "Yuvarlak Atma Baltası";
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
      this.NAME = "Tomahavklar";
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
      this.NAME = "Altın Yumruklar";
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
      this.NAME = "Şuriken";
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
      this.NAME = "Gümüş Şuriken";
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
      this.NAME = "Ronin Şurikeni";
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
      this.NAME = "Parlak Şuriken";
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
      this.NAME = "Kara Ruhlar";
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
      this.NAME = "Uzun Yay";
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
      this.NAME = "Kaliteli Yay";
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
      this.NAME = "Piyade Yayı";
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
      this.NAME = "Dövme Yay";
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
      this.NAME = "Muhafız Yayı";
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
      this.NAME = "Kutsal Yay";
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
      this.NAME = "Avcı Yayı";
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
      this.NAME = "Asker Yayı";
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
      this.NAME = "Ninja Yayı";
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
      this.NAME = "Samuray Yayı";
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
      this.NAME = "Hafif Arbalet";
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
      this.NAME = "Orta Arbalet";
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
      this.NAME = "Seçkin Arbalet";
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
      this.NAME = "Uzun Arbalet";
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
      this.NAME = "Çelik Arbalet";
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
      this.NAME = "Dövme Arbalet";
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
      this.NAME = "Avcı Arbaleti";
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
      this.NAME = "Asker Arbaleti";
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
      this.NAME = "Muhafız Arbaleti";
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
      this.NAME = "Muhafız";
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
      this.NAME = "Piyade Kalkanı";
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
      this.NAME = "Süvari Kalkanı";
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
      this.NAME = "Küçük Kalkancık";
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
      this.NAME = "Yaya Kalkanı";
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
      this.NAME = "Şövalye Kalkanı";
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
      this.NAME = "Ahşap Kalkancık";
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
      this.NAME = "Demir Kalkancık";
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
      this.NAME = "Kahraman Kalkanı";
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
      this.NAME = "Silahsız";
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
