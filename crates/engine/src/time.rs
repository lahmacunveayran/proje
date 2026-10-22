//! Sabit adımlı zaman.
//!
//! Oyunun kuralları saniyede sabit sayıda (60) adımla ilerler; çizim ise ekranın yenilenme
//! hızında yapılır. İki adım arasında çizilen karelerde konumlar `alpha` ile ara değerlenir.

/// Sabit adımlı saat.
#[derive(Clone, Debug)]
pub struct FixedStep {
    step: f64,
    accumulator: f64,
    max_steps: u32,
}

impl FixedStep {
    /// Saniyede `hz` adım. Bir karede en fazla `max_steps` adım atılır; bilgisayar geride
    /// kalırsa fazlası atılır (oyun yavaşlar ama donmaz).
    pub fn new(hz: u32, max_steps: u32) -> Self {
        FixedStep {
            step: 1.0 / f64::from(hz.max(1)),
            accumulator: 0.0,
            max_steps: max_steps.max(1),
        }
    }

    pub fn step_seconds(&self) -> f64 {
        self.step
    }

    /// Geçen süreyi ekler ve bu karede atılması gereken adım sayısını döndürür.
    pub fn advance(&mut self, dt_seconds: f64) -> u32 {
        self.accumulator += dt_seconds.max(0.0);
        let mut steps = 0;
        while self.accumulator >= self.step && steps < self.max_steps {
            self.accumulator -= self.step;
            steps += 1;
        }
        if steps == self.max_steps && self.accumulator >= self.step {
            // Geride kalındı: birikeni at.
            self.accumulator %= self.step;
        }
        steps
    }

    /// Son adımdan bu yana geçen sürenin adım boyuna oranı (0..1).
    pub fn alpha(&self) -> f32 {
        (self.accumulator / self.step) as f32
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn counts_whole_steps() {
        let mut c = FixedStep::new(60, 5);
        assert_eq!(c.advance(1.0 / 120.0), 0);
        assert!((c.alpha() - 0.5).abs() < 1e-6);
        assert_eq!(c.advance(1.0 / 120.0), 1);
        assert!(c.alpha() < 1e-6);
        assert_eq!(c.advance(3.0 / 60.0 + 1e-9), 3);
    }

    #[test]
    fn long_frames_are_capped() {
        let mut c = FixedStep::new(60, 5);
        assert_eq!(c.advance(2.0), 5);
        assert!(c.alpha() < 1.0);
        assert_eq!(c.advance(0.0), 0);
    }

    #[test]
    fn negative_time_is_ignored() {
        let mut c = FixedStep::new(60, 5);
        assert_eq!(c.advance(-1.0), 0);
        assert_eq!(c.alpha(), 0.0);
    }

    #[test]
    fn total_steps_match_elapsed_time() {
        let mut c = FixedStep::new(60, 10);
        let mut total = 0;
        for _ in 0..1000 {
            total += c.advance(1.0 / 144.0);
        }
        // 1000 / 144 saniye ≈ 6,94 saniye ≈ 416 adım.
        assert_eq!(total, (1000.0_f64 / 144.0 * 60.0).floor() as u32);
    }
}
