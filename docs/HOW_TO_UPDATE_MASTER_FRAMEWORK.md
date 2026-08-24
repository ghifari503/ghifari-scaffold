# Cara Memperbarui Master Framework

Panduan ini berlaku untuk Master Framework aktif yang berisi state lokal dan Working Project. Panduan ini tidak berlaku untuk Master Scaffold kanonis yang digunakan untuk menerbitkan rilis.

## Bagian yang Tetap Tidak Diubah

Proses pembaruan tidak mengubah Working Project, state Git-nya, log Master Framework, memory, traceability, artefak operasional, `plan/`, `dev-doc/`, maupun konfigurasi runtime lokal. Satu-satunya area artefak yang boleh ditulis adalah `artifacts/framework-update/`, yaitu area milik updater untuk menyimpan state pembaruan, lock, dan snapshot pemulihan. Area ini bersifat lokal dan tidak pernah masuk ke Git.

## Pembaruan Pertama dari Framework Lama

Buka PowerShell pada root Master Framework. Jangan jalankan `git pull` di root tersebut.

Clone updater terisolasi sekali saja:

```powershell
git clone --filter=blob:none --single-branch --branch main https://github.com/odonplay/odonplay-agent-scaffold.git development/_framework-updater
```

Percayai hanya clone yang diperoleh langsung dari URL GitHub resmi. Jangan menerima folder ini melalui ZIP atau chat, mengubah origin-nya, membuat commit lokal, atau menulis ulang `refs/remotes/origin/main`.

Kemudian buka atau lanjutkan runtime, lalu ketik:

```text
update framework
```

Runtime akan mengenali versi yang tidak ada sebagai `legacy_unversioned`, menjalankan dry-run, menampilkan laporan, dan meminta konfirmasi sebelum apply.

## Pembaruan Rutin

Dapatkan kode updater terbaru:

```powershell
git -C development/_framework-updater pull --ff-only origin main
```

Setelah itu ketik `update framework`. Jika belum ada pembaruan updater yang diperoleh, runtime saat mulai berjalan tidak akan menawarkan prompt pembaruan.

## Dry-Run Manual

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot .
```

Periksa `status`, `framework_state`, `changes`, `protected_roots`, `target_project_mutation`, dan `report_id`. Status harus `ready_to_apply` atau `up_to_date`; mutasi target harus bernilai `none`.

## Apply Manual

Gunakan report id persis seperti yang dihasilkan oleh dry-run saat ini:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot . -Apply -ReportId [report-id]
```

Jika berhasil, hasil akan melaporkan `status: applied`. Direktori Git root lama akan di-unstage seluruhnya dan diarsipkan hanya setelah file yang disalin lolos validasi. Setelah itu root tetap non-Git; updater dan Working Project tetap merupakan repository independen.

## Jika Pembaruan Diblokir

Updater berhenti apabila file generic berubah baik secara lokal maupun di upstream, updater kotor atau memiliki origin yang salah, baseline hilang atau berbeda, report id sudah kedaluwarsa, Master Scaffold kanonis dipilih, atau validasi gagal.

Jangan gunakan `reset --hard`, force checkout, merge otomatis, atau menghapus root Git. Sampaikan path yang dilaporkan kepada founder, lalu putuskan secara eksplisit versi mana yang harus digunakan.

## Rollback

Apply yang gagal akan rollback secara otomatis. Rollback yang dilakukan secara sadar tetap menjaga root Git tidak aktif:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot . -Rollback -SnapshotId [snapshot-id]
```

Gunakan `snapshot_id` persis yang dihasilkan oleh apply yang berhasil, bukan `report_id` dari dry-run. Path snapshot juga berakhir dengan id tersebut. Lakukan rollback sadar hanya setelah persetujuan founder. Rollback tidak mengubah Working Project.

Rollback menolak menimpa file generic yang diedit setelah pembaruan. Rollback yang berhasil memasang hold agar reconciliation tidak menerapkan rilis yang sama secara diam-diam. Untuk memperbarui kembali, dapatkan rilis yang diinginkan, jalankan dry-run baru, periksa laporan barunya, lalu otorisasi apply kembali.

## Perintah yang Tidak Boleh Digunakan

Jangan pernah memperbarui Master Framework aktif dari root-nya dengan `git pull origin main`, `git reset --hard origin/main`, atau `git checkout -- .`. Perintah tersebut melewati kontrol dry-run terisolasi, snapshot, conflict, dan rollback.
