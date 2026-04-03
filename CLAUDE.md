# CLAUDE.md — Physics Simulator Suite

## Project Purpose

A collection of interactive physics simulators targeting high school Physics students (grades 9–11). Each simulator is a standalone React/JSX artifact rendered inside Claude.ai. The design philosophy is **layered complexity**: a student on day one can grasp the core concept, while sliders and toggles progressively surface real-world forces and edge cases.

The simulators are built in Claude.ai as rendered `.jsx` artifacts and optionally ported to a Python/Streamlit web app for classroom deployment.

---

## Architecture

### Rendering Target
- **Primary:** Claude.ai artifact renderer (React/JSX, single-file)
- **Secondary (planned):** Streamlit + Plotly for Python deployment

### Stack Constraints
- React with hooks (`useState`, `useEffect`, `useMemo`, `useCallback`, `useRef`)
- Recharts for trajectory/data graphs (`LineChart`, `Line`, `ResponsiveContainer`, etc.)
- Tailwind utility classes for layout where applicable; inline styles for precise theming
- Google Fonts via `@import` in `<style>` tag — Orbitron (headings) + JetBrains Mono (data)
- **No external state management** (no Redux, Zustand, etc.)
- **No server-side calls** — all physics computed client-side
- `lucide-react` allowed for icons if needed

### Physics Engine Pattern
Each simulator exposes a pure `computeTrajectory()` (or equivalent) function:
- **Analytical path** when closed-form solution exists (no air resistance)
- **Numerical integration (Euler method, dt = 0.02s)** when forces are velocity-dependent (drag)
- Output is an array of state snapshots: `{ x, y, vx, vy, t, ...extras }`
- All computations are wrapped in `useMemo` and re-run only on input change

### Animation Pattern
- `requestAnimationFrame` loop tracks real elapsed time scaled by `animSpeed`
- Simulation time advances via `simTRef` (ref, not state) to avoid re-render on every frame tick
- Only `animIdx` (state) is updated per frame → only the chart dot and live readout re-render
- Trajectory ref (`trajRef`) is kept current so the RAF closure always reads fresh data without stale capture

---

## Simulator 1: Projectile Motion (Complete)

**File:** `projectile-sim.jsx`

### Inputs
| Parameter | Range | Default | Notes |
|-----------|-------|---------|-------|
| Launch velocity | 0–100 m/s | 25 m/s | |
| Launch angle | 0–90° | 45° | 45° triggers pedagogical hint |
| Launch height | 0–100 m | 0 m | |
| Mass | 0.1–20 kg | 1 kg | Only active when drag is enabled |
| Gravity preset | — | Earth | Earth / Moon / Mars / Jupiter |
| Drag coefficient k | 0.01–1.0 kg/m | 0.1 | Represents ½ρCdA; only active when drag enabled |

### Outputs
- Range (m), Max Height (m), Flight Time (s)
- Impact Speed (m/s), Impact Angle (°)
- Live readout during animation: t, x, y, v, vx, vy

### Key Features
- **Drag toggle** — switches engine from analytical → numerical Euler integration
- **Comparison overlay** — when drag is on, dashed ideal (no-drag) trajectory rendered alongside
- **Animated dot** on trajectory path during playback; speed: 0.25×, 0.5×, 1×, 2×
- **Velocity component readout** — vx and vy color-coded separately to emphasize vx = constant
- **Dynamic equation panel** — shows analytical or numerical governing equations, updates with drag state
- **Pedagogical hints** — 45° max-range insight; complementary angles; drag shifts optimal angle below 45°
- **Gravity presets** — same equations, different g; Moon/Mars make abstract physics tangible

### Physics Notes
```
# No drag (analytical):
x(t)  = v₀·cos(θ)·t
y(t)  = h₀ + v₀·sin(θ)·t − ½g·t²
vx(t) = v₀·cos(θ)           ← constant
vy(t) = v₀·sin(θ) − g·t

# With drag (Euler numerical, dt = 0.02s):
F_drag = k·v²  (opposing velocity direction)
ax = −(k/m)·|v|·vx
ay = −g − (k/m)·|v|·vy
```

