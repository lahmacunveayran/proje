//! Oyunun kuralları: savaş benzetimi, ordu, kahraman, dünya.
//!
//! Bu paket grafik, pencere ya da ses bilmez ve belirlenimcidir: aynı tohum ve aynı girdiler
//! her zaman aynı sonucu verir. Sabit adımla (saniyede [`TICKS_PER_SECOND`]) ilerler.

pub mod rng;

/// Benzetimin saniyedeki adım sayısı.
pub const TICKS_PER_SECOND: u32 = 60;

/// Benzetimin adım sayacı.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Tick(pub u64);

impl Tick {
    pub fn next(self) -> Tick {
        Tick(self.0 + 1)
    }

    /// Adımın saniye cinsinden karşılığı.
    pub fn seconds(self) -> f64 {
        self.0 as f64 / f64::from(TICKS_PER_SECOND)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tick_advances_and_converts() {
        let t = Tick::default().next().next();
        assert_eq!(t, Tick(2));
        assert_eq!(Tick(120).seconds(), 2.0);
    }
}
