# Debugging Tests

Panduan identifikasi dan perbaikan test yang gagal.

---

## Langkah Awal

Saat test gagal, selalu lakukan ini dulu sebelum menyimpulkan penyebabnya:

```bash
# Playwright — jalankan ulang dengan output verbose
npx playwright test --reporter=list [file-yang-gagal]

# Playwright — buka trace viewer untuk melihat langkah per langkah
npx playwright show-trace playwright/test-results/[nama-test]/trace.zip

# Cypress — jalankan ulang headless dengan output lengkap
npx cypress run --headless --spec "[file-yang-gagal]"
```

---

## Kategori Error dan Solusinya

### 1. Selector / Element Not Found

**Gejala:**
```
# Playwright
TimeoutError: locator.click: Timeout 10000ms exceeded
waiting for getByTestId('submit-btn')

# Cypress
CypressError: Timed out retrying after 4000ms
Expected to find element: [data-testid="submit-btn"] but never found it
```

**Langkah debug:**
1. Cek apakah `data-testid` memang ada di komponen
2. Cek apakah elemen di dalam iframe atau shadow DOM
3. Cek apakah elemen baru muncul setelah kondisi tertentu (loading, fetch)
4. Cek apakah ada typo di selector

**Solusi umum:**
```typescript
// Playwright — tunggu elemen muncul dulu
await expect(page.getByTestId('submit-btn')).toBeVisible({ timeout: 15_000 })
await page.getByTestId('submit-btn').click()

// Playwright — jika di dalam iframe
const frame = page.frameLocator('#my-iframe')
await frame.getByTestId('submit-btn').click()

// Cypress — tambah timeout lebih panjang
cy.get('[data-testid="submit-btn"]', { timeout: 15000 }).click()

// Cypress — tunggu elemen exist dulu
cy.get('[data-testid="submit-btn"]').should('exist').click()
```

---

### 2. Timing / Race Condition

**Gejala:**
```
# Elemen ada tapi klik tidak berdampak
# Assertion gagal padahal secara visual sudah benar
# Test kadang pass kadang gagal (flaky)
```

**Langkah debug:**
1. Tambahkan screenshot sebelum dan sesudah aksi yang gagal
2. Cek apakah ada animasi atau loading state yang belum selesai
3. Cek apakah ada network request yang belum selesai saat assertion dilakukan

**Solusi — Playwright:**
```typescript
// Tunggu network idle setelah navigasi
await page.goto('/dashboard', { waitUntil: 'networkidle' })

// Tunggu request API selesai
const responsePromise = page.waitForResponse('**/api/users')
await page.getByTestId('load-btn').click()
await responsePromise

// Tunggu elemen tidak disabled lagi
await expect(page.getByTestId('submit-btn')).toBeEnabled()
await page.getByTestId('submit-btn').click()
```

**Solusi — Cypress:**
```typescript
// Intercept dan tunggu request selesai
cy.intercept('GET', '/api/users').as('getUsers')
cy.visit('/users')
cy.wait('@getUsers')
cy.get('[data-testid="user-list"]').should('be.visible')

// Tunggu elemen tidak disabled
cy.get('[data-testid="submit-btn"]').should('not.be.disabled').click()
```

---

### 3. Network / API Error

**Gejala:**
```
# Response tidak sesuai ekspektasi
# Halaman error karena API gagal
# Test bergantung pada data dari server eksternal
```

**Solusi — Mock API:**
```typescript
// Playwright — intercept dan mock response
await page.route('**/api/users', async (route) => {
  await route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify([{ id: 1, name: 'Test User' }]),
  })
})

// Playwright — simulasi error
await page.route('**/api/users', async (route) => {
  await route.fulfill({ status: 500 })
})

// Cypress — intercept dan mock
cy.intercept('GET', '/api/users', { fixture: 'users.json' }).as('getUsers')
cy.intercept('POST', '/api/login', { statusCode: 401, body: { message: 'Unauthorized' } })
```

---

### 4. Authentication State

**Gejala:**
```
# Redirect ke halaman login di tengah test
# 401 Unauthorized dari API
# Session expired
```

**Solusi — Playwright (simpan state auth):**
```typescript
// playwright/fixtures/auth.setup.ts
import { test as setup } from '@playwright/test'

const authFile = 'playwright/.auth/user.json'

setup('authenticate', async ({ page }) => {
  await page.goto('/auth/login')
  await page.getByTestId('email-input').fill(process.env.TEST_EMAIL!)
  await page.getByTestId('password-input').fill(process.env.TEST_PASSWORD!)
  await page.getByTestId('submit-btn').click()
  await page.waitForURL('/dashboard')

  // Simpan state — reuse di test berikutnya tanpa login ulang
  await page.context().storageState({ path: authFile })
})
```

```typescript
// playwright.config.ts — gunakan auth state
projects: [
  { name: 'setup', testMatch: /auth\.setup\.ts/ },
  {
    name: 'authenticated',
    use: { storageState: 'playwright/.auth/user.json' },
    dependencies: ['setup'],
  },
]
```

**Solusi — Cypress (login via API):**
```typescript
// cypress/support/commands.ts
Cypress.Commands.add('loginByApi', (email, password) => {
  cy.request('POST', '/api/auth/login', { email, password })
    .then((response) => {
      window.localStorage.setItem('auth_token', response.body.token)
    })
})

// Di setiap test yang butuh login
beforeEach(() => {
  cy.loginByApi(Cypress.env('TEST_EMAIL'), Cypress.env('TEST_PASSWORD'))
})
```

---

### 5. Flaky Tests (Kadang Pass Kadang Gagal)

**Penyebab umum:**
- Timing issue — test berjalan lebih cepat dari UI update
- Dependency antar test — test A mengubah state yang dipakai test B
- Data tidak konsisten — test bergantung pada data yang bisa berubah
- Environment berbeda — test pass di local tapi gagal di CI

**Langkah identifikasi:**
```bash
# Playwright — jalankan test berkali-kali untuk deteksi flakiness
npx playwright test --repeat-each=5 [file-yang-dicurigai]
```

**Solusi:**
```typescript
// Isolasi test — setiap test harus bisa berdiri sendiri
test.beforeEach(async ({ page }) => {
  // Reset state sebelum setiap test
  await page.evaluate(() => localStorage.clear())
})

// Gunakan data unik per test run
const uniqueEmail = `test-${Date.now()}@example.com`

// Hindari hardcoded wait — gunakan assertion-based wait
// ❌ Jangan
await page.waitForTimeout(3000)

// ✅ Lakukan ini
await expect(page.getByTestId('loader')).toBeHidden()
await expect(page.getByTestId('content')).toBeVisible()
```

---

## Membaca Laporan Test

### Playwright HTML Report
```bash
npx playwright show-report playwright/report
```
Buka `playwright/report/index.html` — klik test yang gagal untuk lihat:
- Screenshot saat gagal
- Video replay
- Trace step-by-step
- Error message lengkap

### Cypress Report
```bash
# Buka hasil run terakhir
open cypress/screenshots/   # screenshot saat gagal
open cypress/videos/        # video recording
```

---

## Checklist Sebelum Menyatakan Test Fixed

- [ ] Test pass konsisten minimal 3x berturut-turut
- [ ] Test tidak bergantung pada state dari test lain
- [ ] Selector menggunakan `data-testid`
- [ ] Tidak ada hardcoded `waitForTimeout` atau `cy.wait(angka)`
- [ ] Test data ada di fixtures, bukan hardcoded di test
- [ ] Test bisa dijalankan secara isolated (tanpa test lain)
