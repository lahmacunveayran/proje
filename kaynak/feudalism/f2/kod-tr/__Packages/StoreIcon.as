class StoreIcon extends MovieClip
{
   var TYPE;
   var amount_txt;
   var ench_back;
   var item;
   var pos;
   function StoreIcon()
   {
      super();
      switch(this._name.charAt(0))
      {
         case "u":
            this.TYPE = "user";
            break;
         case "t":
            this.TYPE = "trader";
            break;
         case "r":
            this.TYPE = "refine";
            break;
         default:
            this.TYPE = "inventory";
      }
      this.stop();
   }
   function setItem(item_ref)
   {
      this.item = item_ref;
      var _loc2_;
      if(item_ref)
      {
         this._visible = true;
         _loc2_ = this.item.getItem();
         this.amount_txt.text = this.TYPE != "user" ? "" : String(this.item.COUNT);
         this.ench_back._visible = this.item.ENCH_ID != null;
         this.gotoAndStop(_loc2_.getIconFrame());
      }
      else
      {
         this._visible = false;
      }
   }
   function onRollOver()
   {
      this._parent.msg_txt.text = "";
      if(this.item)
      {
         this._parent._parent.showItemDescription(this.item);
      }
   }
   function onPress()
   {
      this._parent._parent.removeDescription();
      var _loc3_ = this.item.getItem();
      if(this.TYPE == "trader" && _loc3_.price > _global.GOLD)
      {
         this._parent.msg_txt.text = "Altının yetmiyor!";
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
      if(!this.item)
      {
         return undefined;
      }
      var _loc5_;
      var _loc4_;
      var _loc6_;
      switch(this.TYPE)
      {
         case "user":
            if(this._parent.refine_anvil.hitTest(this._parent._xmouse,this._parent._ymouse,false))
            {
               if(this.item.CATEGORY == "WeaponClass" && this.item.TYPE != "Shield")
               {
                  if(this._parent.refine_anvil.item != null)
                  {
                     _root.addItemInfoTo(_global.INVENTORY,this._parent.refine_anvil.item);
                  }
                  this._parent.refine_anvil.setItem(this.item.getSingleCopy());
                  if(this.item.COUNT > 1)
                  {
                     this.item.COUNT--;
                  }
                  else
                  {
                     _global.INVENTORY.splice(this.pos,1);
                  }
                  this._parent.refine_lvl_txt.text = this.item.REFINE + 1;
                  this._parent._parent.forgeUpdateData();
               }
               break;
            }
            if(this._parent.refine_scroll.hitTest(this._parent._xmouse,this._parent._ymouse,false))
            {
               if(this.item.CATEGORY == "Rune")
               {
                  if(this._parent.refine_scroll.item != null)
                  {
                     _root.addItemInfoTo(_global.INVENTORY,this._parent.refine_scroll.item);
                  }
                  this._parent.refine_scroll.setItem(this.item.getSingleCopy());
                  if(this.item.COUNT > 1)
                  {
                     this.item.COUNT--;
                     break;
                  }
                  _global.INVENTORY.splice(this.pos,1);
               }
               break;
            }
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < 7)
            {
               if(this._parent["trader_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc5_)
            {
               _loc6_ = this.item.getItem();
               if(this.item.COUNT > 1 && !_global.STORE_DONT_ASK_AMOUNT)
               {
                  this._parent.attachMovie("Amount window","am_wnd",150,{_x:200,_y:150});
                  this._parent.am_wnd.pos = this.pos;
                  this._parent.am_wnd.price = _loc6_.price;
                  this._parent.am_wnd.max_amount = this.item.COUNT;
                  this._parent.am_wnd.amount = this._parent.am_wnd.max_amount;
                  this._parent.am_wnd.amount_txt.text = this._parent.am_wnd.amount;
                  this._parent.am_wnd.item_ico.gotoAndStop(_loc6_.getIconFrame());
               }
               else
               {
                  _global.GOLD += Math.floor(_loc6_.price / 2) * this.item.COUNT;
                  _global.INVENTORY.splice(this.pos,1);
               }
               this._parent.money_txt.text = "Para: " + _global.GOLD + " altın";
            }
            break;
         case "trader":
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < 7)
            {
               if(this._parent["user_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc5_)
            {
               _loc6_ = this.item.getItem();
               if(_global.GOLD >= _loc6_.price)
               {
                  _global.GOLD -= _loc6_.price;
                  _root.addItemInfoTo(_global.INVENTORY,this.item.getCopy());
               }
               this._parent.money_txt.text = "Para: " + _global.GOLD + " altın";
            }
            break;
         case "refine":
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < 7)
            {
               if(this._parent["user_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_ = _loc4_ + 1;
            }
            _root.addItemInfoTo(_global.INVENTORY,this.item);
            this.setItem(null);
      }
      this._parent._parent.storeShowUser();
      this._parent._parent.dragItemOff();
   }
   function onRollOut()
   {
      this._parent._parent.removeDescription();
   }
}
