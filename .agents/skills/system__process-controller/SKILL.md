# Process Controller Skill

**Trigger:** Gunakan skill ini saat user ingin:
- Cek status workflow saat ini
- Tahu step berikutnya
- Tahu estimasi token sebelum jalankan step
- Update status setelah step selesai
- Mulai atau resume session
- Cek berapa % quota yang akan dipakai

---

## Tiga Mode Operasi

### MODE 1: STATUS CHECK
**Dipanggil saat:** "Cek status", "Status sekarang apa?", "Lanjut dari mana?"

**Langkah:**
1. Baca `artifacts/operations/WORKFLOW_STATE.md`
2. Baca `artifacts/operations/SESSION_LOG.md` (entry terakhir)
3. Tampilkan ringkasan:
   - Quota sisa (session + weekly)
   - Step terakhir yang selesai
   - Step berikutnya + estimasi token + % quota
   - Blockers jika ada
4. Tanyakan: "Jalankan step berikutnya sekarang?"

**Output format:**
```
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
ðŸ“Š STATUS WORKFLOW
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Quota    : Session [X]% sisa | Weekly [X]% sisa
Model    : [model aktif]

âœ… Terakhir selesai : [Step Name]
â–¶ Berikutnya       : [Step Name]
   Skill/Agent     : [nama]
   Est. token      : [range]
   % dari remaining: ~[X]%
   âš ï¸  Warning     : [jika ada]

Input yang dibutuhkan:
   - [list input]

Jalankan sekarang? (Y/N)
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
```

---

### MODE 2: PRE-STEP CHECK (Sebelum Jalankan Step)
**Dipanggil saat:** User menyebut nama step, "Berapa token untuk X?", "Aman nggak jalankan X?"

**Langkah:**
1. Baca entry step dari `guardrails/system/STEP_REGISTRY.md`
2. Baca `guardrails/system/SKILL_CATALOG.md` untuk memverifikasi skill/agent yang dipakai step resmi
3. Baca quota saat ini dari `artifacts/operations/WORKFLOW_STATE.md`
4. Hitung % quota yang akan terpakai
5. Beri rekomendasi model yang efisien
6. Tampilkan warning jika melebihi threshold
7. Minta konfirmasi sebelum jalankan

**Output format:**
```
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
ðŸ” PRE-STEP CHECK: [Step Name]
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Quota saat ini:
  Session  : [X]% sisa  â‰ˆ [N] tokens tersedia
  Weekly   : [X]% sisa

Estimasi step ini:
  Model [Haiku]  â†’ [N] tokens â†’ [X]% dari remaining
  Model [Sonnet] â†’ [N] tokens â†’ [X]% dari remaining
  Model [Opus]   â†’ [N] tokens â†’ [X]% dari remaining

Rekomendasi: Gunakan [MODEL] â†’ hemat, cukup untuk task ini

Status: [âœ… AMAN / âš ï¸ PERTIMBANGKAN / â›” BERISIKO]

Input yang dibutuhkan:
  âœ… [input yang sudah ada]
  âŒ [input yang belum ada â†’ BLOCKED]

Skill/Agent Check:
  âœ… Mapped skill/agent: [nama dari SKILL_CATALOG.md]
  âš ï¸ Jika belum ada: tandai placeholder dan lanjut hanya jika founder setuju

Lanjutkan dengan [MODEL]? (Y/N)
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
```

---

### MODE 3: POST-STEP UPDATE (Setelah Step Selesai)
**Dipanggil saat:** Step selesai, user ingin update log

**Langkah:**
1. Tanyakan: status (success/failed), token aktual, file output, catatan
2. Update `artifacts/operations/WORKFLOW_STATE.md`:
   - Ubah status step ke âœ… SUCCESS atau âŒ FAILED
   - Isi kolom Model, Token, Selesai
   - Update Next Step Recommendation
   - Unlock step berikutnya jika syarat terpenuhi
3. Update `artifacts/operations/SESSION_LOG.md`:
   - Tambah entry step ke session aktif
4. Tampilkan ringkasan update

**Output format:**
```
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
âœ… STEP UPDATED: [Step Name]
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Status    : âœ… SUCCESS
Token used: ~[N]
Output    : [file path]

WORKFLOW_STATE.md â†’ Updated
SESSION_LOG.md    â†’ Updated

Step yang terbuka (unlock):
  â–¶ [Next Step Name] â€” sekarang PENDING (syarat terpenuhi)

Sisa quota estimasi:
  Session  : [X]% â†’ [X-delta]%
  Weekly   : [X]% â†’ [X-delta]%

Lanjut ke [Next Step]? (Y/N)
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
```

---

## Aturan Wajib

1. **JANGAN jalankan step apapun tanpa konfirmasi user**
   - Selalu tampilkan pre-step check dulu
   - Selalu tanya Y/N sebelum eksekusi

2. **SELALU hitung % quota sebelum eksekusi**
   - Ambil quota dari WORKFLOW_STATE.md
   - Hitung dari STEP_REGISTRY.md
   - Warning jika > 10%, stop jika > 20%

