const input = document.getElementById("input");
const refractButton = document.getElementById("refract");
const resetButton = document.getElementById("reset");
const candidatesEl = document.getElementById("candidates");
const collisionsEl = document.getElementById("collisions");
const traceEl = document.getElementById("trace");

const detectors = [
  {
    name: "Emails",
    regex: /[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}/g,
    table: "tEmails",
    fields: ["address", "domain"],
  },
  {
    name: "RGB Hex Codes",
    regex: /#?[0-9A-Fa-f]{6}\b/g,
    table: "tColors",
    fields: ["hex", "rgb"],
  },
  {
    name: "Floorplan Keywords",
    regex: /\b(room|wall|door|window|corridor|stair)\b/gi,
    table: "tFloorplanRooms",
    fields: ["label", "bounds"],
  },
  {
    name: "Geometry Coords",
    regex: /\b\d+\s*,\s*\d+\s*,\s*\d+\b/g,
    table: "tPointClouds",
    fields: ["x", "y", "z"],
  },
];

const collisionRules = [
  {
    name: "Hex vs ID",
    regex: /#?[0-9A-Fa-f]{6}\b/g,
    note: "Could be a color or opaque identifier.",
  },
  {
    name: "Email vs Handle",
    regex: /[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}/g,
    note: "Could be an email or username-style handle.",
  },
];

const traceTemplates = [
  "Prism warmed up; scanning for persistent motifs.",
  "Refraction pass complete; ranking candidate schema shards.",
  "Collision residue logged for manual inspection.",
];

const buildCard = ({ title, confidence, fields, samples }) => {
  const card = document.createElement("div");
  card.className = "card";

  const heading = document.createElement("h3");
  heading.textContent = title;

  const badge = document.createElement("span");
  badge.className = `badge ${confidence > 0.8 ? "success" : "warning"}`;
  badge.textContent = `${Math.round(confidence * 100)}%`;
  heading.appendChild(badge);

  const body = document.createElement("p");
  body.textContent = `Fields: ${fields.join(", ")}. Samples: ${samples.join(", ")}`;

  card.append(heading, body);
  return card;
};

const buildCollision = ({ label, samples, note }) => {
  const card = document.createElement("div");
  card.className = "card";

  const heading = document.createElement("h3");
  heading.textContent = label;

  const noteEl = document.createElement("p");
  noteEl.textContent = `${note} Samples: ${samples.join(", ")}`;

  card.append(heading, noteEl);
  return card;
};

const resetOutput = () => {
  candidatesEl.innerHTML = "";
  collisionsEl.innerHTML = "";
  traceEl.innerHTML = "";
};

const generateTrace = (detected) => {
  traceTemplates.forEach((template) => {
    const item = document.createElement("li");
    item.textContent = template;
    traceEl.appendChild(item);
  });

  if (detected.length === 0) {
    const item = document.createElement("li");
    item.textContent = "No strong patterns detected. The beam stayed diffuse.";
    traceEl.appendChild(item);
    return;
  }

  const item = document.createElement("li");
  item.textContent = `Detected ${detected.length} emergent motifs. Consider persistent tracking before promoting to real tables.`;
  traceEl.appendChild(item);
};

const refract = () => {
  const text = input.value;
  resetOutput();

  if (!text.trim()) {
    candidatesEl.innerHTML = "<p class=\"card\">No input yet. Feed the beam to see refraction.</p>";
    collisionsEl.innerHTML = "<p class=\"card\">Awaiting signal.</p>";
    generateTrace([]);
    return;
  }

  const detected = detectors
    .map((detector) => {
      const matches = text.match(detector.regex) || [];
      const unique = Array.from(new Set(matches)).slice(0, 4);
      const confidence = Math.min(0.95, matches.length / 8 + 0.3);

      return {
        ...detector,
        matches,
        confidence,
        samples: unique.length ? unique : ["(no sample)"] ,
      };
    })
    .filter((detector) => detector.matches.length > 0);

  if (detected.length === 0) {
    candidatesEl.innerHTML = "<p class=\"card\">No dominant patterns detected. Try adding more structure.</p>";
  } else {
    detected.forEach((detector) => {
      candidatesEl.appendChild(
        buildCard({
          title: detector.table,
          confidence: detector.confidence,
          fields: detector.fields,
          samples: detector.samples,
        })
      );
    });
  }

  const collisions = collisionRules
    .map((rule) => {
      const matches = text.match(rule.regex) || [];
      const unique = Array.from(new Set(matches)).slice(0, 3);

      return {
        ...rule,
        matches,
        samples: unique.length ? unique : ["(none)"] ,
      };
    })
    .filter((rule) => rule.matches.length > 0);

  if (collisions.length === 0) {
    collisionsEl.innerHTML = "<p class=\"card\">No collisions detected. Beam is clean.</p>";
  } else {
    collisions.forEach((rule) => {
      collisionsEl.appendChild(
        buildCollision({
          label: rule.name,
          samples: rule.samples,
          note: rule.note,
        })
      );
    });
  }

  generateTrace(detected);
};

refractButton.addEventListener("click", refract);
resetButton.addEventListener("click", () => {
  input.value = "";
  resetOutput();
  generateTrace([]);
});

resetOutput();
generateTrace([]);
