# Playwright Setup

---

## Instalasi

Gunakan package manager yang sudah terdeteksi di environment-check.

```bash
# npm
npm init playwright@latest

# yarn
yarn create playwright

# pnpm
pnpm create playwright

# bun
bun create playwright
```

Saat prompt muncul, pilih:
- **TypeScript** → Yes (selalu gunakan TypeScript)
- **Folder test** → `playwright/e2e`
- **GitHub Actions** → sesuaikan dengan kebutuhan project
- **Install browsers** → Yes

Jika ingin install manual tanpa wizard:

```bash
# npm
npm install --save-dev @playwright/test
npx playwright install

# pnpm
pnpm add -D @playwright/test
pnpm exec playwright install

# yarn
yarn add -D @playwright/test
yarn playwright install

# bun
bun add -d @playwright/test
bunx playwright install
```

---

## Konfigurasi Standar

Gunakan `references/playwright.config.ts.example` sebagai dasar.
Buat atau update `playwright.config.ts` di root project.

---

## Update package.json

Tambahkan scripts berikut ke `package.json`:

```json
{
  "scripts": {
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:headed": "playwright test --headed",
    "test:e2e:report": "playwright show-report"
  }
}
```

---

## Struktur Folder Playwright

Buat struktur berikut jika belum ada:

```bash
mkdir -p playwright/e2e
mkdir -p playwright/pages
mkdir -p playwright/fixtures
```

```
playwright/
├── e2e/
│   └── [fitur]/
│       └── [fitur].spec.ts
├── pages/
│   └── [Nama]Page.ts
└── fixtures/
    └── [nama].json
```

---

## Verifikasi Instalasi

Gunakan `references/smoke.spec.ts.example` sebagai test awal.

Jalankan smoke test untuk memastikan Playwright berjalan:

```bash
npx playwright test playwright/e2e/smoke.spec.ts
```

Jika berhasil, lanjut ke `references/writing-tests.md`.

Jika browser belum terinstall, jalankan:

```bash
npx playwright install
```

Lalu ulangi test.
