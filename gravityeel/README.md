# Gravityeel Workshop

Gravityeel is an isolated, greenfield space for rapid game-development experiments. Treat it as a sandbox: nothing inside needs to conform to the recursive analysis corpora unless you explicitly opt in.

## Goals
- **Isolation first**: prototypes stay contained within `gravityeel/` so they do not interfere with archival analysis work.
- **Small, fast experiments**: prioritize playable micro-builds, mechanic explorations, and visual tests over production polish.
- **Document the journey**: record short notes and playtest outcomes so experiments are reproducible.

## Suggested Layout
- `prototypes/`: one subfolder per experiment (e.g., `prototypes/zero-grav-puck/`). Include a short `README.md` and any scripts or scenes.
- `assets/`: shared placeholder art, sound, fonts, or shaders. Keep licensed material clearly labeled.
- `docs/`: design sketches, mechanic briefs, or reference links.
- `playtests/`: session notes, feedback snapshots, and balance metrics.
- `archives/`: retired prototypes and their learnings.

## Working Practices
1. **Start tiny**: define a single mechanic, create a subfolder in `prototypes/`, and ship a rough build.
2. **Keep dependencies local**: use per-prototype virtual environments or engine-specific project settings under each subfolder to avoid cross-talk.
3. **Track learnings**: after each session, drop a short note in `playtests/` or inside the prototype folder summarizing what worked, what failed, and next steps.
4. **Version control hygiene**: prefer text-friendly formats where possible and add temporary binaries to `.gitignore` inside prototype folders.

## Quickstart Template
Create a new prototype with the following skeleton:

```
prototypes/
  your-experiment/
    README.md        # goals, controls, build/run instructions
    journal.md       # running log of design decisions and tests
    src/             # engine scripts or code
    builds/          # generated binaries (gitignored)
```

To start a prototype named `glide-beetle`:

```
mkdir -p prototypes/glide-beetle/{src,builds}
cat <<'NOTE' > prototypes/glide-beetle/README.md
# Glide Beetle

- **Goal**: [brief mechanic/feel target]
- **Engine/Stack**: [e.g., Godot 4, Unity, Pico-8, Python+Pygame]
- **Controls**: [list keys/buttons]
- **Run**: [how to launch]
- **Definition of Done (MVP)**: [one-sentence success condition]

## Tasks
- [ ] Prototype core loop
- [ ] Add placeholder art/sfx
- [ ] Playtest with one session and log notes

## Notes
- Start with simplified physics; tweak glide drag separately from gravity.
NOTE
```

## Guardrails
- Keep Gravityeel self-contained. If you integrate with other repository areas, document the linkage clearly.
- Avoid committing large binaries; prefer links or rebuild steps. Use `.gitignore` files inside prototypes to exclude heavy outputs.
- When archiving, move completed or abandoned experiments to `archives/` with a short rationale.

## Status
Fresh slate—no experiments yet. Feel free to claim a prototype slot and start building.
