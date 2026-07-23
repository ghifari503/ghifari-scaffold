# Scaffold Workflow

## Tujuan Dokumen

Dokumen ini adalah panduan singkat bagi developer dan AI agent untuk memahami cara kerja scaffold dari awal sampai handoff. Detail aturan strict tetap berada di `AGENTS.md`, `guardrails/`, `workflows/`, dan `templates/`.

Tujuan utama scaffold:

- memastikan pekerjaan dimulai dari konteks dan requirement yang benar
- mencegah coding sebelum scope, readiness, dan approval tersedia
- menjaga satu fitur dan satu task slice per sesi
- mengurangi pembacaan repository berulang dengan memory dan shared context
- membuat QA, log, handoff, dan keputusan mudah diteruskan ke developer berikutnya

## Aturan Dasar

1. Baca `AGENTS.md` sebelum melakukan pekerjaan.
2. Founder adalah pengambil keputusan akhir untuk produk, arsitektur, risiko, dan release.
3. Request `medium` atau `major` wajib memiliki plan dan approval sebelum eksekusi.
4. Sebelum coding, agent wajib mencari skill yang relevan.
5. Jika skill tidak tersedia, jalankan alur `skill-creator` terlebih dahulu.
6. Kerjakan satu fitur dan satu task slice per sesi secara default.
7. Gunakan context, memory, dan targeted scan; jangan membaca seluruh repository berulang kali.
8. Setelah pekerjaan bermakna, lakukan documentation sync dan update shared context.

## 1. Startup Dan Pemilihan Mode

User memulai dengan:

```text
start
```

Agent kemudian:

1. membaca `AGENTS.md` dan state operasional
2. memeriksa `development/`, termasuk hidden entries, tetapi mengabaikan `README.md` dan `_project-template/` milik scaffold
3. memilih mode: tanpa target project berarti `greenfield_project`, dengan target project berarti existing/inherited project
4. melaporkan mode dan langkah berikutnya

`start` hanya memilih route. Perintah ini tidak otomatis memberi izin untuk bootstrap framework, install dependency, membuat database, atau menulis product code.

## 2. Greenfield Project: Project Dari Nol

### Tujuan

Membangun fondasi project berdasarkan keputusan founder, bukan asumsi agent.

### Urutan

1. `G0`: catat hasil routing greenfield.
2. `G1`: lakukan founder interview tentang masalah, user, outcome, constraint, dan referensi.
3. `G2`: buat project charter, requirement minimum, acceptance criteria, dan task breakdown untuk fitur pertama.
4. `G3`: ajukan stack, arsitektur, struktur repository, QA approach, dan bootstrap plan.
5. Tunggu approval founder.
6. `G4`: buat shared context awal dan buka pre-coding gate dengan allowed write paths.
7. `G5`: lakukan skill lookup, bootstrap hanya teknologi yang disetujui, lalu implementasi satu slice.
8. Lanjutkan ke QA, documentation sync, memory, dan handoff.

## 3. Existing Project: Intake Dan Pembelajaran

### Tujuan

Memahami system yang sudah ada sebelum melakukan perubahan dan menyimpan baseline yang dapat dipakai agent berikutnya.

### Urutan

1. Pastikan project berada di `development/[project-folder]`.
2. Catat path, branch, commit, remote, dan status repository.
3. Inventarisasi guardrail lokal seperti `AGENTS.md`, `README.md`, dan aturan repository lain.
4. Identifikasi framework, bahasa, package manager, database, API, test stack, build, dan deployment.
5. Cari dokumentasi project dan sumber referensi yang tersedia.
6. Jika dokumentasi tidak ditemukan, tanyakan kepada founder apakah ada dokumen, link, diagram, akses repository lain, atau referensi tambahan.
7. Jika tetap tidak ada, buat code-derived baseline berbasis evidence dari source code.
8. Simpan hasilnya pada shared context target project dan sinkronkan fakta stabil ke memory serta feature registry.
9. Buat readiness baseline sebelum implementation planning.

