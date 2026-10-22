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
            return "Piyade Rünü";
         case "Riders":
            return "Süvari Rünü";
         case "Critical":
            return "Kritik Rünü";
         case "Bloody":
            return "Kanlı Rün";
         case "Ghost":
            return "Hayalet Rünü";
         case "IcePick":
            return "Okült Rün";
         case "Wolverine":
            return "Kurt Rünü";
         case "ofWeaken":
            return "Zayıflık Rünü";
         case "ofPoison":
            return "Zehirli Rün";
         case "Stunning":
            return "Sersemletme Rünü";
         case "Mad":
            return "Çılgınlık Rünü";
         case "Charming":
            return "Büyüleme Rünü";
         default:
            return;
      }
   }
   static function getRuneDescription(rune_id)
   {
      switch(rune_id)
      {
         case "Footmans":
            return "Atlılara verilen hasarı %30 artırır";
         case "Riders":
            return "Atı olmayan birliklere verilen hasarı %30 artırır";
         case "Critical":
            return "Kritik vuruş şansını %10 artırır";
         case "Bloody":
            return "Saldırılar düşmanın zırh savunmasını yok sayar.";
         case "Ghost":
            return "Saldırılar düşmanın zırh savunmasını yok sayar ama hasar %30 azalır";
         case "IcePick":
            return "Çok nadir ve güçlü bir rün. Hedefin zırh savunmasına göre daha fazla hasar verdirir: hedefin savunması ne kadar yüksekse o kadar çok hasar alır.";
         case "Wolverine":
            return "Hasar +15";
         case "ofWeaken":
            return "Hedefin canı en yüksek canının %50'sinden azsa hasar +%50, değilse hasar -%50";
         case "ofPoison":
            return "Saldırırken düşmanı %5 ihtimalle zehirler";
         case "Stunning":
            return "Saldırırken düşmanı %5 ihtimalle sersemletir";
         case "Mad":
            return "Saldırırken düşmanı %5 ihtimalle çıldırtır";
         case "Charming":
            return "Saldırırken düşmanı %5 ihtimalle büyüler. Büyülenen düşman senin tarafında dövüşür ve takım arkadaşların ona saldırmaz. Çıldırmış düşmanlarda işe yaramaz. Büyü 5 saniye sürer.";
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
