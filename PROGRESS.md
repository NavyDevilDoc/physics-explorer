# PROGRESS.md — Physics Simulator Suite

## Current Status: Simulators 1–5 Complete

**Last updated:** 2026-04-03

---

## Simulator 1: Projectile Motion — COMPLETE

### Files
- `projectile-sim.jsx` — Original React/JSX artifact version
- `projectile-sim.html` — Standalone HTML version (primary, runs in any browser)

### Build Summary

| Phase | Description | Status |
|-------|-------------|--------|
| 1 — Core Physics Engine | Analytical + Euler numerical integration, adaptive dt, ground interpolation, edge cases | ✅ Done |
| 2 — UI Shell & Inputs | Dark theme, Google Fonts, all sliders/presets per spec, drag toggle | ✅ Done |
| 3 — Trajectory Chart | Recharts LineChart, animated dot, comparison overlay, playback controls | ✅ Done |
| 4 — Live Readouts | Summary metrics, ideal vs drag comparison, live vx/vy readout | ✅ Done |
| 5 — Pedagogical Layer | 45° hint, complementary angles, drag insights, free fall hint | ✅ Done |
| 6 — Polish & Safeguards | Comparison warning, point cap at 3000, adaptive step size | ✅ Done |
| 7 — Dual Animation | Both drag and ideal projectiles animate simultaneously on same clock | ✅ Done |

### Architecture Decision: HTML over JSX
Converted from `.jsx` (requires Claude.ai artifact renderer or Node.js) to standalone `.html` (double-click to open in browser). React, Recharts, and Babel loaded from CDNs. No install required.

### Key Features
- All inputs per CLAUDE.md spec (velocity, angle, height, mass, drag, gravity presets)
- Drag toggle switches analytical → numerical engine
- Dual animated dots: orange (drag) and cyan (ideal) race simultaneously
- Animation continues until the slower projectile lands
- Dynamic equation panel, live readouts, auto-triggered pedagogical hints
- Comparison warning when drag range diverges significantly from ideal

### Safeguards
- v₀ = 0 edge case, mass floor at 0.01, 60K step cap, 3K point cap
- Adaptive Euler step size, ground interpolation, discriminant checks

### Remaining Items (Non-blocking)
- Accessibility: color-coded vx/vy needs non-color indicators for colorblind users
- Streamlit/Python port for potential web deployment

---

## Simulator 2: Newton's Second Law & Forces — COMPLETE

**File:** `forces-sim.html`
**Scope:** Algebra-based (no calculus), high school Physics 1 level

### Architecture
Single HTML file with 7 tabbed scenarios, each self-contained with its own state. SVG-based force diagrams with color-coded, proportionally-scaled force arrows. Same dark theme and design system as Simulator 1.

### Tabs Implemented

| Tab | Topic | Key Physics | Status |
|-----|-------|-------------|--------|
| 1 — Forces 1D | Block on flat surface | F = ma, equilibrium, optional opposing force | ✅ Done |
| 2 — Inclined Plane | Vector decomposition | mg·sin(θ), mg·cos(θ), normal force, a = g·sin(θ) | ✅ Done |
| 3 — Friction | Static vs kinetic | μ_s·N threshold, μ_k < μ_s, sliding detection | ✅ Done |
| 4 — Box Up Ramp | Incline + friction + applied force | Three regimes: accelerating up / equilibrium / slides back | ✅ Done |
| 5 — Atwood Machine | Two masses on pulley | a = (m₁-m₂)g/(m₁+m₂), T = 2m₁m₂g/(m₁+m₂) | ✅ Done |
| 6 — Hanging Signs | Tension in cables at angles | Static equilibrium, ΣFx=0, ΣFy=0, solve T₁ and T₂ | ✅ Done |
| 7 — Work & Energy | W = Fd·cos(θ) | Work-energy theorem, energy bar chart (Recharts) | ✅ Done |

### Shared Components
- **ForceArrow** — SVG arrow with arrowhead, label, proportional scaling, dashed option
- **Panel** — Reusable dark-themed card with Orbitron title
- **TabLayout** — Consistent left (sliders/equations) + right (diagram/results/hints) layout
- **EquationBlock** — Styled equation display with per-line coloring
- **HintBox** — Pedagogical hints auto-triggered by parameter state

