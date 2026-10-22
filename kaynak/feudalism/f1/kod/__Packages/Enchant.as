class Enchant extends Object
{
   var ID;
   var hero_amount;
   var hero_bonus;
   var prefix;
   var price_bonus;
   var suffix;
   var wpn_amount;
   var wpn_bonus;
   function Enchant(en_id)
   {
      super();
      this.wpn_bonus = new Array();
      this.wpn_amount = new Array();
      this.hero_bonus = new Array();
      this.hero_amount = new Array();
      this.ID = en_id;
      this["init" + en_id]();
   }
   function init1()
   {
      this.prefix = "Piercing ";
      this.suffix = "";
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(10);
      this.price_bonus = 1.2;
   }
   function init2()
   {
      this.prefix = "Bloody ";
      this.suffix = "";
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(10);
      this.price_bonus = 1.2;
   }
   function init3()
   {
      this.prefix = "Bleeding ";
      this.suffix = "";
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(20);
      this.price_bonus = 1.5;
   }
   function init4()
   {
      this.prefix = "";
      this.suffix = " of Massacre";
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(10);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(20);
      this.price_bonus = 2;
   }
   function init5()
   {
      this.prefix = "Creeping ";
      this.suffix = "";
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(30);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.8);
      this.price_bonus = 3;
   }
   function init6()
   {
      this.prefix = "Strong ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(20);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(1.2);
      this.price_bonus = 2;
   }
   function init7()
   {
      this.prefix = "Cursed ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(-5);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(30);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(0.5);
      this.price_bonus = 0.5;
   }
   function init8()
   {
      this.prefix = "Undead ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(20);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(50);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(0.7);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(0.5);
      this.price_bonus = 2.2;
   }
   function init9()
   {
      this.prefix = "Unholy ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(100);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(200);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(0.1);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(2.5);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.01);
      this.price_bonus = 10;
   }
   function init10()
   {
      this.prefix = "Great ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(20);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(30);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(1.2);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(1.1);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(1.02);
      this.price_bonus = 2.5;
   }
   function init11()
   {
      this.prefix = "Glorious ";
      this.suffix = " of Sacrifice";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(50);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(300);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(0.5);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(0.5);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.8);
      this.price_bonus = 5.5;
   }
   function init12()
   {
      this.prefix = "Glorious ";
      this.suffix = " of Comassion";
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(-15);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(2);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(1.2);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(1.04);
      this.price_bonus = 5.1;
   }
   function init13()
   {
      this.prefix = "Glorious ";
      this.suffix = " of Valor";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(50);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(50);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(1.5);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.3);
      this.price_bonus = 4.3;
   }
   function init14()
   {
      this.prefix = "Immortal ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(-5);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(-10);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(-20);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(-10);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(3);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(2);
      this.price_bonus = 10;
   }
   function init15()
   {
      this.prefix = "Mysterious ";
      this.suffix = " of Death";
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(1000);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(90);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(100);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(0);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(0.2);
      this.price_bonus = 12;
   }
   function init16()
   {
      this.prefix = "Marksman\'s ";
      this.suffix = "";
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(5);
      this.price_bonus = 1.05;
   }
   function init17()
   {
      this.prefix = "Lucky ";
      this.suffix = "";
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(20);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(20);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(20);
      this.price_bonus = 1.8;
   }
   function init18()
   {
      this.prefix = "Sleeping ";
      this.suffix = "";
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(50);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(-5);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(-5);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(1.3);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.9);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(1.3);
      this.price_bonus = 2;
   }
   function init19()
   {
      this.prefix = "Suffering ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(50);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(30);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(30);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(0.7);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(1.02);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(0.7);
      this.price_bonus = 2;
   }
   function init20()
   {
      this.prefix = "Blind ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(30);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(50);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(20);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(-10);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(1.5);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.7);
      this.price_bonus = 2.4;
   }
   function init21()
   {
      this.prefix = "Blind ";
      this.suffix = " of Rage";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(60);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(100);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(40);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(-30);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(1.8);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.4);
      this.price_bonus = 4.4;
   }
   function init22()
   {
      this.prefix = "Breaking ";
      this.suffix = "";
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(70);
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(10);
      this.price_bonus = 3.5;
   }
   function init23()
   {
      this.prefix = "Crushing ";
      this.suffix = "";
      this.wpn_bonus.push("dmg");
      this.wpn_amount.push(100);
      this.wpn_bonus.push("rnd");
      this.wpn_amount.push(200);
      this.wpn_bonus.push("CRIT");
      this.wpn_amount.push(-90);
      this.price_bonus = 3.5;
   }
   function init24()
   {
      this.prefix = "Saint ";
      this.suffix = " of Divine Light";
      this.wpn_bonus.push("HIT");
      this.wpn_amount.push(-40);
      this.hero_bonus.push("DEF");
      this.hero_amount.push(3);
      this.hero_bonus.push("FLEE");
      this.hero_amount.push(0.1);
      this.hero_bonus.push("MAX_HP");
      this.hero_amount.push(3);
      this.price_bonus = 12;
   }
}