Pembelajaran tidak berarti selalu membaca seluruh repository. Agent membaca operational context, shared context, memory, feature registry, dev-doc, dan session log terlebih dahulu, lalu melakukan targeted scan. Full scan hanya digunakan saat intake pertama, baseline stale/contradicted, risiko tinggi, atau alasan terdokumentasi.

## 4. Shared Context Dan Memory

### Tujuan

Memungkinkan developer B melanjutkan pekerjaan developer A tanpa mengulang pemahaman project dari nol.

Sebelum melanjutkan pekerjaan pada project aktif, baca:

- `development/[project-folder]/artifacts/shared/PROJECT_STATE.md`
- `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`
- entry terbaru `CONTRIBUTOR_LOG.md`
- handoff yang relevan
- `artifacts/memory/MEMORY_INDEX.md` dan memory yang relevan
- feature registry dan session log terkait

Setelah meaningful work:

- update `PROJECT_STATE.md` jika fakta project berubah
- update `ACTIVE_CONTEXT.md`
- append `CONTRIBUTOR_LOG.md`
- buat atau update handoff jika sesi berhenti, berpindah agent, atau memiliki blocker
- simpan memory hanya dari evidence, keputusan, baseline, QA, atau instruksi founder

Shared context harus Git-safe. Jangan menyimpan secret, password, token, raw chat, atau data pribadi.

## 5. Feature Request Dan Task Slicing

### Tujuan

Menjaga pekerjaan kecil, terukur, dan hemat context.

Untuk setiap request:

1. klasifikasikan task sebagai `small`, `medium`, `major`, `ambiguous`, `high-risk`, atau `critical`
2. tentukan satu fitur atau module yang aktif
3. pecah fitur menjadi task kecil
4. pilih satu task slice untuk sesi saat ini
5. catat scope dan non-scope
6. gunakan targeted scan berdasarkan route, symbol, module, memory, dev-doc, dan impact evidence

Jangan menggabungkan beberapa fitur dalam satu sesi tanpa approval founder yang eksplisit.

## 6. Dev-Doc Dan Requirement

### Tujuan

Memastikan implementasi mengikuti requirement yang disetujui dan dokumentasi yang relevan.

Sebelum feature, UI, backend, API, database, integration, refactor, atau behavior change:

1. cari dokumen terkait di `dev-doc/`
2. gunakan feature slug, module, domain, route, dan sinonim sebagai kata pencarian
3. baca BRD, PRD, flow, design, API, dan notes yang relevan
4. catat `dev-doc missing` bila tidak ada dokumentasi terkait
5. buat requirement baseline sebelum coding fitur baru

Jika sumber requirement bertentangan, agent menentukan controlling source berdasarkan precedence policy, membuat conflict decision artifact, dan menahan coding sampai konflik material diselesaikan founder.

## 7. Plan Dan Approval

### Tujuan

Memberi founder kesempatan meninjau arah kerja sebelum perubahan dilakukan.

Untuk task `medium` atau `major`, plan harus berisi objective, scope, non-scope, controlling requirement source, task slice, file atau area yang diubah, langkah eksekusi, strategi QA, documentation sync, risiko, dan rollback.

Plan disimpan di `plan/` dan checklist approval di `artifacts/operations/plan-approval-checklists/`. Sebelum approval, agent tidak boleh coding, build, install dependency, migration, refactor, atau menutup QA.

## 8. Impact Scan Dan Readiness Baseline

Impact scan digunakan saat ada perubahan pada source code, behavior, API, database, UI, test, dependency, security, performance, configuration, atau deployment. Impact scan tidak wajib untuk sekadar menjalankan aplikasi secara lokal tanpa perubahan project.

Untuk existing project, readiness baseline mencatat dependency, environment, database, migration, seed, local run, route/healthcheck, build, lint/typecheck, test, formatter, CI/CD, dan known pre-existing failures.

