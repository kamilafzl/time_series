s//Kamila Fazilatunisa_120410230109_PostTestLab2TS

*1. Pindahkan terlebih dahulu working directory ke folder yang biasa kalian gunakan dan buat macro directory untuk data, log-file dan juga output. Lalu, pasang Log dan buka data pdb.dta. (10%)
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

log using "$log/PostTestLab2TS"
use "$data\pdb.dta"
br

*2. Atur satuan waktu kuartal di stata! (5%)
tsset time, quarterly

*3. Buatlah variabel logaritma dari PDB! (5%)
gen lpdb=log(pdb)

*4. Apakah variabel lpdb mengandung trend? (5%)
tsline lpdb
*grafik dalam gambar tersebut sudah mengandung trend, tetapi belum stasioner

*5. Uji stasioneritas pada variabel lpdb. (5%)
dfuller lpdb
//uji stasioner//
/*hipotesis :
H0 : di dalam model terdapat unit root (belum stasioner)
Ha : di dalam model tidak terdapat unit root (stasioner)

Uji Kriteria :
*P. Value < a: H0 ditolak
*P. Value > a: H0 tidak dapat ditolak

Hasil :
*a = 5% 0.05
*p-value = 0.5679
*0.5679 > 0.05, maka H0 tidak dapat ditolak

Kesimpulan : 
dengan tingkat signifikansi 5%, maka dapat disimpulkan bahwa variabel lpdb terdapat unit root atau belum stasioner di tingkat level*/

dfuller d.lpdb
//Uji Stasioner//
/*Hipotesis :
*H0: Di dalam model terdapat unit root (belum stasioner)
*Ha: Di dalam model tidak terdapat unit root (stasioner)

Uji Kriteria :
*P. Value < a: H0 ditolak
*P. Value > a: H0 tidak dapat ditolak

Hasil :
*a = 5% 0.05
*p-value = 0.0000
*0.000 < 0.05, maka H0 dapat ditolak

Kesimpulan : 
dengan tingkat signifikansi 5%, maka dapat disimpulkan bahwa variabel lpdb tidak terdapat unit root atau sudah stasioner di turunan pertama*/

*6. Lakukan estimasi regresi dengan model AR(4) pada variabel lpdb. Tulis bentuk persamaannya, kemudian berikan interpretasi hasilnya. (Hint: gunakan diferensiasi pertama, d=1, dan cukup interpretasikan koefisien pada lag ke-4). (10%)
arima lpdb, arima(4,1,0) nolog

/* Interpretasi
μ = Tanpa adanya perubahan pada variable-variable lain dalam model, peningkatan PDB di bulan Juli tahun 2008 sampai bulan Desember tahun 2024 adalah rata-rata sebesar 0.0224236 per quarternya.

γY_(t−1) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−1), maka akan meningkatkan pertumbuhan PDB saat ini sebesar 0.0330007, ceteris paribus.

γY_(t−2) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−2), maka akan menurunkan pertumbuhan PDB saat ini sebesar 0.1709866, ceteris paribus.

γY_(t−3) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−3), maka akan menurunkan pertumbuhan PDB saat ini sebesar 0.0475885, ceteris paribus.

γY_(t−4) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−4), maka akan meningkatkan pertumbuhan PDB saat ini sebesar 0.462662, ceteris paribus.*/

*7. Berdasarkan asumsi white noise, lakukan pengecekan stasioneritas pada residu hasil regresi di atas! (5%)
predict ar4, resid
tsline ar4
*tidak mengandung trend 
dfuller ar4
*sudah stasioner di tingkat signifikansi 5%

//Uji Stasioner pada residu//
/*Hipotesis :
*H0 : di dalam residu AR(4) terdapat akar unit atau nilai residu sudah stasioner
*Ha : di dalam residu AR(4) tidak terdapat akar unit atau nilai residu sudah stasioner

Uji Kriteria :
*P. Value < a: H0 ditolak
*P.Value > a: H0 tidak dapat ditolak

Hasil :
*a = 5% 0.05
*p-value = 0.000
*0.0000 < 0.05, maka H0 dapat ditolak

kesimpulan :
*Dengan tingkat signifikansi 5%, maka dapat disimpulkan bahwa di dalam residu AR(4) tidak terdapat akar unit atau nilai residu sudah stasioner di tingkat level.*/

