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
      this.NATION = Town.getNation(townID);
      this.NAME = WorldMap.getTownName(townID);
      this["Town" + townID]();
      var _loc3_ = Town.getLevel(this.ID);
      this.addArmorToStore(_loc3_);
      if(_loc3_ > 2)
      {
         this.addUnitToBarracks("caster",1);
      }
      if(_loc3_ > 4)
      {
         this.addUnitToBarracks("caster",2);
      }
      this.barn.push(new Horse("any",10 * _loc3_,Math.floor(_loc3_ / 2),2 + Math.floor(_loc3_ / 2),1000 * _loc3_));
      this.barn.push(new Horse("any",20 * _loc3_,Math.floor(_loc3_ / 1.7),Math.floor(_loc3_ / 2),750 * _loc3_ * _loc3_));
      this.barn.push(new Horse("black",75 * _loc3_,Math.floor(_loc3_ * 1.1),1,2000 * _loc3_ * _loc3_));
      this.barn.push(new Horse("white",50 * _loc3_,Math.floor(_loc3_ * 0.6),_loc3_,1900 * _loc3_ * _loc3_));
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
      var _loc5_ = 0;
      var _loc4_;
      while(_loc5_ < this.adv_defenders.length)
      {
         _loc4_ = 0;
         while(_loc4_ < this.adv_defenders[_loc5_].COUNT)
         {
            _global.ENEMIES.push(this.adv_defenders[_loc5_].getUnit());
            _loc4_ = _loc4_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
      var _loc6_ = Town.getLevel(this.ID);
      if(_loc6_ == 6 && _root.percent(25) || _loc6_ == 7 && _root.percent(50) || _loc6_ == 8)
      {
         _global.EVIL_HERO = new Hero();
         _global.EVIL_HERO["enemy" + this.NATION + "King"]();
      }
   }
   function setBattleMap()
   {
      switch(this.ID)
      {
         case "Caesarea":
         case "Veii":
         case "Palmyra":
            _global.BATTLE_MAP = 16;
            break;
         case "Tyrus":
         case "Artaxata":
         case "Seleucia":
         case "Treveri":
         case "Curia":
            _global.BATTLE_MAP = 20;
            break;
         case "Grobben":
         case "Torburg":
         case "Dortmund":
            _global.BATTLE_MAP = 0;
            break;
         case "Odense":
         case "Holmgard":
         case "Skara":
         case "Lunde":
         case "Risby":
            _global.BATTLE_MAP = 4;
            break;
         case "RaGorod":
         case "Zlatograd":
         case "Dobrov":
            _global.BATTLE_MAP = 8;
            break;
         case "Grouzeno":
         case "Krasnodolye":
         case "Svetlolesye":
         case "Staroe":
         case "Elki":
            _global.BATTLE_MAP = 12;
            break;
         case "Nagoya":
         case "Izumo":
         case "Matsuyama":
            _global.BATTLE_MAP = 24;
            break;
         case "Omi":
         case "Echigo":
         case "Sapporo":
         case "Suo":
         case "Nara":
            _global.BATTLE_MAP = 28;
            break;
         case "Cardiff":
         case "Armagh":
         case "Kells":
            _global.BATTLE_MAP = 32;
            break;
         case "Iona":
         case "Tara":
         case "Swansea":
         case "Llanelli":
         case "Neath":
            _global.BATTLE_MAP = 36;
            break;
         case "Tiflis":
         case "Medina":
         case "Mosul":
            _global.BATTLE_MAP = 40;
            break;
         case "Samarra":
         case "Mahdia":
         case "Shiraz":
         case "Rabat":
         case "Aden":
            _global.BATTLE_MAP = 44;
      }
      _global.BATTLE_MAP += _root.d(4);
   }
   static function getNation(townID)
   {
      switch(townID)
      {
         case "Caesarea":
         case "Veii":
         case "Palmyra":
         case "Tyrus":
         case "Artaxata":
         case "Seleucia":
         case "Treveri":
         case "Curia":
            return "Viz";
         case "Grobben":
         case "Torburg":
         case "Dortmund":
         case "Odense":
         case "Holmgard":
         case "Skara":
         case "Lunde":
         case "Risby":
            return "Ger";
         case "RaGorod":
         case "Zlatograd":
         case "Dobrov":
         case "Grouzeno":
         case "Krasnodolye":
         case "Svetlolesye":
         case "Staroe":
         case "Elki":
            return "Rus";
         case "Nagoya":
         case "Izumo":
         case "Matsuyama":
         case "Omi":
         case "Echigo":
         case "Sapporo":
         case "Suo":
         case "Nara":
            return "Jap";
         case "Cardiff":
         case "Armagh":
         case "Kells":
         case "Iona":
         case "Tara":
         case "Swansea":
         case "Llanelli":
         case "Neath":
            return "Mon";
         case "Tiflis":
         case "Medina":
         case "Mosul":
         case "Samarra":
         case "Mahdia":
         case "Shiraz":
         case "Rabat":
         case "Aden":
            return "Ara";
         default:
            return;
      }
   }
   static function getFullName(townID)
   {
      switch(townID)
      {
         case "Caesarea":
            return "Görkemli Caesarea şehri, Büyük Ticaret Cumhuriyeti'nin başkenti";
         case "Veii":
            return "Muhteşem Veii şehri, Cumhuriyet'in kültür merkezi";
         case "Palmyra":
            return "Büyük Palmyra kasabası, Cumhuriyet'in doğu limanı";
         case "Tyrus":
            return "Tyrus kasabası, Cumhuriyet'in kuzey karakolu";
         case "Artaxata":
            return "Büyük Artaxata ticaret kampı";
         case "Seleucia":
            return "Seleucia ticaret kampı";
         case "Treveri":
            return "Küçük Treveri limanı";
         case "Curia":
            return "Ufak Curia kampı";
         case "Grobben":
            return "Görkemli Grobben şehri, Tarikat'ın başkenti";
         case "Torburg":
            return "Büyük Torburg şehri, Tarikat'ın ticaret merkezi";
         case "Dortmund":
            return "Kuzeydeki Dortmund kasabası, Tarikat'ın kalesi";
         case "Odense":
            return "Ticaret kasabası Odense";
         case "Holmgard":
            return "Holmgard kasabası, dağ karakolu";
         case "Skara":
            return "Skara köyü, doğu karakolu";
         case "Lunde":
            return "Küçük Lunde köyü, güney karakolu";
         case "Risby":
            return "Ufak Risby köyü";
         case "RaGorod":
            return "Görkemli RaGorod şehri, Orman Diyarı'nın başkenti";
         case "Zlatograd":
            return "Büyük Zlatograd şehri, Diyar'ın ticaret merkezi";
         case "Dobrov":
            return "Dobrov kasabası, Diyar'ın batı kalesi";
         case "Grouzeno":
            return "Kocaman Grouzeno köyü, Diyar'ın doğu kalesi";
         case "Krasnodolye":
            return "Büyük Krasnodolye köyü";
         case "Svetlolesye":
            return "Svetlolesye köyü, Diyar'ın doğu limanı";
         case "Staroe":
            return "Küçük Staroe köyü";
         case "Elki":
            return "Ufak balıkçı köyü Elki";
         case "Nagoya":
            return "Görkemli Nagoya şehri, Doğu İmparatorluğu'nun başkenti";
         case "Izumo":
            return "Büyük Izumo şehri, İmparatorluğun ticaret merkezi";
         case "Matsuyama":
            return "Matsuyama şehri, ninja eğitim merkezi";
         case "Omi":
            return "Küçük Omi kasabası, İmparatorluğun dövüş sanatları merkezi";
         case "Echigo":
            return "Büyük Echigo köyü, İmparatorluğun güney limanı";
         case "Sapporo":
            return "Sapporo köyü, İmparatorluğun kuzey limanı";
         case "Suo":
            return "Küçük Suo köyü";
         case "Nara":
            return "Ufak balıkçı köyü Nara";
         case "Cardiff":
            return "Görkemli Cardiff kampı, Kara Orda'nın başkenti";
         case "Armagh":
            return "Büyük Armagh kampı, Orda'nın ana limanı";
         case "Kells":
            return "Büyük Kells ticaret kampı";
         case "Iona":
            return "Iona kampı, Orda'nın doğu kalesi";
         case "Tara":
            return "Tara kampı, Orda'nın eğitim merkezi";
         case "Swansea":
            return "Swansea kampı, Orda'nın limanı";
         case "Llanelli":
            return "Küçük balıkçı köyü Llanelli";
         case "Neath":
            return "Ufak Neath kampı, Orda'nın kuzey karakolu";
         case "Tiflis":
            return "Görkemli Tiflis şehri, Güney Çölü'nün başkenti";
         case "Medina":
            return "Muhteşem Medina şehri, Güney Çölü'nün kültür merkezi";
         case "Mosul":
            return "Büyük Mosul kasabası, suikastçı akademisi";
         case "Samarra":
            return "Liman kasabası Samarra";
         case "Mahdia":
            return "Mahdia vahası, Güney Çölü'nün ticaret karakolu";
         case "Shiraz":
            return "Shiraz köyü, kumlarda kaybolmuş küçük vaha";
         case "Rabat":
            return "Küçük Rabat limanı";
         case "Aden":
            return "Ufak çöl köyü Aden";
         default:
            return;
      }
   }
   static function hasHarbor(townID)
   {
      switch(townID)
      {
         case "Veii":
         case "Palmyra":
         case "Artaxata":
         case "Treveri":
         case "Zlatograd":
         case "Krasnodolye":
         case "Svetlolesye":
         case "Staroe":
         case "Elki":
         case "Nagoya":
         case "Izumo":
         case "Matsuyama":
         case "Omi":
         case "Echigo":
         case "Sapporo":
         case "Suo":
         case "Nara":
         case "Armagh":
         case "Tara":
         case "Swansea":
         case "Llanelli":
         case "Neath":
         case "Medina":
         case "Mosul":
         case "Samarra":
         case "Rabat":
            return true;
         default:
            return false;
      }
   }
   static function getLevel(townID)
   {
      switch(townID)
      {
         case "Caesarea":
         case "Grobben":
         case "RaGorod":
         case "Nagoya":
         case "Cardiff":
         case "Tiflis":
            return 8;
         case "Veii":
         case "Torburg":
         case "Zlatograd":
         case "Izumo":
         case "Armagh":
         case "Medina":
            return 7;
         case "Palmyra":
         case "Dortmund":
         case "Dobrov":
         case "Matsuyama":
         case "Kells":
         case "Mosul":
            return 6;
         case "Tyrus":
         case "Odense":
         case "Grouzeno":
         case "Omi":
         case "Iona":
         case "Samarra":
            return 5;
         case "Artaxata":
         case "Holmgard":
         case "Krasnodolye":
         case "Echigo":
         case "Tara":
         case "Mahdia":
            return 4;
         case "Seleucia":
         case "Skara":
         case "Svetlolesye":
         case "Sapporo":
         case "Swansea":
         case "Shiraz":
            return 3;
         case "Treveri":
         case "Lunde":
         case "Staroe":
         case "Suo":
         case "Llanelli":
         case "Rabat":
            return 2;
         case "Curia":
         case "Risby":
         case "Elki":
         case "Nara":
         case "Neath":
         case "Aden":
            return 1;
         default:
            return;
      }
   }
   function addUnitToBarracks(tp, id)
   {
      this.barracks.push(new UnitInfo(Town.getNation(this.ID),tp,id));
   }
   function addWeaponsToStore(arr, lv)
   {
      var _loc2_ = 0;
      while(_loc2_ < arr.length)
      {
         this.forge.push(new ItemInfo("WeaponClass",arr[_loc2_],Town.getNation(this.ID),lv));
         _loc2_ = _loc2_ + 1;
      }
   }
   function addArmorToStore(lv)
   {
      this.forge.push(new ItemInfo("Armor","Clothes",Town.getNation(this.ID),lv));
      this.forge.push(new ItemInfo("Armor","Helmet",Town.getNation(this.ID),lv));
   }
   function addDefenders(tp, id, am)
   {
      this.defenders.push(new UnitInfo(Town.getNation(this.ID),tp,id,am));
   }
   function addAdvDefenders(tp, id, am)
   {
      this.adv_defenders.push(new UnitInfo(Town.getNation(this.ID),tp,id,am));
   }
   function TownCaesarea()
   {
      this.addUnitToBarracks("2H_sword",7);
      this.addUnitToBarracks("shield",7);
      this.addUnitToBarracks("throwing",2);
      this.addUnitToBarracks("bow",6);
      this.addUnitToBarracks("crossbow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],7);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],6);
      this.addWeaponsToStore(["Spear"],5);
      this.addWeaponsToStore(["Throwing"],2);
      this.addWeaponsToStore(["Bow","Crossbow","Shield"],4);
      this.addDefenders("shield",7,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_sword",7,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("shield",7,5);
      this.addDefenders("dagger",6,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_sword",7,5);
      this.addAdvDefenders("2H_sword",7,5);
      this.addAdvDefenders("crossbow",6,4);
   }
   function TownVeii()
   {
      this.addUnitToBarracks("2H_sword",6);
      this.addUnitToBarracks("dagger",6);
      this.addUnitToBarracks("throwing",2);
      this.addUnitToBarracks("bow",6);
      this.addUnitToBarracks("crossbow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","OnehandedAxe","TwohandedAxe","OnehandedMace","TwohandedMace","Dagger"],6);
      this.addWeaponsToStore(["Spear"],5);
      this.addWeaponsToStore(["Bow","Crossbow","Shield"],4);
      this.addDefenders("2H_sword",6,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("dual",5,10);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("dagger",6,5);
      this.addDefenders("bow",6,5);
      this.addAdvDefenders("2H_sword",7,5);
      this.addAdvDefenders("bow",6,5);
   }
   function TownPalmyra()
   {
      this.addUnitToBarracks("2H_sword",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("spear",5);
      this.addUnitToBarracks("throwing",0);
      this.addUnitToBarracks("bow",4);
      this.addUnitToBarracks("crossbow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","OnehandedAxe","TwohandedAxe","OnehandedMace","TwohandedMace","Dagger"],5);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],4);
      this.addDefenders("spear",5,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("2H_sword",5,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("dual",5,5);
      this.addDefenders("bow",4,5);
      this.addAdvDefenders("2H_sword",6,5);
      this.addAdvDefenders("bow",4,5);
   }
   function TownTyrus()
   {
      this.addUnitToBarracks("shield",4);
      this.addUnitToBarracks("spear",4);
      this.addUnitToBarracks("bow",4);
      this.addUnitToBarracks("crossbow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","OnehandedAxe","TwohandedAxe","OnehandedMace","TwohandedMace","Dagger"],4);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],3);
      this.addDefenders("shield",4,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("spear",4,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("dagger",3,5);
      this.addDefenders("crossbow",4,5);
   }
   function TownArtaxata()
   {
      this.addUnitToBarracks("shield",3);
      this.addUnitToBarracks("spear",3);
      this.addUnitToBarracks("dagger",3);
      this.addUnitToBarracks("bow",2);
      this.addUnitToBarracks("crossbow",2);
      this.addWeaponsToStore(["Spear"],2);
      this.addWeaponsToStore(["OnehandedSword","OnehandedAxe","OnehandedMace","TwohandedSword","TwohandedAxe","TwohandedMace","Dagger","Bow","Crossbow","Shield"],3);
      this.addDefenders("shield",3,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("spear",3,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("dagger",3,5);
      this.addDefenders("crossbow",2,5);
   }
   function TownSeleucia()
   {
      this.addUnitToBarracks("dagger",3);
      this.addUnitToBarracks("2H_axe",2);
      this.addUnitToBarracks("dual",2);
      this.addUnitToBarracks("spear",1);
      this.addUnitToBarracks("bow",2);
      this.addUnitToBarracks("crossbow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],3);
      this.addWeaponsToStore(["OnehandedAxe","TwohandedAxe","TwohandedMace","OnehandedMace","Spear","Dagger","Bow","Crossbow","Shield"],2);
      this.addDefenders("2H_axe",2,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("dual",2,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("dagger",3,2);
   }
   function TownTreveri()
   {
      this.addUnitToBarracks("2H_axe",2);
      this.addUnitToBarracks("dagger",3);
      this.addUnitToBarracks("shield",0);
      this.addUnitToBarracks("spear",1);
      this.addUnitToBarracks("bow",0);
      this.addUnitToBarracks("crossbow",0);
      this.addWeaponsToStore(["Spear"],1);
      this.addWeaponsToStore(["OnehandedSword","OnehandedAxe","OnehandedMace","TwohandedSword","TwohandedAxe","TwohandedMace","Dagger","Bow","Crossbow","Shield"],2);
      this.addDefenders("shield",0,5);
      this.addDefenders("bow",0,5);
      this.addDefenders("spear",1,4);
      this.addDefenders("crossbow",0,4);
      this.addDefenders("2H_axe",2,2);
   }
   function TownCuria()
   {
      this.addUnitToBarracks("shield",0);
      this.addUnitToBarracks("bow",0);
      this.addUnitToBarracks("crossbow",0);
      this.addWeaponsToStore(["OnehandedSword","OnehandedAxe","OnehandedMace","TwohandedSword","TwohandedAxe","TwohandedMace","Dagger","Bow","Crossbow","Shield"],1);
      this.addDefenders("shield",0,5);
      this.addDefenders("bow",0,5);
      this.addDefenders("spear",1,5);
      this.addDefenders("bow",0,5);
   }
   function TownGrobben()
   {
      this.addUnitToBarracks("2H_sword",7);
      this.addUnitToBarracks("spear",7);
      this.addUnitToBarracks("shield",6);
      this.addUnitToBarracks("2H_axe",6);
      this.addUnitToBarracks("throwing",5);
      this.addUnitToBarracks("crossbow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],7);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace","Throwing"],6);
      this.addWeaponsToStore(["Bow","Crossbow","Shield"],4);
      this.addWeaponsToStore(["Spear"],5);
      this.addDefenders("2H_axe",6,5);
      this.addDefenders("spear",7,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("2H_sword",7,10);
      this.addDefenders("crossbow",6,5);
      this.addAdvDefenders("2H_sword",7,5);
      this.addAdvDefenders("spear",7,5);
   }
   function TownTorburg()
   {
      this.addUnitToBarracks("shield",6);
      this.addUnitToBarracks("2H_axe",6);
      this.addUnitToBarracks("spear",4);
      this.addUnitToBarracks("throwing",5);
      this.addUnitToBarracks("crossbow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],6);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],6);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],4);
      this.addDefenders("shield",6,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("shield",5,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("2H_axe",6,5);
      this.addDefenders("crossbow",6,5);
      this.addAdvDefenders("2H_sword",7,5);
      this.addDefenders("crossbow",6,5);
   }
   function TownDortmund()
   {
      this.addUnitToBarracks("shield",5);
      this.addUnitToBarracks("2H_sword",4);
      this.addUnitToBarracks("spear",4);
      this.addUnitToBarracks("dual",4);
      this.addUnitToBarracks("throwing",5);
      this.addUnitToBarracks("bow",3);
      this.addUnitToBarracks("crossbow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],5);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],5);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],3);
      this.addDefenders("shield",5,5);
      this.addDefenders("spear",4,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("2H_sword",4,5);
      this.addDefenders("throwing",5,5);
      this.addDefenders("dual",4,5);
      this.addAdvDefenders("shield",6,5);
      this.addAdvDefenders("throwing",5,5);
   }
   function TownOdense()
   {
      this.addUnitToBarracks("2H_sword",4);
      this.addUnitToBarracks("spear",4);
      this.addUnitToBarracks("dual",4);
      this.addUnitToBarracks("throwing",3);
      this.addUnitToBarracks("bow",3);
      this.addUnitToBarracks("crossbow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],4);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],4);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],3);
      this.addDefenders("spear",4,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("2H_sword",4,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("dual",4,5);
   }
   function TownHolmgard()
   {
      this.addUnitToBarracks("shield",3);
      this.addUnitToBarracks("spear",3);
      this.addUnitToBarracks("throwing",3);
      this.addUnitToBarracks("bow",3);
      this.addUnitToBarracks("crossbow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],3);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],4);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],2);
      this.addDefenders("spear",3,5);
      this.addDefenders("bow",3,5);
      this.addDefenders("shield",3,5);
      this.addDefenders("throwing",3,5);
      this.addDefenders("spear",2,5);
   }
   function TownSkara()
   {
      this.addUnitToBarracks("shield",2);
      this.addUnitToBarracks("2H_axe",2);
      this.addUnitToBarracks("spear",2);
      this.addUnitToBarracks("throwing",1);
      this.addUnitToBarracks("bow",1);
      this.addUnitToBarracks("crossbow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],2);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],3);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],2);
      this.addDefenders("spear",2,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("shield",2,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("2H_axe",2,5);
   }
   function TownLunde()
   {
      this.addUnitToBarracks("shield",1);
      this.addUnitToBarracks("2H_axe",1);
      this.addUnitToBarracks("throwing",1);
      this.addUnitToBarracks("bow",1);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],2);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],2);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],1);
      this.addDefenders("2H_sword",0,5);
      this.addDefenders("bow",1,5);
      this.addDefenders("shield",1,5);
      this.addDefenders("throwing",1,5);
      this.addDefenders("2H_axe",1,5);
   }
   function TownRisby()
   {
      this.addUnitToBarracks("2H_sword",0);
      this.addUnitToBarracks("bow",1);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],1);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],1);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],1);
      this.addDefenders("2H_sword",0,5);
      this.addDefenders("bow",1,5);
      this.addDefenders("shield",1,5);
      this.addDefenders("throwing",1,5);
      this.addDefenders("2H_axe",1,5);
   }
   function TownRaGorod()
   {
      this.addUnitToBarracks("2H_sword",7);
      this.addUnitToBarracks("2H_axe",7);
      this.addUnitToBarracks("spear",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("bow",6);
      this.addUnitToBarracks("throwing",5);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],7);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace","Throwing"],6);
      this.addWeaponsToStore(["Bow","Crossbow","Shield"],4);
      this.addWeaponsToStore(["Spear"],5);
      this.addDefenders("2H_axe",7,5);
      this.addDefenders("2H_sword",7,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_sword",7,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_axe",7,5);
      this.addDefenders("bow",6,5);
      this.addAdvDefenders("2H_axe",7,10);
      this.addAdvDefenders("2H_sword",7,5);
   }
   function TownZlatograd()
   {
      this.addUnitToBarracks("2H_axe",6);
      this.addUnitToBarracks("spear",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("bow",6);
      this.addUnitToBarracks("throwing",5);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],6);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],6);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],4);
      this.addDefenders("2H_axe",6,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_axe",6,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("dual",5,5);
      this.addDefenders("bow",6,5);
      this.addAdvDefenders("2H_sword",7,5);
      this.addAdvDefenders("bow",4,5);
   }
   function TownDobrov()
   {
      this.addUnitToBarracks("shield",4);
      this.addUnitToBarracks("spear",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("bow",4);
      this.addUnitToBarracks("throwing",5);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],5);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],5);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],3);
      this.addDefenders("spear",5,5);
      this.addDefenders("throwing",5,5);
      this.addDefenders("dual",5,5);
      this.addDefenders("throwing",5,5);
      this.addDefenders("dual",5,5);
      this.addDefenders("throwing",5,5);
      this.addAdvDefenders("2H_axe",6,5);
      this.addAdvDefenders("bow",6,5);
   }
   function TownGrouzeno()
   {
      this.addUnitToBarracks("shield",4);
      this.addUnitToBarracks("spear",4);
      this.addUnitToBarracks("bow",4);
      this.addUnitToBarracks("throwing",3);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],4);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],4);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],3);
      this.addDefenders("spear",4,5);
      this.addDefenders("shield",4,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("spear",4,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("shield",4,5);
   }
   function TownKrasnodolye()
   {
      this.addUnitToBarracks("shield",3);
      this.addUnitToBarracks("dual",3);
      this.addUnitToBarracks("crossbow",1);
      this.addUnitToBarracks("bow",2);
      this.addUnitToBarracks("throwing",3);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],3);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],4);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],2);
      this.addDefenders("shield",3,5);
      this.addDefenders("throwing",3,5);
      this.addDefenders("dual",3,5);
      this.addDefenders("throwing",3,5);
      this.addDefenders("dual",3,5);
   }
   function TownSvetlolesye()
   {
      this.addUnitToBarracks("shield",2);
      this.addUnitToBarracks("2H_axe",1);
      this.addUnitToBarracks("crossbow",1);
      this.addUnitToBarracks("bow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],2);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],3);
      this.addWeaponsToStore(["Spear","Bow","Crossbow","Shield"],2);
      this.addDefenders("shield",2,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("shield",2,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("shield",2,5);
      this.addDefenders("bow",2,5);
   }
   function TownStaroe()
   {
      this.addUnitToBarracks("2H_sword",0);
      this.addUnitToBarracks("2H_axe",0);
      this.addUnitToBarracks("2H_axe",1);
      this.addUnitToBarracks("crossbow",1);
      this.addUnitToBarracks("bow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],2);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],2);
      this.addWeaponsToStore(["Bow","Crossbow","Shield"],1);
      this.addDefenders("2H_sword",0,10);
      this.addDefenders("crossbow",1,5);
      this.addDefenders("2H_axe",0,5);
      this.addDefenders("crossbow",1,5);
      this.addDefenders("2H_axe",1,5);
   }
   function TownElki()
   {
      this.addUnitToBarracks("2H_sword",0);
      this.addUnitToBarracks("2H_axe",0);
      this.addUnitToBarracks("bow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Throwing"],1);
      this.addWeaponsToStore(["OnehandedAxe","OnehandedMace","TwohandedAxe","TwohandedMace"],1);
      this.addWeaponsToStore(["Bow","Crossbow","Shield"],1);
      this.addDefenders("2H_sword",0,10);
      this.addDefenders("crossbow",1,5);
      this.addDefenders("2H_axe",0,5);
      this.addDefenders("crossbow",1,5);
      this.addDefenders("2H_axe",1,5);
   }
   function TownNagoya()
   {
      this.addUnitToBarracks("katana",7);
      this.addUnitToBarracks("katana",8);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("staff",6);
      this.addUnitToBarracks("bow",5);
      this.addUnitToBarracks("throwing",7);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],8);
      this.addWeaponsToStore(["Throwing"],7);
      this.addWeaponsToStore(["Bow"],4);
      this.addDefenders("katana",7,5);
      this.addDefenders("throwing",7,5);
      this.addDefenders("staff",6,5);
      this.addDefenders("throwing",7,5);
      this.addDefenders("staff",6,15);
      this.addDefenders("katana",7,5);
      this.addAdvDefenders("katana",8,9);
   }
   function TownIzumo()
   {
      this.addUnitToBarracks("katana",6);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("staff",6);
      this.addUnitToBarracks("bow",5);
      this.addUnitToBarracks("throwing",6);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],7);
      this.addWeaponsToStore(["Throwing"],6);
      this.addWeaponsToStore(["Bow"],4);
      this.addDefenders("katana",6,5);
      this.addDefenders("throwing",6,5);
      this.addDefenders("staff",6,5);
      this.addDefenders("throwing",6,5);
      this.addDefenders("katana",6,5);
      this.addDefenders("staff",6,5);
      this.addAdvDefenders("katana",7,5);
      this.addAdvDefenders("throwing",6,5);
   }
   function TownMatsuyama()
   {
      this.addUnitToBarracks("katana",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("staff",5);
      this.addUnitToBarracks("bow",5);
      this.addUnitToBarracks("throwing",4);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],6);
      this.addWeaponsToStore(["Throwing"],5);
      this.addWeaponsToStore(["Bow"],3);
      this.addDefenders("katana",5,5);
      this.addDefenders("bow",5,5);
      this.addDefenders("dual",5,5);
      this.addDefenders("bow",5,5);
      this.addDefenders("staff",5,5);
      this.addAdvDefenders("katana",6,5);
   }
   function TownOmi()
   {
      this.addUnitToBarracks("katana",4);
      this.addUnitToBarracks("dual",4);
      this.addUnitToBarracks("staff",4);
      this.addUnitToBarracks("bow",3);
      this.addUnitToBarracks("throwing",4);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],5);
      this.addWeaponsToStore(["Throwing"],5);
      this.addWeaponsToStore(["Bow"],3);
      this.addDefenders("katana",4,5);
      this.addDefenders("throwing",4,5);
      this.addDefenders("dual",4,5);
      this.addDefenders("throwing",4,5);
      this.addDefenders("staff",4,5);
   }
   function TownEchigo()
   {
      this.addUnitToBarracks("katana",3);
      this.addUnitToBarracks("dual",3);
      this.addUnitToBarracks("staff",3);
      this.addUnitToBarracks("bow",3);
      this.addUnitToBarracks("throwing",3);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],4);
      this.addWeaponsToStore(["Throwing"],4);
      this.addWeaponsToStore(["Bow"],2);
      this.addDefenders("katana",3,3);
      this.addDefenders("bow",3,3);
      this.addDefenders("dual",3,4);
      this.addDefenders("throwing",3,5);
      this.addDefenders("staff",3,5);
   }
   function TownSapporo()
   {
      this.addUnitToBarracks("katana",2);
      this.addUnitToBarracks("staff",2);
      this.addUnitToBarracks("bow",2);
      this.addUnitToBarracks("throwing",1);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],3);
      this.addWeaponsToStore(["Throwing"],3);
      this.addWeaponsToStore(["Bow"],2);
      this.addDefenders("katana",2,5);
      this.addDefenders("throwing",1,5);
      this.addDefenders("staff",2,5);
      this.addDefenders("bow",2,5);
   }
   function TownSuo()
   {
      this.addUnitToBarracks("fists",1);
      this.addUnitToBarracks("staff",1);
      this.addUnitToBarracks("bow",1);
      this.addUnitToBarracks("throwing",1);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],2);
      this.addWeaponsToStore(["Throwing"],2);
      this.addWeaponsToStore(["Bow"],1);
      this.addDefenders("fists",2,5);
      this.addDefenders("throwing",1,5);
      this.addDefenders("staff",1,3);
      this.addDefenders("bow",1,2);
   }
   function TownNara()
   {
      this.addUnitToBarracks("fists",1);
      this.addUnitToBarracks("staff",1);
      this.addUnitToBarracks("throwing",0);
      this.addWeaponsToStore(["Katana","NinjaTo","Staff"],1);
      this.addWeaponsToStore(["Throwing"],1);
      this.addDefenders("fists",1,5);
      this.addDefenders("throwing",0,5);
      this.addDefenders("staff",1,5);
      this.addDefenders("bow",1,5);
   }
   function TownCardiff()
   {
      this.addUnitToBarracks("shield",7);
      this.addUnitToBarracks("2H_sword",7);
      this.addUnitToBarracks("dual",7);
      this.addUnitToBarracks("dagger",6);
      this.addUnitToBarracks("bow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],7);
      this.addWeaponsToStore(["Bow","Shield"],4);
      this.addDefenders("shield",7,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_sword",7,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("dual",7,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("dual",7,5);
      this.addDefenders("2H_sword",7,5);
      this.addAdvDefenders("shield",7,5);
      this.addAdvDefenders("bow",6,5);
      this.addAdvDefenders("shield",7,5);
      this.addAdvDefenders("bow",6,5);
   }
   function TownArmagh()
   {
      this.addUnitToBarracks("shield",6);
      this.addUnitToBarracks("2H_sword",6);
      this.addUnitToBarracks("dual",6);
      this.addUnitToBarracks("dagger",6);
      this.addUnitToBarracks("bow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],6);
      this.addWeaponsToStore(["Bow","Shield"],4);
      this.addDefenders("shield",6,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("2H_sword",6,5);
      this.addDefenders("dagger",6,5);
      this.addDefenders("bow",6,5);
      this.addDefenders("dual",6,5);
      this.addAdvDefenders("shield",7,5);
      this.addAdvDefenders("bow",6,5);
   }
   function TownKells()
   {
      this.addUnitToBarracks("shield",5);
      this.addUnitToBarracks("2H_sword",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("dagger",5);
      this.addUnitToBarracks("bow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],5);
      this.addWeaponsToStore(["Bow","Shield"],3);
      this.addDefenders("shield",5,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("2H_sword",5,5);
      this.addDefenders("dagger",5,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("dual",5,5);
      this.addAdvDefenders("shield",6,5);
      this.addAdvDefenders("bow",4,5);
   }
   function TownIona()
   {
      this.addUnitToBarracks("shield",4);
      this.addUnitToBarracks("2H_sword",4);
      this.addUnitToBarracks("dual",4);
      this.addUnitToBarracks("dagger",4);
      this.addUnitToBarracks("bow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],4);
      this.addWeaponsToStore(["Bow","Shield"],3);
      this.addDefenders("shield",4,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("2H_sword",4,5);
      this.addDefenders("dagger",4,5);
      this.addDefenders("bow",4,5);
      this.addDefenders("dual",4,5);
   }
   function TownTara()
   {
      this.addUnitToBarracks("shield",3);
      this.addUnitToBarracks("2H_sword",3);
      this.addUnitToBarracks("dual",3);
      this.addUnitToBarracks("dagger",3);
      this.addUnitToBarracks("bow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],4);
      this.addWeaponsToStore(["Bow","Shield"],2);
      this.addDefenders("shield",3,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("2H_sword",3,5);
      this.addDefenders("dagger",3,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("dual",3,5);
   }
   function TownSwansea()
   {
      this.addUnitToBarracks("shield",2);
      this.addUnitToBarracks("2H_sword",2);
      this.addUnitToBarracks("dual",2);
      this.addUnitToBarracks("dagger",2);
      this.addUnitToBarracks("bow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],3);
      this.addWeaponsToStore(["Bow","Shield"],2);
      this.addDefenders("shield",2,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("2H_sword",2,5);
      this.addDefenders("dagger",2,5);
      this.addDefenders("bow",2,5);
      this.addDefenders("dual",2,5);
   }
   function TownLlanelli()
   {
      this.addUnitToBarracks("shield",1);
      this.addUnitToBarracks("dual",1);
      this.addUnitToBarracks("2H_sword",0);
      this.addUnitToBarracks("dagger",0);
      this.addUnitToBarracks("bow",0);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],2);
      this.addWeaponsToStore(["Bow","Shield"],1);
      this.addDefenders("2H_sword",0,4);
      this.addDefenders("bow",0,4);
      this.addDefenders("shield",1,3);
      this.addDefenders("dagger",0,2);
      this.addDefenders("bow",0,3);
      this.addDefenders("dual",1,3);
   }
   function TownNeath()
   {
      this.addUnitToBarracks("2H_sword",0);
      this.addUnitToBarracks("dagger",0);
      this.addUnitToBarracks("bow",0);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword","Dagger"],1);
      this.addWeaponsToStore(["Bow","Shield"],1);
      this.addDefenders("2H_sword",0,4);
      this.addDefenders("bow",0,4);
      this.addDefenders("shield",1,3);
      this.addDefenders("dagger",0,2);
      this.addDefenders("bow",0,3);
      this.addDefenders("dual",1,5);
   }
   function TownTiflis()
   {
      this.addUnitToBarracks("2H_sword",7);
      this.addUnitToBarracks("dual",7);
      this.addUnitToBarracks("katar",7);
      this.addUnitToBarracks("crossbow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],7);
      this.addWeaponsToStore(["Katar"],6);
      this.addDefenders("dual",7,5);
      this.addDefenders("katar",7,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("2H_sword",7,10);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("katar",7,5);
      this.addAdvDefenders("katar",7,10);
      this.addAdvDefenders("dual",7,5);
      this.addAdvDefenders("2H_sword",7,5);
   }
   function TownMedina()
   {
      this.addUnitToBarracks("2H_sword",6);
      this.addUnitToBarracks("dual",6);
      this.addUnitToBarracks("katar",6);
      this.addUnitToBarracks("crossbow",6);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],6);
      this.addWeaponsToStore(["Katar"],5);
      this.addDefenders("dual",6,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("2H_sword",6,5);
      this.addDefenders("crossbow",6,5);
      this.addDefenders("katar",6,10);
      this.addAdvDefenders("katar",7,10);
   }
   function TownMosul()
   {
      this.addUnitToBarracks("2H_sword",5);
      this.addUnitToBarracks("dual",5);
      this.addUnitToBarracks("katar",5);
      this.addUnitToBarracks("crossbow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],5);
      this.addWeaponsToStore(["Katar"],5);
      this.addDefenders("dual",5,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("2H_sword",5,5);
      this.addDefenders("crossbow",4,10);
      this.addDefenders("katar",5,5);
      this.addAdvDefenders("dual",6,5);
      this.addAdvDefenders("crossbow",6,5);
   }
   function TownSamarra()
   {
      this.addUnitToBarracks("2H_sword",4);
      this.addUnitToBarracks("dual",4);
      this.addUnitToBarracks("katar",4);
      this.addUnitToBarracks("crossbow",4);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],4);
      this.addWeaponsToStore(["Katar"],4);
      this.addDefenders("dual",4,10);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("2H_sword",4,5);
      this.addDefenders("crossbow",4,5);
      this.addDefenders("katar",4,5);
   }
   function TownMahdia()
   {
      this.addUnitToBarracks("2H_sword",3);
      this.addUnitToBarracks("dual",3);
      this.addUnitToBarracks("katar",3);
      this.addUnitToBarracks("crossbow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],3);
      this.addWeaponsToStore(["Katar"],3);
      this.addDefenders("dual",3,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("2H_sword",3,5);
      this.addDefenders("crossbow",2,10);
      this.addDefenders("katar",3,5);
   }
   function TownShiraz()
   {
      this.addUnitToBarracks("2H_sword",2);
      this.addUnitToBarracks("dual",2);
      this.addUnitToBarracks("katar",1);
      this.addUnitToBarracks("crossbow",2);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],2);
      this.addWeaponsToStore(["Katar"],3);
      this.addDefenders("dual",2,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("2H_sword",2,5);
      this.addDefenders("crossbow",2,5);
      this.addDefenders("katar",1,5);
   }
   function TownRabat()
   {
      this.addUnitToBarracks("2H_sword",1);
      this.addUnitToBarracks("dual",0);
      this.addUnitToBarracks("katar",1);
      this.addUnitToBarracks("crossbow",0);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],2);
      this.addWeaponsToStore(["Katar"],2);
      this.addDefenders("dual",0,3);
      this.addDefenders("2H_sword",1,2);
      this.addDefenders("crossbow",0,5);
      this.addDefenders("katar",1,4);
   }
   function TownAden()
   {
      this.addUnitToBarracks("dual",0);
      this.addUnitToBarracks("crossbow",0);
      this.addWeaponsToStore(["OnehandedSword","TwohandedSword"],1);
      this.addWeaponsToStore(["Katar"],1);
      this.addDefenders("dual",0,5);
      this.addDefenders("2H_sword",1,5);
      this.addDefenders("crossbow",0,5);
      this.addDefenders("katar",1,5);
   }
}
