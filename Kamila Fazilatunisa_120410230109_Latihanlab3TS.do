//Kamila Fazilatunisa_120410230109_LAB3TS
*1. Buatlah logfile sebelum memulai project STATA-mu! (0%).
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

*2. Masukkan data m1 yang sudah didownload, buat variabel waktu time-seriesnya dari quarter pertama tahun 1980 dan set waktu time-seriesnya! (5%).
log using "$log/LatihanLab3TS"
use "$data/m1.dta"
gen time=tq(1980q1)+_n-1
format time %tq
tsset time, q

*3. Lakukan pengecekan stasioneritas pada variabel m1 dengan tingkat signifikansi 5% (5%).
tsline m1
//mengandung trend, belum stasioner
*ADF TEST*
dfuller m1
dfuller d.m1

*PPERRON TEST*
pperron m1
pperron d.m1

//kesimpulan : dengan tingkat signifikansi 5%, variabel m1 stasioner di turunan pertama

/*a. Hipotesis: 
Ho: (variabel m1 tidak stasioner) 
Ha: (variabel m1 stasioner) 

b. Uji kriteria: 
α=0.05=5% 
Mc.Kinnon P-value > α = Ho tidak dapat ditolak 
Mc.Kinnon P-value < α = Ho ditolak 

c. Hasil: 
Untuk variabel m1, Nilai probabilitas Mc.Kinnon > α (0.9991 > 0.05) di tingkat level sehingga Ho tidak dapat ditolak. 
Untuk variabel m1, Nilai probabilitas Mc.Kinnon < α (0.0000 < 0.05) di turunan pertama sehingga Ho ditolak. 

d. Kesimpulan: 
Dengan signifikansi 5%, variabel m1 stasioner pada turunan pertama.
*/

*4. akukan pengecekan dengan correlogram variabel m1 di turunan pertama (mempertimbangkan asumsi stasioneritas) untuk menentukan model dan ordo yang mungkin dapat dipakai! (15%)
corrgram d.m1
// AC = Dies Down
// PACF = Cut Off
// kemungkinan model yang dapat dipakai adalah AR dan ARMA

ac d.m1
// Model yang dipakai di MA adalah lag 1 

pac d.m1
// Model yang dipakai di AR adalah lag 1

//Kesimpulan : Model yang dapat digunakan adalah AR(1), ARMA(1,1)

*5. Tuliskan Hipotesis dan Uji kriteria pada uji stasioner Augmented Dickey Fuller (ADF) test terhadap residual dan Uji White Noise! (5%)

/* STASIONERITAS
Hipotesis: 
Ho : residual tidak stasioner 
Ha : residual stasioner 
Kriteria: 
Nilai probabilitas Mc.Kinnon < α (H0 ditolak)
Nilai probabilitas Mc.Kinnon > α (H0 tidak dapat ditolak) 
Hasil:
Variabel (....) > alpha (0,05) sehingga H0 tidak dapat ditolak (variabel tidak stationer)
Variabel (....) < alpha (0,05) sehingga H0 ditolak (variabel stationer)

 Kesimpulan : 
Dengan tingkat Signifikansi sebesar (1%,5%,10%) dapat disimpulkan bahwa  residual model (.......) (stationer/ tidak stationer) 
*/	

/*		White Noise
Hipotesis: 
Ho : residu model white noise
Ha : residu model tidak white noise
Kriteria : 
P-value < α = Ho ditolak (tidak white noise)
P-value > α = Ho tidak dapat ditolak (white noise)
Kesimpulan:
Ho ditolak -> Residual model (…) belum whitenoise.
Ho tidak dapat ditolak -> Residual model persamaan (…) sudah whitenoise.
*/

*6. Lakukan regresi dari model AR, MA dan ARMA di turunan pertama. Coba model yang tidak menggunakan konstanta sehingga kamu punya 4 model. Jangan lupa untuk uji deteksi stasioner untuk residual, melakukan uji asumsi whitenoise, dan catat hasil AIC, BIC, dan LLnya (ex: model yang kamu estimasi pertama adalah AR sehingga model tersebut yang dijadikan pilihan tanpa konstanta sebagai model ke-4). (20%). 

*AR(1)*
arima m1, arima(1,1,0) nolog
atoga
arima d.m1, arima(1,0,0) nolog