//Uji White Noise//
wntestq ar4
/*Hipotesis:
H0 : residu AR(4) di tingkat level white noise
Ha : residu AR(4) di tingkat level tidak white noise

kriteria :
p-value < α 🡪 Ho ditolak 🡪 residu AR(4) di tingkat level tidak white noise
p-value > α 🡪 Ho tidak dapat ditolak 🡪 residu AR(4) di tingkat level white noise

Hasil:
p-value > α 🡪 0.4692 > 0.05, 🡪 Ho Tidak Dapat Ditolak

Kesimpulan:
Model persamaan AR(4) di tingkat level ini sudah menggambarkan keadaan data yang sebenarnya.*/

*8. Catat hasil AIC, BIC, dan LogLikelihood pada hasil regresi AR(4) di turunan pertama! (5%)
estat ic
/*AR(4)
AIC = -294.7811
BIC = -281.7418
LL = 153.3941*/

*9. Lakukan estimasi regresi dengan model MA(4) pada variabel lpdb. Tulis bentuk persamaannya, kemudian berikan interpretasi hasilnya. (Hint: gunakan diferensiasi pertama, d=1, dan cukup interpretasikan koefisien pada lag ke-4). (10%)
arima lpdb, arima(0,1,4) nolog

/* Interpretasi
μ = Tanpa adanya perubahan pada variable-variable lain dalam model, peningkatan PDB di bulan Juli tahun 2008 sampai bulan Desember tahun 2024 adalah rata-rata sebesar 0.0223863 per quarternya.

γY_(t−1) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−1), maka akan meningkatkan pertumbuhan PDB saat ini sebesar 0.056305, ceteris paribus.

γY_(t−2) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−2), maka akan menurunkan pertumbuhan PDB saat ini sebesar 0.0761416, ceteris paribus.

γY_(t−3) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−3), maka akan meningkatkan pertumbuhan PDB saat ini sebesar 0.003326, ceteris paribus.

γY_(t−4) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−4), maka akan meningkatkan pertumbuhan PDB saat ini sebesar 0.4177632, ceteris paribus.*/

*10. Berdasarkan asumsi white noise, lakukan pengecekan stasioneritas pada residu hasil regresi di atas. (5%)
predict ma4, resid
tsline ma4
*tidak mengandung trend
dfuller ma4
*sudah stasioner di tingkat signifikansi 5%

//uji stasioner pada residu//
/*Hipotesis :
*H0 : di dalam residu MA(4) terdapat akar unit atau nilai residu sudah stasioner
*Ha : di dalam residu MA(4) tidak terdapat akar unit atau nilai residu sudah stasioner

Uji Kriteria :
* P.Value < a:H0 ditolak
* P.Value > a: H0 tidak dapat ditolak

Hasil :
*a = 5% 0.05
*p-value = 0.000
*0.0000 < 0.05, maka H0 dapat ditolak

Kesimpulan : 
*Deangan tingkat signifikansi 5%, maka dapat disimpulkan bahwa di dalam residu MA(4) tidak terdapat akar unit atau nilai residu sudah stasioner di tingkat level.*/

//Uji White Noise//
wntestq ma4
/* Hipotesis:
Ho: residu MA(4) di tingkat level white noise
Ha: residu MA(4) di tingkat level tidak white noise

Kriteria:
p-value < α 🡪 Ho ditolak 🡪 residu MA(4) di tingkat level tidak white noise
p-value > α 🡪 Ho tidak dapat ditolak 🡪 residu MA(4) di tingkat level white noise

Hasil:
p-value > α 🡪 0.0007 > 0.05, 🡪 Ho Tidak Dapat Ditolak

Kesimpulan:
Model persamaan MA(4) di tingkat level ini sudah menggambarkan keadaan data yang sebenarnya. */

*11. Catat hasil AIC, BIC, dan LogLikelihood pada hasil regresi MA(4)!
estat ic
/*MA(4)
AIC = -287.6154 
BIC = -274.5691
LL = 149.8077 */

*12. Lakukan estimasi regresi dengan model ARIMA(4) pada variabel lpdb. Tulis bentuk persamaannya, kemudian berikan interpretasi hasilnya. (Hint: gunakan diferensiasi pertama, d=1, dan cukup interpretasikan koefisien pada lag ke-4). (10%)
arima lpdb, arima(4,1,4) nolog

