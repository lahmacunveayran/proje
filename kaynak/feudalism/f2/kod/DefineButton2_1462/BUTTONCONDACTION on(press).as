on(press){
   if(this.amount < this.max_amount)
   {
      this.amount = this.amount + 1;
      this.amount_txt.text = this.amount;
   }
}
