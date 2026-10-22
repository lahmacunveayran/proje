class WorldMap extends MovieClip
{
   var LANDS;
   var TOWNS;
   var avatar;
   var gox;
   var goy;
   var ground;
   var gui;
   var landAra;
   var landMon;
   var sea;
   var seashore;
   var speed;
   function WorldMap()
   {
      super();
      this.speed = 2;
      this.hideIcons();
      this.TOWNS = new Array();
      this.TOWNS.push("Caesarea");
      this.TOWNS.push("Veii");
      this.TOWNS.push("Palmyra");
      this.TOWNS.push("Tyrus");
      this.TOWNS.push("Artaxata");
      this.TOWNS.push("Seleucia");
      this.TOWNS.push("Treveri");
      this.TOWNS.push("Curia");
      this.TOWNS.push("Grobben");
      this.TOWNS.push("Torburg");
      this.TOWNS.push("Dortmund");
      this.TOWNS.push("Odense");
      this.TOWNS.push("Holmgard");
      this.TOWNS.push("Skara");
      this.TOWNS.push("Lunde");
      this.TOWNS.push("Risby");
      this.TOWNS.push("RaGorod");
      this.TOWNS.push("Zlatograd");
      this.TOWNS.push("Dobrov");
      this.TOWNS.push("Grouzeno");
      this.TOWNS.push("Krasnodolye");
      this.TOWNS.push("Svetlolesye");
      this.TOWNS.push("Staroe");
      this.TOWNS.push("Elki");
      this.TOWNS.push("Nagoya");
      this.TOWNS.push("Izumo");
      this.TOWNS.push("Matsuyama");
      this.TOWNS.push("Omi");
      this.TOWNS.push("Echigo");
      this.TOWNS.push("Sapporo");
      this.TOWNS.push("Suo");
      this.TOWNS.push("Nara");
      this.TOWNS.push("Cardiff");
      this.TOWNS.push("Armagh");
      this.TOWNS.push("Kells");
      this.TOWNS.push("Iona");
      this.TOWNS.push("Tara");
      this.TOWNS.push("Swansea");
      this.TOWNS.push("Llanelli");
      this.TOWNS.push("Neath");
      this.TOWNS.push("Tiflis");
      this.TOWNS.push("Medina");
      this.TOWNS.push("Mosul");
      this.TOWNS.push("Samarra");
      this.TOWNS.push("Mahdia");
      this.TOWNS.push("Shiraz");
      this.TOWNS.push("Rabat");
      this.TOWNS.push("Aden");
      this.LANDS = new Array();
      this.LANDS.push("Viz");
      this.LANDS.push("Ger");
      this.LANDS.push("Rus");
      this.LANDS.push("Jap");
      this.LANDS.push("Mon");
      this.LANDS.push("Ara");
      var _loc3_ = 0;
      while(_loc3_ < this.LANDS.length)
      {
         this["land" + this.LANDS[_loc3_]].stop();
         _loc3_ = _loc3_ + 1;
      }
   }
   static function getTownName(townID)
   {
      var _loc0_;
      if((_loc0_ = townID) !== "RaGorod")
      {
         return townID;
      }
      return "Ra Gorod";
   }
   static function getTownNation(townID)
   {
      return Town.getNation(townID);
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
      while(_loc3_ < 34)
      {
         this["quest_avatar_" + _loc3_]._visible = _loc3_ == _global.QUEST.avatar_id;
         _loc3_ = _loc3_ + 1;
      }
      _loc3_ = 0;
      while(_loc3_ < this.TOWNS.length)
      {
         if(!_global.IS_CAPTURED[this.TOWNS[_loc3_]])
         {
            if(_global.IS_HOSTILE[WorldMap.getTownNation(this.TOWNS[_loc3_])])
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
         while(_loc3_ < this.TOWNS.length)
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
            this.gui.congrats.gotoAndPlay(2);
         }
      }
      this.avatar.gotoAndStop(!_global.SAILING_SHIP ? 2 : 1);
      this._x = 400 - this.avatar._x;
      this._y = 300 - this.avatar._y;
      if(this._x < -400)
      {
         this._x = -400;
      }
      if(this._x > 0)
      {
         this._x = 0;
      }
      if(this._y < -300)
      {
         this._y = -300;
      }
      if(this._y > 0)
      {
         this._y = 0;
      }
      this.gui._x = - this._x;
      this.gui._y = - this._y;
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
      if(this["quest_avatar_" + _global.QUEST.avatar_id].hitTest(this.avatar._x + this._x,this.avatar._y + this._y,false))
      {
         _global.QUEST.prepareBattle();
         _global.BATTLE_TYPE = "QUEST";
         this.startBattle(48 + _root.d(8));
      }
      var _loc4_ = 0;
      while(_loc4_ < this.TOWNS.length)
      {
         if(this[this.TOWNS[_loc4_]].hitTest(this.avatar._x + this._x,this.avatar._y + this._y,false))
         {
            _root.openCity(this.TOWNS[_loc4_]);
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function randomEncounter()
   {
      var _loc9_ = !_global.EASY_MODE ? 200 : 300;
      var _loc7_;
      var _loc8_;
      var _loc5_;
      if(_root.dice(_loc9_) == 0)
      {
         _loc7_ = 1 + _root.d(_global.MAIN_HERO.LEVEL / 4);
         _loc8_ = Math.ceil(_global.MAIN_HERO.LEVEL * 0.8);
         if(_loc7_ > 20)
         {
            _loc7_ = 20;
         }
         delete _global.ENEMIES;
         _global.ENEMIES = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc7_)
         {
            _global.ENEMIES.push(_root.dice(2) != 0 ? Unit.getMeleeRogue(_loc8_) : Unit.getRangedRogue(_loc8_));
            _loc5_ = _loc5_ + 1;
         }
         this.startEncounter();
         return undefined;
      }
      var _loc6_;
      var _loc4_;
      if(!_global.SAILING_SHIP)
      {
         _loc6_ = "";
         _loc4_ = 0;
         while(_loc4_ < this.LANDS.length)
         {
            if(this["land" + this.LANDS[_loc4_]].hitTest(this.avatar._x + this._x,this.avatar._y + this._y,true))
            {
               _loc6_ = this.LANDS[_loc4_];
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_global.IS_HOSTILE[_loc6_] && _root.dice(_loc9_) == 0)
         {
            _loc7_ = Math.round(5 + _root.d(_global.MAIN_HERO.LEVEL) / 2);
            if(_loc7_ > 25)
            {
               _loc7_ = 25;
            }
            delete _global.ENEMIES;
            _global.ENEMIES = new Array();
            _loc5_ = 0;
            while(_loc5_ < Math.min(_loc7_,6))
            {
               _global.ENEMIES.push(Unit.getMeleeMilitia(_loc6_,Math.floor(_global.MAIN_HERO.LEVEL / 8)));
               _loc5_ = _loc5_ + 1;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc7_ - 6)
            {
               _global.ENEMIES.push(Unit.getRangedMilitia(_loc6_,Math.floor(_global.MAIN_HERO.LEVEL / 8)));
               _loc5_ = _loc5_ + 1;
            }
            this.startEncounter();
         }
      }
   }
   function startEncounter()
   {
      _global.BATTLE_TYPE = "ENCOUNTER";
      var _loc4_;
      var _loc5_;
      if(!_global.SAILING_SHIP)
      {
         switch(true)
         {
            case this.seashore.hitTest(this.avatar._x + this._x,this.avatar._y + this._y,true):
               _loc4_ = 80;
               break;
            case this.landAra.hitTest(this.avatar._x + this._x,this.avatar._y + this._y,true):
               _loc4_ = 68;
               break;
            case this.landMon.hitTest(this.avatar._x + this._x,this.avatar._y + this._y,true):
               _loc4_ = 72;
               break;
            default:
               _loc5_ = [54,60,64,88,92,96];
               _loc4_ = _loc5_[_root.dice(6)];
         }
      }
      else
      {
         _loc4_ = 76;
      }
      _loc4_ += _root.d(4);
      this.startBattle(_loc4_);
   }
   function startBattle(battle_map)
   {
      _global.BATTLE_MAP = battle_map;
      _global.CURR_TOWN = null;
      _global.WORLD_MAP_X = this.avatar._x;
      _global.WORLD_MAP_Y = this.avatar._y;
      _root.gotoAndStop("SPLASH_SCREEN");
   }
   function checkPosition()
   {
      var _loc3_ = 40;
      var _loc4_ = 15;
      if(_root._xmouse > 800 - _loc3_)
      {
         this._x -= _loc4_;
         if(this._x < -400)
         {
            this._x = -400;
         }
      }
      if(_root._xmouse < _loc3_)
      {
         this._x += _loc4_;
         if(this._x > 0)
         {
            this._x = 0;
         }
      }
      if(_root._ymouse > 600 - _loc3_)
      {
         this._y -= _loc4_;
         if(this._y < -300)
         {
            this._y = -300;
         }
      }
      if(_root._ymouse < _loc3_)
      {
         this._y += _loc4_;
         if(this._y > 0)
         {
            this._y = 0;
         }
      }
      this.gui._x = - this._x;
      this.gui._y = - this._y;
   }
   function showIcon(icon_name)
   {
      this.gui.sign.gotoAndStop(icon_name);
   }
   function hideIcons()
   {
      this.gui.sign.gotoAndStop("none");
   }
   function onEnterFrame()
   {
      this.checkPosition();
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
         if(!_global.SAILING_SHIP ? this.ground.hitTest(_loc4_ + this._x,_loc3_ + this._y,true) : this.sea.hitTest(_loc4_ + this._x,_loc3_ + this._y,true))
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
