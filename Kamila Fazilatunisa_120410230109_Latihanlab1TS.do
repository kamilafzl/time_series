//Kamila Fazilatunisa_120410230109_TS LAB 1

*1. Pindahkan working directory dan buatlah macro directory!*
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

*2. Buatlah log file dan gunakan data hardware.dta yang berasal dari web!*
log using "$log/LatihanLab1TS"
webuse hardware.dta
des

*3. Atur satuan waktu dari dataset tersebut!*
tset qdate, quarterly
br

*4. Tampilkan grafik dan analisa data!*
tsline gdp starts unrate misc

*5. Buatlah variabel logaritma dari gdp, starts, unrate, dan misc!*
//karena data terlalu jauh nilainya dan agar satuan data sama maka semua variabel dibuat dalam bentuk logaritma 
gen lgdp=log(gdp)
gen lstart=log(start)
gen lunrate=log(unrate)
gen lmisc=log(misc)

*6. Lakukan deteksi stationeritas terhadap variable gdp, starts, unrate, dan misc!*

*a. Lakukan deteksi menggunakan metode grafis
*1. metode grafis
tsline lgdp lstart lunrate lmisc
//data masih belom stasioner karena masih menunjukkan tren

*b. Lakukan deteksi menggunakan Augmented Dickey-Fuller Test*/
//diferensiasi variabel
tsline d.lgdp d.lstart d.lunrate d.lmisc
//secara kasat mata, data sudah konstan namun perlu ditest kembali menggunakan ADF Test//

*2. ADF TEST
dfuller lgdp
dfuller lstart
dfuller lunrate
dfuller lmisc

//UJI HIPOTESIS//
*Ho: Variabel lgdp lunrate lstart lmisc Mengandung unit root (belum stasioner)
*Ha: Variabel lgdp lunrate lstart lmisc Tidak mengandung unit root (stasioner)

//UJI KRITERIA//
*P. Value < a: Ho ditolak
*P. Value > a: H0 tidak dapat ditolak

//HASIL//
//a = 5% 0.05
*lgdp = 0.2965 > 0.05 H0 tidak dapat ditolak
*lstart = 0.8987 > 0.05 h0 tidak dapat ditolak
*lunrate = 0.8983 > 0.05 h0 tidak dapat ditolak
*lmisc = 0.4057 > 0.05 h0 tidak dapat ditolak
//KESIMPULAN//
*Dengan tingkat signifikansi 5%, variabel lgdp lstart lunrate lmisc belum stasioner di tingkat level, maka harus di turunkan di turunan pertama

dfuller d.lgdp
dfuller d.lstart
dfuller d.lunrate
dfuller d.lmisc
//HASIL//
//a = 5% 0.05
*lgdp = 0.000 < 0.05 H0 ditolak
*lstart = 0.000 < 0.05 h0 ditolak
*lunrate = 0.009 < 0.05 h0 ditolak
*lmisc = 0.000 < 0.05 h0 ditolak

//KESIMPULAN//
*dengan tingkat signifikansi 5%, variabel lgdp, lstart, lunrate, dan lmisc sudah stasioner di turunan pertama.

*7. Buatlah model pengaruh lstarts, lunrate, lmisc, dan satuan waktu terhadap lgdp dan interpretasikan hasil model tersebut!*
reg lgdp lstart lunrate lmisc qdate
//r-squared: variasi variabel dari lstart lunrate lmisc dan satuan waktu qdate mampu menjelaskan variasi variabel lgdp sebesar 99.64% dan sisanya 0.36% di luar model.

//signifikan 1% => dilihat dari p-value 0.000 < alpha 1%/5%/10%

//lstart= model ini memprediksi setiap peningkatan jumlah proyak konstruksi perumahan baru 1% di kuartalnya, maka akan meningkatkan GDP di amerika serikat sebesar 0,032% dan signifikan pada 1%, cateris paribus.

//signifikan 1% => dilihat dari p-value 0.000 < alpha 1%/5%/10%

//lunrate= Model ini memprediksi setiap peningkatan pengangguran 1% di kuartalnya, maka akan menurunkan GDP di amerika serikat sebesar 0.075% dan signifikan pada 1%, cateris paribus.

