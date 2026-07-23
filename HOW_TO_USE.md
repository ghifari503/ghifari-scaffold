# How To Use

Panduan step-by-step untuk software engineering team menggunakan **project-scafold** — sebuah AI operating scaffold yang mengatur cara Codex/GPT, Claude, dan Gemini bekerja pada project baru maupun project yang sudah berjalan.

Scaffold ini bukan framework kode. Ia adalah lapisan proses (gates, artifacts, memory) di atas runtime AI (Claude Code, Codex CLI, Gemini CLI, Antigravity) supaya AI tidak langsung menulis kode tanpa intake, scope, dan approval yang jelas.

> Sumber kebenaran tunggal untuk aturan runtime adalah [AGENTS.md](AGENTS.md). Dokumen ini adalah panduan praktis untuk _menggunakan_ aturan tersebut, bukan pengganti.

---

## 0. Konsep Dasar (Wajib Dipahami Sebelum Mulai)

**Developer**
Satu-satunya pengambil keputusan (product, arsitektur, risiko, release) dalam sesi kerja dengan AI.

**`AGENTS.md`**
Aturan runtime wajib dibaca AI sebelum bekerja.

**`development/`**
Lokasi setiap target project (repo Git terpisah).
Kosong = greenfield.
berisi folder = existing project.

**Gate**
Checkpoint yang harus lolos sebelum AI boleh coding (misalnya _pre-coding gate_).

**Task slice**
Satu potongan kerja kecil dari satu fitur, dikerjakan per sesi.

**Artifacts**
State, log, evidence, keputusan — disimpan di `artifacts/`.

**Shared context**
Continuity antar developer/agent, disimpan **di dalam repo target project**, bukan di scaffold.

**Memory**
Ingatan lintas sesi (advisory, bukan source of truth) di `artifacts/memory/`.

Aturan emas: **tidak ada kode production yang ditulis sebelum pre-coding gate terbuka** (`guardrails/development/PRE_CODING_POLICY.md` + `artifacts/operations/PRE_CODING_GATE.md`).

---

## 1. Persiapan Awal (Sekali Saja, Semua Case)

1. Clone/pastikan repo `project-scafold` ini ada di mesin lokal.
2. Jalankan proteksi Git root scaffold (mencegah commit tidak sengaja ke repo scaffold):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
   ```
3. Buka repo ini di Claude Code / Codex CLI / Gemini CLI / Antigravity.
4. Pastikan runtime membaca `AGENTS.md` (ditandai oleh compatibility pointer `CLAUDE.md` / `GEMINI.md`).
5. Kirim command pertama:
   ```text
   start
   ```
   AI akan mengecek isi folder `development/`:
   - **kosong** → routing ke **Greenfield Project** (Case 1)
   - **berisi folder project** → routing ke **Existing Project** (Case 2)

---

## CASE 1 — Project Yang Benar-Benar Baru (Greenfield)

Gunakan case ini saat belum ada kode sama sekali dan tim mulai dari nol.

### Step 1 — Mulai Sesi

```text
start
```

atau

```text
start work
```

AI akan melaporkan bahwa `development/` kosong dan meminta project brief. **Tidak ada bootstrap, install dependency, atau kode yang dibuat di titik ini.**

### Step 2 — Berikan Project Brief (G1 Developer Interview)

Siapkan jawaban untuk:

- nama project
- tujuan/outcome yang ingin dicapai
- kandidat fitur pertama (yang paling kecil dan bernilai)
- constraint (budget, timeline, tim, platform, kepatuhan/security)
- referensi yang tersedia (dokumen, kompetitor, desain, repo lama)

Contoh prompt:

```text
Project name: [nama]
Intended outcome: [tujuan bisnis/produk]
First feature candidate: [fitur pertama]
Constraints: [batasan]
References: [link/dokumen/desain jika ada]
```

### Step 3 — Review Charter & Requirement Minimum (G2)

AI menyusun project charter, requirement minimum, acceptance criteria, dan task breakdown untuk fitur pertama. **Baca dan koreksi** — ini bukan dokumen final sampai kamu setujui.

### Step 4 — Review Usulan Stack & Arsitektur (G3)

AI mengusulkan:

- tech stack (bahasa, framework, database)
- struktur repository
- pendekatan QA
- bootstrap plan

Tim engineering wajib meninjau tradeoff di sini — ini adalah keputusan arsitektur yang hanya boleh disetujui oleh developer/tech lead.

### Step 5 — Beri Approval Eksplisit

Tanpa approval eksplisit, AI **tidak boleh** membuat repo, install dependency, atau generate kode. Approval bisa berupa balasan singkat:

```text
Approved. Lanjutkan ke G4/G5 dengan stack dan scope di atas.
```

### Step 6 — Shared Context & Pre-Coding Gate (G4)

AI membuat shared context awal di dalam folder target project (`development/[project-folder]/artifacts/shared/`) dan membuka pre-coding gate dengan allowed write paths yang jelas.

### Step 7 — Bootstrap & Implementasi Slice Pertama (G5)

AI melakukan skill lookup (cek `.claude/skills/` atau `.codex/skills/`), bootstrap **hanya** teknologi yang sudah disetujui, lalu mengimplementasikan **satu task slice** pertama.

### Step 8 — QA, Documentation Sync, Handoff

Command yang relevan:

```text
during dev qa
self review
final qa evidence
final impact check
ready to pr
```

Setelah tiap step selesai, pastikan `artifacts/operations/WORKFLOW_STATE.md`, `CURRENT_TASK.md`, dan `SESSION_LOG.md` ikut ter-update (AI melakukan ini otomatis sebagai bagian dari gate).

### Ringkasan Alur Greenfield

```text
start → G1 (interview) → G2 (charter+requirement) → G3 (stack+arsitektur)
  → APPROVAL DEVELOPER → G4 (shared context+gate) → G5 (bootstrap+slice pertama)
  → QA → documentation sync → handoff / ready to pr
