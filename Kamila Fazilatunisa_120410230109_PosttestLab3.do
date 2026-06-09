//Kamila Fazilatunisa_120410230109_LAB 3 TS// 

*1. Buatlah logfile sebelum memulai project STATA-mu! (0%).
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"
log using "$log/PostTestLab3"

*2. Masukkan data money supply (m2.dta) yang telah di download dan buat variabel waktu quarterly dari 1959 q1, serta set waktu time-seriesnya! (5%)
use "$data\m2.dta"	
desc
br
gen time=tq(1959q1)+_n-1
format time %tq
tsset time

*3. Cek stasioneritasnya dengan menggunakan grafik dan ADF-test! (5%)
tsline m2
dfuller m2
	
/*HIPOTESIS
Ho: Variabel price. Mengandung Unit Root (belum stasioner)
Ha: Variabel price. Tidak Mengandung Unit Root (stasioner)
	
KRITERIA
P. Value < α: Ho ditolak
P. Value > α: Ho tidak dapat ditolak
	
HASIL
1.0000 > 0.05 : Ho tidak dapat ditolak 
	
Dengan tingkat signifikansi 5%, dapat disimpulkan bahwa variabel m2 belum stasioner di tingkat level.*/

dfuller d.m2
	
/*HIPOTESIS
Ho: Variabel price. Mengandung Unit Root (belum stasioner)
Ha: Variabel price. Tidak Mengandung Unit Root (stasioner)
	
KRITERIA
P. Value < α: Ho ditolak
P. Value > α: Ho tidak dapat ditolak
	
HASIL
0.0001 < 0.05 : Ho ditolak 
	
Dengan tingkat signifikansi 5%, dapat disimpulkan bahwa variabel m2 sudah stasioner di turunan pertama.*/

*4. Lakukan pengecekan menggunakan korelogram dengan mempertimbangkan asumsi stasioneritas untuk menentukan model dan ordo yang mungkin dapat dipakai! (15%)
corrgram d.m2
	
/* ACF : dies down
PAC : cut off
Dapat diasumsikan model AR dan ARMA */
	   
ac d.m2 // lag 1
pac d.m2 // lag 1
	 
// Jadi dapat menggunakan AR (1) dan ARMA (1)

*5. Lakukan regresi dari model AR, MA dan ARMA di turunan pertama. Coba model yang tidak menggunakan konstanta sehingga kamu punya 4 model (ex: model yang kamu estimasi pertama adalah AR sehingga model tersebut yang dijadikan pilihan tanpa konstanta sebagai model ke-4). Jangan lupa untuk uji stasioneritas pada residual, mencatatat hasil AIC, BIC, dan LLnya, dan mengecek asumsi whitenoise! Serta tulis juga persamaan dari model-model tersebut! (20%)
// MODEL AR
arima m2, arima (1,1,0)
predict ar1, resid
dfuller ar1 
//hasil = 0.0000 < 5% (0.05), artinya H0 ditolak dengan tingkat signifikansi 5% model residual AR (1) sudah stasioner
wntestq	ar1 
//hasil = 0.0169 < 0.05, artinya H0 ditolak dengan tingkat signifikansi 5% residu model AR (1) tidak white noise

estat ic
/* AIC : 1313.441
BIC : 1322.629
LL  :-653.7205   */
	   
// MODEL MA
arima m2, arima (0,1,1)
predict ma1, resid
dfuller ma1 
//hasil = 0.0000 < 5% (0.05), artinya H0 ditolak, dengan tingkat signifikansi 5% model residual MA(1) sudah stasioner
wntestq	ma1
//hasil = 0.0000 < 5% (0.05), artinya H0 ditolak, dengan tingkat signifikansi 5% model MA(1) tidak white noise
	
estat ic
/* AIC : 1352.986 
BIC : 1362.174
LL  :-673.493    */
	   
// MODEL ARMA
arima m2, arima (1,1,1)
predict arma1, resid
dfuller arma1
//hasil = 0.0000 < 5% (0.05), artinya H0 ditolak, dengan tingkat signifikansi 5% model residual ARMA(1,1) sudah stasioner
wntestq	arma1 
//hasil = 0.3899 > 5% (0.05), artinya H0 tidak dapat ditolak, dengan tingkat signifikansi 5% residu model ARMA(1,1) sudah white noise, sudah menggambarkan keadaan dasar sebenarnya
	
estat ic
/* AIC : 1293.46  
BIC : 1305.71
LL  :-642.7298   */
	   
// MODEL TANPA KONSTANTA
arima m2, arima (1,1,0) nocons
predict arc1, resid
dfuller arc1 // sudah stasioner
wntestq	arc1 // belum white noise
	
estat ic
/* AIC : 1326.63 
BIC : 1332.755
LL  :-661.315   */

*6. Pilih satu model yang terbaik untuk dipergunakan memprediksi jumlah uang beredar (m2) dari antara kemungkinan model tersebut! (5%)
// MODEL AR
/* AIC : 1313.441
BIC : 1322.629
LL  :-653.7205   */
	   
// MODEL MA
/* AIC : 1352.986 
BIC : 1362.174
LL  :-673.493    */
	   
// MODEL ARMA
/* AIC : 1293.46  
BIC : 1305.71
LL  :-642.7298   */
	   
// MODEL TANPA KONSTANTA
/* AIC : 1326.63 
BIC : 1332.755
LL  :-661.315   */
	   
// Model terbaik adalah model ARMA karena residualnya sudah white noise, serta memiliki nilai AIC dan BIC relatif paling kecil dan LL terbesar dibanding model lain 

*7. Setelah mendapatkan model terbaik, kamu bersiap melakukan prediksi yang sifatnya statis (1 kuartal) dan dinamis (6 kuartal) dan gambarkan grafiknya! (20%)
// MODEL ARMA
/* AIC : 1293.46  
BIC : 1305.71
LL  :-642.7298   */
	   
arima m2, arima (1,1,1)
*1998q3 > 1998q4 > 1999q1 > 1999q2 > 1999q3 > 1999q4 > 2000q1
tsappend,last(2000q1) tsfmt(q)
arima m2, arima (1,1,1)
	  
//statis
predict x,xb
predict statis, y
tsline statis m2
	  
//dinamis
predict dinamis, dyn(tq(1998q3))y
tsline dinamis m2

*8. Lakukan uji Theil's U Stat untuk melihat apakah model sudah bisa memprediksi dengan baik! (10%)
ssc install fcstats
fcstats m2 statis
fcstats m2 dinamis
/* 
Hipotesis 
H0 : Model peramalan ARIMA (1,1) kurang akurat dibandingkan peramalan naif
Ha : Model peramalan ARIMA (1,1)lebih akurat dibandingkan peramalan naif
	   
Uji Kriteria
Theil's U Stat < 1 -> H0 ditolak
Theil's U Stat >= 1 -> H0 tidak dapat ditolak
	
Hasil 
0.52761135 < 1 : H0 ditolak
	
Kesimpulan
Model peramalan ARIMA (1,1) pada turunan pertama di variabel m2 lebih akurat dibandingkan peramalan naif.*/		

*9. Tutup log-file dan simpan output! (0%)
save "$output/Kamila Fazilatunisa_120410230109_PostTestLab3TS"
log close
