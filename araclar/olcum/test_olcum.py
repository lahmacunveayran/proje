"""olcum.py birim testleri. Referans dosyası ve çizici gerektirmez.

Çalıştırma (depo kökünden):  python3 -m unittest discover -s araclar/olcum -p 'test_*.py'
"""
import math
import os
import sys
import unittest
import xml.etree.ElementTree as ET

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kukla_yapisi  # noqa: E402
import olcum  # noqa: E402


def degrade(x1="-819.2", x2="819.2", donusum="", duraklar=("#FFFFFF", "#808080")):
    s = (f'<linearGradient xmlns="http://www.w3.org/2000/svg" id="g" gradientUnits="userSpaceOnUse" '
         f'x1="{x1}" x2="{x2}" gradientTransform="{donusum}">'
         + "".join(f'<stop offset="{i}" stop-color="{r}"/>' for i, r in enumerate(duraklar)) + "</linearGradient>")
    return olcum.Degrade(ET.fromstring(s), {})


def figur(**degis):
    """Bilinen oranlı yapay bir tam boy figür: boy 80, baş 10, kasık 40'ta."""
    f = {"tam_boy": True, "bas_tepesi": [50, 10], "cene": [50, 20], "omuz_sol": [40, 24], "omuz_sag": [60, 24],
         "dirsekler": [[38, 36], [62, 36]], "bel": [50, 42], "kasik": [50, 50], "dizler": [[45, 70], [55, 70]],
         "ayaklar": [[44, 90], [56, 90]], "taban": [50, 90], "el_kutulari": [[34, 44, 40, 50], [60, 44, 66, 50]],
         "silah_ekseni": [[37, 0], [37, 100]]}
    f.update(degis)
    return f


class Donusum(unittest.TestCase):
    def test_oteleme_ve_olcek_sirayla_uygulanir(self):
        m = olcum.donusum("translate(10, 5) scale(2)")
        self.assertEqual(olcum.uygula(m, 1, 1), (12, 7))

    def test_bos_donusum_birimdir(self):
        self.assertEqual(olcum.donusum(""), olcum.BIRIM)

    def test_olcek_determinanttan(self):
        self.assertAlmostEqual(olcum.olcek(olcum.donusum("scale(3)")), 3)


class DegradeOlcumu(unittest.TestCase):
    def test_acik_soldan_koyu_saga(self):
        d = degrade(donusum="matrix(0.01, 0, 0, 0.01, 0, 0)")
        yon = d.yon(olcum.BIRIM)
        self.assertAlmostEqual(yon[0], 1)
        self.assertEqual(olcum.yon_adi(yon), "sağa koyulaşır")

    def test_duraklar_ters_ise_yon_ters(self):
        d = degrade(donusum="matrix(0.01, 0, 0, 0.01, 0, 0)", duraklar=("#808080", "#FFFFFF"))
        self.assertEqual(olcum.yon_adi(d.yon(olcum.BIRIM)), "sola koyulaşır")

    def test_donmus_degrade_asagi_koyulasir(self):
        d = degrade(donusum="matrix(0, 0.01, -0.01, 0, 0, 0)")
        self.assertEqual(olcum.yon_adi(d.yon(olcum.BIRIM)), "aşağı koyulaşır")

    def test_uc_farki_parlaklik_ve_doygunluk(self):
        dv, ds = degrade(duraklar=("#FF0000", "#800000")).uc_farki()
        self.assertAlmostEqual(dv, 1 - 128 / 255, places=4)
        self.assertAlmostEqual(ds, 0)


class Oranlar(unittest.TestCase):
    def test_bilinen_figur(self):
        o = olcum.isaret_oranlari(figur())
        self.assertAlmostEqual(o["bas_sayisi"], 8)
        self.assertAlmostEqual(o["bacak_boy"], 0.5)
        self.assertAlmostEqual(o["omuz_boy"], 0.25)
        self.assertAlmostEqual(o["omuz_bas"], 2)
        self.assertAlmostEqual(o["el_boy"], 6 / 80, places=4)
        self.assertAlmostEqual(o["el_yuz"], 0.6)
        self.assertAlmostEqual(o["silah_acisi"], 90)
        self.assertTrue(o["sap_elden_gecer"])

    def test_sap_elden_gecmiyorsa(self):
        o = olcum.isaret_oranlari(figur(silah_ekseni=[[90, 0], [90, 100]]))
        self.assertFalse(o["sap_elden_gecer"])

    def test_yarim_boy_figurde_boya_bagli_oran_yok(self):
        o = olcum.isaret_oranlari({"tam_boy": False, "bas_tepesi": [0, 0], "cene": [0, 10], "omuz_sol": [0, 12],
                                   "omuz_sag": [20, 12], "el_kutulari": [[0, 0, 5, 4]]})
        self.assertNotIn("bas_sayisi", o)
        self.assertAlmostEqual(o["el_yuz"], 0.5)

    def test_dogru_kutudan_gecer(self):
        kutu = (0, 0, 10, 10)
        self.assertTrue(olcum.dogru_kutudan_gecer((-5, 5), (20, 5), kutu))
        self.assertFalse(olcum.dogru_kutudan_gecer((-5, 20), (20, 20), kutu))
        # Doğru kutunun çok ötesinde iki noktayla verilse de sonsuz doğru sayılır
        self.assertTrue(olcum.dogru_kutudan_gecer((100, 100), (200, 200), kutu))