### Force Color Coding
| Color | Force Type |
|-------|-----------|
| Orange (#ff6b35) | Applied force |
| Red (#ef4444) | Weight / gravity |
| Green (#22c55e) | Normal force |
| Yellow (#eab308) | Friction |
| Purple (#a855f7) | Tension |
| Cyan (#00d4ff) | Net force (dashed) |

### Safeguards
- μ_k automatically clamped to ≤ μ_s when user adjusts sliders (Tab 3)
- Normal force clamped to ≥ 0 with liftoff detection (Tab 7)
- sin(θ₁+θ₂) guarded against near-zero for shallow cable angles (Tab 6)
- Mass minimum enforced to prevent division by zero

### Pedagogical Highlights
- Tab 2: "Acceleration doesn't depend on mass on a frictionless ramp" (Galileo insight)
- Tab 3: Static→kinetic transition explained ("harder to START than to KEEP moving")
- Tab 5: Equal-mass equilibrium, massless-string assumption explained
- Tab 6: "Nearly horizontal cables carry enormous tension" — why cables always sag
- Tab 7: cos(θ) in work formula explained visually (90° = zero work)

### Known Limitations
- SVG block positioning on inclined planes is close but not pixel-perfect (visual only, physics correct)

### Remaining Items (Non-blocking)
- Accessibility improvements (color-blind indicators on force arrows)
- Could add animation (block sliding on surface) in future iteration
- Python/Streamlit port for classroom deployment

---

## Simulator 3: Energy & Collisions — COMPLETE

**File:** `collisions-sim.html`
**Scope:** Algebra-based, high school Physics 1 level
**Architecture:** Same as Simulator 2 — single HTML file, tabbed, SVG diagrams, Recharts bar charts

### Tabs Implemented

| Tab | Topic | Key Physics | Key Visual | Status |
|-----|-------|-------------|------------|--------|
| 1 — KE & PE | Kinetic & potential energy | KE = ½mv², PE = mgh, E_total = KE + PE | Stacked bar chart showing KE/PE exchange during fall | ✅ Done |
| 2 — Energy Conservation | Ramp with friction toggle | KE ↔ PE exchange, W_friction = μk·N·d | Ramp SVG with balls at top/bottom + energy bar chart | ✅ Done |
| 3 — Springs | Elastic potential energy | PE_spring = ½kx², v = x√(k/m) | Animated spring coils SVG + energy bar chart | ✅ Done |
| 4 — Elastic Collisions | Two objects, bounce off | Conserve momentum AND KE, solve v₁' and v₂' | Before/after SVG with velocity arrows | ✅ Done |
| 5 — Inelastic Collisions | Objects stick together | Conserve momentum, KE NOT conserved, % lost | Before/after SVG + KE loss bar chart | ✅ Done |
| 6 — Collision Lab | Choose elastic vs inelastic | Side-by-side momentum & KE comparison | Conservation comparison bar chart | ✅ Done |

### Pedagogical Highlights
- **Tab 1:** Stacked bar chart shows KE/PE exchange at 6 heights during a fall — total stays constant
- **Tab 2:** Friction toggle reveals energy "lost" to heat; shallower ramp = more friction distance = more loss
- **Tab 3:** "Double the compression, quadruple the energy" (x² relationship)
- **Tab 4:** Equal masses swap velocities (billiard ball insight)
- **Tab 5:** Shows % KE lost — "where did the energy go?" (sound, heat, deformation)
- **Tab 6:** Toggle elastic/inelastic with same inputs — momentum ALWAYS conserved, KE only in elastic

### Color Coding
| Color | Quantity |
|-------|---------|
| Orange (#ff6b35) | Kinetic energy / Object 1 |
| Purple (#a855f7) | Potential energy / Momentum |
| Green (#22c55e) | Spring PE |
| Red (#ef4444) | Energy lost to heat |
| Cyan (#00d4ff) | Total energy / Object 2 |

### Safeguards
- All energy calculations clamped to ≥ 0 (no negative KE)
- Spring compression range limited to physical values
- μk clamping ensures friction can't exceed available PE

---

## Simulator 4: Pendulums & Simple Harmonic Motion — COMPLETE

**File:** `pendulum-sim.html`
**Scope:** Algebra-based, high school Physics 1 level
**Architecture:** Same tabbed HTML pattern. Heavy on animation — every tab has real-time moving elements.

### Tabs Implemented

| Tab | Topic | Key Physics | Key Visual | Status |
|-----|-------|-------------|------------|--------|
| 1 — Simple Pendulum | Swinging bob | T = 2π√(L/g), KE↔PE exchange | Animated pendulum SVG with live energy bars | ✅ Done |
| 2 — Mass-Spring | Horizontal oscillator | T = 2π√(m/k), x(t) = A cos(ωt) | Animated spring coils + sliding block + energy bars | ✅ Done |
| 3 — SHM Graphs | x(t), v(t), a(t) | Phase relationships: v leads x by 90°, a by 180° | Three stacked Recharts line graphs with time cursor | ✅ Done |
| 4 — Damped Oscillations | Exponential decay | x(t) = Ae^(-bt)cos(ω_d t) | Oscillation with red dashed decay envelope | ✅ Done |
| 5 — Pendulum Lab | Full exploration | Gravity presets, large angle toggle, period comparison | Animated pendulum + small vs large angle comparison | ✅ Done |

### Key Engineering Decisions
- **Reusable animation hook** (`useAnimLoop`) — shared by all 5 tabs, manages RAF loop and sim time
- **`PlayControls` component** — consistent Play/Pause/Reset buttons across all tabs
- **No template literals** — learned from elastic collision crash; all string building uses concatenation
- **`React.createElement` for SVG groups** — avoids Babel JSX edge cases inside render functions
- **Large angle mode** (Tab 5) uses Euler numerical integration for accuracy beyond small-angle approximation

### Pedagogical Highlights
- **Tab 1:** "Period doesn't depend on mass" — Galileo's insight, proven with the slider
- **Tab 2:** "Spring period depends on mass, pendulum period depends on length" — key contrast
- **Tab 3:** Phase relationships visualized with time cursor sweeping across all three graphs simultaneously
- **Tab 4:** Three damping regimes with real-world analogies (swing, car shock, honey)
- **Tab 5:** Small-angle approximation error shown numerically (% error vs actual period)

### Safeguards
- Euler integration step-capped at 200K for large-angle mode
- ω_d clamped to avoid imaginary sqrt in overdamped regime
- All energy calculations use max(value, 0.01) for bar height rendering

---

## Simulator 5: Circular Motion & Centripetal Force — COMPLETE

**File:** `circular-sim.html`
**Scope:** Algebra-based, high school Physics 1 level
**Architecture:** Pure `React.createElement` throughout (no JSX/Babel compilation issues). Same tabbed pattern.

### Tabs Implemented

| Tab | Topic | Key Physics | Key Visual | Status |
|-----|-------|-------------|------------|--------|
| 1 — Uniform Circular | Constant-speed circle | v = 2πr/T, a_c = v²/r | Animated dot with tangent v and inward a_c arrows | ✅ Done |
| 2 — Centripetal Force | What provides F_c? | F_c = mv²/r, scenario presets | Animated orbit + force arrow + scenario selector | ✅ Done |
| 3 — Vertical Circles | Ball on string in loop | v_min = √(gr), T varies around loop | Animated vertical loop with tension + weight arrows | ✅ Done |
| 4 — Banked Curves | Car on banked road | tan(θ) = v²/(rg), friction toggle | SVG cross-section with force decomposition | ✅ Done |
| 5 — Circular ↔ SHM | The connection | x-projection of circle = cosine wave | Side-by-side animated circle + SHM + Recharts wave | ✅ Done |

### Key Engineering Decision
Entire file uses `React.createElement` (aliased as `h`) instead of JSX — eliminates all Babel template literal and JSX compilation edge cases. This is the most robust pattern we've found.

### Pedagogical Highlights
- **Tab 1:** "Speed is constant but velocity changes direction — that IS acceleration"
- **Tab 2:** "No centrifugal force — it's your inertia wanting to go straight" + 3 real-world scenarios
- **Tab 3:** "Why don't you fall out at the top?" — critical speed concept, T_bottom > T_top explained
- **Tab 4:** NASCAR banking angles, friction extends safe speed range
- **Tab 5:** The "aha" moment — SHM is just the shadow of circular motion

---

## Course Progression Map

| # | Topic | File | Status |
|---|-------|------|--------|
| 1 | Projectile Motion | `projectile-sim.html` | ✅ Complete |
| 2 | Newton's Second Law & Forces | `forces-sim.html` | ✅ Complete |
| 3 | Energy & Collisions | `collisions-sim.html` | ✅ Complete |
| 4 | Pendulums & SHM | `pendulum-sim.html` | ✅ Complete |
| 5 | Circular Motion | `circular-sim.html` | ✅ Complete |
| 6 | Waves & Sound | TBD | — |
| 7 | Optics (Snell's Law) | TBD | — |

*Note: Course order follows standard algebra-based Physics 1 curriculum. Mechanics is now complete (simulators 1–5). Remaining topics transition to waves and optics.*

---

## Website: Physics Explorer

**File:** `index.html` (landing page)
**Architecture:** Pure HTML/CSS, no JavaScript. Links to each simulator.

### Features
- Dark-themed landing page matching the simulator design system
- Card grid with module number, title, description, and topic tags
- Hover effects (border glow, lift, arrow reveal)
- "Coming Soon" placeholder cards for Waves & Optics (dashed border, dimmed)
- Each simulator has a "Back to Physics Explorer" nav link at top
- Responsive grid layout (auto-fills columns at 300px min)

### Deployment
Ready for static hosting on Vercel, Netlify, or GitHub Pages. No build step — just upload the folder. All CDN dependencies (React, Recharts, Babel, Google Fonts) load on first visit, then browser-cached for offline use.
