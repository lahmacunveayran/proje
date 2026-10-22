class StoreIcon extends MovieClip
{
   var amount_txt;
   var ench_back;
   var is_user;
   var item;
   var pos;
   function StoreIcon()
   {
      super();
      this.is_user = this._name.substr(0,4) == "user";
      this.stop();
   }
   function setItem(item_ref)
   {
      this.item = item_ref;
      var _loc2_ = this.item.getItem();
      this.amount_txt.text = !this.is_user ? "" : String(this.item.COUNT);
      this.ench_back._visible = this.item.ENCH_ID != 0;
      this.gotoAndStop(_loc2_.getIconFrame());
   }
   function onRollOver()
   {
      var _loc2_ = this.item.getItem();
      this._parent.item_name_txt.text = _loc2_.NAME;
      switch(this.item.CATEGORY)
      {
         case "WeaponClass":
            if(_loc2_.TYPE != "Shield")
            {
               this._parent.item_stats_txt.text = "Hasar: " + _loc2_.dmg + "-" + (_loc2_.dmg + _loc2_.rnd) + "\n";
               this._parent.item_stats_txt.text += "Saldırı hızı: " + String(Math.round(100 / (_loc2_.t_bef + _loc2_.t_aft) * 100) / 100).split(".").join(",") + "\n";
               if(_loc2_.rng > 0)
               {
                  this._parent.item_stats_txt.text += "Menzil: " + _loc2_.rng + "\n";
               }
               this._parent.item_stats_txt.text += "Kritik: %" + _loc2_.crit + "\n";
               this._parent.item_stats_txt.text += (!_loc2_.twohanded ? "Tek elli" : "İki elli") + "\n";
               break;
            }
            this._parent.item_stats_txt.text = "Kaçınma şansı: %" + _loc2_.crit + "\n";
            break;
         case "Armor":
            this._parent.item_stats_txt.text = "Savunma: " + _loc2_.value + "\n";
      }
      if(_loc2_.require_param != null)
      {
         this._parent.item_stats_txt.text += "Gereken: " + _loc2_.require_value + " " + {STR:"GÜÇ",DEX:"ÇEV",CON:"DAY",INT:"ZEK"}[_loc2_.require_param] + "\n\n";
      }
      this._parent.item_stats_txt.text += "Fiyat: " + _loc2_.price + " altın";
   }
   function onPress()
   {
      var _loc3_ = this.item.getItem();
      if(!this.is_user && _loc3_.price > _global.GOLD)
      {
         this._parent.item_name_txt.text = "Altının yetmiyor!";
         this._parent.item_stats_txt.text = "";
      }
      else
      {
         this._parent._parent.dragItemOn(this.item);
      }
   }
   function onRelease()
   {
      this._parent._parent.dragItemOff();
   }
   function onReleaseOutside()
   {
      var _loc6_ = !this.is_user ? "user_" : "trader_";
      var _loc5_ = false;
      var _loc4_ = 0;
      while(_loc4_ < 7)
      {
         if(this._parent[_loc6_ + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
         {
            _loc5_ = true;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      var _loc7_;
      if(_loc5_)
      {
         _loc7_ = this.item.getItem();
         if(this.is_user)
         {
            if(this.item.COUNT > 1 && !_global.STORE_DONT_ASK_AMOUNT)
            {
               this._parent.attachMovie("Amount window","am_wnd",150,{_x:200,_y:150});
               this._parent.am_wnd.pos = this.pos;
               this._parent.am_wnd.price = _loc7_.price;
               this._parent.am_wnd.max_amount = this.item.COUNT;
               this._parent.am_wnd.amount = this._parent.am_wnd.max_amount;
               this._parent.am_wnd.amount_txt.text = this._parent.am_wnd.amount;
               this._parent.am_wnd.item_ico.gotoAndStop(_loc7_.getIconFrame());
            }
            else
            {
               _global.GOLD += Math.floor(_loc7_.price / 2) * this.item.COUNT;
               _global.INVENTORY.splice(this.pos,1);
            }
         }
         else if(_global.GOLD >= _loc7_.price)
         {
            _global.GOLD -= _loc7_.price;
            _root.addItemInfoTo(_global.INVENTORY,new ItemInfo(this.item.CATEGORY,this.item.TYPE,this.item.NATION,this.item.LEVEL));
         }
      }
      this._parent.money_txt.text = _global.GOLD + " altın";
      this._parent._parent.storeShowUser();
      this._parent._parent.dragItemOff();
   }
   function onRollOut()
   {
      this._parent.item_name_txt.text = "";
      this._parent.item_stats_txt.text = "";
   }
}
