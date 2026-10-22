class Status
{
   var TYPE;
   var initail_values;
   var time_left;
   function Status(tp, tl)
   {
      this.TYPE = tp;
      this.time_left = tl;
      this.initail_values = new Array();
   }
   function startStatus(human)
   {
      this[this.TYPE + "Start"](human);
   }
   function duringStatus(human)
   {
      this[this.TYPE + "During"](human);
   }
   function endStatus(human)
   {
      this[this.TYPE + "End"](human);
   }
   function timePassed()
   {
      this.time_left = this.time_left - 1;
      if(this.time_left <= 0)
      {
         return true;
      }
      return false;
   }
   function StunStart(human)
   {
      human.aspd_timer = this.time_left * 10;
      human.onAnimComplete();
      human.body.head.stun_anim._visible = true;
      human.isSwitchingWeapons = true;
   }
   function StunEnd(human)
   {
      human.aspd_timer = 0;
      human.body.head.stun_anim._visible = false;
      human.onAnimComplete();
   }
   function PoisonStart(human)
   {
      var _loc1_ = new Color(human.body);
      _loc1_.setTransform({rb:-40,gb:40,bb:-40});
   }
   function PoisonDuring(human)
   {
      human.HP -= Math.round(human.MAX_HP / 20);
      if(human.HP <= 0)
      {
         human.HP = 1;
      }
      human.redrawHealthBar();
   }
   function PoisonEnd(human)
   {
      var _loc1_ = new Color(human.body);
      _loc1_.setTransform({rb:0,gb:0,bb:0});
   }
   function ChaosStart(human)
   {
      this.initail_values.push(human.team);
      human.team = _root.d(998) + 2;
      human.attacking = null;
   }
   function ChaosEnd(human)
   {
      human.team = Number(this.initail_values.pop());
   }
   function CharmStart(human)
   {
      human.team = 1 - human.team;
      human.attacking = null;
   }
   function CharmEnd(human)
   {
      human.team = 1 - human.team;
      human.attacking = null;
   }
}
