class Cities extends MovieClip
{
   var barn_btn;
   var barracks_btn;
   var city;
   var forge_btn;
   var hall_btn;
   var harbor_btn;
   var hint;
   var temple_btn;
   var wnd;
   var scrollTrader = 0;
   var scrollUser = 0;
   function Cities()
   {
      super();
      _root.saveGame("auto");
      this.init();
      this.barracks_btn.onRollOver = function()
      {
         if(_global.SHOW_HELP)
         {
            this._parent.hint.gotoAndStop("barracks");
         }
      };
      this.hall_btn.onRollOver = function()
      {
         if(_global.SHOW_HELP)
         {
            this._parent.hint.gotoAndStop("hall");
         }
      };
      this.temple_btn.onRollOver = function()
      {
         if(_global.SHOW_HELP)
         {
            this._parent.hint.gotoAndStop("temple");
         }
      };
      this.barn_btn.onRollOver = function()
      {
         if(_global.SHOW_HELP)
         {
            this._parent.hint.gotoAndStop("barn");
         }
      };
      this.harbor_btn.onRollOver = function()
      {
         if(_global.SHOW_HELP)
         {
            this._parent.hint.gotoAndStop("harbor");
         }
      };
      this.forge_btn.onRollOver = function()
      {
         if(_global.SHOW_HELP)
         {
            this._parent.hint.gotoAndStop("forge");
         }
      };
      this.barracks_btn.onRollOut = this.hall_btn.onRollOut = this.temple_btn.onRollOut = this.barn_btn.onRollOut = this.harbor_btn.onRollOut = function()
      {
         this._parent.hint.gotoAndStop("empty");
      };
   }
   function init()
   {
      this.city = new Town(_global.CURR_TOWN);
      if(_global.SAILING_SHIP)
      {
         _global.SHIP_LOCATION = _global.CURR_TOWN;
         _global.SAILING_SHIP = false;
      }
      this.gotoAndStop(this.getFrame(_global.CURR_TOWN));
      if(!_global.IS_CAPTURED[this.city.ID] && _global.IS_HOSTILE[this.city.NATION])
      {
         this.wnd.gotoAndStop(12);
         this.disableAll();
      }
      else
      {
         this.wnd.gotoAndStop(1);
      }
      this.enableAll();
   }
   function getFrame(townID)
   {
      switch(townID)
      {
         case "Trapezus":
            return 1;
         case "Lutetia":
            return 2;
         case "Arretium":
            return 3;
         case "Ravenna":
            return 4;
         case "Lacrimosa":
            return 5;
         case "Caesaria":
            return 6;
         case "Carthage":
            return 7;
         case "Alexandria":
            return 8;
         case "Jana":
            return 9;
         case "Konstanz":
            return 10;
         case "Gerlitz":
            return 11;
         case "Sturmburg":
            return 12;
         case "Hoffen":
            return 13;
         case "Endem":
            return 14;
         case "Braunburg":
            return 15;
         case "Wanderburg":
            return 16;
         case "Dubkee":
            return 17;
         case "Dalnevodye":
            return 18;
         case "Losevo":
            return 19;
         case "Dobrov":
            return 20;
         case "Zlatograd":
            return 21;
         case "Medvedevo":
            return 22;
         case "Grouzeno":
            return 23;
         case "RaGorod":
            return 24;
         case "Omi":
            return 25;
         case "Kozuke":
            return 26;
         case "Matsuyama":
            return 27;
         case "Fukushima":
            return 28;
         case "Izumo":
            return 29;
         case "Suo":
            return 30;
         case "Nagoya":
            return 31;
         case "Echigo":
            return 32;
         default:
            return;
      }
   }
   function leaveTown()
   {
      _root.gotoAndStop("WORLD_MAP");
   }
   function storeShowTrader()
   {
      var _loc2_ = 0;
      while(_loc2_ < 7)
      {
         if(this.scrollTrader + _loc2_ < this.city.forge.length)
         {
            this.wnd["trader_" + _loc2_].setItem(this.city.forge[this.scrollTrader + _loc2_]);
            this.wnd["trader_" + _loc2_]._visible = this.scrollTrader + _loc2_;
            this.wnd["trader_" + _loc2_]._visible = true;
         }
         else
         {
            this.wnd["trader_" + _loc2_]._visible = false;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function storeShowUser()
   {
      var _loc3_ = 0;
      while(_loc3_ < 7)
      {
         if(this.scrollUser + _loc3_ < _global.INVENTORY.length)
         {
            this.wnd["user_" + _loc3_].setItem(_global.INVENTORY[this.scrollUser + _loc3_]);
            this.wnd["user_" + _loc3_].pos = this.scrollUser + _loc3_;
            this.wnd["user_" + _loc3_]._visible = true;
         }
         else
         {
            this.wnd["user_" + _loc3_]._visible = false;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function barracksShowUser()
   {
      var _loc3_ = 0;
      while(_loc3_ < 10)
      {
         this.wnd["army_" + _loc3_].setUnitClass(_global.FRIENDS[_loc3_]);
         this.wnd["army_" + _loc3_].pos = _loc3_;
         _loc3_ = _loc3_ + 1;
      }
      _loc3_ = 0;
      while(_loc3_ < 8)
      {
         this.wnd["reserve_" + _loc3_].setUnitClass(_global.FRIENDS[_loc3_ + 10 + this.scrollUser]);
         this.wnd["reserve_" + _loc3_].pos = _loc3_ + 10 + this.scrollUser;
         _loc3_ = _loc3_ + 1;
      }
   }
   function barracksShowTrader()
   {
      var _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this.wnd["unit_" + _loc2_].setUnit(this.city.barracks[this.scrollTrader + _loc2_]);
         this.wnd["unit_" + _loc2_].pos = this.scrollTrader + _loc2_;
         _loc2_ = _loc2_ + 1;
      }
   }
   function barnShowTrader()
   {
      this.wnd.hero_ico.setHero(_global.MAIN_HERO);
      var _loc3_ = 0;
      while(_loc3_ < 8)
      {
         this.wnd["unit_" + _loc3_].setHorse(this.city.barn[this.scrollTrader + _loc3_]);
         this.wnd["unit_" + _loc3_].pos = this.scrollTrader + _loc3_;
         _loc3_ = _loc3_ + 1;
      }
      this.wnd.money_txt.text = _global.GOLD + " altın";
   }
   function inventoryShowUser()
   {
      this.wnd.ARMOR_ico.setItem(_global.MAIN_HERO.ARMOR.getItemInfo());
      this.wnd.HELMET_ico.setItem(_global.MAIN_HERO.HELMET.getItemInfo());
      this.wnd.WEAPON_PRI_ico.setItem(_global.MAIN_HERO.WEAPON_PRI.getItemInfo());
      this.wnd.WEAPON_SEC_ico.setItem(_global.MAIN_HERO.WEAPON_SEC.getItemInfo());
      this.wnd.ARMOR_ico.slot = "ARMOR";
      this.wnd.HELMET_ico.slot = "HELMET";
      this.wnd.WEAPON_PRI_ico.slot = "WEAPON_PRI";
      this.wnd.WEAPON_SEC_ico.slot = "WEAPON_SEC";
      this.wnd.hero_ico.setHero(_global.MAIN_HERO);
      var _loc3_ = 0;
      while(_loc3_ < 4)
      {
         if(this.scrollUser + _loc3_ < _global.INVENTORY.length)
         {
            this.wnd["user_" + _loc3_].setItem(_global.INVENTORY[this.scrollUser + _loc3_]);
            this.wnd["user_" + _loc3_].pos = this.scrollUser + _loc3_;
            this.wnd["user_" + _loc3_]._visible = true;
         }
         else
         {
            this.wnd["user_" + _loc3_]._visible = false;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function inventoryShowStats()
   {
      this.wnd.STR_txt.text = _global.MAIN_HERO.STR;
      this.wnd.DEX_txt.text = _global.MAIN_HERO.DEX;
      this.wnd.CON_txt.text = _global.MAIN_HERO.CON;
      this.wnd.INT_txt.text = _global.MAIN_HERO.INT;
      var _loc3_ = _global.MAIN_HERO.free_points >= 2;
      var _loc4_ = 0;
      while(_loc4_ < 4)
      {
         this.wnd["stat_btn_" + _loc4_]._visible = _loc3_;
         _loc4_ = _loc4_ + 1;
      }
      if(_global.MAIN_HERO.STR >= 200)
      {
         this.wnd.stat_btn_0._visible = false;
      }
      if(_global.MAIN_HERO.DEX >= 200)
      {
         this.wnd.stat_btn_1._visible = false;
      }
      if(_global.MAIN_HERO.CON >= 200)
      {
         this.wnd.stat_btn_2._visible = false;
      }
      if(_global.MAIN_HERO.INT >= 200)
      {
         this.wnd.stat_btn_3._visible = false;
      }
      this.wnd.free_points_txt.text = _global.MAIN_HERO.free_points;
      _loc3_ = _global.MAIN_HERO.free_points >= 1;
      for(_loc4_ in _global.MAIN_HERO.SKILL)
      {
         this.wnd[_loc4_ + "_txt"].text = _global.MAIN_HERO.SKILL[_loc4_];
         this.wnd["skill_btn_" + _loc4_]._visible = _global.MAIN_HERO.SKILL[_loc4_] >= 100 ? false : _loc3_;
      }
      if(_global.MAIN_HERO.SKILL.ArtOfWar >= _global.MAIN_HERO.INT * 2)
      {
         this.wnd.skill_btn_ArtOfWar._visible = false;
      }
      if(_global.MAIN_HERO.SKILL.Patriotism >= _global.MAIN_HERO.INT * 2)
      {
         this.wnd.skill_btn_Patriotism._visible = false;
      }
      this.wnd.hero_stats_txt.text = _global.MAIN_HERO.NAME + "\nSeviye " + _global.MAIN_HERO.LEVEL;
   }
   function harborShow()
   {
      if(_global.GOLD < _global.SHIP_PRICE)
      {
         this.wnd.quest_txt.text = "Gemi kiralamaya altının yetmiyor.\n\nBir seferin ücreti: " + _global.SHIP_PRICE + " altın";
         this.wnd.yes_btn._visible = false;
         this.wnd.no_btn._visible = false;
      }
      else
      {
         this.wnd.quest_txt.text = "Bir seferin ücreti: " + _global.SHIP_PRICE + " altın.\nGemiye binmek ister misin?";
         this.wnd.yes_btn._visible = true;
         this.wnd.no_btn._visible = true;
      }
   }
   function dragItemOn(item_info)
   {
      this.wnd.attachMovie("ICON Mouse","drag_item",100,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.drag_item.startDrag(this.wnd.drag_item);
      this.wnd.drag_item.gotoAndStop(item_info.getItem().getIconFrame());
   }
   function dragItemOff()
   {
      this.wnd.drag_item.stopDrag();
      this.wnd.drag_item.removeMovieClip();
   }
   function dragUnitOn(unit_mc)
   {
      this.wnd.attachMovie(!unit_mc.anim.unit_ref.HORSE ? "Human" : "Horseman","drag_item",100,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.drag_item.initUnit(unit_mc.anim.unit_ref);
      this.wnd.drag_item.light_circle._visible = false;
      this.wnd.drag_item.startDrag(this.wnd.drag_item);
   }
   function dragUnitOff()
   {
      this.wnd.drag_item.stopDrag();
      this.wnd.drag_item.removeMovieClip();
   }
   function startBattleForCity()
   {
      _global.BATTLE_TYPE = "SIEGE";
      if(_global.SHIP_LOCATION != _global.CURR_TOWN)
      {
         this.city.setBattleMap();
      }
      else
      {
         _global.BATTLE_MAP = 76 + _root.d(4);
      }
      this.city.getDefenders();
      _global.IS_CAPTURED[_global.CURR_TOWN] = true;
      if(this.city.NATION != _global.MAIN_HERO.NATION)
      {
         _global.IS_HOSTILE[this.city.NATION] = true;
      }
      _root.gotoAndStop("SPLASH_SCREEN");
   }
   function enableAll()
   {
      this.barracks_btn.enabled = true;
      this.hall_btn.enabled = true;
      this.temple_btn.enabled = true;
      this.barn_btn.enabled = true;
      this.harbor_btn.enabled = true;
      this.forge_btn.enabled = true;
   }
   function disableAll()
   {
      this.barracks_btn.enabled = false;
      this.hall_btn.enabled = false;
      this.temple_btn.enabled = false;
      this.barn_btn.enabled = false;
      this.harbor_btn.enabled = false;
      this.forge_btn.enabled = false;
      this.hint.gotoAndStop("empty");
   }
   function openForge()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.gotoAndStop(2);
      this.wnd.money_txt.text = _global.GOLD + " altın";
   }
   function openTemple()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.gotoAndStop(3);
      this.wnd.money_txt.text = _global.GOLD + " altın";
   }
   function openBarracks()
   {
      this.disableAll();
      if(_global.IS_CAPTURED[this.city.ID])
      {
         this.scrollUser = 0;
         this.scrollTrader = 0;
         this.wnd.gotoAndStop(4);
         this.wnd.money_txt.text = _global.GOLD + " altın";
      }
      else
      {
         this.wnd.gotoAndStop(11);
      }
   }
   function openCityHall()
   {
      this.disableAll();
      if(!this.checkReward())
      {
         this.wnd.gotoAndStop(6);
      }
   }
   function openBarn()
   {
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.disableAll();
      this.wnd.gotoAndStop(9);
   }
   function openHeroStats()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.gotoAndStop(5);
   }
   function openGetQuest()
   {
      this.disableAll();
      this.wnd.gotoAndStop(7);
      var _loc4_;
      if(_root.dice(2) == 1)
      {
         _global.QUEST.initQuestBattle(_global.CURR_TOWN);
         this.wnd.quest_txt.text = "Pekâlâ yolcu. Birkaç haydutla başa çıkabilirsin, değil mi?\n\nÖdülün: " + _global.QUEST.curr_gold + " altın";
      }
      else
      {
         _global.QUEST.initQuestFedEx(this.city.ID,this.city.NATION);
         _loc4_ = new Town(_global.QUEST.deliver_to);
         this.wnd.quest_txt.text = "Bir paketi " + _loc4_.NAME + " şehrine götürmemiz gerekiyor. Gider misin?\nŞehre vardığında sana " + _global.QUEST.curr_gold + " altın ödenecek.";
      }
   }
   function openCaptureTown()
   {
      this.disableAll();
      if(_global.IS_CAPTURED[this.city.ID])
      {
         this.wnd.gotoAndStop(13);
      }
      else
      {
         this.wnd.gotoAndStop(15);
      }
   }
   function checkReward()
   {
      var _loc4_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < _global.QUEST.cities.length)
      {
         if(_global.QUEST.cities[_loc3_] == this.city.ID)
         {
            _loc4_ = _global.QUEST.rewards[_loc3_];
            _global.QUEST.rewards.splice(_loc3_,1);
            _global.QUEST.cities.splice(_loc3_,1);
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      if(_loc4_ > 0)
      {
         this.disableAll();
         this.wnd.gotoAndStop(8);
         this.wnd.quest_txt.text = "Aferin yolcu, işini iyi yaptın!\n\nİşte ödülün: " + _loc4_ + " altın";
         _global.GOLD += _loc4_;
         return true;
      }
      return false;
   }
   function openHarbor()
   {
      this.disableAll();
      this.wnd.gotoAndStop(10);
      this.harborShow();
   }
}
