class AuraSkillChooser extends SkillChooser
{
   var ID;
   var _parent;
   var curr_value;
   var ico;
   static var arr = ["Devotion","DivineHelp","Barrier","Sacrifice","ForceBalance","VenomCloud","HolyTribunal","UnholyBreath","LifeLeech","SoulDrain","Healing","BansheeCry","NationViz","NationGer","NationRus","NationJap","NationMon","NationAra"];
   function AuraSkillChooser()
   {
      super();
      this.ico.shade.gotoAndStop(3);
      this.ico.amount_txt.text = "";
      this.showChosen();
   }
   function showChosen()
   {
      this.ico.gotoAndStop(Aura.getFrame(this.curr_value));
   }
   function goRight()
   {
      var _loc2_ = Aura.getFrame(this.curr_value) - 60;
      _loc2_ = _loc2_ + 1;
      if(_loc2_ >= AuraSkillChooser.arr.length)
      {
         _loc2_ = 0;
      }
      this.curr_value = AuraSkillChooser.arr[_loc2_];
      if(this.same())
      {
         this.goRight();
      }
      else
      {
         this.showChosen();
      }
   }
   function goLeft()
   {
      var _loc2_ = Aura.getFrame(this.curr_value) - 60;
      _loc2_ = _loc2_ - 1;
      if(_loc2_ < 0)
      {
         _loc2_ = AuraSkillChooser.arr.length - 1;
      }
      this.curr_value = AuraSkillChooser.arr[_loc2_];
      if(this.same())
      {
         this.goLeft();
      }
      else
      {
         this.showChosen();
      }
   }
   function same()
   {
      var _loc2_ = 0;
      while(_loc2_ < 3)
      {
         if(_loc2_ != this.ID && this._parent["aura_" + _loc2_].curr_value == this.curr_value)
         {
            return true;
         }
         _loc2_ = _loc2_ + 1;
      }
      return false;
   }
}
