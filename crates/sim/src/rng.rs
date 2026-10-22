//! Belirlenimci rastgele sayı üreteci (PCG32).
//!
//! İşletim sisteminden ya da saatten bağımsızdır; aynı tohum her bilgisayarda aynı diziyi verir.
//! Savaşların kaydedilip yeniden oynatılabilmesi buna dayanır.

/// PCG-XSH-RR 64/32 üreteci.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Rng {
    state: u64,
    inc: u64,
}

const MULTIPLIER: u64 = 6_364_136_223_846_793_005;

impl Rng {
    /// Tohum ve akış numarasıyla üreteç kurar. Aynı tohumla farklı akışlar bağımsız diziler verir.
    pub fn new(seed: u64, stream: u64) -> Self {
        let mut rng = Rng {
            state: 0,
            inc: (stream << 1) | 1,
        };
        rng.next_u32();
        rng.state = rng.state.wrapping_add(seed);
        rng.next_u32();
        rng
    }

    pub fn next_u32(&mut self) -> u32 {
        let old = self.state;
        self.state = old.wrapping_mul(MULTIPLIER).wrapping_add(self.inc);
        let xorshifted = (((old >> 18) ^ old) >> 27) as u32;
        let rot = (old >> 59) as u32;
        xorshifted.rotate_right(rot)
    }

    /// `0..bound` aralığında, eğilimsiz tamsayı. `bound` sıfırsa sıfır döner.
    pub fn below(&mut self, bound: u32) -> u32 {
        if bound == 0 {
            return 0;
        }
        let threshold = bound.wrapping_neg() % bound;
        loop {
            let r = self.next_u32();
            if r >= threshold {
                return r % bound;
            }
        }
    }

    /// `lo..=hi` aralığında tamsayı.
    pub fn range_i32(&mut self, lo: i32, hi: i32) -> i32 {
        if hi <= lo {
            return lo;
        }
        let span = (i64::from(hi) - i64::from(lo) + 1) as u64;
        if span > u64::from(u32::MAX) {
            return lo.wrapping_add(self.next_u32() as i32);
        }
        lo + self.below(span as u32) as i32
    }

    /// `0..1` aralığında kesirli sayı (24 bit duyarlıkla, platformdan bağımsız).
    pub fn unit_f32(&mut self) -> f32 {
        (self.next_u32() >> 8) as f32 / (1u32 << 24) as f32
    }

    /// `p` olasılıkla doğru döner.
    pub fn chance(&mut self, p: f32) -> bool {
        self.unit_f32() < p
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn same_seed_same_sequence() {
        let mut a = Rng::new(42, 7);
        let mut b = Rng::new(42, 7);
        for _ in 0..1000 {
            assert_eq!(a.next_u32(), b.next_u32());
        }
    }

    #[test]
    fn known_sequence_is_stable() {
        // Bu dizi değişirse eski kayıtlar ve tekrar oynatmalar bozulur.
        let mut r = Rng::new(42, 54);
        let got: Vec<u32> = (0..6).map(|_| r.next_u32()).collect();
        assert_eq!(
            got,
            vec![
                0xa15c02b7, 0x7b47f409, 0xba1d3330, 0x83d2f293, 0xbfa4784b, 0xcbed606e
            ]
        );
    }

    #[test]
    fn streams_differ() {
        let mut a = Rng::new(1, 1);
        let mut b = Rng::new(1, 2);
        let same = (0..100).filter(|_| a.next_u32() == b.next_u32()).count();
        assert!(same < 3);
    }

    #[test]
    fn below_stays_in_bounds_and_covers_range() {
        let mut r = Rng::new(9, 0);
        let mut seen = [false; 6];
        for _ in 0..1000 {
            let v = r.below(6);
            assert!(v < 6);
            seen[v as usize] = true;
        }
        assert!(seen.iter().all(|s| *s));
        assert_eq!(r.below(0), 0);
    }

    #[test]
    fn ranges_and_floats() {
        let mut r = Rng::new(3, 3);
        for _ in 0..1000 {
            let v = r.range_i32(-5, 5);
            assert!((-5..=5).contains(&v));
            let f = r.unit_f32();
            assert!((0.0..1.0).contains(&f));
        }
        assert_eq!(r.range_i32(4, 4), 4);
        assert_eq!(r.range_i32(4, 1), 4);
    }
}