Setiap failure diklasifikasikan sebagai `in scope`, `out of scope`, `unknown`, atau founder-accepted exception. Failure `in scope` atau `unknown` memblokir coding sampai diselesaikan atau diterima founder secara terdokumentasi.

## 9. Skill Lookup Dan Pre-Coding Gate

### Tujuan

Memastikan agent menggunakan cara kerja yang sesuai sebelum mengubah code atau menjalankan proses build.

Sebelum coding, refactor, test creation, dependency work, migration, generation, atau build:

1. cari skill dan agent yang relevan
2. gunakan `.codex/skills/` untuk Codex, `.claude/skills/` untuk Claude, dan `.agents/skills/` untuk Antigravity
3. baca skill yang dipilih
4. gunakan `find-skills` jika tidak ada skill lokal yang relevan
5. validasi sumber, penggunaan, lisensi, dan isi kandidat; hanya publisher allowlist yang boleh diunduh otomatis
6. tempatkan skill yang disetujui pada kedua folder runtime, lalu jalankan `cek skill`
7. gunakan `skill-creator` jika tidak ada skill eksternal yang sesuai
8. pastikan intake, requirement, impact scan, readiness, plan, task slice, shared context, dan allowed write paths lengkap
9. pastikan `artifacts/operations/PRE_CODING_GATE.md` berstatus terbuka

Tidak ada product code yang boleh ditulis sebelum pre-coding gate terpenuhi.

## 10. Development Dan During-Development QA

### Tujuan

Menghasilkan perubahan yang terkontrol dan mendeteksi masalah sedini mungkin.

Saat implementasi, agent hanya mengubah scope yang disetujui, mengikuti pola existing, melakukan targeted test, memperbarui test relevan, mencatat keputusan, dan menghentikan pekerjaan jika scope berubah menjadi task baru.

Jika UI terlibat, validasi behavior frontend terlebih dahulu sebelum memperluas kontrak backend.

## 11. QA Final

### Tujuan

Memastikan perubahan aman, teruji, dan tidak menimbulkan regresi yang tidak diketahui.

QA mencatat status `pass`, `fail`, `blocked`, atau `skipped` untuk unit, integration, E2E/browser, UI/visual, security, performance, dan regression sesuai dampak perubahan.

Mulai dari check terkecil yang relevan. Full suite atau browser suite luas hanya dijalankan jika alasan dan evidence-nya terdokumentasi. Jika verifikasi visual membutuhkan manusia, agent wajib memberi notifikasi kepada founder dengan route/state, alasan, evidence atau URL, dan checklist pemeriksaan.

## 12. Documentation Sync Dan Handoff

### Tujuan

Menjaga pekerjaan tetap dapat dilanjutkan, diaudit, dan dipahami agent atau developer berikutnya.

Setelah setiap official step atau meaningful work, update `WORKFLOW_STATE.md`, `CURRENT_TASK.md`, `SESSION_LOG.md`, artifact source-of-truth yang terdampak, shared context target project, serta memory dan learnings bila relevan.

Handoff harus mencatat objective, current state, keputusan, artifact yang berubah, test result, known issue, blocker, Do Not Repeat, dan exact next step.

Task `medium` atau `major` tidak boleh dilaporkan sebagai `SUCCESS`, `verified`, `resume_safe`, `closed`, atau `ready to pr` sebelum documentation sync lengkap.

## 13. Release Readiness

### Tujuan

Memastikan perubahan siap direview atau dirilis dengan risiko yang dipahami.

Sebelum `ready to pr`, pastikan tersedia scope summary, test summary, rollback path, smoke checklist, configuration checklist, backward compatibility notes, impact terhadap user dan data, final QA evidence, final impact check, dan PR readiness note.

`ready to pr` berarti siap untuk review. Scaffold tidak otomatis membuat remote pull request.

