
//1. Pindahkan terlebih dahulu working directory ke folder yang biasa kalian gunakan dan buat macro directory untuk data, log-file dan juga output. Lalu buka data saham PT Indofood CBP Sukses Makmur Tbk. (ICBP.JK). sejak Januari 2020 sampai Agustus 2025 dari Yahoo Finance dengan frekuensi data harian.
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

log using "$log/LatihanLab2TS"

ssc install getsymbols

getsymbols ICBP.JK, fy(2020) fm(01) ly(2025) lm(08) yahoo frequency(d)

br

//2. Atur satuan waktu harian di stata!
tsset period, daily
br

//3. Ubah variabel 'open_ICBP_JK' menjadi 'price'
rename open_ICBP_JK price

//4. Apakah variabel price mengandung trend?
tsline price
///////data tidak mengandung trend

//5. Uji stasioneritas pada variabel price!
dfuller price
//////sudah stasioner dengan tingkat signifikansi 5%
*tulis uji kriteria, hipotesis di post test

//6. Lakukan regresi menggunakan AR (1) pada variabel price dan tulis persamaannya serta interpretasikan!
arima price, arima(1,0,0)
arima price, arima (1,0,0) nolog
/*
Interpretasi
μ = Tanpa adanya perubahan pada variable-variable lain dalam model, peningkatan harga saham PT. Indofood CBP Sukses Makmur Tbk. di tanggal 2 januari 2020 sampai 29 Agustus 2025 adalah rata-rata sebesar 10006.3 per harinya.

γpricet-1 = Model ini menjelaskan apabila terdapat peningkatan pada nilai harga saham PT. Indofood CBP Sukses Makmur Tbk. sebesar Rp1 pada hari sebelumnya (t-1), maka akan meningkatkan variabel nilai harga saham PT. Indofood CBP Sukses Makmur Tbk. saat ini sebesar Rp0.99 , ceteris paribus.
*/

//7. Berdasarkan asumsi white noise, lakukan pengecekan stasioneritas pada residu hasil regresi di atas!
predict ar1, r
tsline ar1 
//tidak mengandung trend 
dfuller ar1
//sudah stasioner di tingkat signifikansi 5%
*uji hipotesis, uji kriteria, hasil dan kesimpulan ditulis di posttest

*uji white noise*
wntestq ar1
/*
Hipotesis:
Ho: residu AR(1) di tingkat level white noise
Ha: residu AR(1) di tingkat level tidak white noise

Kriteria:
p-value < α 🡪 Ho ditolak 🡪 residu AR(1) di tingkat level tidak white noise
p-value > α 🡪 Ho tidak dapat ditolak 🡪 residu AR(1) di tingkat level white noise

Hasil:
p-value < α 🡪 0.0780 > 0.05, 🡪 Ho Tidak Dapat Ditolak

Kesimpulan:
Dengan tingkat signifikansi 5%, dapat disimpulkan bahwa model AR(1) di tingkat level ini sudah menggambarkan keadaan data yang sebenarnya
*/

//8. Catat hasil AIC, BIC, dan LogLikelihood pada hasil regersi AR(1) di tingkat level!
estat ic
/*AR(1)
AIC = <18004.92
BIC = 18020.57
LL = -8999.458
*/

//9. Lakukan regresi menggunakan MA (1) pada variabel price dan tuliskan persamaan serta interpretasinya!
arima price, arima (0,0,1) nolog
//θt-1= Model ini menjelaskan apabila terdapat peningkatan pada error / shock di variable harga saham PT. Indofood CBP Sukses Makmur Tbk. sebesar 1 satuan pada periode sebelumnya (t-1) , maka akan meningkatkan variabel harga saham PT. Indofood CBP Sukses Makmur Tbk. saat ini sebesar Rp0.99 , ceteris paribus

10. Berdasarkan asumsi white noise, lakukan pengecekan stasioneritas pada residu hasil regresi di atas.
predict ma1, r
tsline ma1
//tidak mengandung trend
dfuller ma1
//sudah stasioner di tingkat signifikansi 5%
*uji hipotesos, uji kriteria, hasil dan kesimpulan ditulis kalau diposttest

