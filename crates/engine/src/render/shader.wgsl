// Vektör çizim gölgelendiricisi.
//
// Renkler sRGB uzayında ve önceden çarpılmış saydamlıkla karışır (Flash'taki gibi).
// Degradeler, şekil koordinatlarından birim degrade uzayına çevrilip bir renk şeridinden okunur.

struct View {
    // Mantıksal koordinatlardan kırpma uzayına dönüşümün iki satırı.
    row0: vec4<f32>,
    row1: vec4<f32>,
    // x: rampa dokusunun satır sayısı; y, z: resim atlasının genişliği ve yüksekliği.
    ramp: vec4<f32>,
};

struct Paint {
    kind: u32,
    spread: u32,
    ramp_row: u32,
    pad: u32,
    color: vec4<f32>,
    m0: vec4<f32>,
    m1: vec4<f32>,
    focal: vec4<f32>,
};

@group(0) @binding(0) var<uniform> view: View;
@group(0) @binding(1) var<storage, read> paints: array<Paint>;
@group(0) @binding(2) var ramp_texture: texture_2d<f32>;
@group(0) @binding(3) var ramp_sampler: sampler;
@group(0) @binding(4) var atlas: texture_2d<f32>;

struct VertexIn {
    @location(0) position: vec2<f32>,
    @location(1) paint: u32,
    // Örnek (instance) bilgisi: dönüşümün iki satırı ve renk dönüşümü.
    @location(2) t0: vec4<f32>,
    @location(3) t1: vec4<f32>,
    @location(4) mul: vec4<f32>,
    @location(5) add: vec4<f32>,
};

struct VertexOut {
    @builtin(position) clip: vec4<f32>,
    @location(0) local: vec2<f32>,
    @location(1) @interpolate(flat) paint: u32,
    @location(2) @interpolate(flat) mul: vec4<f32>,
    @location(3) @interpolate(flat) add: vec4<f32>,
};

@vertex
fn vs_main(in: VertexIn) -> VertexOut {
    let p = vec3<f32>(in.position, 1.0);
    let world = vec3<f32>(dot(in.t0.xyz, p), dot(in.t1.xyz, p), 1.0);
    var out: VertexOut;
    out.clip = vec4<f32>(dot(view.row0.xyz, world), dot(view.row1.xyz, world), 0.0, 1.0);
    out.local = in.position;
    out.paint = in.paint;
    out.mul = in.mul;
    out.add = in.add;
    return out;
}

fn apply_spread(t: f32, mode: u32) -> f32 {
    if mode == 1u {
        // Aynalama
        let m = fract(t * 0.5);
        return 1.0 - abs(m * 2.0 - 1.0);
    }
    if mode == 2u {
        // Tekrar
        return fract(t);
    }
    return clamp(t, 0.0, 1.0);
}

fn gradient_t(paint: Paint, local: vec2<f32>) -> f32 {
    let p = vec3<f32>(local, 1.0);
    let u = vec2<f32>(dot(paint.m0.xyz, p), dot(paint.m1.xyz, p));
    if paint.kind == 1u {
        return u.x;
    }
    let f = paint.focal.xy;
    if dot(f, f) < 1e-12 {
        return length(u);
    }
    // Odaklı radyal degrade: odaktan geçen ışının birim daireyi kestiği yere göre oran.
    let d = u - f;
    let len = length(d);
    if len < 1e-9 {
        return 0.0;
    }
    let dir = d / len;
    let b = dot(f, dir);
    let c = dot(f, f) - 1.0;
    let s = -b + sqrt(max(b * b - c, 0.0));
    if s <= 1e-9 {
        return 1.0;
    }
    return len / s;
}

@fragment
fn fs_main(in: VertexOut) -> @location(0) vec4<f32> {
    let paint = paints[in.paint];
    var c: vec4<f32>;
    if paint.kind == 0u {
        c = paint.color;
    } else if paint.kind == 3u {
        // Resim: m0/m1 şekil koordinatlarından resim pikseline; focal atlastaki yer (x, y, en, boy);
        // spread 1 kırpılmış (kenar uzar), 0 tekrarlı; ramp_row 1 yumuşatmalı; color.x saydamlık.
        let p = vec3<f32>(in.local, 1.0);
        var u = vec2<f32>(dot(paint.m0.xyz, p), dot(paint.m1.xyz, p));
        let size = paint.focal.zw;
        if paint.spread == 1u {
            u = clamp(u, vec2<f32>(0.0), size - vec2<f32>(0.001));
        } else {
            u = u - floor(u / size) * size;
        }
        if paint.ramp_row == 1u {
            let q = clamp(u, vec2<f32>(0.5), size - vec2<f32>(0.5));
            c = textureSampleLevel(atlas, ramp_sampler, (paint.focal.xy + q) / view.ramp.yz, 0.0);
        } else {
            c = textureLoad(atlas, vec2<i32>(paint.focal.xy + floor(u)), 0);
        }
        c = c * paint.color.x;
    } else {
        let t = apply_spread(gradient_t(paint, in.local), paint.spread);
        let uv = vec2<f32>((t * 255.0 + 0.5) / 256.0, (f32(paint.ramp_row) + 0.5) / view.ramp.x);
        c = textureSampleLevel(ramp_texture, ramp_sampler, uv, 0.0);
    }
    // Renk dönüşümü (Flash'taki gibi): düz renk üzerinde çarpma ve ekleme.
    var straight = vec4<f32>(0.0);
    if c.a > 0.0 {
        straight = vec4<f32>(c.rgb / c.a, c.a);
    }
    let r = clamp(straight * in.mul + in.add, vec4<f32>(0.0), vec4<f32>(1.0));
    return vec4<f32>(r.rgb * r.a, r.a);
}