## 14. Route Multi-Agent

Untuk pekerjaan medium atau high-risk bila runtime tersedia:

1. Claude: analisis requirement, arsitektur, risiko, dan QA scenario.
2. Codex/GPT: implementasi, command execution, dan targeted test.
3. Gemini: independent review dan consistency cross-check.
4. Claude atau human reviewer: final QA reasoning, handoff, dan PR summary.

Semua runtime tetap memakai gate, path artifact, status, dan evidence shape yang sama.

### Routing Model Runtime

- Codex memakai Luna/Terra/Sol melalui router sebelum sesi CLI baru atau worker ephemeral.
- Claude Code VS Code memakai Sonnet sebagai supervisor dan dapat mendelegasikan subtask L0 ke Haiku atau L3 review ke Opus. Model sesi VS Code yang terlihat tidak diganti di tengah percakapan.
- Fable hanya dipakai Claude setelah identitas model yang benar-benar tersedia diverifikasi pada konfigurasi lokal atau managed. `Auto` pada UI Claude Code adalah mode izin, bukan router model.
- Antigravity mengikuti kebijakan Gemini di `guardrails/system/ANTIGRAVITY_RUNTIME_POLICY.md`.

## 15. Governance Tim

Tim dapat menambah project-specific docs, skill, agent, template, dan automation tanpa melemahkan flow scaffold. Perubahan terhadap `AGENTS.md`, `COMMANDS.md`, `guardrails/`, `workflows/`, `templates/`, runtime skills, scripts, atau CI wajib mengikuti `guardrails/system/SCAFFOLD_CORE_CHANGE_POLICY.md` dan mendapat review maintainer.

## Alur Ringkas

```text
User Request
 -> Read AGENTS.md dan operational state
 -> Classify task dan pilih project mode
 -> Read shared context, memory, dan dev-doc
 -> Interview bila diperlukan
 -> Impact scan dan readiness baseline
 -> Slice satu task
 -> Skill lookup
 -> Plan dan founder approval bila medium/major
 -> Open pre-coding gate
 -> Implement
 -> During-development QA
 -> Self-review dan final QA
 -> Manual visual QA bila diperlukan
 -> Final impact check
 -> Documentation sync
 -> Update shared context dan memory
 -> Handoff atau ready to pr
```

## Referensi Utama

- `AGENTS.md`: aturan runtime dan gate utama
- `COMMANDS.md`: daftar command dan prompt operasional
- `workflows/`: workflow detail per jenis pekerjaan
- `guardrails/`: policy strict dan protocol
- `templates/`: format artifact dan evidence
- `artifacts/operations/`: state, task, gate, dan session log
- `development/[project-folder]/artifacts/shared/`: continuity yang dibawa Git bersama project

Project pada `development/[project-folder]/` wajib menjadi repository Git terpisah. Commit dan push source project serta shared context dilakukan dari folder project; repo scaffold mengabaikan seluruh folder target dan memblokir commit/push root secara default.

Update `main` pada repository scaffold hanya dilakukan oleh `@odonplay`. Contributor lain membuat branch dan Pull Request; aktifkan GitHub Ruleset pada `docs/REPOSITORY_GOVERNANCE.md` agar aturan ini enforced di server.

## 16. Routing Model Codex

Sebelum coding, Terra sebagai supervisor otomatis menjalankan router tanpa meminta user memilih model. Ia menangani route `standard` sendiri, lalu membuat satu worker sementara untuk Luna/`fast`, Sol/`deep`, atau Sol/`critical` bila diperlukan. GPT-5.5 hanya untuk reproduksi legacy atau benchmark yang diminta secara eksplisit, bukan fallback. Router tidak mengubah model chat yang sedang aktif dan tidak membuka gate coding. Keputusan ringkas tersimpan pada `artifacts/shared/AI_ROUTING_LOG.md` milik project bila tersedia.
