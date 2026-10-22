class PassiveSkillChooser extends SkillChooser
{
   var ID;
   var _parent;
   var curr_value;
   var ico;
   static var arr = ["Bowmen_1","Bowmen_2","Bowmen_3","Infantry_1","Infantry_2","Infantry_3","Horsemen_1","Horsemen_2","Horsemen_3","Swordsmen_1","Swordsmen_2","Swordsmen_3","Meditate","FarEastWarTraining","AssassinTraining","BerserkerTraining","KungFuSecrets","FindWeakPoint"];
   function PassiveSkillChooser()
   {
      super();
      this.ico.shade.gotoAndStop(3);
      this.ico.amount_txt.text = "";
      this.showChosen();
   }
   function showChosen()
   {
      this.ico.gotoAndStop(Skill.getPassiveSkillFrame(this.curr_value));
   }
   function goRight()
   {
      var _loc2_ = Skill.getPassiveSkillFrame(this.curr_value) - 37;
      _loc2_ = _loc2_ + 1;
      if(_loc2_ >= PassiveSkillChooser.arr.length)
      {
         _loc2_ = 0;
      }
      this.curr_value = PassiveSkillChooser.arr[_loc2_];
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
      var _loc2_ = Skill.getPassiveSkillFrame(this.curr_value) - 37;
      _loc2_ = _loc2_ - 1;
      if(_loc2_ < 0)
      {
         _loc2_ = PassiveSkillChooser.arr.length - 1;
      }
      this.curr_value = PassiveSkillChooser.arr[_loc2_];
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
      while(_loc2_ < 6)
      {
         if(_loc2_ != this.ID && this._parent["passive_" + _loc2_].curr_value == this.curr_value)
         {
            return true;
         }
         _loc2_ = _loc2_ + 1;
      }
      return false;
   }
}