class PozOzgunlugu(unittest.TestCase):
    def test_ayni_poz_sifir(self):
        p = olcum.poz_isaretten(figur())
        self.assertAlmostEqual(olcum.poz_uzakligi(p, p), 0)

    def test_aynalanmis_poz_sifir(self):
        f = figur(dirsekler=[[30, 30], [62, 36]], silah_ekseni=[[20, 0], [40, 100]])
        ayna = {k: v for k, v in f.items()}
        for k in ("bas_tepesi", "cene", "bel", "kasik", "taban"):
            ayna[k] = [100 - f[k][0], f[k][1]]
        ayna["omuz_sol"], ayna["omuz_sag"] = [100 - f["omuz_sag"][0], 24], [100 - f["omuz_sol"][0], 24]
        for k in ("dirsekler", "dizler", "ayaklar"):
            ayna[k] = [[100 - x, y] for x, y in f[k]]
        ayna["el_kutulari"] = [[100 - k[2], k[1], 100 - k[0], k[3]] for k in f["el_kutulari"]]
        ayna["silah_ekseni"] = [[100 - x, y] for x, y in f["silah_ekseni"]]
        self.assertAlmostEqual(olcum.poz_uzakligi(olcum.poz_isaretten(f), olcum.poz_isaretten(ayna)), 0, places=6)

    def test_farkli_poz_uzak(self):
        a = olcum.poz_isaretten(figur())
        b = olcum.poz_isaretten(figur(dirsekler=[[30, 20], [70, 20]], el_kutulari=[[20, 5, 26, 11], [74, 5, 80, 11]]))
        self.assertGreater(olcum.poz_uzakligi(a, b), 10)

    def test_olcek_pozu_degistirmez(self):
        # Aynı figürün iki kat büyüğü aynı pozdur: açılar ölçekten bağımsızdır
        f = figur()
        buyuk = {k: ([[2 * x for x in p] for p in v] if isinstance(v[0], list) else [2 * x for x in v])
                 if isinstance(v, list) else v for k, v in f.items()}
        self.assertAlmostEqual(olcum.poz_uzakligi(olcum.poz_isaretten(f), olcum.poz_isaretten(buyuk)), 0, places=6)

    def test_en_iyi_eslesme_aynayi_dondurur(self):
        p = olcum.poz_isaretten(figur(dirsekler=[[30, 30], [62, 36]]))
        d, eslesen = olcum.en_iyi_eslesme(p, olcum.aynala(p))
        self.assertAlmostEqual(d, 0, places=6)
        self.assertAlmostEqual(eslesen["kol"][0][0], p["kol"][0][0], places=6)

    def test_cop_adam_govdesi_bir_birim(self):
        p = olcum.poz_isaretten(figur())
        (a, b), *_ = olcum.cop_adam(p, olcek=100)
        self.assertAlmostEqual(math.dist(a, b), 100, places=6)

    def test_aci_farki_yari_turda(self):
        self.assertAlmostEqual(olcum.aci_farki(350, 10), 20)
        self.assertAlmostEqual(olcum.aci_farki(170, 10, yari=True), 20)

    def test_kukla_karesinden_poz(self):
        yapi = {"parcalar": [{"ad_tr": a, "yerel_kutu_bas": [0, 0, 0, 1.3]} for a in ("on_kol_on", "on_kol_arka")]
                + [{"ad_tr": a, "yerel_kutu_bas": [0, 0, 0, 1.15]} for a in ("baldir_on", "baldir_arka")]}
        asagi = [0.0, 1.0]
        kare = {"eklem": {"bas": [0, -2, 0] + asagi, "uyluk_on": [0, 0, 0] + asagi, "uyluk_arka": [0, 0, 0] + asagi,
                          "baldir_on": [0, 1, 0] + asagi, "baldir_arka": [0, 1, 0] + asagi,
                          "ust_kol_on": [0, -1.8, 0] + asagi, "on_kol_on": [0, -1, 0] + [1.0, 0.0],
                          "ust_kol_arka": [0, -1.8, 0] + asagi, "on_kol_arka": [0, -1, 0] + asagi}}
        p = olcum.poz_kukladan(kare, yapi)
        self.assertAlmostEqual(p["govde"], -90)
        self.assertAlmostEqual(p["kol"][0][0], 90)
        self.assertAlmostEqual(p["kol"][0][1], 0)
        self.assertAlmostEqual(p["bacak"][1][1], 90)