```

---

## CASE 2 — Contributor Pada Project Yang Sudah Berjalan (Existing/Inherited Project)

Gunakan case ini saat kode sudah ada — baik dari tim sendiri maupun repo yang diwariskan.

### Step 1 — Tempatkan Project Di `development/`

Clone atau copy repo target ke:

```text
development/[project-folder]/
```

Project target **harus** menjadi Git repository tersendiri (terpisah dari repo scaffold). Repo scaffold mengabaikan seluruh isi `development/[project-folder]/` termasuk `artifacts/shared/`.

### Step 2 — Mulai Sesi

```text
start
```

atau

```text
start work
```

Karena `development/` berisi folder project, AI akan menampilkan daftar project terdeteksi (numbered picker). Balas dengan nomor project, atau langsung beri path jika sudah tahu.

### Step 3 — Attach Repo (Opsional Tapi Direkomendasikan)

```text
attach repo
```

AI mencatat path/URL, branch, commit, remote, dan status working tree — tanpa install dependency atau ubah kode.

### Step 4 — Jalankan Intake (I1 — Existing Project Intake)

```text
Run I1 Existing Project Intake for:
development/[project-folder]

Mode: read_only_audit.
Do not edit product code.
Do not install dependencies.
Do not run migrations.
Do not scaffold or generate code.
Update scaffold docs only.
```

AI akan:

1. Membaca guardrail lokal project (README, `AGENTS.md` milik project jika ada).
2. Mengidentifikasi stack, frontend/backend root, package manager, database, test stack, routes, modul utama.
3. Mencari dokumentasi project yang sudah ada.
4. **Jika dokumentasi tidak ada** → AI akan bertanya apakah ada dokumen/link/diagram/referensi lain sebelum membuat baseline dari source code (_code-derived baseline_).
5. Menyimpan hasil ke `development/[project-folder]/artifacts/shared/PROJECT_STATE.md`.

Sebagai contributor baru di project ini, **selalu jalankan I1 di awal**, bukan langsung minta fitur.

### Step 5 — Baca Shared Context (Continuity Antar Developer)

Sebelum melanjutkan pekerjaan siapa pun sebelumnya:

```text
Read shared target repository context before continuing:
development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md
development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md
development/[project-folder]/artifacts/shared/handoffs/
Then continue with targeted scans only.
```

Ini menggantikan kebutuhan membaca ulang seluruh repo setiap kali developer baru masuk.

### Step 6 — Readiness Baseline (Sebelum Coding Apa Pun)

```text
readiness baseline
```

Mencatat status dependency, environment, database, migration/seed, local run, build, lint/typecheck, test, dan known failure. Ini wajib ada sebelum pre-coding gate bisa terbuka.

### Step 7 — Jalankan `start dev` Untuk Uji Lokal (Bukan Fitur)

```text
start dev
```

Gunakan ini hanya untuk memastikan project bisa jalan lokal (dependency, `.env`, port, service). **Bukan** untuk implementasi fitur. Jika saat proses ini ditemukan bug/config yang perlu diubah, AI akan berhenti dan mengusulkan `I2 Impact Scan` untuk scope tersebut.

### Step 8 — Scope Satu Perubahan (Fitur/Bugfix/Refactor)

Pilih **satu** fitur, bugfix, redesign, atau refactor per sesi:

```text
Review this existing project and scope only this change:
[nama fitur atau modul]
Start with intake and impact scan before planning implementation.
```

### Step 9 — Impact Scan (I2)

```text
Run impact scan for this change:
[fitur/bugfix/refactor]
List impacted pages, endpoints, modules, docs, tests, allowed write paths, blocked paths, and risks.
Do not edit product code yet.
```

I2 wajib untuk perubahan behavior/source/API/DB/UI/test/dependency — **tidak wajib** hanya untuk menjalankan project secara lokal.

### Step 10 — Dev-Doc Discovery

AI mencari dokumentasi terkait di `dev-doc/[feature-name]/` (BRD, PRD, design, prototype). Jika tidak ada, dicatat sebagai `dev-doc missing` dan requirement baseline harus dibuat dulu sebelum coding fitur baru.

### Step 11 — Plan & Approval (Untuk Perubahan Medium/Major)

Untuk perubahan yang bukan trivial, AI **wajib berhenti** dan menyusun compact plan (objective, scope, file/area yang diubah, execution steps, QA plan, risiko) sebelum coding. Plan disimpan di `plan/`.

```text
implementation plan
```

Beri approval eksplisit sebelum lanjut:

```text
Approved. Lanjutkan implementasi sesuai plan di atas.
```

### Step 12 — Pre-Coding Gate Check

```text
Check guardrails/development/PRE_CODING_POLICY.md and artifacts/operations/PRE_CODING_GATE.md for the current task.
Report whether coding is allowed.
If blocked, list exactly what is missing.
Do not edit product code.
```

### Step 13 — Build (Sesuai Layer Yang Terdampak)

Frontend divalidasi dulu bila UI terlibat, sebelum backend contract difinalisasi.

```text
Run step B2: Frontend Build.
Scope it to this page or feature only:
[page/feature]
```

```text
Run step B1: Backend Build.
Scope it to this feature/module only:
[feature/module]
```

### Step 14 — During-Dev QA, Self Review, Final QA

```text
during dev qa
self review
final qa evidence
final impact check
```

### Step 15 — Update Shared Context Setiap Kali Ada Progres Berarti

```text
Update shared target repository context for this work session:
development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md
development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md
development/[project-folder]/artifacts/shared/handoffs/[feature]-[slice]-handoff.md
Keep it Git-safe and do not store secrets, raw chat, or large logs.
```

Commit dan push perubahan ini **dari dalam repo project target**, bukan dari repo scaffold.

### Step 16 — Ready To PR / Handoff

```text
ready to pr
```

atau, bila sesi berhenti sebelum selesai:

```text
handoff
```

`ready to pr` hanya menyiapkan evidence review — tidak membuat pull request otomatis. Buat PR manual (atau via `gh pr create`) dari repo project target setelah evidence lengkap.

### Ringkasan Alur Existing Project

```text
clone/copy ke development/[project-folder] → start → I1 intake
  → baca shared context (ACTIVE_CONTEXT, CONTRIBUTOR_LOG, handoffs)
  → readiness baseline → start dev (opsional, cek lokal)
  → scope 1 perubahan → I2 impact scan → dev-doc discovery
  → plan (medium/major) → APPROVAL → pre-coding gate check
  → build (frontend-first bila ada UI) → during dev qa
  → self review → final qa evidence → final impact check
  → update shared context → ready to pr / handoff