### Error Handling
- Projectile stops at y = 0 (ground clamp); interpolates exact landing point
- v₀ = 0 and h₀ = 0 returns a single ground point (no crash)
- Discriminant check before sqrt in flight-time formula
- Mass clamped to min 0.01 to prevent division-by-zero in drag term
- Loop hard-capped at 60,000 steps to prevent runaway on extreme inputs

### Known Tradeoffs / Design Decisions
- Euler integration (not RK4) — adequate for high school precision; RK4 would add complexity without meaningful educational gain at these scales
- Recharts custom `dot` prop renders a circle only at `animIdx`; called for every data point per render but acceptable at N ≤ 300 points
- Comparison trajectory aligned to main trajectory's x-axis via linear interpolation (not its own x-axis), which breaks down if comparison range << main range; acceptable for intended parameter ranges
- Mass slider grayed out (not hidden) when drag is off — deliberate: students see it exists and ask *why* mass only matters with drag (Galileo moment)

---

## Planned Simulators

| # | Topic | Core Concept | Key Toggle |
|---|-------|-------------|-----------|
| 2 | Simple Harmonic Motion | Period, amplitude, phase | Damping on/off |
| 3 | Energy Conservation | KE ↔ PE exchange | Friction on/off |
| 4 | Circular / Centripetal Motion | v²/r, banking angle | Gravity on/off |
| 5 | Wave Interference | Constructive/destructive | Phase offset slider |
| 6 | Optics (Snell's Law) | Refraction, total internal reflection | Medium presets |

---

## Aesthetic / Design System

| Token | Value | Use |
|-------|-------|-----|
| Background | `#070c18` | Page background |
| Panel | `#0a1220` | Card / section background |
| Border | `#1a2d4a` | Card borders |
| Primary accent | `#00d4ff` | Active values, toggles, highlights |
| Secondary accent | `#ff6b35` | Trajectory line, projectile dot |
| Muted text | `#475569` / `#334155` | Labels, secondary info |
| Heading font | Orbitron | Section labels, title |
| Data font | JetBrains Mono | All numeric values, equations |

---

## Python / Streamlit Port Notes

For classroom deployment, the simulator can be ported to **Streamlit + Plotly**. Recommended library pairing for dynamic Vx/Vy display:

### Best Options

**Streamlit + Plotly (recommended — matches existing stack)**
- `st.slider()` for all inputs; `st.toggle()` for drag
- `plotly.graph_objects.Scatter` for trajectory; `go.FigureWidget` for live updates
- `st.empty()` + loop for animation (frame-by-frame replot)
- Limitation: animation is slower than RAF-based browser animation; use `time.sleep(0.03)` between frames

**Matplotlib + FuncAnimation (best for Jupyter/Colab)**
- `FuncAnimation` handles the RAF equivalent natively
- `ax.quiver()` for live velocity vector arrows — excellent for showing Vx/Vy as actual vectors
- `ipywidgets` sliders integrate well in Jupyter
- Best choice if the target environment is a notebook rather than a deployed app

**Bokeh (best for true streaming)**
- `ColumnDataSource` streams new points each frame
- Works well with `bokeh serve` for classroom server deployment
- Steeper setup than Streamlit but smoothest real-time performance

### Recommendation
Use **Streamlit + Plotly** for deployment (consistent with existing nl2sql/EDA tool stack). Use **Matplotlib + FuncAnimation** in a Jupyter notebook for live demos during class — `ax.quiver()` for velocity vectors is uniquely well-suited for showing the Vx/Vy decomposition visually.

---

## Session Continuity

See `PROGRESS.md` for implementation status, open questions, and next session starting point.

**Invariants across all simulators:**
- Pure physics functions have no side effects and are independently testable
- All user inputs validated/clamped before entering physics engine
- Pedagogical hints surface automatically based on parameter state (not a separate "hint mode")
- Each simulator ships as a single self-contained `.jsx` file
