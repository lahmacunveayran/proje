class DamageData
{
   var attacker;
   var crit;
   var damage;
   var hit;
   var statuses;
   var arrow_error_ratio = 0;
   function DamageData(att, dam, ht, cri)
   {
      this.attacker = att;
      this.damage = dam;
      this.hit = ht;
      this.crit = cri;
      this.statuses = new Array();
   }
   function addStatus(st, tl)
   {
      this.statuses.push(new Status(st,tl));
   }
   function addDmgData(dmg_data)
   {
      this.damage += dmg_data.damage;
      this.crit = (this.crit + dmg_data.crit) / 2;
      this.hit = (this.hit + dmg_data.hit) / 2;
      this.statuses.concat(dmg_data.statuses);
   }
}
