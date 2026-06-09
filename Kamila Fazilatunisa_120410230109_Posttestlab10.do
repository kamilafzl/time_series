///Kamila Fazilatunisa_120410230109_Post Test Lab 10///

cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

log using "$log/PosttestLab10TS"


//1. Masukan data posttestardl.dta dalam praktikum ini (0%)
use "$data/posttestardl.dta"
br

//2. Set waktu bulanan, dan buatlah bentuk logaritma untuk variabel m1 dan m2 ! (5%)
* Set Waktu Bulanan
format date %tm
tsset date, monthly

* Logaritma Variabel m1 dan m2
gen lm1 = ln(m1)
gen lm2 = ln(m2)


//3. Cek stationeritas pada variabel inf, m1, dan m2 (10%)
dfuller inf
dfuller lm1
dfuller lm2

/* Hipotesis :
Ho: Variabel  mengandung Unit Root(belum stasioner)
Ha: Variabel Tidak Mengandung Unit Root (stasioner)

Uji Kriteria :
P. Value < α: Ho ditolak
P. Value > α: Ho tidak dapat ditolak

Hasil :
inf = 0.0000 // sudah stasioner
lm1 = 0.7868 // belum stasioner 
lm2 = 0.3639 // belum stasioner

Kesimpulan : 
Maka, dengan tingkat signifikasi 5% di tingkat level variabel inf sudah stasioner di tingkat level, sedangkan variabel lm1 dan lm2 belum stationer di tingkat level. */

dfuller d.lm1
dfuller d.lm2

/* Hipotesis :
Ho: Variabel  mengandung Unit Root(belum stasioner)
Ha: Variabel Tidak Mengandung Unit Root (stasioner)

Uji Kriteria :
P. Value < α: Ho ditolak
P. Value > α: Ho tidak dapat ditolak

Hasil :
lm1 = 0.0000
lm2 = 0.0000

Kesimpulan : 
Maka dengan tingkat signifikasi 5% variabel lm1 dan lm2 sudah stationer di turunan pertama. */

//4. Identifikasi lag optimal sampai lag 10 (15%)
ssc install ardl
ardl inf lm1 lm2, aic
matrix list e(lags)
* Lag optimum yang dapat digunakan untuk semua variabel adalah (2 2 4)

//5. Lakukan Regresi ARDL dengan menggunakan lag optimal kemudian cek kointegrasi (Bounds test) untuk melihat kointegrasi jangka panjang (15%)
ardl inf lm1 lm2, lags(2 2 4) ec
estat btest

/* Hipotesis :
Ho: Variabel  Tidak Terdapat Kointegrasi
Ha: Variabel Terdapat Kointegrasi

Uji Kriteria :
F Stat > Crit-Value : Ho dapat ditolak
F Stat < Crit-Value : Ho tidak dapat ditolak

Hasil :
22.712 > 4.85 -> F Stat > Crit-Value maka, Ho dapat ditolak

Kesimpulan : 
Dengan tingkat signifikansi 5%, dapat dilihat bahwa F Stat > Crit-Value (upper bound) -> 22.17 > 4.85 maka H0 dapat ditolak, Artinya terdapat kointegrasi di dalam model. */

//6. Lakukan pengujian stabilitas pada model yang telah dibangun untuk melihat apakah model sudah stabil (15%)
ssc install cusum9
cusum9 l(1/2).inf l(1/2).lm1 l(1/4). lm2 

* Dilihat dari grafik, model belum stabil karena garis biru keluar dari batas atas dan batas bawah

//7. Simpan output dengan outreg dalam bentuk .doc dan lakukan estimasi model pada untuk melihat hubungan jangka pendek, jangka panjang dan kecepatan perubahan diequilibrium di jangka pendek (20%)
ardl inf lm1 lm2, lags (2 2 4) ec
ssc install outreg2
outreg2 using hasil_posttestlab10.doc, word
/* ECT (cpi inf) = -0.765 -> signifikan dan negatif, sudah sesuai dengan syarat ECT yang artinya terdapat hubungan jangka panjang yang valid meskipun secara individual terdapat variabel yang belum signifikan.

Interpretasi ECT = Model akan menuju keseimbangan dengan kecepatan sekitar 23% (0.229 x 100%) setiap kuartal, proses kovergensi atau penysuaian penuh ke tingkat keseimbangan (equilibrium) memakan waktu sekitar 4.34 kuartal/390 hari untuk mencapai penyesuaian 100%. */

di 1/0.229

//8. Lakukan pengujian Normalitas, multikoleniaritas, Heteroskedastisitas dan Autokorelasi pada model (15%)
Uji Multikolineritas (Uji VIF Variance Inflation Factor)
ardl inf lm1 lm2, lags (2 2 4) ec
estat vif
* Notes : Batas kriteria 5 itu kalau R-Square < 80%, kalau batas kriteria 10 R-Square > 80%
/* Hipotesis :
Ho: Variabel Tidak Terdapat Multikolineritas
Ha: Variabel Terdapat Multikolineritas
Uji Kriteria :
VIF > a : Ho dapat ditolak
VIF < a : Ho tidak dapat ditolak
Hasil :
VIF > 5 = 11.08 > 0.05 -> H0 tidak dapat ditolak.
Kesimpulan :
Dengan tingkat signifikansi 5%, dapat dilihat bahwa VIF > 5 = 11.08 > 0.05 maka H0 tidak dapat ditolak, Artinya tidak terdapat multikolineritas pada model ini. */
*** Uji Heteroskedastisitas
estat imtest, white
/* Hipotesis :
Ho: Variabel Tidak Terdapat Masalah Heteroskedastisitas
Ha: Variabel Terdapat Masalah Heteroskedastisitas
Uji Kriteria :
Prob Chi2 > a : Ho dapat ditolak
Prob Chi2 < a : Ho tidak dapat ditolak
Hasil :
Prob Chi2 > a = 0.0636 > 0.05 -> H0 tidak dapat ditolak
Kesimpulan :
Dengan tingkat signifikansi 5%, dapat dilihat bahwa Prob Chi2 > a = 0.0636 > 0.05 -> H0 tidak dapat ditolak, Artinya tidak terdapat masalah heteroskedastisitas. */
*** Uji Autokorelasi (Beursh Godfrey)
estat bgodfrey
/* Hipotesis :
Ho: Variabel Tidak Terdapat Masalah Autokorelasi
Ha: Variabel Terdapat Masalah Autokorelasi
Uji Kriteria :
Prob Chi2 > a : Ho dapat ditolak
Prob Chi2 < a : Ho tidak dapat ditolak
Hasil :
Prob Chi2 > a = 0.7932 > 0.05 -> H0 tidak dapat ditolak
Kesimpulan :
Dengan tingkat signifikansi 5%, dapat dilihat bahwa Prob Chi2 > a = 0.7932 > 0.05 -> H0 tidak dapat ditolak, Artinya tidak terdapat masalah autokorelasi. */
*** Uji Normalitas tidak dilakukan karena lebih dari > 40 yaitu 92

//9. Simpan hasil dan log close!
save "$output\posttestlab10"
log close