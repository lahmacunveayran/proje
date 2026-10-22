var nat = _root.getNationNumber(_global.MAIN_HERO.NATION);
var gen = _global.MAIN_HERO.GENDER != "m" ? 1 : 0;
gotoAndStop(nat * 2 + gen);
