# Culture Knowledge Database Schema (MySQL)

This document proposes a **MySQL-first schema** for building a knowledge base that captures sociological, biological, historical, and technological aspects of civilizations, including **delta tracking** between a current reference society and target cultures. It also includes an approach for **archiving raw primary materials (e.g., `.md` files) in the database** with privacy controls.

---

## Goals

1. **Represent culture as a multi-domain, multi-epoch system** (society, biology, history, technology, economics, governance, ecology).
2. **Track differences (deltas)** between a baseline society and a target culture.
3. **Tie every claim to sources** (books, essays, primary documents) and preserve raw artifacts in the DB.
4. **Support taxonomy + synthesis** queries: *what changed, what events must have occurred, what technologies exist, and what the culture looks like overall.*

---

## High-Level Model (Entities + Relationships)

### Core
- **`civilization`**: A coherent cultural system over time.
- **`epoch`**: Time slices for a civilization (e.g., “baseline 2025”, “Culture era 1”).
- **`domain`**: Broad areas (society, biology, technology, governance, economy, ecology, etc.).
- **`trait`**: A specific fact/feature (e.g., “distributed cognition norms”).
- **`event`**: A change-driving historical event.
- **`technology`**: Tools/systems the civilization uses.
- **`source`**: A book or primary document.
- **`artifact`**: Raw file content stored in DB.

### Linking
- **`civilization_epoch`**: When a civilization exists, mapped to epochs.
- **`trait_assertion`**: A claim that a trait exists in an epoch.
- **`event_assertion`**: A claim that an event occurred in an epoch.
- **`technology_assertion`**: A claim that a tech exists in an epoch.
- **`delta`**: The difference between two epochs for a given trait.
- **`evidence`**: Attribution of claims to sources and page references.

---

## Recommended MySQL Schema

> **Note:** IDs are `BIGINT` to scale. Use `utf8mb4`. All timestamps in UTC.

```sql
-- Core tables
CREATE TABLE civilization (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE epoch (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  start_year INT NULL,
  end_year INT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE civilization_epoch (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  civilization_id BIGINT NOT NULL,
  epoch_id BIGINT NOT NULL,
  notes TEXT,
  UNIQUE KEY uniq_civ_epoch (civilization_id, epoch_id),
  FOREIGN KEY (civilization_id) REFERENCES civilization(id),
  FOREIGN KEY (epoch_id) REFERENCES epoch(id)
);

CREATE TABLE domain (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT
);

CREATE TABLE trait (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  domain_id BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  UNIQUE KEY uniq_trait (domain_id, name),
  FOREIGN KEY (domain_id) REFERENCES domain(id)
);

CREATE TABLE event (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT
);

CREATE TABLE technology (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT
);

-- Assertions per epoch
CREATE TABLE trait_assertion (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  trait_id BIGINT NOT NULL,
  civilization_epoch_id BIGINT NOT NULL,
  value_text TEXT NOT NULL,
  confidence DECIMAL(5,2) DEFAULT 0.50,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trait_id) REFERENCES trait(id),
  FOREIGN KEY (civilization_epoch_id) REFERENCES civilization_epoch(id)
);

CREATE TABLE event_assertion (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  event_id BIGINT NOT NULL,
  civilization_epoch_id BIGINT NOT NULL,
  value_text TEXT NOT NULL,
  confidence DECIMAL(5,2) DEFAULT 0.50,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES event(id),
  FOREIGN KEY (civilization_epoch_id) REFERENCES civilization_epoch(id)
);

CREATE TABLE technology_assertion (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  technology_id BIGINT NOT NULL,
  civilization_epoch_id BIGINT NOT NULL,
  value_text TEXT NOT NULL,
  confidence DECIMAL(5,2) DEFAULT 0.50,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (technology_id) REFERENCES technology(id),
  FOREIGN KEY (civilization_epoch_id) REFERENCES civilization_epoch(id)
);

-- Delta tracking between epochs
CREATE TABLE delta (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  trait_id BIGINT NOT NULL,
  from_civilization_epoch_id BIGINT NOT NULL,
  to_civilization_epoch_id BIGINT NOT NULL,
  delta_text TEXT NOT NULL,
  confidence DECIMAL(5,2) DEFAULT 0.50,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trait_id) REFERENCES trait(id),
  FOREIGN KEY (from_civilization_epoch_id) REFERENCES civilization_epoch(id),
  FOREIGN KEY (to_civilization_epoch_id) REFERENCES civilization_epoch(id)
);

-- Sources + evidence
CREATE TABLE source (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255),
  year INT NULL,
  source_type VARCHAR(100),
  notes TEXT
);

CREATE TABLE evidence (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  source_id BIGINT NOT NULL,
  assertion_type ENUM('trait','event','technology','delta') NOT NULL,
  assertion_id BIGINT NOT NULL,
  location_ref VARCHAR(255),
  quote TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (source_id) REFERENCES source(id)
);

-- Raw artifacts stored in DB (encrypted-at-rest recommended)
CREATE TABLE artifact (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  source_id BIGINT NULL,
  filename VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  content_hash CHAR(64) NOT NULL,
  content_encrypted LONGBLOB NOT NULL,
  encryption_hint VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (source_id) REFERENCES source(id)
);
```