```

---

## 2. Command Cepat Yang Sering Dipakai

Semua command lengkap ada di [COMMANDS.md](COMMANDS.md). Yang paling sering dipakai tim:

**`start` / `start work`**
Mulai sesi, auto-routing greenfield vs existing.

**`start dev`**
Cek project bisa jalan lokal (bukan implementasi).

**`attach repo`**
Catat detail repo target sebelum intake.

**`readiness baseline`**
Baseline dependency/env/test sebelum coding.

**`implementation plan`**
Buat plan resmi untuk perubahan medium/major.

**`during dev qa`**
QA incremental saat development berjalan.

**`self review`**
Review mandiri sebelum code review resmi.

**`final qa evidence`**
Evidence QA final sebelum PR.

**`final impact check`**
Cek dampak akhir sebelum PR.

**`ready to pr`**
Siapkan evidence review (bukan bikin PR beneran).

**`handoff`**
Simpan continuity untuk developer/sesi berikutnya.

**`cek skill`**
Sinkronkan skill antar runtime (`.codex/`, `.claude/`, `.agents/`).

**`cek bug listing`**
Lihat bug backlog aktif di `bug-listing/`.

## 3. Aturan Yang Tidak Boleh Dilanggar Tim

1. **Satu fitur, satu task slice per sesi** kecuali developer/tech lead menyetujui scope lebih luas.
2. **Tidak ada kode ditulis sebelum pre-coding gate terbuka.**
3. Perubahan **medium/major wajib punya plan tertulis + approval eksplisit** sebelum eksekusi.
4. **Jangan commit/push project target dari repo scaffold** — selalu dari repo project itu sendiri.
5. Hanya `@odonplay` yang boleh update `main` di repo scaffold ini; kontributor lain wajib branch + Pull Request (lihat [docs/REPOSITORY_GOVERNANCE.md](docs/REPOSITORY_GOVERNANCE.md)).
6. Jangan simpan secret, `.env`, token, atau data pribadi di shared context maupun memory.
7. QA final wajib mencatat status jelas (`pass`/`fail`/`blocked`/`skipped`) untuk setiap layer — tidak boleh diklaim selesai jika status tidak diketahui.

## 4. Kalau Tersesat / Tidak Tahu Harus Ngapain

Kirim command status read-only ini kapan pun:

```text
Review the current scaffold state.
Read artifacts/operations/WORKFLOW_STATE.md, artifacts/operations/CURRENT_PHASE.md, artifacts/operations/CURRENT_TASK.md, guardrails/development/PRE_CODING_POLICY.md, and artifacts/operations/PRE_CODING_GATE.md.
Tell me the safest next action.
Do not edit files.
```

Command ini tidak mengubah apa pun — aman dijalankan kapan saja untuk re-orientasi.

## 5. Referensi Lanjutan

- [AGENTS.md](AGENTS.md) — aturan runtime lengkap (source of truth)
- [SCAFFOLD_WORKFLOW.md](SCAFFOLD_WORKFLOW.md) — ringkasan alur end-to-end (Bahasa Indonesia)
- [COMMANDS.md](COMMANDS.md) — daftar command lengkap
- [CONTRIBUTING.md](CONTRIBUTING.md) — cara berkontribusi ke scaffold itu sendiri
- `workflows/greenfield_project_workflow.md` — detail alur greenfield
- `workflows/existing_project_onboarding_workflow.md` — detail alur onboarding existing project
- `workflows/incremental_feature_workflow.md` — detail alur fitur incremental
- `guardrails/` — seluruh policy strict (pre-coding, QA, memory, shared context, dll.)
