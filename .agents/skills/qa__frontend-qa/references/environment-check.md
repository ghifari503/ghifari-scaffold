# Environment Check

Jalankan semua pengecekan ini sebelum memulai task apapun.
Catat hasilnya dan gunakan untuk menentukan mode kerja di SKILL.md.

---

## 1. Deteksi Package Manager

```bash
# Cek lock file yang ada di root project
ls -la | grep -E "package-lock.json|yarn.lock|pnpm-lock.yaml|bun.lockb"
```

| Lock file ditemukan  | Package manager           |
| -------------------- | ------------------------- |
| `package-lock.json`  | npm                       |
| `yarn.lock`          | yarn                      |
| `pnpm-lock.yaml`     | pnpm                      |
| `bun.lockb`          | bun                       |
| Tidak ada            | Tanya user sebelum lanjut |

Simpan hasil ini — gunakan package manager yang sama untuk semua instalasi selanjutnya.
Jangan mencampur package manager kecuali user secara eksplisit memintanya.

---

## 2. Cek Playwright

```bash
# Cek di package.json
cat package.json | grep -E "playwright"

# Cek versi jika ada
npx playwright --version 2>/dev/null

# Cek browser binaries
ls node_modules/.cache/ms-playwright 2>/dev/null || \
  ls ~/.cache/ms-playwright 2>/dev/null
```

Kemungkinan hasil:

- **Terinstall, browser ada** → skip `playwright-setup.md`, langsung ke `writing-tests.md`
- **Terinstall, browser belum** → jalankan `npx playwright install` (atau ekuivalen package manager)
- **Ada di package.json tapi belum install** → jalankan install dulu
- **Tidak ada sama sekali** → baca `playwright-setup.md`

---

## 3. Cek Cypress

```bash
# Cek di package.json
cat package.json | grep -E '"cypress"'

# Cek versi jika ada
npx cypress --version 2>/dev/null
```

Kemungkinan hasil sama seperti Playwright.
Jika binary rusak / gagal verify → baca `troubleshooting.md` bagian Cypress binary.

---

## 4. Cek Konfigurasi Test yang Ada

```bash
# Cek file konfigurasi
ls -la | grep -E "playwright.config|cypress.config"

# Cek folder test yang ada
ls -d */ 2>/dev/null | grep -E "playwright|cypress|e2e|tests|__tests__"

# Cek apakah ada test scripts di package.json
cat package.json | grep -E '"test|e2e|cypress|playwright"'
```

---

## 5. Cek MCP Playwright

```bash
# Cek file konfigurasi MCP lokal (Claude-compatible path)
cat .claude/mcp_settings.json 2>/dev/null

# Atau di lokasi global (Claude-compatible path)
cat ~/.claude/mcp_settings.json 2>/dev/null

# Cek apakah package MCP Playwright sudah ada
npx @playwright/mcp --version 2>/dev/null
```

Hasil:

- **Ada dan terkonfigurasi** → MCP siap digunakan
- **Tidak ada** → lanjutkan tanpa MCP; baca `mcp-setup.md` hanya jika dibutuhkan

---

## 6. Cek Framework Frontend dan Kebutuhan Server

```bash
# Cek framework dari package.json
cat package.json | grep -E '"next"|"vite"|"nuxt"|"@angular|"remix"'

# Cek script dev/start/preview
cat package.json | grep -E '"dev"|"start"|"preview"'

# Cek .env
ls -la | grep -E "\.env"
cat .env.example 2>/dev/null || cat .env.local.example 2>/dev/null
```

Port default umum:

| Framework    | Port default |
| ------------ | ------------ |
| Vite         | 5173         |
| Next.js dev  | 3000         |
| CRA          | 3000         |
| Nuxt         | 3000         |
| Angular      | 4200         |
| Remix        | 3000         |

---

## 7. Cek Dokumen Project

```bash
# Cek apakah ada USERFLOW sebagai sumber test case
ls docs/ 2>/dev/null | grep -iE "userflow|flow|journey"

# Cek instruksi agent project
ls -la | grep -E "AGENTS.md|CLAUDE.md"

# Cek TypeScript config
ls -la | grep tsconfig
```

---

## Ringkasan Hasil Pengecekan

Setelah semua pengecekan selesai, buat ringkasan seperti ini sebelum lanjut:

```
✅ Package manager  : pnpm
❌ Playwright       : belum terinstall
✅ Cypress          : v13.x (terinstall)
❌ MCP Playwright   : belum dikonfigurasi (bukan blocker)
✅ USERFLOW.md      : ada di docs/
✅ TypeScript       : ada
⚠️  Browser binaries : belum diinstall
🔍 Framework        : React + Vite (port 5173)
```

Lalu kembali ke SKILL.md dan tentukan mode kerja.
