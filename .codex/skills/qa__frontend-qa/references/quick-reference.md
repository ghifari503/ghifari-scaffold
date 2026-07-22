# Quick Reference — Frontend QA

Dokumen ini menjadi pegangan cepat untuk keputusan teknis konsisten saat skill dijalankan.

---

## Urutan Audit yang Disarankan

1. Cari `package.json`
2. Deteksi package manager dari lock file
3. Baca script utama repo (`dev`, `start`, `build`, `test`)
4. Deteksi framework frontend
5. Cari dependency Playwright / Cypress
6. Cari config file existing
7. Cari folder test existing
8. Cek kebutuhan startup app dan base URL
9. Cek env yang dibutuhkan
10. Baru putuskan: install / run / perbaikan

---

## Matriks Keputusan Framework

### Pilih Playwright jika:

- Project baru / greenfield
- Belum ada framework E2E sama sekali
- Butuh cross-browser testing
- Butuh trace viewer untuk debugging
- Butuh screenshot/video yang stabil
- Butuh test paralel dan CI-friendly
- Tim ingin stack E2E yang lebih modern

### Pilih Cypress jika:

- Repo sudah Cypress-based dengan banyak spec existing
- Tim QA/dev sudah terbiasa dengan Cypress workflow
- Kebutuhan utama adalah debugging test interaktif di Cypress runner
- Ada banyak custom Cypress commands yang sudah dibangun

---

## Tanda Repo Sudah Siap Test

- Dependency tersedia dan terinstall
- Config file ada dan valid
- Test spec ada minimal 1
- Base URL diketahui
- App bisa boot normal
- Env tidak error
- Script run test tersedia dan berjalan

---

## Tanda Repo Belum Siap Test

- Tidak ada framework E2E sama sekali
- Script app tidak jelas atau tidak berjalan
- App tidak bisa start
- Environment variable penting hilang
- Route utama error sebelum testing dimulai
- Dependency bentrok atau package manager kacau

---

## Prioritas Smoke Test Minimal

Test awal jangan terlalu luas. Prioritaskan:

1. Homepage render — title muncul
2. Heading utama terlihat
3. Navigasi utama tampil
4. CTA utama tampil dan dapat diklik
5. Halaman login / form utama terbuka
6. Basic submit flow tidak crash
7. Halaman penting tidak blank / error 500

---

## Selector Strategy

Urutan preferensi selector:

1. `data-testid` — **wajib sebagai default**
2. Locator berbasis role (`getByRole` di Playwright)
3. Text yang memang stabil
4. Label form (`getByLabel`)
5. CSS selector stabil
6. XPath — **hanya jika benar-benar terpaksa**

---

## Base URL Default per Framework

| Framework    | Port default |
| ------------ | ------------ |
| Vite         | 5173         |
| Next.js dev  | 3000         |
| CRA          | 3000         |
| Nuxt         | 3000         |
| Angular      | 4200         |
| Remix        | 3000         |

---

## Prinsip MCP

- MCP bukan pengganti test framework
- MCP hanya lapisan integrasi / orchestration opsional
- Jika CLI cukup, jangan tambah kompleksitas MCP
- Buat MCP hanya bila ada kebutuhan tool exposure yang jelas lintas agent

---

## Kriteria Rekomendasi Akhir

Rekomendasi akhir harus tegas:

- Lanjut pakai Playwright / Cypress
- Cukup CLI, tidak perlu MCP
- Perlu tambahkan CI integration
- Perlu tambah smoke / regression suite
- Blocker environment harus dibereskan dulu sebelum lanjut test

---

## Format Audit Summary

```
✅ Framework frontend : [nama]
✅ Package manager   : [npm/yarn/pnpm/bun]
[✅/❌] Playwright    : [status + versi]
[✅/❌] Cypress       : [status + versi]
[✅/❌] MCP          : [status]
✅ Script dev/test   : [nama script]
✅ Base URL          : [url]
[✅/⚠️/❌] Blocker   : [detail jika ada]
```
