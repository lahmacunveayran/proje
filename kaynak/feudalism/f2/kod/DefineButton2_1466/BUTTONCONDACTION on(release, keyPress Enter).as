on(release, keyPress "<Enter>"){
   _global.GOLD += Math.floor(this.price / 2) * this.amount;
   if(this.amount == this.max_amount)
   {
      _global.INVENTORY.splice(this.pos,1);
   }
   else
   {
      _global.INVENTORY[this.pos].COUNT -= this.amount;
   }
   _parent._parent.storeShowUser();
   _parent.money_txt.text = _global.GOLD + " gold";
   this.removeMovieClip();
}
