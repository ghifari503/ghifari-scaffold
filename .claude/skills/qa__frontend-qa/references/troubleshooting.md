# Troubleshooting — Frontend QA

---

## 1. `package.json` tidak ditemukan

### Gejala
Claude tidak menemukan root frontend yang valid.

### Tindakan
- Cari subfolder app/frontend/web
- Pastikan working directory benar
- Jangan install framework testing sebelum root project valid

---

## 2. Package manager bentrok

### Gejala
Ada `package-lock.json` dan `yarn.lock` sekaligus, atau ada lock file lama yang tidak konsisten.

### Tindakan
- Pilih package manager paling dominan / terbaru sesuai repo
- Jangan campur command install
- Laporkan konflik ini sebagai technical debt

---

## 3. Playwright terinstall tapi browser belum ada

### Gejala
Test gagal dengan error browser executable tidak ditemukan.

### Tindakan
Jalankan:
- npm: `npx playwright install`
- pnpm: `pnpm exec playwright install`
- yarn: `yarn playwright install`
- bun: `bunx playwright install`

---

## 4. Cypress terinstall tapi binary rusak / gagal verify

### Gejala
Cypress gagal open/run setelah install.

### Tindakan
- Coba reinstall dependency
- Jalankan verify ulang jika perlu
- Cek cache/path/permission
- Pastikan versi Node kompatibel

---

## 5. App tidak sempat ready saat test mulai

### Gejala
Test gagal karena `ECONNREFUSED`, timeout halaman, atau base URL belum siap.

### Tindakan
- Pastikan server app dijalankan dulu
- Tunggu port ready
- Gunakan `wait-on` atau `start-server-and-test`
- Tambah timeout dengan wajar, jangan berlebihan

---

## 6. Environment variable tidak lengkap

### Gejala
Frontend crash saat boot, halaman blank, atau auth tidak jalan.

### Tindakan
- Cek `.env`, `.env.local`, `.env.example`
- Identifikasi env wajib
- Jangan menebak nilai production
- Gunakan placeholder/dev-safe value jika sesuai scope

---

## 7. Selector rapuh

### Gejala
Test sering flaky karena selector berbasis class atau DOM position.

### Tindakan
- Ganti ke `data-testid`
- Gunakan role selector
- Gunakan text hanya jika stabil
- Hindari selector berbasis index bila bisa dihindari

---

## 8. Login flow sulit diotomasi

### Gejala
Auth bergantung captcha, OTP, third-party redirect, atau session ephemeral.

### Tindakan
- Prioritaskan test untuk page public terlebih dahulu
- Gunakan seed user / test user bila ada
- Gunakan state reuse / storage state untuk Playwright
- Jangan mem-bypass auth production tanpa izin

---

## 9. Port bentrok

### Gejala
App atau runner gagal start karena port sudah dipakai.

### Tindakan
- Identifikasi port default dari project
- Cari proses yang bentrok
- Gunakan port alternatif jika aman
- Update base URL test sesuai perubahan

---

## 10. Repo monorepo

### Gejala
Ada banyak `package.json` dan tidak jelas app mana yang harus dites.

### Tindakan
- Cari app frontend utama
- Pastikan root kerja di package yang benar
- Jangan setup test di package yang salah

---

## 11. MCP tidak tersedia

### Gejala
User ingin workflow dengan MCP tapi repo belum punya MCP sama sekali.

### Tindakan
- Tegaskan bahwa E2E tetap bisa dijalankan via CLI
- Audit dulu apakah MCP benar-benar dibutuhkan
- Jika perlu, buat wrapper/tool sederhana sebelum membuat MCP penuh

---

## 12. Test flaky di CI

### Gejala
Lokal pass, CI fail secara acak.

### Tindakan
- Cek race condition / loading state
- Gunakan wait berbasis kondisi, bukan sleep mentah
- Review timeout, retry, dan stabilitas environment CI
- Fokus ke deterministic selectors