/* Interpretasi
μ = Tanpa adanya perubahan pada variable-variable lain dalam model, peningkatan PDB di bulan Juli tahun 2008 sampai bulan Desember tahun 2024 adalah rata-rata sebesar 0.0223853 per quarternya.

γY_(t−1) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−1), maka akan menurunkan pertumbuhan PDB saat ini sebesar 0.3205923 , ceteris paribus.

γY_(t−2) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−2), maka akan menurunkan pertumbuhan PDB saat ini sebesar 0.3991953, ceteris paribus.

γY_(t−3) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−3), maka akan menurunkan pertumbuhan PDB saat ini sebesar 0.3472191, ceteris paribus.

γY_(t−4) = Model ini menjelaskan apabila terdapat peningkatan pada pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t−4), maka akan meningkatkan pertumbuhan PDB saat ini sebesar 0.5931787, ceteris paribus.

θt-1 = Model ini menjelaskan apabila terdapat peningkatan pada
error pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t-1) , maka akan meningkatkan pertumbuhan PDB saat ini
sebesar 0.7438835, ceteris paribus.

θt-2 = Model ini menjelaskan apabila terdapat peningkatan pada
error pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t-2) , maka akan meningkatkan pertumbuhan PDB saat ini
sebesar 0.4883549, ceteris paribus.

θt-2 = Model ini menjelaskan apabila terdapat peningkatan pada
error pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t-2) , maka akan meningkatkan pertumbuhan PDB saat ini
sebesar 0.6884526, ceteris paribus.

θt-2 = Model ini menjelaskan apabila terdapat peningkatan pada error pertumbuhan PDB sebesar 1 satuan pada periode sebelumnya (t-2) , maka akan menurunkan pertumbuhan PDB saat ini
sebesar 0.5371616, ceteris paribus. */

*13. Berdasarkan asumsi white noise, lakukan pengecekan stasioneritas pada residu hasil regresi di atas! (5%)
predict arima4, resid
tsline arima4 
*tidak mengandung trend
dfuller arima4
*Sudah stasioner di tingkat signifikansi 5%

///Uji Stasioner pada Residu///
/* Hipotesis : 
*Ho: Di dalam residu ARIMA(4)  terdapat akar unit atau niai residu sudah stasioner
*Ha: Di dalam residu ARIMA(4) tidak terdapat akar unit atau niai residu sudah stasioner

Uji Kriteria : 
*P. Value < a: Ho ditolak
*P. Value > a: H0 tidak dapat ditolak

Hasil : 
*a = 5% 0.05
*p-value = 0.000
*0.0000 < 0.05, maka H0 dapat ditolak

Kesimpulan : 
*Dengan tingkat signifikansi 5%, maka dapat disimpulkan bahwa di dalam residu ARIMA(4) tidak terdapat akar unit atau niai residu sudah stasioner di tingkat level. */

///Uji White Noise///
wntestq arima4
/* Hipotesis:
Ho: residu ARIMA(4) di tingkat level white noise
Ha: residu ARIMA(4) di tingkat level tidak white noise

Kriteria:
p-value < α 🡪 Ho ditolak 🡪 residu ARIMA(4) di tingkat level tidak white noise
p-value > α 🡪 Ho tidak dapat ditolak 🡪 residu ARIMA(4) di tingkat level white noise

Hasil:
p-value > α 🡪 0.9361 > 0.05, 🡪 Ho Tidak Dapat Ditolak

Kesimpulan:
Model persamaan ARIMA(4) di tingkat level ini sudah menggambarkan keadaan data yang sebenarnya. */

*14. Catat hasil AIC, BIC, dan LogLikelihood pada hasil regresi ARIMA(4,4) (5%)
estat ic
/*ARIMA(4)
AIC = -304.6556
BIC = -282.9117
LL = 162.3278 */

*15. Dari ketiga model di atas, model manakah yang terbaik? (10%)
*Model terbaik adalah ARIMA (4) karena residualnya sudah white noise serta memiliki nilai AIC dan BIC yang relatif paling kecil  dan LL yang paling besar dibanding model lain yg residualnya sudah white noise.

*16. Tutup log file! (0%)
save "$output/PostTestLab2TS"
log close