//Kamila Fazilatunisa_120410230109_Posttestlab8TS

*1. Masukan txhprice.dta yang berasal dari web stata! (2%) 
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

log using "$log/PostTestLab8TS"

webuse txhprice
des
br

*2. Atur variabel waktu bulanan yang terdapat pada data untuk dijadikan satuan waktu pada STATA! (3%)
tsset t, monthly

*3. Lakukan pengecekan stationeritas untuk variabel harga rumah di austin dallas houston sa menggunakan grafik Augmented Dickey-Fuller Test (ADF) dengan tingkat signfikansi 5%! (5%)
dfuller austin // belum stasioner
dfuller dallas // belum stasioner
dfuller houston // belum stasioner
dfuller sa // belum stasioner

/*Hipotesis 
Ho : Variabel return Mengandung Unit Root (belum stasioner)
Ha : Variabel return Tidak Mengandung Unit Root (stasioner)
Kriteria
α = 0.05
P. Value < α: Ho ditolak
P. Value > α: Ho tidak dapat ditolak
Hasil
0.6170, 0.6910, 0.5280, 0.1608 > 0.05 (H0 tidak dapat ditolak)
Kesimpulan
Dengan tingkat signifikansi 5%, harga rumah di Austin, Dallas, Houston belum stasioner di tingkat level.
*/

dfuller d.austin // sudah stasioner
dfuller d.dallas // sudah stasioner
dfuller d.houston // sudah stasioner
dfuller d.sa // sudah stasioner
/*
Hipotesis
Ho: Variabel return Mengandung Unit Root (belum stasioner)
Ha: Variabel return Tidak Mengandung Unit Root (stasioner)
Kriteria
α = 0.05
P. Value < α: Ho ditolak
P. Value > α: Ho tidak dapat ditolak
Hasil
0.0000 < 0.05 (H0 ditolak)
Kesimpulan
Dengan tingkat signifikansi 5%, harga rumah di Austin, Dallas, Houston, dan SA tidak mengandung unit root dan sudah stasioner di turunan pertama
*/

*4. Carilah lag optimal untuk mode VAR diantara ke empat variabel tersebut dengan cara (5%)
varsoc d.austin d.dallas d.houston d.sa
//lag optimal yang dapat digunakan adalah lag 4 karena memiliki AIC terkecil

*5. Buatlah regresi VAR dari keempat variabel tersebut, Lalu, tulislan persamaan matriks dan linear! (20%)
var d.austin d.dallas d.houston d.sa, lags(1/4)

*6. Lihatlah apakah ada kausalitas yang terjadi di antara keempat variabel! (10%)
vargranger
/*
HIPOTESIS :
H0 : tidak terdapat hubungan kausalitas antar variabel
Ha : terdapat hubungan kausalitas (1/2 arah) antar variabel

UJI KRITERIA :
p.value < α H0 ditolak
p.value > α H0 tidak dapat ditolak

HASIL :
- antara d.austin dan d.dallas (0.031), terdapat kausalitas
- antara d.austin dan d.houston (0.213), tidak terdapat kausalitas
- antara d.austin dan d.sa (0.143), tidak terdapat kausalitas
- antara d.dallas dan d.austin (0.043), terdapat kausalitas
- antara d.dallas dan d.houston (0.612), tidak terdapat kausalitas
- antara d.dallas dan d.sa (0.096), tidak terdapat kausalitas
- antara d.houston dan d.austin (0.930), tidak terdapat kausalitas
- antara d.houston dan d.dallas (0.000), terdapat kausalitas
- antara d.houston dan d.sa (0.008), terdapat kausalitas
- antara d.sa dan d.austin (0.029), terdapat kausalitas
- antara d.sa dan d.dallas (0.234), tidak terdapat kausalitas
- antara d.sa dan d.houston (0.398), tidak terdapat kausalitas

KESIMPULAN :
dengan tingkat signifikansi 5%, dapat disimpulkan bahwa model memiliki hubungan kausalitas satu arah antara variabel d.austin dengan d.sa, d.houston dengan d.dallas, dan d.houston dengan d.sa, selain itu terdapat hubungan kausalitas dua arah antara variabel d.austin dengan d.dallas
*/

*7. Lakukan uji stabilitas pada model tersebut! (5%)
varstable, graph
//kesimpulan : eigenvalue telah berada pada kondisi -1<e<1, maka model sudah dalam keadaan stabil.

