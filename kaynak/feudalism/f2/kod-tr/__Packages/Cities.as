class Cities extends MovieClip
{
   var active_skills_arr;
   var barn_btn;
   var barracks_btn;
   var city;
   var forge_btn;
   var hall_btn;
   var harbor_btn;
   var hint;
   var market_btn;
   var name_txt;
   var nation_mc;
   var temp_hero;
   var temple_btn;
   var wnd;
   var scrollTrader = 0;
   var scrollUser = 0;
   function Cities()
   {
      super();
      this.init();
      this.barracks_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("barracks");
      };
      this.hall_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("hall");
      };
      this.temple_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("temple");
      };
      this.barn_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("barn");
      };
      this.harbor_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("harbor");
      };
      this.forge_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("forge");
      };
      this.market_btn.onRollOver = function()
      {
         this._parent.hint.gotoAndStop("market");
      };
      this.forge_btn.onRollOut = this.market_btn.onRollOut = this.barracks_btn.onRollOut = this.hall_btn.onRollOut = this.temple_btn.onRollOut = this.barn_btn.onRollOut = this.harbor_btn.onRollOut = function()
      {
         this._parent.hint.gotoAndStop("empty");
      };
      this.sendData();
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
      this.name_txt.text = Town.getFullName(_global.CURR_TOWN);
      this.nation_mc.gotoAndStop(Town.getNation(_global.CURR_TOWN));
      var _loc5_ = Town.getLevel(_global.CURR_TOWN);
      var _loc4_ = 1;
      while(_loc4_ <= 8)
      {
         this["star_" + _loc4_]._visible = true;
         this["star_" + _loc4_].gotoAndStop(_loc4_ > _loc5_ ? "off" : "on");
         _loc4_ = _loc4_ + 1;
      }
      if(!_global.IS_CAPTURED[this.city.ID] && _global.IS_HOSTILE[this.city.NATION])
      {
         this.wnd.gotoAndStop("enemy_at_gates");
         this.disableAll();
      }
      else
      {
         _root.saveGame("auto");
         this.wnd.gotoAndStop(1);
         this.enableAll();
      }
   }
   function sendData()
   {
      this.attachMovie(_global.MAIN_HERO.HORSE == null ? "Human_Player" : "Horseman_Player","temp_hero",1,{_x:-1000,_y:-1000,_visible:false});
      this.temp_hero.initUnit(_global.MAIN_HERO);
      var _loc4_ = 0;
      for(var _loc5_ in _global.IS_CAPTURED)
      {
         if(_global.IS_CAPTURED[_loc5_])
         {
            _loc4_ = _loc4_ + 1;
         }
      }
      if(!isNaN(_global.MAIN_HERO.LEVEL) && !isNaN(_global.GOLD) && !isNaN(this.temp_hero.MAX_HP))
      {
         _root.submitStat("MaxLevel",_global.MAIN_HERO.LEVEL);
         _root.submitStat("MaxGold",_global.GOLD);
         _root.submitStat("MaxHP",this.temp_hero.MAX_HP);
         _root.submitStat("TownsControlled",_loc4_);
      }
   }
   function getFrame(townID)
   {
      return 4 * (_root.getNationNumber(Town.getNation(townID)) - 1) + 2 * (!Town.hasHarbor(townID) ? 0 : 1) + (Town.getLevel(townID) >= 6 ? 2 : 1);
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
      this.wnd.refine_anvil.setItem(this.wnd.refine_anvil.item);
      this.wnd.refine_scroll.setItem(this.wnd.refine_scroll.item);
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
      this.showUnitDescription(this.wnd.hero_ico.anim);
      var _loc3_ = 0;
      while(_loc3_ < 6)
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
   function showStats()
   {
      this.wnd.STR_txt.text = _global.MAIN_HERO.STR;
      this.wnd.DEX_txt.text = _global.MAIN_HERO.DEX;
      this.wnd.CON_txt.text = _global.MAIN_HERO.CON;
      this.wnd.SPR_txt.text = _global.MAIN_HERO.SPR;
      var _loc12_ = _global.MAIN_HERO.stat_points >= 2;
      var _loc4_ = 0;
      while(_loc4_ < 4)
      {
         this.wnd["stat_btn_" + _loc4_]._visible = _loc12_;
         _loc4_ = _loc4_ + 1;
      }
      var _loc14_ = !_global.EASY_MODE ? 100 : 200;
      if(_global.MAIN_HERO.STR >= _loc14_ || !_global.EASY_MODE && _global.MAIN_HERO.STR >= 30 + _global.MAIN_HERO.LEVEL * 1.8)
      {
         this.wnd.stat_btn_0._visible = false;
      }
      if(_global.MAIN_HERO.DEX >= _loc14_ || !_global.EASY_MODE && _global.MAIN_HERO.DEX >= 30 + _global.MAIN_HERO.LEVEL * 1.8)
      {
         this.wnd.stat_btn_1._visible = false;
      }
      if(_global.MAIN_HERO.CON >= _loc14_ || !_global.EASY_MODE && _global.MAIN_HERO.CON >= 30 + _global.MAIN_HERO.LEVEL * 1.8)
      {
         this.wnd.stat_btn_2._visible = false;
      }
      if(_global.MAIN_HERO.SPR >= _loc14_ || !_global.EASY_MODE && _global.MAIN_HERO.SPR >= 30 + _global.MAIN_HERO.LEVEL * 1.8)
      {
         this.wnd.stat_btn_3._visible = false;
      }
      this.wnd.stat_points_txt.text = _global.MAIN_HERO.stat_points;
      this.wnd.skill_points_txt.text = _global.MAIN_HERO.skill_points;
      _loc12_ = _global.MAIN_HERO.stat_points >= 1;
      for(_loc4_ in _global.MAIN_HERO.SKILL)
      {
         this.wnd[_loc4_ + "_txt"].text = _global.MAIN_HERO.SKILL[_loc4_];
         this.wnd["skill_btn_" + _loc4_]._visible = _global.MAIN_HERO.SKILL[_loc4_] < 100 && _loc12_;
      }
      _loc4_ = 1;
      delete this.active_skills_arr;
      this.active_skills_arr = new Array();
      var _loc3_;
      var _loc6_;
      var _loc8_;
      var _loc5_;
      var _loc7_;
      for(var _loc13_ in _global.MAIN_HERO.ACTIVE_SKILLS)
      {
         this.active_skills_arr.push(_loc13_);
         this.wnd["active_" + _loc4_ + "_txt"].text = Skill.getSkilltypeDescr(_loc13_);
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc6_ = this.wnd["active_" + _loc4_ + "_ico_" + (_loc3_ + 1)];
            _loc6_.useHandCursor = false;
            _loc8_ = _global.MAIN_HERO.ACTIVE_SKILLS[_loc13_][_loc3_];
            _loc5_ = Skill.getSkillRequire(_loc13_,_loc3_ + 1);
            if(_loc3_ == 0)
            {
               _loc7_ = 0;
            }
            else
            {
               _loc7_ = _global.MAIN_HERO.ACTIVE_SKILLS[_loc13_][_loc3_ - 1];
               this.wnd["active_" + _loc4_ + "_pre_" + (_loc3_ + 1) + "_txt"].text = "Sv. " + _loc5_;
            }
            _loc6_.gotoAndStop(Skill.getActiveSkillFrame(_loc13_,_loc3_ + 1));
            _loc6_.shade.gotoAndStop(_loc5_ <= _loc7_ ? 3 : 1);
            _loc6_.amount_txt.text = _loc8_ > 0 ? _loc8_ : "";
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      _loc4_ = 0;
      var _loc11_;
      var _loc10_;
      var _loc9_;
      while(_loc4_ < 6)
      {
         _loc11_ = _global.MAIN_HERO.PASSIVE_SKILLS[_loc4_][0];
         _loc8_ = _global.MAIN_HERO.PASSIVE_SKILLS[_loc4_][1];
         _loc10_ = Math.floor(_loc4_ / 3) + 1;
         _loc9_ = _loc4_ % 3 + 1;
         _loc6_ = this.wnd["passive_" + _loc10_ + "_ico_" + _loc9_];
         _loc6_.useHandCursor = false;
         _loc6_.gotoAndStop(Skill.getPassiveSkillFrame(_loc11_));
         _loc6_.amount_txt.text = _loc8_ > 0 ? _loc8_ : "";
         _loc6_.shade.gotoAndStop(!(_loc9_ == 1 || _global.MAIN_HERO.PASSIVE_SKILLS[_loc4_ - 1][1] > 0) ? 1 : 3);
         _loc4_ = _loc4_ + 1;
      }
      _loc4_ = 0;
      while(_loc4_ < 3)
      {
         _loc11_ = _global.MAIN_HERO.AURA_SKILLS[_loc4_][0];
         _loc8_ = _global.MAIN_HERO.AURA_SKILLS[_loc4_][1];
         _loc6_ = this.wnd["aura_ico_" + (_loc4_ + 1)];
         _loc6_.useHandCursor = false;
         _loc6_.gotoAndStop(Aura.getFrame(_loc11_));
         _loc6_.amount_txt.text = _loc8_ > 0 ? _loc8_ : "";
         _loc6_.shade.gotoAndStop(!(_loc4_ == 0 || _global.MAIN_HERO.AURA_SKILLS[_loc4_ - 1][1] >= 5) ? 1 : 3);
         _loc4_ = _loc4_ + 1;
      }
   }
   function harborShow()
   {
      if(_global.SHIP_LOCATION == "none")
      {
         this.wnd.quest_txt.text = "Şu an bir gemin yok. Satın almak ister misin?\n\nGeminin fiyatı: " + _global.SHIP_PRICE + " altın";
      }
      else
      {
         this.wnd.quest_txt.text = "Merhaba kaptan! Gemine binmek ister misin?";
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
         _global.BATTLE_MAP = 100 + _root.d(4);
      }
      this.city.getDefenders();
      _global.IS_CAPTURED[_global.CURR_TOWN] = true;
      if(this.city.NATION != _global.MAIN_HERO.NATION)
      {
         _global.IS_HOSTILE[this.city.NATION] = true;
      }
      _root.gotoAndStop("SPLASH_SCREEN");
   }
   function startChallengeForCity(with_army)
   {
      _global.BATTLE_TYPE = !with_army ? "CHALLENGE" : "ARMY_CHALLENGE";
      this.city.setBattleMap();
      _global.EVIL_HERO = Hero.getChampion(this.city.NATION,Town.getLevel(this.city.ID));
      var _loc4_;
      if(with_army)
      {
         delete _global.ENEMIES;
         _global.ENEMIES = new Array();
         _loc4_ = 0;
         while(_loc4_ < 5)
         {
            _global.ENEMIES.push(Unit.getMeleeMilitia(this.city.NATION,Town.getLevel(this.city.ID) - 1));
            _loc4_ = _loc4_ + 1;
         }
         _loc4_ = 0;
         while(_loc4_ < 5)
         {
            _global.ENEMIES.push(Unit.getRangedMilitia(this.city.NATION,Town.getLevel(this.city.ID) - 1));
            _loc4_ = _loc4_ + 1;
         }
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
      this.market_btn.enabled = true;
      this.removeDescription();
   }
   function disableAll()
   {
      this.barracks_btn.enabled = false;
      this.hall_btn.enabled = false;
      this.temple_btn.enabled = false;
      this.barn_btn.enabled = false;
      this.harbor_btn.enabled = false;
      this.forge_btn.enabled = false;
      this.market_btn.enabled = false;
      this.hint.gotoAndStop("empty");
   }
   function openForge()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.wnd.gotoAndStop("forge");
      this.wnd.money_txt.text = "Para: " + _global.GOLD + " altın";
   }
   function openMarketplace()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.gotoAndStop("market");
      this.wnd.money_txt.text = _global.GOLD + " altın";
   }
   function openTemple()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.gotoAndStop("temple");
      this.wnd.money_txt.text = _global.GOLD + " altın";
   }
   function openBarracks()
   {
      this.disableAll();
      this.wnd.gotoAndStop("barracks");
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.money_txt.text = _global.GOLD + " altın";
      var _loc3_;
      if(_global.IS_CAPTURED[this.city.ID])
      {
         this.wnd.refuser._visible = false;
         this.wnd.unit_scroll_l._visible = true;
         this.wnd.unit_scroll_r._visible = true;
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            this.wnd["unit_" + _loc3_]._visible = true;
            _loc3_ = _loc3_ + 1;
         }
      }
      else
      {
         this.wnd.refuser._visible = true;
         this.wnd.unit_scroll_l._visible = false;
         this.wnd.unit_scroll_r._visible = false;
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            this.wnd["unit_" + _loc3_]._visible = false;
            _loc3_ = _loc3_ + 1;
         }
      }
      this.hideUnitDescription();
   }
   function openCityHall()
   {
      this.disableAll();
      if(!this.checkReward())
      {
         this.wnd.gotoAndStop("city_hall");
         if(_global.IS_CAPTURED[this.city.ID])
         {
            this.wnd.capture_icon.gotoAndStop(2);
         }
         else
         {
            this.wnd.capture_icon.gotoAndStop(1);
         }
      }
   }
   function openBarn()
   {
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.disableAll();
      this.wnd.gotoAndStop("barn");
   }
   function openHeroStats()
   {
      this.disableAll();
      this.scrollUser = 0;
      this.scrollTrader = 0;
      this.wnd.gotoAndStop("inventory");
   }
   function openGetQuest()
   {
      this.disableAll();
      this.wnd.gotoAndStop("get_quest");
      if(_root.dice(2) == 1)
      {
         _global.QUEST.initQuestBattle(_global.CURR_TOWN);
         this.wnd.quest_txt.text = "Pekâlâ yolcu. Birkaç haydutla başa çıkabilirsin, değil mi?\n\nÖdülün: " + _global.QUEST.curr_gold + " altın";
      }
      else
      {
         _global.QUEST.initQuestFedEx(this.city.ID,this.city.NATION);
         this.wnd.quest_txt.text = "Bir paketi " + WorldMap.getTownName(_global.QUEST.deliver_to) + " şehrine götürmemiz gerekiyor. Gider misin?\nŞehre vardığında sana " + _global.QUEST.curr_gold + " altın ödenecek.";
      }
   }
   function openCaptureTown()
   {
      this.disableAll();
      if(_global.IS_CAPTURED[this.city.ID])
      {
         this.wnd.gotoAndStop("city_ours");
      }
      else
      {
         this.wnd.gotoAndStop("wanna_fight");
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
         this.wnd.gotoAndStop("town_msg");
         this.wnd.quest_txt.text = "Aferin yolcu, işini iyi yaptın!\n\nİşte ödülün: " + _loc4_ + " altın";
         _global.GOLD += _loc4_;
         return true;
      }
      return false;
   }
   function openHarbor()
   {
      this.disableAll();
      this.wnd.gotoAndStop("harbor");
      this.harborShow();
   }
   function openStats()
   {
      this.disableAll();
      this.wnd.gotoAndStop("stats");
      this.showStats();
   }
   function goBack()
   {
      if(this.wnd.refine_anvil.item)
      {
         _root.addItemInfoTo(_global.INVENTORY,this.wnd.refine_anvil.item);
      }
      if(this.wnd.refine_scroll.item)
      {
         _root.addItemInfoTo(_global.INVENTORY,this.wnd.refine_scroll.item);
      }
      this.enableAll();
      this.wnd.gotoAndStop(1);
   }
   function showActiveSkillDescription(raw, col)
   {
      this.wnd.attachMovie("MouseHint","mouse_hint",90,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.mouse_hint.showSkillInfo(this.active_skills_arr[raw - 1],col);
   }
   function showPassiveSkillDescription(raw, col)
   {
      this.wnd.attachMovie("MouseHint","mouse_hint",90,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.mouse_hint.showSkillInfo(_global.MAIN_HERO.PASSIVE_SKILLS[(raw - 1) * 3 + (col - 1)][0],0);
   }
   function showAuraSkillDescription(col)
   {
      this.wnd.attachMovie("MouseHint","mouse_hint",90,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.mouse_hint.showSkillInfo(_global.MAIN_HERO.AURA_SKILLS[col - 1][0],-1);
   }
   function showItemDescription(item_info)
   {
      this.wnd.attachMovie("MouseHint","mouse_hint",90,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.mouse_hint.showItemInfo(item_info);
   }
   function showUnitDescription(unit_mc)
   {
      this.wnd.unit_hint._visible = true;
      this.wnd.unit_hint.showUnitInfo(unit_mc);
   }
   function showUnitSkillDescription(frame)
   {
      this.wnd.attachMovie("MouseHint","mouse_hint",90,{_x:this._xmouse,_y:this._ymouse});
      var _loc2_ = Skill.getSkillInfoByFrame(frame);
      this.wnd.mouse_hint.showSkillInfo(_loc2_.nm,_loc2_.id);
   }
   function showSmallDescr(msg)
   {
      this.wnd.attachMovie("MouseHint","mouse_hint",90,{_x:this._xmouse,_y:this._ymouse});
      this.wnd.mouse_hint.showSmallDescr(msg);
   }
   function removeDescription()
   {
      this.wnd.mouse_hint.removeMovieClip();
   }
   function hideUnitDescription()
   {
      this.wnd.unit_hint._visible = false;
   }
   function addPointToActiveSkill(raw, col)
   {
      if(_global.MAIN_HERO.skill_points == 0)
      {
         return undefined;
      }
      if(_global.MAIN_HERO.ACTIVE_SKILLS[this.active_skills_arr[raw - 1]][col - 1] == 5)
      {
         return undefined;
      }
      _global.MAIN_HERO.ACTIVE_SKILLS[this.active_skills_arr[raw - 1]][col - 1]++;
      _global.MAIN_HERO.skill_points--;
      this.showStats();
   }
   function addPointToPassiveSkill(raw, col)
   {
      if(_global.MAIN_HERO.skill_points == 0)
      {
         return undefined;
      }
      if(_global.MAIN_HERO.PASSIVE_SKILLS[(raw - 1) * 3 + (col - 1)][1] == 5)
      {
         return undefined;
      }
      _global.MAIN_HERO.PASSIVE_SKILLS[(raw - 1) * 3 + (col - 1)][1] = _global.MAIN_HERO.PASSIVE_SKILLS[(raw - 1) * 3 + (col - 1)][1] + 1;
      _global.MAIN_HERO.skill_points--;
      this.showStats();
   }
   function addPointToAuraSkill(col)
   {
      if(_global.MAIN_HERO.skill_points == 0)
      {
         return undefined;
      }
      if(_global.MAIN_HERO.AURA_SKILLS[col - 1][1] == 5)
      {
         return undefined;
      }
      _global.MAIN_HERO.AURA_SKILLS[col - 1][1] = _global.MAIN_HERO.AURA_SKILLS[col - 1][1] + 1;
      _global.MAIN_HERO.skill_points--;
      this.showStats();
   }
   function forgeGetChance(curr_lv, need_lv)
   {
      var _loc3_ = 100;
      var _loc4_ = !_global.EASY_MODE ? 0.07 : 0.03;
      var _loc2_ = curr_lv;
      while(_loc2_ < need_lv)
      {
         _loc3_ *= 1 - _loc4_ * _loc2_;
         _loc2_ = _loc2_ + 1;
      }
      return Math.ceil(_loc3_);
   }
   function forgeGetPrice(curr_lv, need_lv)
   {
      return (need_lv - curr_lv) * 200;
   }
   function forgeRefine()
   {
      if(!this.wnd.refine_anvil.item)
      {
         return null;
      }
      var _loc5_ = this.wnd.refine_anvil.item.REFINE;
      var _loc4_ = Number(this.wnd.refine_lvl_txt.text);
      if(_loc5_ >= _loc4_ || _loc5_ >= 10)
      {
         this.wnd.msg_txt.text = "Bu kadar yüksek seviyeye geliştirilemez!";
         return undefined;
      }
      var _loc7_ = this.forgeGetChance(_loc5_,_loc4_);
      var _loc6_ = this.forgeGetPrice(_loc5_,_loc4_);
      if(_loc6_ > _global.GOLD)
      {
         this.wnd.msg_txt.text = "Altının yetmiyor!";
      }
      else
      {
         _global.GOLD -= _loc6_;
         this.wnd.money_txt.text = "Para: " + _global.GOLD + " altın";
         if(_root.percent(_loc7_))
         {
            this.wnd.refine_anvil.item.REFINE = _loc4_;
            this.wnd.refine_anvil.setItem(this.wnd.refine_anvil.item);
            this.wnd.anvil_mc.gotoAndPlay("success");
            this.wnd.refine_lvl_txt.text = _loc4_ + 1;
            _root.submitStat("MaxRefineRate",_loc4_);
         }
         else
         {
            this.wnd.refine_anvil.setItem(null);
            this.wnd.anvil_mc.gotoAndPlay("failure");
            this.wnd.refine_lvl_txt.text = "";
         }
         this.forgeUpdateData();
      }
   }
   function forgeEnchant()
   {
      if(!this.wnd.refine_anvil.item)
      {
         return undefined;
      }
      if(!this.wnd.refine_scroll.item)
      {
         return undefined;
      }
      if(this.wnd.refine_anvil.item.ENCH_ID)
      {
         this.wnd.msg_txt.text = "Bu eşya zaten geliştirilmiş!";
         return undefined;
      }
      this.wnd.refine_anvil.item.ENCH_ID = this.wnd.refine_scroll.item.ENCH_ID;
      this.wnd.refine_anvil.setItem(this.wnd.refine_anvil.item);
      this.wnd.refine_scroll.setItem(null);
   }
   function forgeUpdateData()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(this.wnd.refine_anvil.item)
      {
         _loc2_ = this.wnd.refine_anvil.item.REFINE;
         _loc3_ = Number(this.wnd.refine_lvl_txt.text);
         _loc4_ = this.forgeGetChance(_loc2_,_loc3_);
         _loc5_ = this.forgeGetPrice(_loc2_,_loc3_);
         this.wnd.success_txt.text = "Başarı şansı: %" + _loc4_ + "\n";
         this.wnd.success_txt.text += "Fiyat: " + _loc5_ + " altın";
      }
      else
      {
         this.wnd.success_txt.text = "";
         this.wnd.refine_lvl_txt.text = "";
      }
   }
   function sellAll()
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _global.INVENTORY.length)
      {
         if(!_global.INVENTORY[_loc3_].ENCH_ID && _global.INVENTORY[_loc3_].REFINE == 0)
         {
            _loc4_ = _global.INVENTORY[_loc3_].getItem();
            _global.GOLD += Math.floor(_loc4_.price / 2) * _global.INVENTORY[_loc3_].COUNT;
            _global.INVENTORY.splice(_loc3_,1);
            _loc3_ = _loc3_ - 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      this.scrollUser = 0;
      this.wnd.money_txt.text = "Para: " + _global.GOLD + " altın";
      this.storeShowUser();
   }
   function addStatTo(stat)
   {
      if(_global.MAIN_HERO.stat_points >= 2)
      {
         _global.MAIN_HERO[stat] = _global.MAIN_HERO[stat] + 1;
         _global.MAIN_HERO.stat_points -= 2;
         this.showStats();
      }
   }
}