---

## Privacy + “Inscrutable” Storage Strategy

To keep `.md` primary material stored **inside the DB but hard to access**:

1. **Encrypt artifacts before storage** with an external key (KMS or offline key).
2. Store only **encrypted blobs** in `artifact.content_encrypted` and add a `content_hash` for integrity.
3. **Isolate access**:
   - Restrict DB roles to only the ingestion service for writes.
   - No human query access to the raw artifact table.
4. Optional: **split secrets** (e.g., Shamir or two-man rule) for decrypt access.

This ensures the material is preserved but not casually inspectable.

---

## Taxonomy Template (for “Differences / Events / Technologies / Inventory”)

Use these domains and layers for structured capture:

### 1) Society & Culture
- Social structure, kinship, community organization
- Norms, taboos, rituals, values
- Identity, language, memory systems

### 2) Biology & Cognition
- Baseline physiology
- Augmentation, genetic shifts
- Cognition, consciousness, extended mind

### 3) Technology & Infrastructure
- Energy systems
- Computation & AI
- Transportation & logistics
- Manufacturing & material science
- Medicine & life extension

### 4) Governance & Economics
- Political systems
- Governance models (centralized, distributed, participatory)
- Trade, currency, resource distribution

### 5) Ecology & Planetary Context
- Environmental stewardship
- Terraforming or climate control
- Biodiversity and biosphere management

### 6) Historical Events (Bridging Timeline)
- Pivotal conflicts
- Scientific revolutions
- Sociopolitical shifts
- Catastrophes & recoveries

---

## Query Examples

### 1) Differences between Present Society and Target Culture
```sql
SELECT t.name, d.delta_text
FROM delta d
JOIN trait t ON d.trait_id = t.id
JOIN civilization_epoch ce_from ON d.from_civilization_epoch_id = ce_from.id
JOIN civilization_epoch ce_to ON d.to_civilization_epoch_id = ce_to.id
WHERE ce_from.civilization_id = ? AND ce_to.civilization_id = ?;
```

### 2) Events that Must Have Happened
```sql
SELECT e.name, ea.value_text
FROM event_assertion ea
JOIN event e ON ea.event_id = e.id
JOIN civilization_epoch ce ON ea.civilization_epoch_id = ce.id
WHERE ce.civilization_id = ?;
```

### 3) Technologies in the Culture
```sql
SELECT tech.name, ta.value_text
FROM technology_assertion ta
JOIN technology tech ON ta.technology_id = tech.id
JOIN civilization_epoch ce ON ta.civilization_epoch_id = ce.id
WHERE ce.civilization_id = ?;
```

### 4) Full Inventory with Sources
```sql
SELECT t.name, ta.value_text, s.title, e.location_ref
FROM trait_assertion ta
JOIN trait t ON ta.trait_id = t.id
LEFT JOIN evidence e ON e.assertion_type = 'trait' AND e.assertion_id = ta.id
LEFT JOIN source s ON e.source_id = s.id
WHERE ta.civilization_epoch_id = ?;
```

---

## How to Ingest Favorite Books (Workflow)

1. **Create `source` records** for each book.
2. **Store book content** (if needed) in `artifact` as encrypted `.md`.
3. **Extract claims** into `trait_assertion`, `event_assertion`, `technology_assertion`.
4. **Attach evidence** with page or chapter references.
5. **Define deltas** vs. your baseline epoch.

---

## Next Step Checklist

- [ ] Add your “current society” epoch as baseline (e.g., Earth 2025).
- [ ] Add target culture epoch(s) (e.g., “The Culture – 2300 CE”).
- [ ] Enter your book list as sources.
- [ ] Begin claim extraction + evidence mapping.
- [ ] Populate deltas between baseline and target.

---

## Notes

- The schema is **normalized** but can be extended into a **graph** (e.g., Neo4j) if you later need richer relationship traversals.
- `confidence` supports uncertain or debated claims.
- `evidence` is polymorphic by design; ensure you apply application-level constraints to guarantee integrity.

