class WorldMap extends MovieClip
{
   var LANDS;
   var TOWNS;
   var avatar;
   var congrats;
   var gox;
   var goy;
   var ground;
   var sea;
   var seashore;
   var speed;
   var temp_hero;
   function WorldMap()
   {
      super();
      this.speed = 2;
      this.TOWNS = new Array();
      this.TOWNS.push("Trapezus");
      this.TOWNS.push("Lutetia");
      this.TOWNS.push("Arretium");
      this.TOWNS.push("Ravenna");
      this.TOWNS.push("Lacrimosa");
      this.TOWNS.push("Caesaria");
      this.TOWNS.push("Carthage");
      this.TOWNS.push("Alexandria");
      this.TOWNS.push("Jana");
      this.TOWNS.push("Konstanz");
      this.TOWNS.push("Gerlitz");
      this.TOWNS.push("Sturmburg");
      this.TOWNS.push("Hoffen");
      this.TOWNS.push("Endem");
      this.TOWNS.push("Braunburg");
      this.TOWNS.push("Wanderburg");
      this.TOWNS.push("Dubkee");
      this.TOWNS.push("Dalnevodye");
      this.TOWNS.push("Losevo");
      this.TOWNS.push("Dobrov");
      this.TOWNS.push("Zlatograd");
      this.TOWNS.push("Medvedevo");
      this.TOWNS.push("Grouzeno");
      this.TOWNS.push("RaGorod");
      this.TOWNS.push("Omi");
      this.TOWNS.push("Kozuke");
      this.TOWNS.push("Matsuyama");
      this.TOWNS.push("Fukushima");
      this.TOWNS.push("Izumo");
      this.TOWNS.push("Suo");
      this.TOWNS.push("Nagoya");
      this.TOWNS.push("Echigo");
      this.LANDS = new Array();
      this.LANDS.push("Viz");
      this.LANDS.push("Ger");
      this.LANDS.push("Rus");
      this.LANDS.push("Jap");
      this.sendData();
   }
   function sendData()
   {
      this.attachMovie(_global.MAIN_HERO.HORSE == null ? "Human_Player" : "Horseman_Player","temp_hero",1,{_x:1000,_y:1000,_visible:false});
      this.temp_hero.initUnit(_global.MAIN_HERO);
      var _loc5_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < this.TOWNS.length)
      {
         if(_global.IS_CAPTURED[this.TOWNS[_loc4_]])
         {
            _loc5_ = _loc5_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      if(!isNaN(_global.MAIN_HERO.LEVEL) && !isNaN(_global.GOLD) && !isNaN(this.temp_hero.wpn.dmg + this.temp_hero.wpn.rnd) && !isNaN(this.temp_hero.MAX_HP))
      {
         _root.kongregateStats.submit("MaxLevel",_global.MAIN_HERO.LEVEL);
         _root.kongregateStats.submit("MaxGold",_global.GOLD);
         _root.kongregateStats.submit("MaxDamage",this.temp_hero.wpn.dmg + this.temp_hero.wpn.rnd);
         _root.kongregateStats.submit("Max HP",this.temp_hero.MAX_HP);
         _root.kongregateStats.submit("TownsControlled",_loc5_);
      }
   }
   function getTownNation(townID)
   {
      switch(townID)
      {
         case "Trapezus":
         case "Lutetia":
         case "Arretium":
         case "Ravenna":
         case "Lacrimosa":
         case "Caesaria":
         case "Carthage":
         case "Alexandria":
            return "Viz";
         case "Jana":
         case "Konstanz":
         case "Gerlitz":
         case "Sturmburg":
         case "Hoffen":
         case "Endem":
         case "Braunburg":
         case "Wanderburg":
            return "Ger";
         case "Dubkee":
         case "Dalnevodye":
         case "Losevo":
         case "Dobrov":
         case "Zlatograd":
         case "Medvedevo":
         case "Grouzeno":
         case "RaGorod":
            return "Rus";
         case "Omi":
         case "Kozuke":
         case "Matsuyama":
         case "Fukushima":
         case "Izumo":
         case "Suo":
         case "Nagoya":
         case "Echigo":
            return "Jap";
         default:
            return;
      }
   }
   function init()
   {
      this.gox = null;
      this.goy = null;
      if(_global.CURR_TOWN != null)
      {
         this.avatar._x = this[_global.CURR_TOWN]._x;
         this.avatar._y = this[_global.CURR_TOWN]._y;
      }
      else
      {
         this.avatar._x = _global.WORLD_MAP_X;
         this.avatar._y = _global.WORLD_MAP_Y;
      }
      var _loc3_ = 0;
      while(_loc3_ < 15)
      {
         this["quest_avatar_" + _loc3_]._visible = _loc3_ == _global.QUEST.avatar_id;
         _loc3_ = _loc3_ + 1;
      }
      _loc3_ = 0;
      while(_loc3_ < this.TOWNS.length)
      {
         if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
         {
            if(_global.IS_HOSTILE[this.getTownNation(this.TOWNS[_loc3_])])
            {
               this[this.TOWNS[_loc3_]].name_txt.textColor = 16711680;
            }
            else
            {
               this[this.TOWNS[_loc3_]].name_txt.textColor = 16777215;
            }
         }
         else
         {
            this[this.TOWNS[_loc3_]].name_txt.textColor = 65280;
         }
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_;
      if(_global.IS_HOSTILE.Viz)
      {
         _loc4_ = true;
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
            {
               _loc4_ = false;
               break;
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_)
         {
            _global.IS_HOSTILE.Viz = false;
         }
      }
      if(_global.IS_HOSTILE.Ger)
      {
         _loc4_ = true;
         _loc3_ = 8;
         while(_loc3_ < 16)
         {
            if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
            {
               _loc4_ = false;
               break;
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_)
         {
            _global.IS_HOSTILE.Ger = false;
         }
      }
      if(_global.IS_HOSTILE.Rus)
      {
         _loc4_ = true;
         _loc3_ = 16;
         while(_loc3_ < 24)
         {
            if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
            {
               _loc4_ = false;
               break;
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_)
         {
            _global.IS_HOSTILE.Rus = false;
         }
      }
      if(_global.IS_HOSTILE.Jap)
      {
         _loc4_ = true;
         _loc3_ = 24;
         while(_loc3_ < 32)
         {
            if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
            {
               _loc4_ = false;
               break;
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_)
         {
            _global.IS_HOSTILE.Jap = false;
         }
      }
      if(!_global.GAME_ENDED)
      {
         _loc4_ = true;
         _loc3_ = 0;
         while(_loc3_ < 32)
         {
            if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
            {
               _loc4_ = false;
               break;
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc4_)
         {
            _global.GAME_ENDED = true;
            this.congrats.gotoAndStop(2);
         }
      }
      this.avatar.gotoAndStop(!_global.SAILING_SHIP ? 2 : 1);
   }
   function onMousePress()
   {
      this.gox = this._xmouse;
      this.goy = this._ymouse;
   }
   function stopMoving()
   {
      this.gox = null;
      this.goy = null;
      if(this["quest_avatar_" + _global.QUEST.avatar_id].hitTest(this.avatar._x,this.avatar._y,false))
      {
         _global.QUEST.prepareBattle();
         _global.BATTLE_TYPE = "QUEST";
         this.startBattle(32 + _root.d(8));
      }
      var _loc4_ = 0;
      while(_loc4_ < this.TOWNS.length)
      {
         if(this[this.TOWNS[_loc4_]].hitTest(this.avatar._x,this.avatar._y,false))
         {
            _root.openCity(this.TOWNS[_loc4_]);
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function randomEncounter()
   {
      var _loc7_;
      var _loc6_;
      if(_root.dice(150) == 0)
      {
         _loc7_ = _root.d(_global.MAIN_HERO.LEVEL + 3);
         if(_loc7_ > 24)
         {
            _loc7_ = 24;
         }
         delete _global.ENEMIES;
         _global.ENEMIES = new Array();
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _global.ENEMIES.push(new Unit(_root.dice(2) != 0 ? "Ranged" : "Melee","Rog",_root.d(3)));
            _loc6_ = _loc6_ + 1;
         }
         this.startEncounter();
         return undefined;
      }
      var _loc4_;
      var _loc5_;
      if(!_global.SAILING_SHIP)
      {
         _loc4_ = 0;
         while(_loc4_ < this.LANDS.length)
         {
            if(this["land" + this.LANDS[_loc4_]].hitTest(this.avatar._x,this.avatar._y,true))
            {
               _loc5_ = this.LANDS[_loc4_];
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_global.IS_HOSTILE[_loc5_] && _root.dice(150) == 0)
         {
            _loc7_ = 8 + _root.d(_global.MAIN_HERO.LEVEL);
            if(_loc7_ > 24)
            {
               _loc7_ = 24;
            }
            delete _global.ENEMIES;
            _global.ENEMIES = new Array();
            _loc6_ = 0;
            while(_loc6_ < Math.min(_loc7_,6))
            {
               _global.ENEMIES.push(new Unit("Melee",_loc5_,1 + _root.d(2)));
               _loc6_ = _loc6_ + 1;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc7_ - 6)
            {
               _global.ENEMIES.push(new Unit("Ranged",_loc5_,_root.d(2) * 2));
               _loc6_ = _loc6_ + 1;
            }
            this.startEncounter();
         }
      }
   }
   function startEncounter()
   {
      _global.BATTLE_TYPE = "ENCOUNTER";
      var _loc5_;
      var _loc4_;
      if(!_global.SAILING_SHIP)
      {
         if(this.seashore.hitTest(this.avatar._x,this.avatar._y,true))
         {
            _loc5_ = 56 + _root.d(4);
         }
         else
         {
            _loc4_ = [10,11,12,16,17,18];
            _loc5_ = _loc4_[_root.dice(6)] * 4 + _root.d(4);
         }
      }
      else
      {
         _loc5_ = 52 + _root.d(4);
      }
      this.startBattle(_loc5_);
   }
   function startBattle(battle_map)
   {
      _global.BATTLE_MAP = battle_map;
      _global.CURR_TOWN = null;
      _global.WORLD_MAP_X = this.avatar._x;
      _global.WORLD_MAP_Y = this.avatar._y;
      _root.gotoAndStop("SPLASH_SCREEN");
   }
   function onEnterFrame()
   {
      var _loc5_;
      var _loc4_;
      var _loc3_;
      if(this.gox != null && this.goy != null)
      {
         _loc5_ = Math.atan2(this.goy - this.avatar._y,this.gox - this.avatar._x);
         _loc4_ = this.avatar._x + this.speed * Math.cos(_loc5_);
         _loc3_ = this.avatar._y + this.speed * Math.sin(_loc5_);
         if(Math.abs(this.avatar._x - this.gox) < this.speed && Math.abs(this.avatar._y - this.goy) < this.speed)
         {
            this.stopMoving();
         }
         if(!_global.SAILING_SHIP ? this.ground.hitTest(_loc4_,_loc3_,true) : this.sea.hitTest(_loc4_,_loc3_,true))
         {
            this.randomEncounter();
            this.avatar._x = _loc4_;
            this.avatar._y = _loc3_;
         }
         else
         {
            this.gox = null;
            this.goy = null;
         }
      }
   }
}