class Asimetri(unittest.TestCase):
    def test_simetrik_figur_sifir(self):
        self.assertAlmostEqual(olcum.asimetri(olcum.poz_isaretten(figur())), 0, places=6)

    def test_tek_kol_kalkinca_artar(self):
        p = olcum.poz_isaretten(figur(dirsekler=[[30, 14], [62, 36]]))
        self.assertGreater(olcum.asimetri(p), 5)


class EgriOrani(unittest.TestCase):
    def test_kenarlar_sayilir(self):
        el = ET.fromstring('<path d="M0 0 L10 0 Q20 5 10 10 20 15 10 20 L0 20 Z" fill="#000000"/>')
        self.assertAlmostEqual(olcum.egri_orani([(el, olcum.BIRIM, 1.0)]), 0.5)

    def test_kontur_yolu_sayilmaz(self):
        el = ET.fromstring('<path d="M0 0 L10 0" fill="none" stroke="#000000"/>')
        self.assertIsNone(olcum.egri_orani([(el, olcum.BIRIM, 1.0)]))


class Doygunluk(unittest.TestCase):
    def test_degrade_alani_uclara_bolunur(self):
        self.assertEqual(olcum.renk_payi([["degrade #FF0000→#808080", 0.5], ["#FFFFFF", 0.5]]),
                         [("#FF0000", 0.25), ("#808080", 0.25), ("#FFFFFF", 0.5)])

    def test_doygun_alan_aile_ve_saf_renk(self):
        o = olcum.doygunluk_olculeri([["#FF0000", 0.1], ["#CC0000", 0.1], ["#0000CC", 0.01], ["#999999", 0.79]])
        self.assertAlmostEqual(o["doygun_alan"], 0.21)
        self.assertEqual(o["doygun_aile"], 1)  # mavinin alanı %2'den az, sayılmaz
        self.assertAlmostEqual(o["saf_ana_renk_alani"], 0.1)


class Rapor(unittest.TestCase):
    def test_dagilim_ceyrekler(self):
        d = olcum.dagilim([1, 2, 3, 4, 5, None])
        self.assertEqual((d["en_kucuk"], d["ceyrek_1"], d["ortanca"], d["ceyrek_3"], d["en_buyuk"], d["sayi"]),
                         (1, 2, 3, 4, 5, 5))

    def test_dagilim_bos(self):
        self.assertIsNone(olcum.dagilim([None]))

    def test_renk_doygunlugu(self):
        self.assertAlmostEqual(olcum.renk_doygunlugu("#FF0000"), 1)
        self.assertAlmostEqual(olcum.renk_doygunlugu("degrade #FF0000→#FFFFFF"), 0.5)

    def test_karsilastirma_tablosu_sayar(self):
        d = {"en_kucuk": 0, "ceyrek_1": 1, "ortanca": 2, "ceyrek_3": 3, "en_buyuk": 4}
        md = olcum.karsilastirma_md("bizim", [("a", d, 2.0, True), ("b", d, 9.0, False), ("c", d, 1.0, None)])
        self.assertIn("| a | 0 | 1 | 2 | 3 | 4 | 2 | GEÇTİ |", md)
        self.assertIn("KALDI", md)
        self.assertIn("Geçen: 1 / 2", md)

    def test_sahibin_siniri_orta_yarinin_yerine_gecer(self):
        d = {"ceyrek_1": 1, "ceyrek_3": 2.5}
        self.assertEqual(olcum.gecme_araligi("doygun_aile", d), (0, 1))
        self.assertEqual(olcum.gecme_araligi("dolgu_grubu", d), (1, 2.5))

    def test_sayi_virgullu(self):
        self.assertEqual(olcum.sayi(0.125), "0,125")
        self.assertEqual(olcum.sayi(None), "–")


class KuklaYapisi(unittest.TestCase):
    def test_y_ekseni_birim_vektor(self):
        x, y = kukla_yapisi.y_ekseni((2, 0, 0, 2, 0, 0))
        self.assertEqual((x, y), (0.0, 1.0))
        x, y = kukla_yapisi.y_ekseni((0, 1, -3, 0, 0, 0))
        self.assertAlmostEqual(math.hypot(x, y), 1)
        self.assertEqual((x, y), (-1.0, 0.0))


if __name__ == "__main__":
    unittest.main()
