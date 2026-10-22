class MovieDummy extends Creature
{
   var body;
   function MovieDummy()
   {
      super();
      this.body.head.stun_anim._visible = false;
   }
   function dress(unit_nat, unit_type, unit_id)
   {
      this.initUnit(new Unit(unit_nat,unit_type,unit_id));
   }
   function playAnim(anim_name)
   {
      this.body.gotoAndPlay(anim_name);
   }
   function stopAt(anim_name)
   {
      this.body.gotoAndStop(anim_name);
   }
   function meleeHit(skill_id, useSecondWeapon, dmg_mod, skill_flag)
   {
   }
   function rangedHit(skill_id, useSecondWeapon, dmg_mod, skill_flag)
   {
   }
}
