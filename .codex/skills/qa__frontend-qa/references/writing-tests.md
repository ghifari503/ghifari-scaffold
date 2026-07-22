# Writing Tests

Panduan menulis test yang konsisten untuk Playwright dan Cypress.

---

## Langkah Sebelum Menulis Test

1. Baca `docs/USERFLOW.md` jika tersedia — identifikasi semua user journey
2. Jika tidak ada USERFLOW.md, minta user mendeskripsikan flow yang ingin ditest
3. Identifikasi actor, trigger, input, output sukses, dan output gagal
4. Tentukan priority: flow kritis (login, checkout, submit form) didahulukan

---

## Page Object Model (POM)

Semua test **wajib** menggunakan POM. Jangan tulis selector langsung di dalam test.

### POM untuk Playwright

```typescript
// playwright/pages/LoginPage.ts
import { Page, Locator, expect } from '@playwright/test'

export class LoginPage {
  readonly page: Page

  // Definisi locator — semua di satu tempat
  readonly emailInput: Locator
  readonly passwordInput: Locator
  readonly submitButton: Locator
  readonly errorMessage: Locator
  readonly forgotPasswordLink: Locator

  constructor(page: Page) {
    this.page = page
    this.emailInput = page.getByTestId('email-input')
    this.passwordInput = page.getByTestId('password-input')
    this.submitButton = page.getByTestId('submit-btn')
    this.errorMessage = page.getByTestId('error-message')
    this.forgotPasswordLink = page.getByTestId('forgot-password-link')
  }

  // Actions
  async goto() {
    await this.page.goto('/auth/login')
  }

  async fillEmail(email: string) {
    await this.emailInput.fill(email)
  }

  async fillPassword(password: string) {
    await this.passwordInput.fill(password)
  }

  async submit() {
    await this.submitButton.click()
  }

  async login(email: string, password: string) {
    await this.fillEmail(email)
    await this.fillPassword(password)
    await this.submit()
  }

  // Assertions
  async expectErrorVisible() {
    await expect(this.errorMessage).toBeVisible()
  }

  async expectErrorMessage(text: string) {
    await expect(this.errorMessage).toContainText(text)
  }
}
```

### POM untuk Cypress

```typescript
// cypress/pages/LoginPage.ts
export class LoginPage {
  // Selector sebagai property — ubah di satu tempat jika berubah
  private selectors = {
    emailInput: '[data-testid="email-input"]',
    passwordInput: '[data-testid="password-input"]',
    submitButton: '[data-testid="submit-btn"]',
    errorMessage: '[data-testid="error-message"]',
  }

  visit() {
    cy.visit('/auth/login')
    return this
  }

  fillEmail(email: string) {
    cy.get(this.selectors.emailInput).clear().type(email)
    return this
  }

  fillPassword(password: string) {
    cy.get(this.selectors.passwordInput).clear().type(password)
    return this
  }

  submit() {
    cy.get(this.selectors.submitButton).click()
    return this
  }

  login(email: string, password: string) {
    return this.fillEmail(email).fillPassword(password).submit()
  }

  // Assertions — kembalikan this untuk chaining
  shouldShowError() {
    cy.get(this.selectors.errorMessage).should('be.visible')
    return this
  }

  shouldShowErrorMessage(text: string) {
    cy.get(this.selectors.errorMessage).should('contain.text', text)
    return this
  }
}
```

---

## Struktur Test

### Playwright

```typescript
// playwright/e2e/auth/login.spec.ts
import { test, expect } from '@playwright/test'
import { LoginPage } from '../../pages/LoginPage'
import users from '../../fixtures/users.json'

test.describe('Login', () => {
  let loginPage: LoginPage

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page)
    await loginPage.goto()
  })

  test('should login with valid credentials', async ({ page }) => {
    await loginPage.login(users.valid.email, users.valid.password)
    await expect(page).toHaveURL(/\/dashboard/)
  })

  test('should show error with wrong password', async () => {
    await loginPage.login(users.valid.email, 'wrong-password')
    await loginPage.expectErrorMessage('Password salah')
  })

  test('should disable submit button when fields empty', async () => {
    await expect(loginPage.submitButton).toBeDisabled()
  })
})
```

### Cypress

```typescript
// cypress/e2e/auth/login.cy.ts
import { LoginPage } from '../../pages/LoginPage'

describe('Login', () => {
  const loginPage = new LoginPage()

  beforeEach(() => {
    loginPage.visit()
  })

  it('should login with valid credentials', () => {
    loginPage.login(Cypress.env('TEST_EMAIL'), Cypress.env('TEST_PASSWORD'))
    cy.url().should('include', '/dashboard')
  })

  it('should show error with wrong password', () => {
    loginPage
      .login(Cypress.env('TEST_EMAIL'), 'wrong-password')
      .shouldShowErrorMessage('Password salah')
  })
})
```

---

## Fixtures (Test Data)

Jangan hardcode data test di dalam file test.

```json
// playwright/fixtures/users.json
// cypress/fixtures/users.json
{
  "valid": {
    "email": "testuser@example.com",
    "password": "TestPassword123!",
    "name": "Test User"
  },
  "admin": {
    "email": "admin@example.com",
    "password": "AdminPassword123!",
    "name": "Admin User"
  },
  "invalidEmail": "not-an-email",
  "shortPassword": "123"
}
```

Untuk data sensitif, gunakan environment variable:

```typescript
// Playwright
const email = process.env.TEST_EMAIL!

// Cypress
Cypress.env('TEST_EMAIL')
```

---

## Prioritas Test yang Harus Dibuat

Urutan pembuatan test berdasarkan dampak bisnis:

1. **Authentication** — login, logout, register, forgot password
2. **Core user journey** — flow utama yang menghasilkan nilai (beli, submit, kirim)
3. **Authorization** — halaman yang hanya bisa diakses role tertentu
4. **Form validation** — semua form dengan input penting
5. **Error state** — apa yang terjadi saat API gagal atau data tidak valid
6. **Navigation** — routing yang kritis

---

## Naming Convention

| Elemen | Format | Contoh |
|---|---|---|
| File Playwright | `[fitur].spec.ts` | `login.spec.ts` |
| File Cypress | `[fitur].cy.ts` | `login.cy.ts` |
| File POM | `[Nama]Page.ts` | `LoginPage.ts` |
| `describe` / `test.describe` | Nama fitur/halaman | `'Login'` |
| `it` / `test` | Mulai dengan "should" | `'should login with valid credentials'` |
| Fixture file | `[konteks].json` | `users.json`, `products.json` |

---

## Selector Priority

Gunakan selector dalam urutan prioritas berikut:

1. `data-testid` — **wajib sebagai default**
2. `role` + `name` (untuk Playwright: `getByRole`)
3. `placeholder` atau `label` (untuk form)
4. CSS class — **hindari** jika class bisa berubah karena styling
5. XPath — **hindari** kecuali tidak ada pilihan lain