//signifikan 1% => dilihat dari p-value 0.000 < alpha 1%/5%/10%

//lmisc= Model ini memprediksi setiap peningkatan penjualan berbagai perangkat 1% di kuartalnya, maka akan menurunkan GDP di amerika serikat sebesar 0.049% dan signifikan pada 1%, cateris paribus.

//signifikan 1% => dilihat dari p-value 0.000 < alpha 1%/5%/10%

//qdate= model ini memprediksi setiap 1 kuartal, maka akan meningkatkan GDP di amerika serikat sebesa 0.006% dan signifikan pada 1%, cateris paribus

//cons= tanpa dipengaruhi variabel apapun nilai variabel logaritma gdp sebesar 7.85%

//8. Apakah di dalam model terdapat autokorelasi? Buktikan dengan menguji modeltersebut pada signifikansi 5%!
//a. Lakukan uji menggunakan Durbin Watson Test//
*df= variabel independen + 1=> 3 + 1 = 4
*n= 91
*a= 5%

DL= 1.5452 DU= 1.7763
*4-DU= 2.4548
di 4 - 1.5452
*4-DL = 2.2237
di 4 - 1.7763*

estat dwatson 
*df= variabel independen + 1
*nilai dwatson = 0.4363384
*d.watson < dL -> 0,4363384 < 1.5452 -> ADA AUTOKORELASI POSITIF
b. Lakukan uji menggunakan Breusch-Godfrey Test*/
// uji hipotesis, kriteria di posttest

//Hasil= 0.000 < 0.50 h0 ditolak
//kesimpulan: dengan tingkat signifikansi 5% di dalam model terdapat masalah autokorelasi

//9. Jika ada kemungkinan autokorelasi, lakukan perbaikan model dan uji ulang hingga model tidak memiliki autokorelasi!//
//a. Menggunakan variabel yang sudah diturunkan ke tingkat ke-1 (tanpa variabel waktu)//
reg d.lgdp d.lstart d.lunrate d.lmisc

//DURBIN WATSON//
estat dwatson
df = 4
n = 90
//nilai dwatson = 1.841204//

DL = 1.5656
DU = 1.7508
4- DL = 2.4344
di 4-1.5656
4-DU= 2.2492
di 4-1.7508

//KESIMPULAN : dengan tingkat signifikansi 5% dapat disimpulkan bahwa tidka terdapat autokorelasi di dalam model, dengan seluruh variabel berada di turunan pertama

//UJI BEURSCH GODFREY
estat bgodfrey

*tulis uji hipotesis dan kriteria di posttest
//hasil= 0.4738 > 0.05, h0 tidak dapat ditolak
//kesmpulan: dengan tingkat signifikansi 5%, dapat disimpulkan bahwa model tidak terdapat masalah autokorelasi dengan seluruh variabel berada di turunan pertama

//b. Menggunakan variabel yang sudah diturunkan ke tingkat ke-1 (dengan variabel waktu)//
reg d.lgdp d.lstart d.lunrate d.lmisc qdate

//DURBIN WATSON//
estat dwatson
*df= 5
*n=90
*bilai dwatson = 1.909451

DL= 1.5420
DU= 1.7758
4- DL = 2.458
di 4-1.5420
4- DU= 2.2242
di 4.17758

*dU<d.watson < 4-dU -> 1.7758 <1.909451 <2.2242 -> TIDAK ADA AUTOKORELASI
//kesimpulan : dengan tingkat signifikansi 5%, dapat disimpulkan bahwa tidak terdapat autokorelasi di dalam model, dengan seluruh variabel berada di turunan pertama

//UJI BEURSCH GODFREY//
estat bgodfrey

*tulis uji hipotesis dan kriteria di posttest
//hasil= 0.6695 > 0.05, h0 tidak dapat ditolak
//kesimpulan: dengan tingkat signifikansi 5%, dapat disimpulkan bahwa model tidak terdapat masalah autokorelasi dengan seluruh variabel berada diturunan pertama

*10. Simpan data dan tutup log file!*
save "$output/LatihanLab1TS"
log close