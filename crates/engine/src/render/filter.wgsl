// Süzgeç gölgelendiricisi: bütün ekranı kaplayan tek üçgen üstünde çalışır; dokular piksel piksel
// okunur (girdi ve çıktı aynı boyda). Renkler önceden çarpılmış saydamlıkla.

struct Params {
    // Bulanıklık yönü (1, 0) ya da (0, 1).
    dir: vec2<f32>,
    // Kutu süzgecinin genişliği (piksel).
    width: f32,
    // Parlamanın gücü.
    strength: f32,
    // Parlamanın rengi (düz, saydamlık ayrı).
    color: vec4<f32>,
    // x: iç parlama, y: delme (şeklin kendisi çizilmez).
    mode: vec4<u32>,
};

@group(0) @binding(0) var source: texture_2d<f32>;
@group(0) @binding(1) var base: texture_2d<f32>;
@group(0) @binding(2) var<uniform> params: Params;

@vertex
fn vs_full(@builtin(vertex_index) i: u32) -> @builtin(position) vec4<f32> {
    let x = f32((i << 1u) & 2u);
    let y = f32(i & 2u);
    return vec4<f32>(x * 2.0 - 1.0, 1.0 - y * 2.0, 0.0, 1.0);
}

fn texel(t: texture_2d<f32>, p: vec2<i32>) -> vec4<f32> {
    let size = vec2<i32>(textureDimensions(t));
    if p.x < 0 || p.y < 0 || p.x >= size.x || p.y >= size.y {
        return vec4<f32>(0.0);
    }
    return textureLoad(t, p, 0);
}

// Kutu süzgeci: piksel merkezli [-w/2, w/2] aralığının her pikselle örtüşen payı ağırlıktır.
@fragment
fn fs_blur(@builtin(position) pos: vec4<f32>) -> @location(0) vec4<f32> {
    let p = vec2<i32>(floor(pos.xy));
    let half = params.width * 0.5;
    let reach = i32(ceil(half - 0.5));
    let step = vec2<i32>(params.dir);
    var sum = vec4<f32>(0.0);
    var total = 0.0;
    for (var k = -reach; k <= reach; k++) {
        let x = f32(k);
        let w = clamp(min(x + 0.5, half) - max(x - 0.5, -half), 0.0, 1.0);
        sum += texel(source, p + step * k) * w;
        total += w;
    }
    if total <= 0.0 {
        return texel(source, p);
    }
    return sum / total;
}

// Parlama: `source` bulanıklaştırılmış hâl, `base` özgün çizim.
@fragment
fn fs_glow(@builtin(position) pos: vec4<f32>) -> @location(0) vec4<f32> {
    let p = vec2<i32>(floor(pos.xy));
    let s = texel(base, p);
    let b = texel(source, p);
    let colour = vec4<f32>(params.color.rgb * params.color.a, params.color.a);
    if params.mode.x == 1u {
        // İç parlama: şeklin içinde, kenardan içeri doğru
        let a = clamp((1.0 - b.a) * params.strength, 0.0, 1.0) * s.a;
        let glow = colour * a;
        if params.mode.y == 1u {
            return glow;
        }
        return glow + s * (1.0 - glow.a);
    }
    let glow = colour * clamp(b.a * params.strength, 0.0, 1.0);
    if params.mode.y == 1u {
        return glow * (1.0 - s.a);
    }
    return s + glow * (1.0 - s.a);
}

// Süzgeçli katmanı üstteki çizime koyar.
@fragment
fn fs_copy(@builtin(position) pos: vec4<f32>) -> @location(0) vec4<f32> {
    return texel(source, vec2<i32>(floor(pos.xy)));
}