*uji white noise*
wntestq ma1
/*
Hipotesis:
Ho: residu MA(1) di tingkat level white noise
Ha: residu MA(1) di tingkat level tidak white noise

Kriteria:
p-value < α 🡪 Ho ditolak 🡪 residu MA(1) di tingkat level tidak white noise
p-value > α 🡪 Ho tidak dapat ditolak 🡪 residu MA(1) di tingkat level white noise

Hasil:
p-value < α 🡪 0.0000 > 0.05, 🡪 Ho Ditolak

Kesimpulan:
Dengan tingkat signifikansi 5%, dapat disimpulkan bahwa Model MA(1) di tingkat level ini belum menggambarkan keadaan data yang sebenarnya
*/

//11. Catat hasil AIC, BIC, dan LogLikelihood pada hasil regersi MA(1)!
estat ic
/*MA1*
AIC = 22112.38
BIC = 22122.81
LL = -11054.19
*/

//12. Lakukan regresi menggunakan ARMA (1,1) pada variabel price!//
arima price, arima(1,0,1)
/*μ = Tanpa adanya perubahan pada variabel-variabel lain dalam model, peningkatan harga saham PT. Indofood CBP Sukses Makmur Tbk. di tanggal 2 januari 2020 sampai 29 Agustus 2025 adalah rata-rata sebesar Rp10016.6 per harinya.
γpricet-1 = Model ini menjelaskan apabila terdapat peningkatan pada nilai harga saham PT. Indofood CBP Sukses Makmur Tbk. sebesar Rp1 pada hari sebelumnya (t-1), maka akan meningkatkan variabel nilai harga saham PT. Indofood CBP Sukses Makmur Tbk. saat ini sebesar Rp0.994 , ceteris paribus.
θt-1= Model ini menjelaskan apabila terdapat peningkatan pada error / shock di variable harga saham PT. Indofood CBP Sukses Makmur Tbk. sebesar Rp1 pada periode sebelumnya (t-1) , maka akan menurunkan variabel harga saham PT. Indofood CBP Sukses Makmur Tbk. saat ini sebesar Rp0.184 , ceteris paribus.
*/

//13. Berdasarkan asumsi white noise, lakukan pengecekan stasioneritas pada residu hasil regresi di atas! 
predict arima, r
tsline arima
//tidak mengandung trend
dfuller arima
//sudah stasioner di tingkat signifikansi 5%
*uji hipotesis, uji kriteria, hasil dan kesimpulan ditulis kalau di posttest

*uji white noise*
wntestq arima
/*
Hipotesis:
Ho: residu ARMA(1) di tingkat level white noise
Ha: residu ARMA(1) di tingkat level tidak white noise

Kriteria:
p-value < α 🡪 Ho ditolak 🡪 residu ARMA(1) di tingkat level tidak white noise
p-value > α 🡪 Ho tidak dapat ditolak 🡪 residu ARMA(1) di tingkat level white noise

Hasil:
p-value > α 🡪 0.0154 < 0.05, 🡪 Ho Ditolak

Kesimpulan:
Dengan tingkat signifikansi 5%, dapat disimpulkan bahwa  Model ARMA(1) di tingkat level ini belum menggambarkan keadaan data yang sebenarnya
*/

//14. Catat hasil AIC, BIC, dan LogLikelihood pada hasil regersi ARMA(1,1)
estat ic
/*ARMA(1,1)
AIC = 17977.48
BIC = 17998.34
LL = -8984.738
*/

//15. Dari ketiga model di atas, model manakah yang terbaik?
*Model terbaik adalah AR(1) karena residualnya sudah white noise serta memiliki nilai AIC dan BIC yang relatif paling kecil  dan LL yang paling besar dibanding model lain yg residualnya sudah white noise.*

//16. Tutup log file!
save "$output/Kamila_latihanlab2TS"
log close