predict ar1, r
dfuller ar1
//hasil = 0.000 < 5%(0.05). artinya H0 ditolak model residual ar1 sudah stasioner
wntestq ar1
//hasil 0.0295 < 0.05, artinya H0 ditolak, residu model AR(1) tidak white noise

estat ic
/*AR(1)
AIC = 1032.107
BIC = 1041.295
LL = -513.0536
*/

*MA(1)*
arima m1, arima(0,1,1) nolog

predict ma1, r
dfuller m1
//hasil = 0.000 < 5%(0.05). artinya HO ditolak, dengan tingkat signifikansi 5% model residual MA(1) sudah stasioneritas
wntestq ma1
//hasil 0.0000 < 0.05, artinya H0 ditolak, dengan tingkat signifikansi % residu model MA(1) tidak white noise

estat ic
/*AR(1)
AIC = 1081.011
BIC = 1090.199
LL = -537.0536
*/

*ARMA(1,1)
arima m1, arima(1,1,1) nolog
atau
arima d.m1, arima (1,0,1) nolog

predict arma, r
dfuller arma
//hasil = 0.000 < 5%(0.05). artinya H0 ditolak dengan tingkat signifikansi 5% model residual ARMA(1,1) sudah stasioner
wntestq arma
//hasil 0.0976 > 0.05, artinya H0 ditolak, dengan tingkat signifikansi 5% residu model ARMA(1) sudah white noise

estat ic
/*ARMA(1,1)
AIC = 1022.099
BIC = 1034.259
LL = -507.0043
*/
 **AR(1) TANPA CONSTANTA**
arima m1, arima(1,1,0) nocons
*atau*
arima d.m1, arima (1,1,0) nocons

predict arnc, r
dfuller arnc
//hasil : 0.000 < 5%(0.05). artinya H0 ditolak, dengan tingkat signifikansi 5% model residual AR(1) NO CONSTANTA sudah stasioneritas
wntestq arnc
//hasil 0.0086 < 0.05, artinya H0 ditolak, dengan tingkat signifikansi 5% residu model AR(1) NO CONSTANTA belum white noise atau belum menggambarkan keadaan data sebenarnya

estat ic
/*ARMA(1,1)
AIC = 1036.93
BIC = 1043.055
LL = -516.465
*/

*7. Identifikasi satu model yang terbaik untuk dipergunakan memprediksi nilai m1 dari antara 4 kemungkinan model tersebut! (15%).
//Kesimpulan : Model terbaik ialah model ARMA (1,0,1) karena sudah memenuhi 3 dari 3 kriteria dimana model ini memiliki AIC BIC terkecil dan LL terbesar dan residu model ARIMA(1,1,1) sudah white noise atau sudah menggambarkan keadaan data sebenarnya.

*8. Setelah mendapatkan model terbaik, lakukan prediksi 1 kuartal dan 5 kuartal kedepan (statis dan dinamis) dan gambarkan grafiknya! (20%)
//Forecast Statis//
arima m1, arima(1,1,1) nolog
br

tsappend, last(2020q4) tsfmt(tq)

predict x, xb
predict statis, y
br
tsline statis m1

//forecast dinamis//
predict dinamis, dyn(tq(2019q3)) y
br
tsline dinamis m1
drop x statis (bukan disini deh)

*9. Lakukan uji Theil's U Stat untuk melihat apakah model sudah bisa memprediksi dengan baik! (10%).
ssc install fcstats
fcstats m1 statis
//lebih baik dibandingkan peramalan ..
fcstats m1 dinamis
/* Hipotesis : 
Ho : model peramalan ARIMA(1,1,1) kurang akurat dibandingkan peramalan naif 
Ha : model peramalan ARIMA(1,1,1) lebih akurat dibandingkan peramalan naif 

Uji Kriteria: 
Theils's u stat < 1 : Ho ditolak 
Theil's u stat ≥ 1 : Ho diterima 
Hasil : 0.55686177 < 1 Ho ditolak 

Kesimpulan : 
Model peramalan ARMA (1,1,1) pada variabel m1 lebih akurat dibandingkan peramalan naif.
*/

*10. Tutup log file dan simpan output beserta dofilenya! (0%)
save "$output/kamila_latihanlab3_ts"