2a. **Untuk step resmi P1-P7, B1-B3, R1-R4, SELALU cek skill catalog dulu**
   - Verifikasi skill/agent dari `guardrails/system/SKILL_CATALOG.md`
   - Jika entry placeholder atau missing, tampilkan sebagai risiko sebelum konfirmasi

3. **SELALU update state setelah step selesai**
   - WORKFLOW_STATE.md harus selalu akurat
   - SESSION_LOG.md harus selalu terisi

4. **SCOPE REMINDER setiap kali build step**
   - Selalu ingatkan user untuk scope per fitur
   - "Build login API hanya" bukan "build backend"

5. **RESUME CAPABILITY**
   - Jika session baru, baca state terlebih dahulu
   - Laporkan posisi terakhir sebelum tanya step apa

6. **HYBRID POLICY**
   - Wajib skill check hanya untuk official workflow steps
   - Untuk tindakan kecil di luar step resmi, tidak perlu memaksa skill lookup bila konteks sudah jelas

7. **AUTO-RUN DRY-RUN POLICY**
   - Setelah framework decision approved, sistem boleh auto-run scaffold preparation dan scaffold dry-run
   - Real scaffold execute tetap butuh approval founder
   - Jika microservice backend target belum spesifik, dry-run boleh lanjut tapi execute backend harus tetap ditahan

---

## Token Calculation Logic

```
Input dari user:
  session_remaining_pct = [angka dari UI, misal 63]
  weekly_remaining_pct  = [angka dari UI, misal 60]
  model_active          = [light / balanced / powerful]

Kapasitas baseline per session (estimasi):
  balanced_session_capacity = 30,000  tokens
  light_session_capacity    = 90,000  tokens  (3x lebih hemat)
  powerful_session_capacity = 10,000  tokens  (3x lebih mahal)

Tokens tersedia:
  available = capacity Ã— (remaining_pct / 100)

Contoh (Balanced, 63% sisa):
  available = 30,000 Ã— 0.63 = 18,900 tokens

Persentase step:
  step_pct = (step_token_estimate / available) Ã— 100

Contoh (step 1,500 token, 18,900 tersedia):
  step_pct = (1,500 / 18,900) Ã— 100 = 7.9%

Threshold:
  < 10% â†’ âœ… AMAN
  10-20% â†’ âš ï¸  Pertimbangkan scope lebih kecil atau model lebih murah
  > 20% â†’ â›” STOP â€” tunggu reset atau kurangi scope drastis
```

---

## Contoh Percakapan

### Contoh 1: Mulai Session Baru
```
User: "Status sekarang apa? Session sisa 63%, weekly 60%"

Assistant (process-controller):
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
ðŸ“Š STATUS WORKFLOW
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Quota    : Session 63% sisa (~18,900 token) | Weekly 60% sisa
Model    : Sonnet (aktif)

Belum ada step yang selesai.
â–¶ Mulai dari : P1 â€” Founder Interview
   Skill     : founder-interviewer
   Est. token: 800 â€“ 1,500
   % pakai   : ~6.3â€“7.9% dari sisa session âœ… AMAN

Input yang dibutuhkan:
   - Tuliskan ide produk Anda (1-2 paragraf)

Jalankan P1 sekarang? (Y/N)
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
```

### Contoh 2: User Tanya Sebelum Jalankan
```
User: "Berapa token kalau saya jalankan architecture sekarang? Sisa session 30%"

Assistant (process-controller):
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
ðŸ” PRE-STEP CHECK: P6 â€” Solution Architecture
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Quota saat ini:
  Session  : 30% sisa  â‰ˆ 9,000 tokens tersedia
  Weekly   : [dari WORKFLOW_STATE]

Estimasi step ini (per sistem):
  Haiku  â†’ 2,000 tokens â†’ 22.2% dari remaining â›”
  Sonnet â†’ 2,000 tokens â†’ 22.2% dari remaining â›”
  Opus   â†’ 2,000 tokens â†’ 22.2% dari remaining â›”

âš ï¸  PERINGATAN: Step ini akan menggunakan >20% sisa session.
Pilihan Anda:
  1. Tunggu session reset (dalam [X] jam)
  2. Scope lebih kecil: "Architecture untuk auth module saja"
     â†’ Est. 800 tokens â†’ 8.9% âœ… AMAN
  3. Lanjut dengan risiko kehabisan di tengah proses

Lanjutkan opsi mana? (1/2/3)
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
```

### Contoh 3: Update Setelah Selesai
```
User: "P1 sudah selesai, pakai sekitar 1,100 token, output di interview_notes.md"

Assistant (process-controller):
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
âœ… STEP UPDATED: P1 â€” Founder Interview
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Status    : âœ… SUCCESS
Token used: ~1,100
Output    : artifacts/brd/interview_notes.md

WORKFLOW_STATE.md â†’ Updated (P1 = âœ… SUCCESS)
SESSION_LOG.md    â†’ Updated

Step yang terbuka:
  â–¶ P2 â€” Requirements â€” sekarang PENDING âœ…

Sisa quota estimasi:
  Session  : 63% â†’ ~58% (-5.8% untuk 1,100 token)
  Tersedia : ~17,400 tokens

Lanjut ke P2 (Requirements)? Est. 1,500-3,000 token (~8-17%) (Y/N)
â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
```



