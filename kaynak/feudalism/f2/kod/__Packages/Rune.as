class Rune extends Item
{
   var FRAME;
   var NAME;
   var TYPE;
   var price;
   function Rune(rune_id, rf)
   {
      super();
      this.ENCH_ID = rune_id;
      this.TYPE = "Rune";
      this.FRAME = this.getFrame();
      this.NAME = Rune.getRuneName(rune_id);
      this.price = 100;
      this.setRefine(rf);
   }
   static function getRuneName(rune_id)
   {
      switch(rune_id)
      {
         case "Footmans":
            return "Infantry Rune";
         case "Riders":
            return "Chivalry Rune";
         case "Critical":
            return "Critical Rune";
         case "Bloody":
            return "Bloody Rune";
         case "Ghost":
            return "Ghost Rune";
         case "IcePick":
            return "Occult Rune";
         case "Wolverine":
            return "Wolf Rune";
         case "ofWeaken":
            return "Weak Rune";
         case "ofPoison":
            return "Poisoned Rune";
         case "Stunning":
            return "Stunning Rune";
         case "Mad":
            return "Mad Rune";
         case "Charming":
            return "Charming Rune";
         default:
            return;
      }
   }
   static function getRuneDescription(rune_id)
   {
      switch(rune_id)
      {
         case "Footmans":
            return "Increase damage on horsemen by 30%";
         case "Riders":
            return "Increase damage on all units without horses by 30%";
         case "Critical":
            return "Increase critical strike chance by 10%";
         case "Bloody":
            return "Attacks ignore enemy’s armor defense.";
         case "Ghost":
            return "Attacks ignore enemy’s armor defense. But damage decreased by 30%";
         case "IcePick":
            return "Very rare and powerful rune. It allows to deal more damage depending on target’s armor defense. Te more defense has target, the more damage it will receive.";
         case "Wolverine":
            return "Damage +15";
         case "ofWeaken":
            return "If target has less than 50% of its max HP then damage + 50%, else damage -50%";
         case "ofPoison":
            return "Adds 5% chance to poison enemy when attacking";
         case "Stunning":
            return "Adds 5% chance to stun enemy when attacking";
         case "Mad":
            return "Adds 5% chance to make mad enemy when attacking";
         case "Charming":
            return "Adds 5% chance to charm enemy when attacking. Charmed enemies fight on your side and cannot be attacked by your teammates. Does not work on mad enemies. Charm status lasts 5 seconds.";
         default:
            return;
      }
   }
   static function getRandomRune()
   {
      var _loc2_ = _root.d(1000);
      if(_loc2_ == 1)
      {
         return new Rune("IcePick");
      }
      if(_loc2_ < 5)
      {
         return new Rune("Bloody");
      }
      if(_loc2_ < 14)
      {
         return new Rune("Footmans");
      }
      if(_loc2_ < 20)
      {
         return new Rune("Riders");
      }
      if(_loc2_ < 25)
      {
         return new Rune("Critical");
      }
      if(_loc2_ < 30)
      {
         return new Rune("Ghost");
      }
      if(_loc2_ < 40)
      {
         return new Rune("ofWeaken");
      }
      if(_loc2_ < 50)
      {
         return new Rune("ofPoison");
      }
      if(_loc2_ < 60)
      {
         return new Rune("Stunning");
      }
      if(_loc2_ < 70)
      {
         return new Rune("Mad");
      }
      if(_loc2_ < 80)
      {
         return new Rune("Charming");
      }
      if(_loc2_ < 100)
      {
         return new Rune("Wolverine");
      }
      return null;
   }
}
