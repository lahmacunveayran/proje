class EquipmentIcon extends StoreIcon
{
   var StoreIcon;
   var _parent;
   var _visible;
   var amount_txt;
   var ench_back;
   var gotoAndStop;
   var hitArea;
   var is_user;
   var item;
   var pos;
   var rect_hit_area;
   var slot = "NONE";
   function EquipmentIcon()
   {
      super();
      this.StoreIcon();
      this.hitArea = this.rect_hit_area;
   }
   function setItem(item_ref)
   {
      if(!item_ref)
      {
         this._visible = false;
         return undefined;
      }
      this._visible = true;
      this.item = item_ref;
      this.ench_back._visible = this.item.ENCH_ID != 0;
      var _loc2_ = this.item.getItem();
      this.amount_txt.text = !this.is_user ? "" : String(this.item.COUNT);
      this.gotoAndStop(_loc2_.getIconFrame());
   }
   function onPress()
   {
      this._parent._parent.dragItemOn(this.item);
   }
   function onRollOver()
   {
      super.onRollOver();
      var _loc3_;
      var _loc4_;
      if(this.item.ENCH_ID != 0)
      {
         this._parent.ench_info.gotoAndStop(this.item.ENCH_ID + 1);
         _loc3_ = new ItemInfo(this.item.CATEGORY,this.item.TYPE,this.item.NATION,this.item.LEVEL,0);
         _loc4_ = _loc3_.getItem();
         this._parent.ench_info.item_name_txt.text = _loc4_.NAME;
      }
   }
   function onRollOut()
   {
      super.onRollOut();
      this._parent.ench_info.gotoAndStop(1);
   }
   function onReleaseOutside()
   {
      var _loc5_;
      var _loc8_;
      var _loc7_;
      var _loc6_;
      var _loc4_;
      if(this.is_user)
      {
         _loc5_ = "none";
         switch(true)
         {
            case this._parent.ARMOR_hit.hitTest(this._parent._xmouse,this._parent._ymouse,false):
               _loc5_ = "ARMOR";
               break;
            case this._parent.HELMET_hit.hitTest(this._parent._xmouse,this._parent._ymouse,false):
               _loc5_ = "HELMET";
               break;
            case this._parent.WEAPON_PRI_hit.hitTest(this._parent._xmouse,this._parent._ymouse,false):
               _loc5_ = "WEAPON_PRI";
               break;
            case this._parent.WEAPON_SEC_hit.hitTest(this._parent._xmouse,this._parent._ymouse,false):
               _loc5_ = "WEAPON_SEC";
         }
         if(_loc5_ != "none")
         {
            _loc8_ = _global.MAIN_HERO[_loc5_].getItemInfo();
            _loc7_ = _global.MAIN_HERO.equipItemInfo(_loc5_,this.item);
            if(_loc7_ == "OK")
            {
               if(_global.INVENTORY[this.pos].COUNT == 1)
               {
                  _global.INVENTORY.splice(this.pos,1);
               }
               else
               {
                  _global.INVENTORY[this.pos].COUNT--;
               }
               _root.addItemInfoTo(_global.INVENTORY,_loc8_);
               this._parent.error_txt.text = "";
            }
            else
            {
               this._parent.item_name_txt.text = "";
               this._parent.item_stats_txt.text = "";
               this._parent.error_txt.text = _loc7_;
            }
         }
      }
      else
      {
         _loc6_ = -1;
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            if(this._parent["user_" + _loc4_].hitTest(this._parent._xmouse,this._parent._ymouse,false))
            {
               _loc6_ = _loc4_;
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_loc6_ >= 0)
         {
            _root.addItemInfoTo(_global.INVENTORY,this.item);
            _global.MAIN_HERO[this.slot] = null;
            if(this.slot == "WEAPON_PRI" && _global.MAIN_HERO.WEAPON_SEC.rng == 0)
            {
               if(_global.MAIN_HERO.WEAPON_SEC.TYPE != "Shield")
               {
                  _global.MAIN_HERO.WEAPON_PRI = _global.MAIN_HERO.WEAPON_SEC;
               }
               else
               {
                  _root.addItemTo(_global.INVENTORY,_global.MAIN_HERO.WEAPON_SEC);
               }
               _global.MAIN_HERO.WEAPON_SEC = null;
            }
         }
      }
      this._parent._parent.inventoryShowUser();
      this._parent._parent.dragItemOff();
   }
}
