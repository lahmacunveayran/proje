_parent.inventoryShowUser();
_parent.inventoryShowStats();
hero_stats_txt.text = _global.MAIN_HERO.NAME + "\nSeviye " + _global.MAIN_HERO.LEVEL + "\ndeneyim: ";
hero_stats_txt.text += _global.MAIN_HERO.EXP + "/" + Hero.getExpForLevel(_global.MAIN_HERO.LEVEL + 1);
hero_ico.enabled = false;