*8. Lakukan uji kointegrasi dengan grafik dan uji Johansen, apakah terdapat kointegrasi pada model? (10%)
vecrank austin dallas houston sa
/*HIPOTESIS :
Ho : r = 0 (tidak terdapat kointegrasi antara variabel inflasi dan suku bunga)
Ha : r ≠ 0 (terdapat kointegrasi antara variabel inflasi dan suku bunga)
	
UJI KRITERIA :
Trace statistic < critical value -> Ho tidak dapat ditolak
Trace statistic > critical value -> Ho ditolak
	
HASIL :
rank (0) : 115.8785 > 47.21 --> Ho ditolak
rank (1) : 63.2021 > 29.68 --> Ho ditolak
rank (2) : 13.8741 < 15.41 --> Ho tidak dapat ditolak
rank (3) : 0.2400 < 3.76 --> Ho tidak dapat ditolak

KESIMPULAN :
Terdapat hubungan jangka panjang atau kointegrasi antara variabel d.austin, d.dallas, d.houston, dan d.sa sebanyak 2 kejadian dan dapat dilanjutkan ke permodelan VECM 
*/

*9. Tampilkan grafik IRF untuk 5 periode mendatang dari persamaan VAR diatas, lalu gambarlah grafik IRF antara austin terhadap houston serta lihat bagaimana pengaruhnya pada 3 periode mendatang! (15%)
var d.austin d.dallas d.houston d.sa, lags(1/4)
irf create PostTestTS8, step(5) set (txhprice)
irf graph irf
irf ograph (PostTestTS8 d.austin d.houston irf)
irf table irf
irf table irf, irf(PostTestTS8) impuls(d.austin) response(d.houston)
//Guncangan sebesar 1 standar deviasi pada pertumbuhan diferensiasi austin menyebabkan respon positif awal pada pertumbuhan diferensiasi Houston, dengan nilai puncak sebesar 0.05 standar deviasi. Setelah itu, respon diferensiasi Houston mengalami fluktuasi dan pada periode ketiga kembali meningkat  yaitu sebesar 0.02 standar deviasi

*10. Tampilkan grafik FEVD dan gambarlah grafik FEVD antara d.austin terhadap d.houston! Setelahnya, lihat bagaimana pengaruh dari d.austin terhadap d.houston pada 3 periode yang akan datang! (15%)
irf table fevd
irf table fevd, irf(PostTestTS8) impuls(d.austin) response(d.houston)
irf graph fevd
//pada 3 periode mendatang, jika terdapat shock pada variabel diferensiasi austin maka akan berpengaruh 0.65% terhadap variabel diferensiasi Houston

*11. Lakukan forecasting untuk semua variabel sampai lima periode selanjutnya serta interpretasikan hasilnya! (10%)
var d.austin d.dallas d.houston d.sa, lags(1/4) 
fcast compute fc_, step(5)
fcast graph fc_D_austin
//Guncangan sebesar 1 unit standar deviasi pada variabel d.austin menyebabkan penurunan pada variabel d.austin selama 2 periode, lalu peningkatan positif dibandingkan periode nol pada periode ke-3, terjadi penurunan pada periode ke-4, dan kembali meningkat pada periode ke-5. Puncak penurunan terjadi pada periode ke-1
fcast graph fc_D_dallas
//Guncangan sebesar 1 unit standar deviasi pada variabel d.dallas menyebabkan penurunan pada variabel d.dallas selama 2 periode, lalu terjadi peningkatan positif pada periode ke-3, ke-4, dan ke-5. Puncak penurunan terjadi pada periode ke-1
fcast graph fc_D_houston
//Guncangan sebesar 1 unit standar deviasi pada variabel d.houston menyebabkan penurunan pada variabel d.houston selama 1 periode, lalu terjadi fluktuasi pada periode ke-3 sampai ke-5. Puncak penurunan terjadi pada periode ke-1
fcast graph fc_D_sa
//Guncangan sebesar 1 unit standar deviasi pada variabel d.sa tidak menyebabkan penurunan pada variabel d.sa selama 2 periode, lalu terjadi penurunan pada period eke3 dan kembali terjadi peningkatan positif pada periode ke-4 dan ke-5. Puncak penurunan terjadi pada periode ke-3

save "$output/Kamila Fazilatunisa_posttestlab8"
log close