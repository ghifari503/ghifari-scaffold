# Cypress Setup

---

## Instalasi

Gunakan package manager yang sudah terdeteksi di environment-check.

```bash
# npm
npm install --save-dev cypress

# yarn
yarn add -D cypress

# pnpm
pnpm add -D cypress

# bun
bun add -d cypress
```

---

## Inisialisasi

Setelah install, jalankan Cypress sekali untuk generate struktur folder:

```bash
# Jalankan headless untuk generate config tanpa buka GUI
npx cypress run --headless 2>/dev/null || true

# Atau generate config manual
npx cypress open --e2e
```

Jika tidak ada display (environment headless seperti Claude Code), buat struktur manual:

```bash
mkdir -p cypress/e2e
mkdir -p cypress/pages
mkdir -p cypress/fixtures
mkdir -p cypress/support
```

---

## Konfigurasi Standar

Gunakan `references/cypress.config.ts.example` sebagai dasar.
Buat atau update `cypress.config.ts` di root project.

---

## Support Files

Buat file support wajib:

```typescript
// cypress/support/e2e.ts
import './commands'

// Tambahkan global setup di sini
beforeEach(() => {
  // cy.clearLocalStorage()
  // cy.clearCookies()
})
```

```typescript
// cypress/support/commands.ts

declare global {
  namespace Cypress {
    interface Chainable {
      login(email: string, password: string): Chainable<void>
      loginByApi(email: string, password: string): Chainable<void>
    }
  }
}

// Login via UI
Cypress.Commands.add('login', (email: string, password: string) => {
  cy.visit('/auth/login')
  cy.get('[data-testid="email-input"]').type(email)
  cy.get('[data-testid="password-input"]').type(password)
  cy.get('[data-testid="submit-btn"]').click()
  cy.url().should('not.include', '/login')
})

// Login via API (lebih cepat, bypass UI)
Cypress.Commands.add('loginByApi', (email: string, password: string) => {
  cy.request('POST', '/api/auth/login', { email, password }).then((response) => {
    window.localStorage.setItem('auth_token', response.body.token)
  })
})

export {}
```

---

## TypeScript Config untuk Cypress

Tambahkan ke `tsconfig.json` atau buat `cypress/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["es5", "dom"],
    "types": ["cypress", "node"]
  },
  "include": ["**/*.ts"]
}
```

---

## Update package.json

```json
{
  "scripts": {
    "test:cypress": "cypress run --headless",
    "test:cypress:open": "cypress open",
    "test:cypress:headed": "cypress run --headed",
    "test:cypress:debug": "cypress open --e2e"
  }
}
```

---

## Struktur Folder Cypress

```
cypress/
├── e2e/
│   └── [fitur]/
│       └── [fitur].cy.ts
├── pages/
│   └── [Nama]Page.ts
├── fixtures/
│   └── [nama].json
└── support/
    ├── commands.ts
    └── e2e.ts
```

---

## Verifikasi Instalasi

Gunakan `references/cypress/e2e/smoke.cy.ts` sebagai test awal.

Jalankan headless:

```bash
npx cypress run --headless --spec "cypress/e2e/smoke.cy.ts"
```

Jika berhasil, hapus smoke test dan lanjut ke `references/writing-tests.md`.

---

## Catatan Penting Cypress di Claude Code

Cypress **tidak bisa dibuka secara GUI** di environment Claude Code karena tidak ada display.
Selalu gunakan flag `--headless` saat menjalankan test:

```bash
npx cypress run --headless
npx cypress run --headless --spec "cypress/e2e/auth/*.cy.ts"
npx cypress run --headless --browser chrome
```
