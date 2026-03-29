# Praktikum 1 — Sistem Operasi

---

# Soal 1 — Analisis Data Penumpang Kereta KANJ (AWK)

## Deskripsi

Pada soal ini, dilakukan pengolahan data penumpang kereta KANJ menggunakan **AWK** dari file berformat CSV. Program menerima parameter mode (`a–e`) untuk melakukan berbagai analisis data.

---

## Fitur Program (Mode)

| Mode | Fungsi |
|------|--------|
| a | Menghitung jumlah seluruh penumpang |
| b | Menghitung jumlah gerbong unik |
| c | Menentukan penumpang dengan usia tertua |
| d | Menghitung rata-rata usia penumpang |
| e | Menghitung jumlah penumpang kelas Business |

---

## Penjelasan File

### `KANJ.sh`

Script AWK yang memproses data penumpang kereta KANJ dari file CSV. Script menerima satu parameter mode (`a` sampai `e`) untuk menentukan jenis analisis yang dilakukan.

**Bagian BEGIN** — dijalankan sebelum membaca data:
- Mengatur pemisah kolom (`FS = ","`) karena file bertipe CSV
- Membaca mode dari argumen kedua (`ARGV[2]`)
- Menginisialisasi semua variabel penghitung

**Bagian utama `{ }`** — dijalankan untuk setiap baris data:
- `NR > 1` digunakan untuk melewati baris header
- Mode `a` — menghitung jumlah baris (penumpang)
- Mode `b` — menyimpan nama gerbong unik ke dalam array, karakter non-alphanumeric dibersihkan dengan `gsub`
- Mode `c` — mencari penumpang dengan usia tertinggi pada kolom `$2`
- Mode `d` — menjumlahkan usia seluruh penumpang untuk dihitung rata-ratanya
- Mode `e` — menghitung penumpang yang kelas tiketnya `Business` pada kolom `$3`

**Bagian END** — dijalankan setelah semua data selesai dibaca:
- Mode `a` — mencetak total penumpang
- Mode `b` — menghitung panjang array gerbong lalu mencetak hasilnya
- Mode `c` — mencetak nama dan usia penumpang tertua
- Mode `d` — menghitung rata-rata dengan pembulatan (`int(total/count_r + 0.5)`)
- Mode `e` — mencetak jumlah penumpang kelas Business
- Jika mode tidak dikenali — mencetak pesan error

---

## Penjelasan Konsep

- **AWK** digunakan untuk memproses file berbasis teks (CSV)
- **Field Separator (FS)** digunakan untuk memisahkan kolom berdasarkan koma
- **NR > 1** digunakan untuk melewati header
- Array digunakan untuk menyimpan data unik (gerbong)

---

## Cara Menjalankan

```bash
awk -f KANJ.sh data.csv a
```

Ganti `a` dengan mode lain sesuai kebutuhan.

---

## Contoh Output

- Mode a: `Jumlah seluruh penumpang KANJ adalah X orang`
- Mode b: `Jumlah gerbong penumpang KANJ adalah X`
- Mode c: `[Nama] adalah penumpang kereta tertua dengan usia X tahun`
- Mode d: `Rata-rata usia penumpang KANJ adalah X tahun`
- Mode e: `Jumlah penumpang business class X orang`

---

# Soal 2 — Ekspedisi Pencarian Benda Pusaka Gunung Kawi

## Deskripsi Soal

Mahasiswa berperan sebagai asisten pribadi **Mas Amba** untuk menemukan lokasi benda pusaka yang tersembunyi di kawasan Gunung Kawi, Jawa Timur.

Langkah pengerjaan:

1. Download PDF peta ekspedisi menggunakan `gdown`
2. Buka isi PDF menggunakan `cat` untuk menemukan tautan tersembunyi
3. Clone repository dari tautan yang ditemukan menggunakan `git`
4. Parsing file JSON menggunakan `awk + regex`
5. Hitung titik pusat koordinat menggunakan metode titik tengah diagonal
6. Simpan hasil ke file `posisipusaka.txt`

---

## Konsep yang Digunakan

- Shell scripting
- AWK + Regex
- Git clone
- Perhitungan titik tengah (midpoint)

---

## Struktur Folder

```
ekspedisi/
├── peta-ekspedisi-amba.pdf
└── peta-gunung-kawi/
    ├── gsxtrack.json
    ├── parserkoordinat.sh
    ├── nemupusaka.sh
    ├── titik-penting.txt
    └── posisipusaka.txt
```

---

## Penjelasan File

### `peta-ekspedisi-amba.pdf`

File ini adalah **Peta Topografi Gunung Kawi** yang mencakup wilayah Gunung Kawi, Jawa Timur dengan skala 1:50000 menggunakan sistem koordinat WGS84 UTM Zone 49M. Peta ini dibuat oleh CalTopo dan menampilkan kontur ketinggian, jalur, serta nama-nama puncak di sekitar kawasan Gunung Kawi.

Beberapa lokasi yang tertera pada peta:
- Gunung Kawi (Puncak Redi Kawi)
- Gunung Kawi (Puncak Selatan)
- Gunung Paranggembong
- Gunung Tunggeng
- Gunung Pehmangun
- Gunung Gentonggowah

Ketika file PDF ini dibuka menggunakan perintah `cat` di terminal, outputnya sebagian besar berupa karakter acak karena PDF adalah format binary. Namun di bagian akhir output tersebut, tersembunyi sebuah **tautan Git** yang bisa terbaca:

```bash
cat peta-ekspedisi-amba.pdf
```

Output yang relevan dari perintah tersebut:
```
...
%%EOF
https://github.com/pocongcyber77/peta-gunung-kawi.git
```

