//! Klavye ve fare girdisi.
//!
//! Pencere olayları buraya yazılır; oyun her sabit adımda durumu okur. "Basıldı" bilgisi,
//! onu gören ilk adımdan sonra silinir; böylece hiçbir tuş basışı kaybolmaz ya da iki kez
//! sayılmaz.

use std::collections::HashSet;

use glam::Vec2;

pub use winit::keyboard::KeyCode as Key;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum MouseButton {
    Left,
    Right,
    Middle,
}

#[derive(Clone, Debug, Default)]
pub struct Input {
    down: HashSet<Key>,
    pressed: HashSet<Key>,
    released: HashSet<Key>,
    mouse_down: HashSet<MouseButton>,
    mouse_pressed: HashSet<MouseButton>,
    mouse_released: HashSet<MouseButton>,
    /// Farenin mantıksal ekrandaki konumu.
    mouse: Vec2,
}

impl Input {
    pub fn key_down(&self, key: Key) -> bool {
        self.down.contains(&key)
    }

    /// Tuş bu adımda (ya da son adımdan beri) basıldı mı?
    pub fn key_pressed(&self, key: Key) -> bool {
        self.pressed.contains(&key)
    }

    pub fn key_released(&self, key: Key) -> bool {
        self.released.contains(&key)
    }

    pub fn mouse_down(&self, button: MouseButton) -> bool {
        self.mouse_down.contains(&button)
    }

    pub fn mouse_pressed(&self, button: MouseButton) -> bool {
        self.mouse_pressed.contains(&button)
    }

    pub fn mouse_released(&self, button: MouseButton) -> bool {
        self.mouse_released.contains(&button)
    }

    /// Farenin mantıksal ekrandaki (1920×1080) konumu.
    pub fn mouse_position(&self) -> Vec2 {
        self.mouse
    }

    pub fn on_key(&mut self, key: Key, is_down: bool) {
        if is_down {
            // Tuş basılı tutulunca işletim sistemi tekrar olayları gönderir; bunlar yeni basış değildir.
            if self.down.insert(key) {
                self.pressed.insert(key);
            }
        } else if self.down.remove(&key) {
            self.released.insert(key);
        }
    }

    pub fn on_mouse_button(&mut self, button: MouseButton, is_down: bool) {
        if is_down {
            if self.mouse_down.insert(button) {
                self.mouse_pressed.insert(button);
            }
        } else if self.mouse_down.remove(&button) {
            self.mouse_released.insert(button);
        }
    }

    pub fn on_mouse_move(&mut self, logical: Vec2) {
        self.mouse = logical;
    }

    /// Pencere odağı kaybedince basılı tuşları bırakır (takılı kalmasınlar).
    pub fn release_all(&mut self) {
        self.released.extend(self.down.drain());
        self.mouse_released.extend(self.mouse_down.drain());
    }

    /// Bir sabit adım bittiğinde çağrılır: tek seferlik olayları siler.
    pub fn end_step(&mut self) {
        self.pressed.clear();
        self.released.clear();
        self.mouse_pressed.clear();
        self.mouse_released.clear();
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn press_is_seen_once() {
        let mut i = Input::default();
        i.on_key(Key::Space, true);
        assert!(i.key_down(Key::Space) && i.key_pressed(Key::Space));
        i.end_step();
        assert!(i.key_down(Key::Space) && !i.key_pressed(Key::Space));
    }

    #[test]
    fn key_repeat_is_not_a_new_press() {
        let mut i = Input::default();
        i.on_key(Key::KeyW, true);
        i.end_step();
        i.on_key(Key::KeyW, true);
        assert!(!i.key_pressed(Key::KeyW));
    }

    #[test]
    fn quick_tap_between_steps_is_not_lost() {
        let mut i = Input::default();
        i.on_key(Key::KeyA, true);
        i.on_key(Key::KeyA, false);
        assert!(i.key_pressed(Key::KeyA));
        assert!(i.key_released(Key::KeyA));
        assert!(!i.key_down(Key::KeyA));
    }

    #[test]
    fn mouse_buttons_and_position() {
        let mut i = Input::default();
        i.on_mouse_move(Vec2::new(10.0, 20.0));
        i.on_mouse_button(MouseButton::Left, true);
        assert!(i.mouse_pressed(MouseButton::Left));
        assert_eq!(i.mouse_position(), Vec2::new(10.0, 20.0));
        i.end_step();
        i.on_mouse_button(MouseButton::Left, false);
        assert!(i.mouse_released(MouseButton::Left) && !i.mouse_down(MouseButton::Left));
    }

    #[test]
    fn focus_loss_releases_everything() {
        let mut i = Input::default();
        i.on_key(Key::KeyD, true);
        i.on_mouse_button(MouseButton::Right, true);
        i.release_all();
        assert!(!i.key_down(Key::KeyD) && i.key_released(Key::KeyD));
        assert!(!i.mouse_down(MouseButton::Right));
    }
}
