class Horse extends Object
{
   var bonus_DEF;
   var bonus_HP;
   var bonus_speed;
   var price;
   var skin_color;
   function Horse(clr, bhp, bdf, bsp, prc)
   {
      super();
      var _loc4_;
      if(clr == "any")
      {
         _loc4_ = ["red","brown","grey","white","black"];
         this.skin_color = _loc4_[_root.dice(4)];
      }
      else
      {
         this.skin_color = clr;
      }
      this.bonus_HP = bhp;
      this.bonus_DEF = bdf;
      this.bonus_speed = bsp;
      this.price = prc;
   }
}
