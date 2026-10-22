class Enchant extends Object
{
   var ID;
   var BASE_BONUS = 0.3;
   function Enchant(en_id)
   {
      super();
      this.ID = en_id;
   }
   static function getFrame(en_id)
   {
      switch(en_id)
      {
         case "Footmans":
            return 1;
         case "Riders":
            return 2;
         case "Critical":
            return 3;
         case "Bloody":
            return 4;
         case "Ghost":
            return 5;
         case "IcePick":
            return 6;
         case "Wolverine":
            return 7;
         case "ofWeaken":
            return 8;
         case "ofPoison":
            return 9;
         case "Stunning":
            return 10;
         case "Mad":
            return 11;
         case "Charming":
            return 12;
         default:
            return;
      }
   }
   static function getPrefix(en_id)
   {
      switch(en_id)
      {
         case "Footmans":
            return "Footman\'s ";
         case "Riders":
            return "Rider\'s ";
         case "Critical":
            return "Critical ";
         case "Bloody":
            return "Bloody ";
         case "Ghost":
            return "Ghost ";
         case "IcePick":
            return "";
         case "Wolverine":
            return "Wolverine ";
         case "ofWeaken":
            return "";
         case "ofPoison":
            return "";
         case "Stunning":
            return "Stunning ";
         case "Mad":
            return "Mad ";
         case "Charming":
            return "Charming ";
         default:
            return;
      }
   }
   static function getSuffix(en_id)
   {
      switch(en_id)
      {
         case "Footmans":
            return "";
         case "Riders":
            return "";
         case "Critical":
            return "";
         case "Bloody":
            return "";
         case "Ghost":
            return "";
         case "IcePick":
            return " of Thanatos";
         case "Wolverine":
            return "";
         case "ofWeaken":
            return " of Weaking";
         case "ofPoison":
            return " of Poison";
         case "Stunning":
            return "";
         case "Mad":
            return "";
         case "Charming":
            return "";
         default:
            return;
      }
   }
   function operate(who, dmg_data)
   {
      this["operate_" + this.ID](who,dmg_data);
   }
   function operate_Footmans(who, dmg_data)
   {
      if(who.isHorseman)
      {
         dmg_data.damage = Math.round(dmg_data.damage * (1 + this.BASE_BONUS));
      }
   }
   function operate_Riders(who, dmg_data)
   {
      if(!who.isHorseman)
      {
         dmg_data.damage = Math.round(dmg_data.damage * (1 + this.BASE_BONUS));
      }
   }
   function operate_Critical(who, dmg_data)
   {
      dmg_data.crit += 10;
   }
   function operate_Bloody(who, dmg_data)
   {
      dmg_data.damage += who.DEF;
   }
   function operate_Ghost(who, dmg_data)
   {
      dmg_data.damage = Math.round(dmg_data.damage * (1 - this.BASE_BONUS));
      dmg_data.damage += who.DEF;
   }
   function operate_IcePick(who, dmg_data)
   {
      dmg_data.damage = Math.round(dmg_data.damage * (1 + who.DEF / 50));
      dmg_data.damage += who.DEF;
   }
   function operate_Wolverine(who, dmg_data)
   {
      dmg_data.damage += 15;
   }
   function operate_ofWeaken(who, dmg_data)
   {
      if(who.HP < who.MAX_HP / 2)
      {
         dmg_data.damage = Math.round(dmg_data.damage * 1.5);
      }
      else
      {
         dmg_data.damage = Math.round(dmg_data.damage * 0.5);
      }
   }
   function operate_ofPoison(who, dmg_data)
   {
      if(_root.percent(5))
      {
         dmg_data.addStatus("Poison",5);
      }
   }
   function operate_Stunning(who, dmg_data)
   {
      if(_root.percent(5))
      {
         dmg_data.addStatus("Stun",2);
      }
   }
   function operate_Mad(who, dmg_data)
   {
      if(_root.percent(5))
      {
         dmg_data.addStatus("Chaos",5);
      }
   }
   function operate_Charming(who, dmg_data)
   {
      if(_root.percent(5))
      {
         dmg_data.addStatus("Charm",5);
      }
   }
}