Tautan inilah yang kemudian digunakan untuk meng-clone repositori berisi data koordinat ekspedisi.

---

### `gsxtrack.json`

File berformat **GeoJSON** yang didapat setelah meng-clone repositori. Berisi data koordinat 4 titik lokasi bekas ekspedisi paman Mas Amba di kawasan Gunung Kawi. Keempat titik membentuk sebuah persegi panjang.

Isi file jika dibuka dengan `cat gsxtrack.json`:

```json
{
  "type": "FeatureCollection",
  "name": "gunung_kawi_spatial_nodes",
  "features": [
    { "id": "node_001", "properties": { "site_name": "Titik Berak Paman Mas Mba", "latitude": -7.920000, "longitude": 112.450000 } },
    { "id": "node_002", "properties": { "site_name": "Basecamp Mas Fuad",         "latitude": -7.920000, "longitude": 112.468100 } },
    { "id": "node_003", "properties": { "site_name": "Gerbang Dimensi Keputih",   "latitude": -7.937960, "longitude": 112.468100 } },
    { "id": "node_004", "properties": { "site_name": "Tembok Ratapan Keputih",    "latitude": -7.937960, "longitude": 112.450000 } }
  ]
}
```

Keempat node membentuk persegi panjang pada peta:

```
node_001 ────────── node_002
   │          ╲          │
   │        [pusaka]      │
   │                      │
node_004 ────────── node_003
```

---

### `parserkoordinat.sh`

Script yang membaca `gsxtrack.json` menggunakan **awk + regex** dan mengekstrak field `id`, `site_name`, `latitude`, `longitude` dari setiap node.

Isi file jika dibuka dengan `cat parserkoordinat.sh`:

```bash
#!/bin/bash
awk '
/"id"/       { gsub(/.*"id": "|",.*/, "", $0); id=$0 }
/"site_name"/ { gsub(/.*"site_name": "|",.*/, "", $0); name=$0 }
/"latitude"/  { gsub(/.*"latitude": |,.*/, "", $0); lat=$0 }
/"longitude"/ && !/coordinates/ { gsub(/.*"longitude": |,.*/, "", $0); lon=$0; print id","name","lat","lon }
' gsxtrack.json > titik-penting.txt

cat titik-penting.txt
```

---

### `titik-penting.txt`

Hasil output dari `parserkoordinat.sh`. Data yang tadinya berantakan dalam format JSON kini menjadi CSV yang bersih dan terstruktur.

Isi file jika dibuka dengan `cat titik-penting.txt`:

```
node_001,Titik Berak Paman Mas Mba,-7.920000,112.450000
node_002,Basecamp Mas Fuad,-7.920000,112.468100
node_003,Gerbang Dimensi Keputih,-7.937960,112.468100
node_004,Tembok Ratapan Keputih,-7.937960,112.450000
```

---

### `nemupusaka.sh`

Script yang menghitung titik pusat persegi panjang menggunakan metode **titik tengah diagonal**. node_001 dan node_003 digunakan karena keduanya adalah titik yang saling berseberangan secara diagonal.

Isi file jika dibuka dengan `cat nemupusaka.sh`:

```bash
#!/bin/bash
lat1=$(awk -F',' 'NR==1{print $3}' titik-penting.txt)
lon1=$(awk -F',' 'NR==1{print $4}' titik-penting.txt)
lat3=$(awk -F',' 'NR==3{print $3}' titik-penting.txt)
lon3=$(awk -F',' 'NR==3{print $4}' titik-penting.txt)

lat_tengah=$(echo "scale=6; ($lat1 + $lat3) / 2" | bc)
lon_tengah=$(echo "scale=6; ($lon1 + $lon3) / 2" | bc)

echo "Koordinat pusat: $lat_tengah, $lon_tengah"
echo "$lat_tengah,$lon_tengah" > posisipusaka.txt
```

Rumus yang digunakan:
```
latitude_pusat  = (-7.920000 + -7.937960) / 2 = -7.928980
longitude_pusat = (112.450000 + 112.468100) / 2 = 112.459050
```

---

### `posisipusaka.txt`

File output akhir yang berisi koordinat lokasi benda pusaka.

Isi file jika dibuka dengan `cat posisipusaka.txt`:

```
-7.928980,112.459050
```

Titik ini berada tepat di pusat keempat node dan diasumsikan sebagai lokasi benda pusaka yang tersembunyi di kawasan Gunung Kawi.

---

## Cara Menjalankan

### 1. Install dependencies
```bash
sudo apt install python3-pip python3-venv git -y
```

### 2. Download file peta
```bash
python3 -m venv myenv
source myenv/bin/activate
pip install gdown

mkdir ekspedisi && cd ekspedisi
gdown "LINK_GDRIVE" -O peta-ekspedisi-amba.pdf
```

### 3. Temukan link tersembunyi di dalam PDF
```bash
cat peta-ekspedisi-amba.pdf
# Link ditemukan: https://github.com/pocongcyber77/peta-gunung-kawi.git
```

### 4. Clone repository
```bash
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
cd peta-gunung-kawi
```

### 5. Parsing data koordinat
```bash
chmod +x parserkoordinat.sh
./parserkoordinat.sh
```

### 6. Hitung lokasi pusaka
```bash
chmod +x nemupusaka.sh
./nemupusaka.sh
```

---

## Output Akhir

```
Koordinat pusat: -7.928980, 112.459050
```

---

## Identitas

| | |
|---|---|
| **Nama** | A. Algifari Rantiga Isdar |
| **NRP** | 5027251112 |
| **Kelas** | C |
| **Mata Kuliah** | Sistem Operasi |
