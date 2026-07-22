# Draft MCP Wrapper — Frontend QA Browser Tools

## Tujuan

Dokumen ini adalah draft awal jika project benar-benar membutuhkan MCP untuk membantu workflow QA browser.

## Catatan penting

Untuk Playwright dan Cypress, **MCP tidak wajib**. Jalur default tetap CLI lokal. Draft ini hanya dipakai jika memang ada kebutuhan orchestration/tool exposure yang jelas.

---

## Kapan Draft Ini Relevan

- Ingin expose command browser testing ke agent melalui tool interface
- Ingin agent bisa menjalankan smoke test, screenshot, dan report command secara terstruktur
- Ingin wrapper yang lebih aman daripada memberi akses shell terlalu luas

---

## Scope Tool MCP Minimum

Tool yang disarankan:

1. `audit_frontend_test_stack`
2. `install_playwright_if_missing`
3. `install_cypress_if_missing`
4. `run_playwright_smoke`
5. `run_cypress_smoke`
6. `start_frontend_server`
7. `capture_test_report_summary`

---

## Input/Output yang Disarankan

### 1. `audit_frontend_test_stack`

**Input:**
- `projectPath: string`

**Output:**
- `packageManager`
- `frontendFramework`
- `hasPlaywright`
- `hasCypress`
- `hasMcp`
- `scripts`
- `recommendedFramework`
- `blockers[]`

---

## Struktur Implementasi Minimal

```text
mcp-frontend-qa/
├── package.json
├── src/
│   ├── index.ts
│   ├── tools/
│   │   ├── auditFrontendTestStack.ts
│   │   ├── installPlaywrightIfMissing.ts
│   │   ├── installCypressIfMissing.ts
│   │   ├── runPlaywrightSmoke.ts
│   │   └── runCypressSmoke.ts
│   └── utils/
│       ├── detectPackageManager.ts
│       ├── readPackageJson.ts
│       └── execCommand.ts
└── README.md
```

---

## Aturan Keamanan

- Batasi path agar hanya bisa bekerja di root project yang diizinkan
- Whitelist command yang boleh dieksekusi
- Sanitasi input path dan argumen
- Hindari shell interpolation mentah
- Log command yang dijalankan

---

## Rekomendasi Praktis

Jika kebutuhan Anda hanya setup dan run test lokal, **jangan buat MCP dulu**. Gunakan skill + CLI. Buat MCP hanya saat Anda benar-benar butuh tool interface yang reusable lintas agent.
