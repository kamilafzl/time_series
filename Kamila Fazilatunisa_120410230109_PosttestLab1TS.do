//Kamila Fazilatunisa_120410230109_PosttestLab1

*1. Pindahkan working directory, buat macro directory, dan pasang log sebelum pengerjaan praktikum dimulai! (5%)*
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

*2. Input data makroekonomi Indonesia (macrovariables.dta)! (5%)*
log using "$log/PostTestLab1TS"
use "$data/macrovariables.dta"
des

*3. Set waktu yang menandakan data time series! (5%) 
tsset t, monthly
sum

*4. Lakukan uji stasioneritas untuk variabel tingkat inflasi, suku bunga BI, nilai kurs, jumlah uang beredar di Indonesia dengan*
*(a) grafik dan jelaskan!*
tsline inf birate lnkurs lnjub
//Grafik menunjukan bahwa variabel dari log of exchange rate, BI rate, dan log of JUB belum stasioner karena dari grafik tersbeut menunjukkan belum konstan dan masih bersifat trend sedangkan pada variabel tingkat inflasi menunjukan data sudah stasioner atau konstan.

*(b) Augmented Dickey-Fuller Test dan tuliskan hipotesis uji tersebut pada tingkat signifikansi 5%! (20%)*
tsline d.inf d.birate d.lnkurs d.lnjub

//ADF TEST
dfuller inf
dfuller birate
dfuller lnkurs
dfuller lnjub

//Uji Hipotesis//
*H0 : Variabel inf birate lnkurs lnjub mengandung unit root (belum stasioner)
*Ha : Variabel inf birate lnkurs lnjub tidak mengandung unit root (stasioner)

//Uji Kriteria//
*P. Value < a: H0 ditolak
*P. Value > a: H0 tidak dapat ditolak

//Hasil//
//a = 5% 0.05
*inf = 0.0000 < 0.05 H0 dapat ditolak
*birate = 0.6148 > 0.05 H0 tidak dapat ditolak
*lnkurs = 0.8857 > 0.05 H0 tidak dapat ditolak
*lnjub = 0.1508 > 0.05 H0 tidak dapat ditolak

//Kesimpulan//
*Dengan tingkat signifikansi 5%, variabel inf sudah stasioner, sedangkan variabel birate lnkurs lnjub belum stasioner di tingkat level, maka harus di turunkan di turunan pertama

dfuller d.birate
dfuller d.lnkurs
dfuller d.lnjub

//Hasil//
//a = 5% 0.05
*birate = 0.0000 < 0.05 H0 dapat ditolak
*lnkurs = 0.009 < 0.05 H0 dapat ditolak
*lnjub = 0.0000< 0.05 H0 dapat ditolak

//Kesimpulan//
*Dengan tingkat signifikansi 5%, variabel inf, birate, lnkurs, dan lnjub sudah stasioner di turunan pertama 

*5. Lakukan regresi pengaruh tingkat suku bunga BI, nilai tukar rupiah, dan jumlah uang beredar terhadap tingkat inflasi di Indonesia! Tuliskan juga formal reportnya dan intepretasikan variabel suku bunga, nilai tukar, dan R2 saja! (25%)*
reg inf birate lnkurs lnjub

*Birate : model ini memprediksi setiap peningkatan jumlah suku bunga BI 1% di tiap bulannya, maka akan menambah inflasi sebesar 0,06%, ceteris paribus
*lnkurs : model ini memprediksi setiap peningkatan nilai kurs sebesar nilai tukar rupiah 1% di tiap bulannya, maka akan menurunkan inflasi sebesar 0,8%, ceteris paribus
*R-Square : variasi dari variabel birate, lnkurs, dan lnjub mampu menjelaskan variasi dari variabel inf sebesar 5,25% dan sisanya 94,75% dijelaskan oleh variabel lain diluar model

*6. Apakah di dalam model terdapat masalah autokorelasi? Lakukan pengujian menggunakan kedua metode (Durbin-Watson Dan Breusch Godfrey) dengan signifikansi 5% untuk membuktikannya! (20%)*
//DURBIN WATSON//
estat dwatson
df = 4
n = 145
//nilai dwatson = 1.288464//
DL = 1.6724
DU = 1.7856
4- DL = 2.3276
di 4-1.6724
4-DU = 2.2144
di 4-1.7856
//Dw < 4-DU = 1.288464 < 2.2144 maka, terdapat autokorelasi

//KESIMPULAN : dengan tingkat signifikansi 5% dapat disimpulkan bahwa terdapat autokorelasi positif di dalam model, dengan seluruh variabel yang berada ditingkat level

//Breusch bgodfrey//

estat bgodfrey
*chi square = 18.156
*DF = 1
* Prob > Chi2 : 0.0000

//Hipotesis//
*H0 : di dalam model tidak terdapat masalah autokorelasi
*Ha : di dalam model terdapat masalah autokorelasi

// uji kriteria //
*Nilai probabilitas x2 < a (H0 ditolak)
*Nilai probabilitas x2 > a (H0 tidak dapat ditolak)
*0.000 < 0.05, maka H0 ditolak

//Kesimpulan : dengan tingkat signifikansi 5%, dapat disimpulkan bahwa terdapat masalah autokorelasi dalam model

*7. Jika terdapat masalah autokorelasi, lakukan perbaikan untuk model menggunakan metode Transformasi Model Turunan Pertama dengan penambahan variabel waktu (dalam satu model yang sama)! Tuliskan pengujian hipotesis dan hasil pengujian otokolerasi pada metode tersebut! (Metode DW test & BG test)! (20%)
reg d.inf d.birate d.lnkurs d.lnjub t

//DURBIN WATSON//

estat dwatson
df = 5
n = 144
//nilai dwatson = 2.054312//
DL = 1.6565
DU = 1.8000
4- DL = 2.3435
di 4-1.6565
4-DU=2.2
di 4-1.800
/*DU < Dw < 4-DU
1.8000 < 2.054312 < 2.2 maka, tidak ada autokorelasi*/

//kesimpulan : dengan tingkat signifikansi 5%, dapat disimpulkan bahwa tidak terdapat autokorelasi di dalam model, dengan seluruh variabel berada di turunan pertama

// BREUSCH GODFREY

estat bgodfrey
*Chi Square : 0.135
*Df : 1
* Prob > Chi2 : 0.7133

//Hipotesis//
*H0 : di dalam model tidak terdapat masalah autokorelasi
*Ha : di dalam model terdapat masalah autokorelasi

//Uji Kriteria//
*Nilai probabilitas x2 < a (H0 ditolak)
*Nilai probabilitas x2 > a (H0 tidak dapat ditolak)
*0.7133 > 0.05, maka h0 tidak dapat ditolak

//kesimpulan : dengan tingkat signifikansi 5%, dapat disimpulkan bahwa tidak terdapat masalah autokorelasi dalam model

*8. Tutup logfile! (0%)
save "$output/PosttestLab1TS"
log close