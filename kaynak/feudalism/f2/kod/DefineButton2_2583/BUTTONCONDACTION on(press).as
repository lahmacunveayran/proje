on(press){
   if(refine_anvil.item)
   {
      var curr_lv = refine_anvil.item.REFINE;
      var written_lv = Number(refine_lvl_txt.text);
      if(written_lv < 10)
      {
         refine_lvl_txt.text = written_lv + 1;
      }
      _parent.forgeUpdateData();
   }
}
